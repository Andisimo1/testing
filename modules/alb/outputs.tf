output "alb_dns" {
  value = aws_alb.main.dns_name
}

output "alb_listener" {
  value = aws_alb_listener.front_end.id
}