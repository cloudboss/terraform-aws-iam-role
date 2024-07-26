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

variable "create_instance_profile" {
  type        = bool
  description = "Whether or not to create an instance profile."

  default = false
}

variable "max_session_duration" {
  type        = number
  description = "Maximum duration in seconds for assume role session."

  default = null
}

variable "name" {
  type        = string
  description = "Name of the IAM role and policy, if created."
}

variable "path" {
  type        = string
  description = "Path of IAM role and policy, if created."

  default = null
}

variable "permissions_boundary" {
  type        = string
  description = "ARN of an IAM policy to use as a permissions boundary."

  default = null
}

variable "policy_arns" {
  type        = set(any)
  description = "ARNs of IAM policies to attach to the role."

  default = []
}

variable "policy_statements" {
  type        = list(any)
  description = "A list of statements for the IAM policy. If not defined, a policy will not be created."

  default = []
}

variable "tags" {
  type        = map(string)
  description = "Tags to be assigned to the role and policy, if created."

  default = {}
}

variable "trust_policy_statements" {
  type        = list(any)
  description = "A list of statements for the trust policy."
}
