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
