provider "aws" {
    region = "us-east-2"
}

# Notes - resources are defined with the convention of "resource '<provider>_<resource>' '<name>'"
# were <provider> refers to the backend provider (in this case AWS)
# <resource> refers to a provider's product (eg EC2 instance) and <name>
# which can be referenced by other parts of the code
resource "aws_instance" "example" {
    ami             = "ami-0fb653ca2d3203ac1"
    instance_type   = "t2.micro"

    tags = {
        Name = "terraform-first-example"
    }
}