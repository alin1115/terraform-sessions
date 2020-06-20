resource "random_password" "demo_password" {
  length            = 16
  special           = true
  override_special  = "_%#*"
}

resource "aws_secretsmanager_secret" "db_password" {
  name          = var.db_password
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "db_password" {
  secret_id     = aws_secretsmanager_secret.db_password.id
  secret_string = random_password.demo_password.result
}

resource "aws_security_group" "db_sg" {
  name = var.db_sg
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

resource "aws_db_instance" "demo_db_instance" {
  identifier        = var.db_identifier
  engine            = "mysql"
  allocated_storage = var.db_storage
  instance_class    = var.db_instance_type
  name              = "rds"
  username          = "admin"
  password          = random_password.demo_password.result
  publicly_accessible = true
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  skip_final_snapshot = var.skip_final_snapshot
  final_snapshot_identifier = var.skip_final_snapshot == true ? null : format("%s-%s", "rds-snap", formatdate("DD-MMM-YYYY-hh-mmZZZ", timestamp()))
}

data "template_file" "sql_table" {
  template = file("${path.module}/table.sql")
  vars = {
    db = replace("rds-users-1", "-", "_")
  }
}

resource "null_resource" "db_table" {
  triggers = {
    tt = trimspace(file("${path.module}/table.sql"))
    #tt = timestamp()
  }
  depends_on = [aws_db_instance.demo_db_instance]

  provisioner "local-exec" {
    command = <<-EOF
      echo "${data.template_file.sql_table.rendered}" > run.sql
      mysql -h "${aws_db_instance.demo_db_instance.address}" -u "${aws_db_instance.demo_db_instance.username}" -p"${random_password.demo_password.result}" < "run.sql" 
      rm -rf run.sql
    EOF
  }
}
