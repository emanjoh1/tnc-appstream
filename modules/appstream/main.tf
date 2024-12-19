####################################
# AppStream
####################################

resource "aws_iam_policy" "bucket" {
  name   = "${var.aws_account_name}-app-bucket-policy"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:ListBucket",
        "s3:GetBucketLocation"
      ],
      "Resource": "${var.app_resources_bucket_arn}"
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObjectAttributes",
        "s3:GetObject",
        "s3:PutObject",
        "s3:ListMultipartUploadParts",
        "s3:AbortMultipartUpload"
      ],
      "Resource": "${var.app_resources_bucket_arn}/*"
    }
  ]
}
EOF
}

resource "aws_iam_role" "image_builder" {
  name                = "${var.aws_account_name}-image_builder"
  managed_policy_arns = [aws_iam_policy.bucket.arn, var.db_admin_policy]
  assume_role_policy  = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "appstream.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_appstream_image_builder" "lrm" {
  count                          = var.create_image_builder ? 1 : 0
  name                           = "${var.aws_account_name}-appstream-imagebuilder"
  description                    = "Image Builder for ${var.aws_account_name}"
  display_name                   = "Image Builder for ${var.aws_account_name}"
  enable_default_internet_access = false
  image_name                     = "AppStream-WinServer2019-06-12-2023"
  instance_type                  = "stream.standard.medium"
  iam_role_arn                   = aws_iam_role.image_builder.arn

  vpc_config {
    security_group_ids = [var.security_groups.appstream_sg_id]
    subnet_ids         = [var.application_subnets[0]]
  }

  access_endpoint {
    endpoint_type = "STREAMING"
    vpce_id       = var.aws_vpc_endpoint_streaming
  }

  domain_join_info {
    directory_name                         = "tnc.org"
    organizational_unit_distinguished_name = var.organizational_unit
  }

  tags = merge(
    {
      "Name" = "${var.aws_account_name}-appstream-imagebuilder"
    },
    var.tags
  )
}

####################################
# AppStream LRM User Stack
####################################

resource "aws_appstream_fleet" "user" {
  name = "${var.aws_account_name}-user-fleet"

  compute_capacity {
    desired_instances = var.desired_lrm_stream_instances
  }

  domain_join_info {
    directory_name                         = "tnc.org"
    organizational_unit_distinguished_name = var.organizational_unit
  }

  description                        = "Fleet for the ${var.aws_account_name} user images streaming with access to LRM only."
  idle_disconnect_timeout_in_seconds = 300
  display_name                       = "${var.aws_account_name} user fleet"
  enable_default_internet_access     = false
  fleet_type                         = "ALWAYS_ON"
  image_name                         = var.user_image_name
  instance_type                      = var.instance_size
  max_user_duration_in_seconds       = 14400
  stream_view                        = "APP"

  vpc_config {
    security_group_ids = [var.security_groups.appstream_sg_id]
    subnet_ids         = var.application_subnets
  }

  tags = merge(
    {
      "Name" = "${var.aws_account_name}-user-fleet"
    },
    var.tags
  )
}

resource "aws_appstream_stack" "user" {
  name         = "${var.aws_account_name}-user-stack"
  description  = "User stack for ${var.aws_account_name}"
  display_name = "User stack for ${var.aws_account_name}"

  access_endpoints {
    endpoint_type = "STREAMING"
    vpce_id       = var.aws_vpc_endpoint_streaming
  }

  storage_connectors {
    connector_type = "HOMEFOLDERS"
  }

  user_settings {
    action     = "CLIPBOARD_COPY_FROM_LOCAL_DEVICE"
    permission = "ENABLED"
  }

  user_settings {
    action     = "CLIPBOARD_COPY_TO_LOCAL_DEVICE"
    permission = "ENABLED"
  }

  user_settings {
    action     = "DOMAIN_PASSWORD_SIGNIN"
    permission = "ENABLED"
  }

  user_settings {
    action     = "DOMAIN_SMART_CARD_SIGNIN"
    permission = "DISABLED"
  }

  user_settings {
    action     = "FILE_DOWNLOAD"
    permission = "ENABLED"
  }

  user_settings {
    action     = "FILE_UPLOAD"
    permission = "ENABLED"
  }

  user_settings {
    action     = "PRINTING_TO_LOCAL_DEVICE"
    permission = "ENABLED"
  }

  application_settings {
    enabled        = true
    settings_group = "SettingsGroup"
  }

  tags = merge(
    {
      "Name" = "${var.aws_account_name}-user-fleet"
    },
    var.tags
  )
}

resource "aws_appstream_fleet_stack_association" "user" {
  fleet_name = aws_appstream_fleet.user.name
  stack_name = aws_appstream_stack.user.name
}
