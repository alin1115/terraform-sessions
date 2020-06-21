terraform {
    backend "s3" {
        bucket = "akumo-terraform101-state20"
        key    = "session4/ec2.tfstate"
        region = "us-east-1"
        dynamodb_table = "terraform101-state-locks"
        encrypt = true
        profile = "terraform"
    }
}
