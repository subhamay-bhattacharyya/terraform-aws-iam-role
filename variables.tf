/*
####################################################################################################
# Terraform IAM Role Module Variabls Configuration
#
# Description: This module creates IAM Policy / IAM Role and EC2 Instance Profile.
#
# Author: Subhamay Bhattacharyya
# Created: 08-Dec-2024 
# Version: 1.0
#
####################################################################################################
*/

######################################## Project Name ##############################################
# This variable defines the name of the project.
# It is a string type variable with a default value of "your-project-name".
# You can override this default value by providing a different project name.
variable "project-name" {
  description = "The name of the project"
  type        = string
  default     = "your-project-name"
}

######################################## IAM Role / Policy #########################################

# This variable defines a map of roles with their respective policies.
# Each role can have multiple policies, which can be either AWS managed or customer managed.
# The map key is the role name, and the value is a list of policy ARNs.
variable "iam-custom-role-with-policies" {
  type = object({
    role-name        = string
    role-description = string
    role-path        = string
    assume-role-policy-document = object({
      Version = string
      Statement = list(object({
        Sid       = optional(string, "")
        Effect    = string
        Principal = optional(map(string), {}) # Optional Principal added
        Action    = string
        Condition = optional(map(any), {}) # Optional Condition added
      }))
    })
    aws-managed-policies      = optional(list(string))
    customer-managed-policies = optional(map(any))
  })
  description = <<EOF
A map of roles with their respective policies.
Each role can have multiple policies, which can be either AWS managed or customer managed.
The map key is the role name, and the value is a list of policy objects.
Each policy object contains:
- role-path: The path for the role.
- assume-role-policy-document: The JSON policy document that grants an entity permission to assume the role.
  - Principal: An optional map specifying the principal entities allowed to assume the role.
  - Condition: An optional map specifying conditions for assuming the role.
- aws-managed-policies: A list of ARNs for AWS managed policies.
- customer-managed-policies: A map of customer managed policies, where the key is the policy name and the value is an object containing:
  - policy-name: The name of the custom policy.
  - policy-document: The policy document for the custom policy, which includes:
    - Sid: The statement ID.
    - Effect: The effect of the policy (e.g., Allow or Deny).
    - Action: A list of actions that are allowed or denied by the policy.
    - Resource: A list of resources that the policy applies to.
    - Condition: An optional map of conditions that must be met for the policy to apply.
EOF
}

# This variable defines the name of the EC2 instance profile.
# Type: string
# Description: The name of the EC2 instance profile
# Default: ""
variable "ec2-instance-profile-name" {
  type        = string
  description = "The name of the EC2 instance profile"
  default     = ""
}

######################################## GitHub ####################################################
# The CI build string
# This variable defines the CI build string.
# It is a string type variable with a default value of an empty string.
variable "ci-build" {
  description = "The CI build string"
  type        = string
  default     = ""
}