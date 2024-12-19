####################################
# VPC
####################################

resource "aws_vpc_endpoint" "streaming" {
  vpc_id              = var.vpc_id
  vpc_endpoint_type   = "Interface"
  service_name        = "com.amazonaws.${var.aws_region}.appstream.streaming"
  private_dns_enabled = true
  security_group_ids  = [var.streaming_security_group_id]
  subnet_ids          = var.application_subnets
}
