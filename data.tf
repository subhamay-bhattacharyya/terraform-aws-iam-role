/*
####################################################################################################
# Terraform IAM Role Module Data Block Configuration
#
# Description: This module creates IAM Policy / IAM Role and EC2 Instance Profile.
#
# Author: Subhamay Bhattacharyya
# Created: 29-Dec-2024
# Version: 1.0
#
####################################################################################################
*/

# AWS Region and Caller Identity
data "aws_region" "current" {}

data "aws_caller_identity" "current" {}