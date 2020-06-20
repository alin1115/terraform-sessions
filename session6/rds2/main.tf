module "rds" {
    source = "../modules/rds"

    db_password = "second-rds-secret"
    db_sg = "second-rds-sg"
    db_identifier = "second-rds-identifier"
    db_storage = 20
}