data "aws_ecr_image" "latest" {
  repository_name = data.aws_ecr_repository.this.name
  most_recent     = true
}

resource "aws_lambda_function" "this" {
  function_name = local.app
  image_uri     = "${data.aws_ecr_repository.this.repository_url}:${data.aws_ecr_image.latest.image_tags[0]}"
  architectures = [
    "x86_64",
  ]
  role         = aws_iam_role.lambda.arn
  package_type = "Image"

  lifecycle {
    ignore_changes = [
      image_uri
    ]
  }
}

resource "aws_iam_role" "lambda" {
  name               = "${local.app}-lambda"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRole",
    ]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy" "lambda" {
  name   = "${local.app}-lambda"
  policy = data.aws_iam_policy_document.lambda.json
}

data "aws_iam_policy_document" "lambda" {
  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject",
    ]
    resources = [
      "arn:aws:s3:::creators-team-skeleton-tokyo/*",
    ]
  }
}
