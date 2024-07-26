# iam-role

A Terraform module to create an IAM role. The module will create an IAM policy if policy statements are defined, or it can attach policies that are provided.

## Example

```
module "iam_role" {
  source  = "cloudboss/iam-role/aws"
  version = "x.x.x"

  create_instance_profile = true
  name                    = var.name
  permissions_boundary    = var.iam.permissions_boundary
  policy_arns             = var.iam.policy_arns
  policy_statements       = [
    {
      Action = [
        "ssm:GetParameter",
        "ssm:GetParametersByPath",
      ]
      Effect   = "Allow"
      Resource = ["/path/to/parameters/*"]
    },
    {
      Action   = ["kms:Decrypt"]
      Effect   = "Allow"
      Resource = [data.aws_kms_key.it.arn]
    },
  ]
  tags                    = var.tags
  trust_policy_statements = [
    {
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    },
  ]
}
```
