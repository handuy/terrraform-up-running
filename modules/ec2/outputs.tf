output "instance_private_ip" {
  value = aws_instance.myapp.private_ip
}

output "instance_public_ip" {
  value = aws_instance.myapp.public_ip
}