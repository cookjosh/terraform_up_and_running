provider "aws" {
    region = "us-east-2"
}

module "webserver_cluster" {
    source = "github.com/cookjosh/terraform_up_and_running"

    cluster_name           = "webservers-prod"
    db_remote_state_bucket = "terraform-up-and-running-state-book-jcook"
    db_remote_state_key    = "prod/data-stores/mysql/terraform.tfstate"

    # A prod environment might need larger instance types, but I'm keeping it free for now :)
    instance_type = "t2.micro"
    min_size      = 2
    max_size      = 2
}

resource "aws_autoscaling_schedule" "scale_out_during_business_hours" {
    scheduled_action_name = "scale-out-during-business-hours"
    min_size              = 2
    max_size              = 10
    desired_capacity      = 10
    recurrence            = "0 9 * * *" # cron syntax meaning everyday at 9am"

    autoscaling_group_name = module.webserver_cluster.asg_name
}

resource "aws_autoscaling_schedule" "scale_in_at_night" {
    scheduled_action_name = "scale-in-at-night"
    min_size              = 2
    max_size              = 10
    desired_capacity      = 2
    recurrence            = "0 17 * * *" 
  
    autoscaling_group_name = module.webserver_cluster.asg_name
}