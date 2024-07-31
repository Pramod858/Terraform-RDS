terraform {
    backend "s3" {
        bucket = "pramod858tf"
        key    = "terraform/rds/terraform.tfstate"
        region = "us-east-1"
    }
}