data "terraform_remote_state" "rds" {
    backend = "s3"
    config = {
        bucket = "akumo-terraform101-state"
        key = "session4/rds.tfstate"
        region = "us-east-1"
        profile = "terraform"
    }
}