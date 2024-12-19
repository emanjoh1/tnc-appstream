output "appstream_sg_id" {
  description = "The ID of the AppStream security group"
  value       = aws_security_group.appstream.id
}

output "streaming_sg_id" {
  value = aws_security_group.streaming.id
}

