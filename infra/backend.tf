terraform {
  backend "s3" {
    bucket         = "terraform-state-sns-and-sqs"
    key            = "sns-and-sqs/infra/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock"
  }
}