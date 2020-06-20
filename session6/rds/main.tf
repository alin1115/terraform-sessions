module "rds" {
    source = "../modules/rds"

    db_password = "first-rds-secret"
    db_sg = "first-rds-sg"
    db_identifier = "first-rds-identifier"
}