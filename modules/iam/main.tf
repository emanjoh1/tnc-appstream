####################################
# IAM
####################################

resource "aws_iam_saml_provider" "this" {
  name                   = var.saml_idp_name
  saml_metadata_document = file(var.saml_metadata_file)
}

data "aws_iam_policy_document" "saml_assume" {
  statement {
    actions = [
      "sts:AssumeRoleWithSAML",
      "sts:TagSession"
    ]
    principals {
      type        = "Federated"
      identifiers = [aws_iam_saml_provider.this.arn]
    }
    condition {
      test     = "StringEquals"
      variable = "SAML:aud"
      values   = ["https://signin.aws.amazon.com/saml"]
    }
  }
}

data "aws_iam_policy_document" "stream" {
  statement {
    actions   = ["appstream:Stream"]
    resources = [
      "arn:aws:appstream:${var.aws_region}:${local.account_id}:stack/${var.aws_account_name}-user-stack"
    ]
    condition {
      test     = "StringEquals"
      variable = "appstream:userId"
      values   = ["$${saml:sub}"]
    }
  }
}

resource "aws_iam_role" "users" {
  name               = "${var.aws_account_name}-users"
  assume_role_policy = data.aws_iam_policy_document.saml_assume.json
  
  inline_policy {
    name   = "UsersAppStreamPolicy"
    policy = data.aws_iam_policy_document.stream.json
  }

  tags = merge(
    {
      "Name" = "${var.aws_account_name}-users"
    },
    var.tags
  )
}
