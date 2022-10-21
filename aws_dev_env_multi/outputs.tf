output "dev_ip" {
  description = "Output the public IP of the dev node instance"
  value = aws_instance.dev_node[0].public_ip
}

output "dev_ip2" {
  description = "Output the public IP of the dev node instance"
  value = aws_instance.dev_node[1].public_ip
}

output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.dev_node[0].id
}

output "instance_id2" {
  description = "ID of the EC2 instance"
  value       = aws_instance.dev_node[1].id
}