# This file was applied on default workspace and another workspace called example 1
# To show how the use of workspaces can provide some isolation between infrastructure!

provider "aws" {
    region = "us-east-2"
}

resource "aws_instance" "example" {
    ami           = "ami-0fb653ca2d3203ac1"
    instance_type = "t2.micro"
}

terraform {
    backend "s3" {
        bucket         = "terraform-up-and-running-state-book-jcook" # Using the name of the bucket we created below
        key            = "workspaces-example/terraform.tfstate"
        region         = "us-east-2"
        profile        = "tf-course"
        dynamodb_table = "terraform-up-and-running-locks"
        encrypt        = true     
    }
}