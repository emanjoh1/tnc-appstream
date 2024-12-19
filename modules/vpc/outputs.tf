output "aws_vpc_endpoint" {
  value = {
    streaming = aws_vpc_endpoint.streaming.id
  }
}

output "aws_vpc_endpoint_streaming" {
  value = aws_vpc_endpoint.streaming.id
}
