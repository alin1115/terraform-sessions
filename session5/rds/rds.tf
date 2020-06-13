resource "random_password" "demo_password" {
  length            = 16
  special           = true
  override_special  = "_%#*"
}

resource "aws_secretsmanager_secret" "db_password" {
  name          = "db-password"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "db_password" {
  secret_id     = aws_secretsmanager_secret.db_password.id
  secret_string = random_password.demo_password.result
}

resource "aws_security_group" "db_sg" {
  name = "rds-db-sg"
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

resource "aws_db_instance" "demo_db_instance" {
  identifier        = "rds-users"
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