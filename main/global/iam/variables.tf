variable "user_names" {
    description = "List of user names to use for creating IAM users"
    type        = list(string)
    default     = ["neo", "trinity", "morpheus"]
}