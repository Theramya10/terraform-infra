# OIDC provider for GitHub Actions
resource "aws_iam_openid_connect_provider" "github" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]

  # Prevent Terraform from failing if it already exists
  lifecycle {
    ignore_changes = [url, thumbprint_list]
  }
}

# IAM role for GitHub Actions to assume
resource "aws_iam_role" "github_actions" {
  name = "github-actions-deploy"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/token.actions.githubusercontent.com"
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
            # Replace repo name with your GitHub repo
            "token.actions.githubusercontent.com:sub" = "repo:Theramya10/terraform-infra:*"
          }
        }
      }
    ]
  })
}

# IAM policy attachment (AdministratorAccess)
resource "aws_iam_policy_attachment" "github_policy_attach" {
  name       = "github-policy-attach"
  roles      = [aws_iam_role.github_actions.name]
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# Caller identity data source (for account ID)
data "aws_caller_identity" "current" {}
