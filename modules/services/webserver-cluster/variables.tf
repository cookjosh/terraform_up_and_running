variable "server_port" {
    description = "The port the server will use for HTTP requests"
    type        = number
    default     = 8080
}

variable "cluster_name" {
    description = "The name to use for all cluster resources"
    type        = string
}

variable "db_remote_state_bucket" {
    description = "The name of the S3 bucket for the db's remote state"
    type        = string
}

variable "db_remote_state_key" {
    description = "The path for the db's remote state in S3"
    type        = string
}

variable "instance_type" {
    description = "The type of the ec2 instances to run (eg t2.micro)"
    type        = string
}

variable "min_size" {
    description = "Minimum number of instances in the ASG"
    type        = number
}

variable "max_size" {
    description = "Maximum number of instances in the ASG"
    type        = number
}

variable "custom_tags" {
    description = "Custom, dynamic tags for the Instances in the ASG"
    type        = map(string)
    default     = {}
}

variable "enable_autoscaling" {
    description = "If true, enable auto scaling"
    type        = bool
}

variable "ami" {
    description = "AMI to run in the cluster"
    type        = string
    default     = "ami-0fb653ca2d3203ac1"
}

variable "server_text" {
    description = "Text the web server will return"
    type        = string
    default     = "Hello, world!"
}