terraform {
  backend "s3" {
    bucket = "aws-jhooq-demo-project"
    key    = "ec2-setup/terraform.tfstate"
    region = "eu-central-1"
  }
}