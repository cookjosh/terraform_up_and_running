output "public_ip" {
    value       = aws_lb.example.dns_name
    description = "Public IP of the web server"
}

output "asg_name" {
    value       = aws_autoscaling_group.example.name
    description = "Name of the ASG"
}

output "alb_dns_name" {
    value       = aws_lb.example.dns_name
    description = "URL of the load balancer"
}