provider "aws" {
    region = "us-east-2"
}

/* Example using `count`
resource "aws_iam_user" "example" {
    count = length(var.user_names)
    name  = var.user_names[count.index]
}
*/

resource "aws_iam_user" "example" {
    for_each = toset(var.user_names) #`toset` here converts the list user_names into a set
    name     = each.value            # Remember `for_each` does not support lists in resources
}