data "aws_ecr_repository" "this" {
  name = "lambda-docker"
}

data "http" "actions_openid_configuration" {
  url = "https://token.actions.githubusercontent.com/.well-known/openid-configuration"
}

data "tls_certificate" "actions" {
  url = jsondecode(data.http.actions_openid_configuration.response_body).jwks_uri
}

data "aws_iam_openid_connect_provider" "actions" {
  url = "https://token.actions.githubusercontent.com"
}

resource "aws_iam_role" "actions" {
  name               = "${local.app}-github-actions-oidc"
  assume_role_policy = data.aws_iam_policy_document.actions_assume_role.json
}

resource "aws_iam_policy" "actions" {
  name   = "${local.app}-github-actions-oidc"
  policy = data.aws_iam_policy_document.actions.json
}

resource "aws_iam_role_policy_attachment" "actions" {
  role       = aws_iam_role.actions.name
  policy_arn = aws_iam_policy.actions.arn
}

data "aws_iam_policy_document" "actions" {
  statement {
    effect = "Allow"
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetRepositoryPolicy",
      "ecr:DescribeRepositories",
      "ecr:ListImages",
      "ecr:DescribeImages",
      "ecr:BatchGetImage",
      "ecr:GetLifecyclePolicy",
      "ecr:GetLifecyclePolicyPreview",
      "ecr:ListTagsForResource",
      "ecr:DescribeImageScanFindings",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:PutImage"
    ]
    resources = [
      data.aws_ecr_repository.this.arn,
      "${data.aws_ecr_repository.this.arn}:*",
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "ecr:GetAuthorizationToken",
    ]
    resources = [
      "*"
    ]
  }
}

data "aws_iam_policy_document" "actions_assume_role" {
  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRoleWithWebIdentity",
    ]
    principals {
      type        = "Federated"
      identifiers = [data.aws_iam_openid_connect_provider.actions.arn]
    }
    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }
    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:reizt/lambda-docker*"]
    }
  }
}
