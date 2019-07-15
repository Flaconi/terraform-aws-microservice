# -------------------------------------------------------------------------------------------------
# IAM Policy Document
# -------------------------------------------------------------------------------------------------
data "aws_iam_policy_document" "assume_role_service" {
  count = var.iam_role_enabled ? 1 : 0

  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "assume_role_principals" {
  count = (var.iam_role_enabled ? signum(
    var.iam_user_enabled ? 1 : 0 + length(var.iam_role_principals_arns),
  ) : 0)
  source_json = element(
    concat(
      data.aws_iam_policy_document.assume_role_service.*.json,
      [""],
    ),
    0,
  )

  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = concat(var.iam_role_principals_arns, aws_iam_user.this.*.arn)
    }
  }
}

# -------------------------------------------------------------------------------------------------
# IAM Role
# -------------------------------------------------------------------------------------------------
resource "aws_iam_role" "this" {
  count = var.iam_role_enabled ? 1 : 0
  name  = "${var.env}-microservice-${var.name}"

  assume_role_policy = length(var.iam_role_principals_arns) + tonumber(var.iam_user_enabled ? 1 : 0) > 0 ? element(
    concat(
      data.aws_iam_policy_document.assume_role_principals.*.json,
      [""],
    ),
    0,
  ) : data.aws_iam_policy_document.assume_role_service[0].json

  description = "IAM Role for ${var.env}-microservice-${var.name}"

  tags = local.tags
}

# -------------------------------------------------------------------------------------------------
# IAM User
# -------------------------------------------------------------------------------------------------
resource "aws_iam_user" "this" {
  count         = var.iam_user_enabled ? 1 : 0
  name          = "${var.env}-microservice-${var.name}"
  path          = var.iam_user_path
  force_destroy = true
  tags          = local.tags
}

resource "aws_iam_access_key" "this" {
  count = var.iam_user_enabled ? 1 : 0
  user  = aws_iam_user.this[0].name
}

# -------------------------------------------------------------------------------------------------
# IAM DynamoDB resources
# -------------------------------------------------------------------------------------------------
data "aws_iam_policy_document" "dynamodb_full_access" {
  count = var.dynamodb_enabled && var.iam_role_enabled ? 1 : 0

  statement {
    sid    = "ListDynamoDB"
    effect = "Allow"

    resources = [
      "arn:aws:dynamodb:*:*:table/${module.dynamodb.table_id}",
    ]

    actions = [
      "dynamodb:List*",
      "dynamodb:DescribeReservedCapacity*",
      "dynamodb:DescribeLimits",
      "dynamodb:DescribeTimeToLive",
    ]
  }

  statement {
    sid    = "FullAccess"
    effect = "Allow"

    resources = [
      "arn:aws:dynamodb:*:*:table/${module.dynamodb.table_id}",
      "arn:aws:dynamodb:*:*:table/${module.dynamodb.table_id}/*",
    ]

    actions = [
      "dynamodb:BatchGet*",
      "dynamodb:DescribeStream",
      "dynamodb:DescribeTable",
      "dynamodb:Get*",
      "dynamodb:Query",
      "dynamodb:Scan",
      "dynamodb:BatchWrite*",
      "dynamodb:CreateTable",
      "dynamodb:DeleteItem",
      "dynamodb:Update*",
      "dynamodb:PutItem",
    ]
  }
}

resource "aws_iam_role_policy" "dynamodb_role_policy" {
  count = var.dynamodb_enabled && var.iam_role_enabled ? 1 : 0
  role  = element(concat(aws_iam_role.this.*.name, [""]), 0)

  name = "dynamodb-policy"

  # This defines what permissions our role will be given
  policy = data.aws_iam_policy_document.dynamodb_full_access[0].json
}

data "aws_iam_policy_document" "dynamodb2_full_access" {
  count = var.dynamodb2_enabled && var.iam_role_enabled ? 1 : 0

  statement {
    sid    = "ListDynamoDB"
    effect = "Allow"

    resources = [
      "arn:aws:dynamodb:*:*:table/${module.dynamodb2.table_id}",
    ]

    actions = [
      "dynamodb:List*",
      "dynamodb:DescribeReservedCapacity*",
      "dynamodb:DescribeLimits",
      "dynamodb:DescribeTimeToLive",
    ]
  }

  statement {
    sid    = "FullAccess"
    effect = "Allow"

    resources = [
      "arn:aws:dynamodb:*:*:table/${module.dynamodb2.table_id}",
      "arn:aws:dynamodb:*:*:table/${module.dynamodb2.table_id}/*",
    ]

    actions = [
      "dynamodb:BatchGet*",
      "dynamodb:DescribeStream",
      "dynamodb:DescribeTable",
      "dynamodb:Get*",
      "dynamodb:Query",
      "dynamodb:Scan",
      "dynamodb:BatchWrite*",
      "dynamodb:CreateTable",
      "dynamodb:DeleteItem",
      "dynamodb:Update*",
      "dynamodb:PutItem",
    ]
  }
}

resource "aws_iam_role_policy" "dynamodb2_role_policy" {
  count = var.dynamodb2_enabled && var.iam_role_enabled ? 1 : 0
  role  = element(concat(aws_iam_role.this.*.name, [""]), 0)

  name = "dynamodb2-policy"

  # This defines what permissions our role will be given
  policy = data.aws_iam_policy_document.dynamodb2_full_access[0].json
}

##
## IAM KMS permissions
##
data "aws_iam_policy_document" "kms_permissions" {
  count = var.kms_enabled && var.iam_role_enabled ? 1 : 0

  statement {
    effect = "Allow"
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]
    resources = [element(concat(aws_kms_key.this.*.arn, [""]), 0)]
  }
}

resource "aws_iam_role_policy" "kms" {
  count  = var.iam_role_enabled && var.kms_enabled ? 1 : 0
  name   = "kms-permissions"
  role   = element(concat(aws_iam_role.this.*.name, [""]), 0)
  policy = element(concat(data.aws_iam_policy_document.kms_permissions.*.json, [""]), 0)
}


##
## IAM S3 permissions
##
data "aws_iam_policy_document" "s3_permissions" {
  statement {
    effect    = "Allow"
    actions   = ["s3:ListBucket"]
    resources = [format("arn:aws:s3:::%s", element(concat(aws_s3_bucket.this.*.id, [""]), 0))]
  }

  statement {
    effect    = "Allow"
    actions   = ["s3:*"]
    resources = [format("arn:aws:s3:::%s/*", element(concat(aws_s3_bucket.this.*.id, [""]), 0))]
  }
}

resource "aws_iam_role_policy" "s3" {
  count  = var.iam_role_enabled && var.s3_enabled ? 1 : 0
  name   = "s3-permissions"
  role   = element(concat(aws_iam_role.this.*.name, [""]), 0)
  policy = element(concat(data.aws_iam_policy_document.s3_permissions.*.json, [""]), 0)
}

##
## IAM Extra inline policies
##
data "aws_iam_policy_document" "this" {
  count = length(var.iam_inline_policies)

  dynamic statement {
    for_each = var.iam_inline_policies[count.index].statements

    content {
      sid       = lookup(statement.value, "sid", "")
      effect    = lookup(statement.value, "effect", "Allow")
      actions   = lookup(statement.value, "actions")
      resources = statement.value.resources
    }
  }
}

resource "aws_iam_role_policy" "this" {
  count  = var.iam_role_enabled ? length(var.iam_inline_policies) : 0
  name   = lookup(var.iam_inline_policies[count.index], "name")
  role   = element(concat(aws_iam_role.this.*.name, [""]), 0)
  policy = data.aws_iam_policy_document.this[count.index].json
}
