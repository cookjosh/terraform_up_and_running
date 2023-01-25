output "public_ip" {
    value       = aws_lb.example.dns_name
    description = "Public IP of the web server"
}