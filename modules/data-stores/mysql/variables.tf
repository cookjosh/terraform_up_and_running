variable "db_name" {
    description = "Name for db"
    type        = string
    default     = null
}

variable "db_username" {
    description = "The username of the db"
    type        = string
    sensitive   = true
    default     = null
}

variable "db_password" {
    description = "The password of the db"
    type        = string
    sensitive   = true
    default     = null
}

variable "backup_retention_period" {
    description = "Days for backup retention. Must be > 0 to enable."
    type        = number
    default     = null
}

variable "replicate_source_db" {
    description = "If specified, replicate the db at the given ARN"
    type        = string
    default     = null  
}