####################################
# Security Groups
####################################

resource "aws_security_group" "appstream" {
  name        = "${var.aws_account_name}-appstream-sg"
  description = "Security group for ${var.aws_account_name}-appstream"
  vpc_id      = var.vpc_id

  tags = merge(
    {
      "Name" = "${var.aws_account_name}-appstream-sec-grp"
    },
    var.tags
  )
}

# Allow egress from AppStream to DB security group
resource "aws_vpc_security_group_egress_rule" "appstream_rds" {
  security_group_id            = aws_security_group.appstream.id
  referenced_security_group_id = var.db_security_group
  ip_protocol                  = "tcp"
  from_port                    = var.db_port
  to_port                      = var.db_port
}

# Allow egress from AppStream to RDP security group
resource "aws_vpc_security_group_egress_rule" "appstream_rdp" {
  security_group_id            = aws_security_group.appstream.id
  referenced_security_group_id = var.db_security_group
  ip_protocol                  = "tcp"
  from_port                    = "3389"
  to_port                      = "3389"
}

# Allow egress from AppStream to the internet
resource "aws_vpc_security_group_egress_rule" "appstream_internet" {
  security_group_id = aws_security_group.appstream.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_security_group" "streaming" {
  name        = "${var.aws_account_name}-streaming-sg"
  description = "Security group for AppStream streaming endpoint"
  vpc_id      = var.vpc_id

  tags = merge(
    {
      "Name" = "${var.aws_account_name}-streaming-sg"
    },
    var.tags
  )
}

# Allow ingress from any IP in TNC VPC CIDRs to streaming VPC endpoint on port 443
resource "aws_vpc_security_group_ingress_rule" "streaming_1" {
  count             = length(var.tnc_vpcs_cidrs)
  security_group_id = aws_security_group.streaming.id
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  description       = "Allow ingress from any IP in TNC VPC CIDRs to streaming VPC endpoint"
  cidr_ipv4         = var.tnc_vpcs_cidrs[count.index]
}

# Allow ingress from any IP in TNC VPC CIDRs to streaming VPC endpoint on port 1400-1499
resource "aws_vpc_security_group_ingress_rule" "streaming_2" {
  count             = length(var.tnc_vpcs_cidrs)
  security_group_id = aws_security_group.streaming.id
  from_port         = 1400
  to_port           = 1499
  ip_protocol       = "tcp"
  description       = "Allow ingress from any IP in TNC VPC CIDRs to streaming VPC endpoint"
  cidr_ipv4         = var.tnc_vpcs_cidrs[count.index]
}
