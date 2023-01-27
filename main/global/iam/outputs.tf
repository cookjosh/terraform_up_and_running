/* Used with `count` to illustrate
output "first_arn" {
    value       = aws_iam_user.example[0].arn
    description = "ARN of the first user in the resource array 'example'"
}

output "all_arns" { # demonstrates using a splat expression
    value       = aws_iam_user.example[*].arn
    description = "ARNS of all IAM users in the array 'example'"
}
*/


output "all_users" {
    value = values(aws_iam_user.example)[*].arn
    # Here we are looping through each key (username) of the map 
    # using the values function (specifying arn) and splat for each username.
}

