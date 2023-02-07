provider "aws" {
    region = "us-east-2"
}

terraform {
    backend "s3" {
        bucket         = "terraform-up-and-running-state-book-jcook" # Using the name of the bucket we created below
        key            = "prod/services/webserver-cluster/terraform.tfstate"
        region         = "us-east-2"
        profile        = "tf-course"
        dynamodb_table = "terraform-up-and-running-locks"
        encrypt        = true     
    }
}

module "webserver_cluster" {
    source = "../../../../modules/services/webserver-cluster"

    cluster_name           = "webservers-prod"
    db_remote_state_bucket = "terraform-up-and-running-state-book-jcook"
    db_remote_state_key    = "prod/data-stores/mysql/terraform.tfstate"

    # A prod environment might need larger instance types, but I'm keeping it free for now :)
    instance_type      = "t2.micro"
    min_size           = 2
    max_size           = 2
    enable_autoscaling = true

    custom_tags = {
        Owner     = "team-foo"
        ManagedBy = "terraform" # This tag can help others know not to modify this resource by hand in the console
    }
}