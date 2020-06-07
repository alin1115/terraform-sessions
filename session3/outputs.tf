output "lb_dns_name" {
    value = aws_lb.example.dns_name
}

output "rendered_user_data" {
    value = data.template_file.user_data.rendered
}