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
  count = ( var.iam_role_enabled ? signum(
    var.iam_user_enabled ? 1 : 0 + length(var.iam_role_principals_arns),
  ) : 0 )
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

  assume_role_policy = length(var.iam_role_principals_arns) + tonumber( var.iam_user_enabled ? 1 : 0 ) > 0 ? element(
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

