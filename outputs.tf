output "web_public_ip" {
  description = "The public IP address of the web server"

  value = aws_eip.wordpress_web_eip[0].public_ip

  depends_on = [aws_eip.wordpress_web_eip]
}

output "web_public_dns" {
  description = "The public DNS address of the web server"
  value       = aws_eip.wordpress_web_eip[0].public_dns

  depends_on = [aws_eip.wordpress_web_eip]
}

output "wordpress-web-link" {
  description = "wordpress website"
  value       = "https://${var.domain}"
}

output "phpmyadmin-link" {
  description = "wordpress phpmyadmin"
  value       = "https://${var.domain}/phpmyadmin"
}
