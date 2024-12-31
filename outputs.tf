/*
####################################################################################################
# Terraform IAM Role Module Outputs Configuration
#
# Description: This module creates IAM Policy / IAM Role and EC2 Instance Profile.
#
# Author: Subhamay Bhattacharyya
# Created: 29-Dec-2024 
# Version: 1.0
#
####################################################################################################
*/


# This output block defines an output variable named "iam-role-id".
# The description attribute provides a brief explanation of the output, indicating that it represents the IAM Role ID.
# The value attribute retrieves the ID of the IAM role from the aws_iam_role resource named "iam_role".
output "iam-role-id" {
  description = "IAM Role ID"
  value       = aws_iam_role.iam_role.id
}

# This output variable provides the name of the IAM Role created by this module.
# 
# Attributes:
# - description: A brief description of the output variable.
# - value: The name of the IAM Role resource created, referenced from the aws_iam_role resource.
output "iam-role-name" {
  description = "IAM Role Name"
  value       = aws_iam_role.iam_role.name
}

# This output variable provides the Amazon Resource Name (ARN) of the IAM Role.
# The ARN is a unique identifier for the IAM Role created by this module.
# 
# Attributes:
# - description: A brief description of the output variable.
# - value: The ARN of the IAM Role, sourced from the aws_iam_role resource.
output "iam-role-arn" {
  description = "IAM Role ARN"
  value       = aws_iam_role.iam_role.arn
}

# This output block defines an output variable named "iam-policy-arn".
# The description attribute provides a brief explanation of the output, indicating that it represents the ARN of an IAM Policy.
# The value attribute uses the try function to attempt to retrieve the ARNs of customer-managed IAM policies attached to the IAM role.
# If no customer-managed policies are attached, it returns the string "No Customer Managed Policy Attached".
output "iam-policy-arn" {
  description = "IAM Policy ARN"
  value       = try(aws_iam_role_policy.customer_managed_policies[*].arn, "No Customer Managed Policy Attached")
}


# This output provides the ID of the IAM instance profile.
# If no instance profile is attached, it returns "No Instance Profile Attached".
# 
# Attributes:
# - description: A brief description of the output.
# - value: The ID of the IAM instance profile or a fallback message if not attached.
output "instance-profile-id" {
  description = "Instance Profile ID"
  value       = try(aws_iam_instance_profile.iam_instance_profile[0].id, "No Instance Profile Attached")
}

# This output variable provides the name of the IAM instance profile.
# If the instance profile is not attached, it returns "No Instance Profile Attached".
# 
# Attributes:
# - description: A brief description of the output variable.
# - value: The name of the IAM instance profile or a fallback message if not attached.
output "instance-profile-name" {
  description = "Instance Profile Name"
  value       = try(aws_iam_instance_profile.iam_instance_profile[0].name, "No Instance Profile Attached")
}

# This output provides the ARN of the IAM instance profile.
# If no instance profile is attached, it returns "No Instance Profile Attached".
# 
# Output:
# - instance-profile-arn: The ARN of the IAM instance profile.
output "instance-profile-arn" {
  description = "Instance Profile ARN"
  value       = try(aws_iam_instance_profile.iam_instance_profile[0].arn, "No Instance Profile Attached")
}
