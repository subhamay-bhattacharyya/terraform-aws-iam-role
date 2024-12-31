/*
####################################################################################################
# Terraform IAM Role Module Configuration
#
# Description: This module creates IAM Policy / IAM Role and EC2 Instance Profile.
#
# Author: Subhamay Bhattacharyya
# Created: 29-Dec-2024 
# Version: 1.0
#
####################################################################################################
*/

# Creates an IAM role with the specified name, description, path, and assume role policy.
# The role name is constructed using the project name, role name, environment name, and CI build identifier.
# Tags the IAM role with a Name tag constructed using the project name, environment name, and CI build identifier.
# 
# Arguments:
# - name: The name of the IAM role.
# - description: The description of the IAM role.
# - path: The path for the IAM role.
# - assume_role_policy: The policy that grants an entity permission to assume the role.
# - tags: A map of tags to assign to the IAM role.
resource "aws_iam_role" "iam_role" {
  name               = "${var.project-name}-${var.iam-custom-role-with-policies.role-name}${var.ci-build}"
  description        = var.iam-custom-role-with-policies.role-description
  path               = var.iam-custom-role-with-policies.role-path
  assume_role_policy = jsonencode(var.iam-custom-role-with-policies.assume-role-policy-document)

  tags = {
    Name = "${var.project-name}-${var.iam-custom-role-with-policies.role-name}${var.ci-build}"
  }
}


# This resource attaches AWS managed policies to an IAM role.
# 
# Arguments:
# - role: The name of the IAM role to attach the policies to.
# - count: The number of AWS managed policies to attach, determined by the length of the list `var.iam-custom-role-with-policies.aws-managed-policies`.
# - policy_arn: The ARN of the AWS managed policy to attach, indexed by `count.index` from the list `var.iam-custom-role-with-policies.aws-managed-policies`.
resource "aws_iam_role_policy_attachment" "aws_managed_policy_attachment" {
  role = aws_iam_role.iam_role.name

  count      = length(var.iam-custom-role-with-policies.aws-managed-policies)
  policy_arn = var.iam-custom-role-with-policies.aws-managed-policies[count.index]
}


# This resource block defines an AWS IAM Role Policy.
# It attaches customer-managed policies to an IAM role.
# 
# Arguments:
# - role: The ID of the IAM role to which the policy will be attached.
# - for_each: Iterates over the customer-managed policies defined in the variable `iam-custom-role-with-policies`.
# - name: The name of each policy, derived from the key of the iteration.
# - policy: The policy document, encoded in JSON format, derived from the value of the iteration.
resource "aws_iam_role_policy" "customer_managed_policies" {
  role = aws_iam_role.iam_role.id

  for_each = var.iam-custom-role-with-policies.customer-managed-policies
  name     = each.key
  policy   = jsonencode(each.value)
}

# Creates an IAM instance profile.
# The instance profile is created only if the `ec2-instance-profile-name` variable is not empty.
# 
# Arguments:
# - count: Determines whether to create the instance profile based on the `ec2-instance-profile-name` variable.
# - name: The name of the instance profile, constructed using the project name, instance profile name, environment name, and CI build identifier.
# - role: The IAM role to associate with the instance profile, referenced from the `aws_iam_role` resource.
resource "aws_iam_instance_profile" "iam_instance_profile" {
  count = var.ec2-instance-profile-name != "" ? 1 : 0
  name  = "${var.project-name}-${var.ec2-instance-profile-name}${var.ci-build}"
  role  = aws_iam_role.iam_role.name
}