# Copyright © 2024 Joseph Wright <joseph@cloudboss.co>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

locals {
  assume_role_policy = {
    Version   = local.policy_version
    Statement = var.trust_policy_statements
  }

  policy = (
    length(var.policy_statements) > 0
    ? {
      Version   = local.policy_version
      Statement = var.policy_statements
    }
    : null
  )

  policy_version = "2012-10-17"
}

resource "terraform_data" "validate" {
  lifecycle {
    precondition {
      condition = anytrue([
        length(var.policy_arns) > 0,
        length(var.policy_statements) > 0,
      ])
      error_message = "You must provide at least one policy ARN or policy statement."
    }
  }
}

resource "aws_iam_role" "it" {
  name = var.name

  assume_role_policy   = jsonencode(local.assume_role_policy)
  max_session_duration = var.max_session_duration
  path                 = var.path
  permissions_boundary = var.permissions_boundary
  tags                 = var.tags
}

resource "aws_iam_policy" "it" {
  count = local.policy == null ? 0 : 1

  name   = var.name
  path   = var.path
  policy = jsonencode(local.policy)
  tags   = var.tags
}

resource "aws_iam_role_policy_attachment" "it" {
  count = local.policy == null ? 0 : 1

  policy_arn = one(aws_iam_policy.it[*].arn)
  role       = aws_iam_role.it.name
}

resource "aws_iam_role_policy_attachment" "them" {
  for_each = var.policy_arns

  policy_arn = each.key
  role       = aws_iam_role.it.name
}

resource "aws_iam_instance_profile" "it" {
  count = var.create_instance_profile ? 1 : 0

  name = var.name
  role = aws_iam_role.it.name
}
