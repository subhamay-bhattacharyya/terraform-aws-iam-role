![](https://img.shields.io/github/commit-activity/t/subhamay-bhattacharyya/terraform-aws-iam-role)&nbsp;![](https://img.shields.io/github/last-commit/subhamay-bhattacharyya/terraform-aws-iam-role)&nbsp;![](https://img.shields.io/github/release-date/subhamay-bhattacharyya/terraform-aws-iam-role)&nbsp;![](https://img.shields.io/github/repo-size/subhamay-bhattacharyya/terraform-aws-iam-role)&nbsp;![](https://img.shields.io/github/directory-file-count/subhamay-bhattacharyya/terraform-aws-iam-role)&nbsp;[](https://img.shields.io/github/issues/subhamay-bhattacharyya/terraform-aws-iam-role)&nbsp;![](https://img.shields.io/github/languages/top/subhamay-bhattacharyya/terraform-aws-iam-role)&nbsp;![](https://img.shields.io/github/commit-activity/m/subhamay-bhattacharyya/terraform-aws-iam-role)&nbsp;![](https://img.shields.io/endpoint?url=https://gist.githubusercontent.com/bsubhamay/14ec97a92b2d05a933f93fc85d3f836c/raw/terraform-aws-iam-role.json?)

## Terraform AWS IAM Role Module

### Usage

* Terraform module to create IAM Role / Policy / EC2 Instance profile.
* Module source: app.terraform.io/subhamay-bhattacharyya/iam-role/aws
* Version: 1.0.0

### Required Inputs:
- `role_name`: The name of the IAM role.
- `assume_role_policy`: The policy that grants an entity permission to assume the role.
- `managed_policy_arns`: A list of ARNs of the IAM managed policies to attach to the role.
- `inline_policies`: A map of inline policies to attach to the role.
- `tags`: A map of tags to assign to the resources.

### Example Usage:

```hcl
module "iam_role" {
  source  = "app.terraform.io/subhamay-bhattacharyya/iam-role/aws"
  version = "1.0.0"

  project-name                  = var.project-name
  iam-custom-role-with-policies = local.iam-custom-role-with-policies
  ec2-instance-profile-name     = var.ec2-instance-profile-name
  ci-build                      = var.ci-build
}
```

#### 
_Define the policy templates as *.tftpl* files in a seperate directory as follows:_

_DynamoDB Table Access Policy_
```hcl
{
   "Version":"2012-10-17",
   "Statement":[
      {
         "Sid":"AllowWriteAccessToDynamoDBTable",
         "Effect":"Allow",
         "Action": ${dynamodb-actions},
         "Resource": ["${dynamodb-table-arn}"]
      }
   ]
}
```

_S3 Bucket Policy_
```hcl
{
   "Version":"2012-10-17",
   "Statement":[
      {
         "Sid":"AllowFullAccessToS3Bucket",
         "Effect":"Allow",
         "Action": ${s3-bucket-actions},
         "Resource": ["${s3-bucket-arn}","${s3-bucket-arn}/*"]
      }
   ]
}
```

_Use local variables to generate the policy document_
```hcl

locals {

  template-vars = {
    s3-bucket-arn      = "arn:aws:s3:::${var.s3-bucket-name}"
    s3-bucket-actions  = jsonencode(var.s3-bucket-actions)
    dynamodb-table-arn = "arn:aws:dynamodb:${var.aws-region}:${data.aws_caller_identity.current.account_id}:table/${var.dynamodb-table-name}"
    dynamodb-actions   = jsonencode(var.dynamodb-actions)
  }

  customer-managed-policies = {
    "s3-policy"       = jsondecode(templatefile("policy-templates/s3-read-only-policy.tftpl", local.template-vars)),
    "dynamodb-policy" = jsondecode(templatefile("policy-templates/dynamodb-read-write-policy.tftpl", local.template-vars))
  }


  iam-custom-role-with-policies = {
    role-name        = "example-role"
    role-description = "This is an example role."
    role-path        = "/example/"
    assume-role-policy-document = {
      Version = "2012-10-17"
      Statement = [{
        Sid    = "AllowEC2Service"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }]
    }
    aws-managed-policies = [
      "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess",
      "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
    ]
    customer-managed-policies = local.customer-managed-policies
  }
}
```

##### Default tags

Use local variables to configure the default tags.
_The default resource tags are implemented using the CI/CD Pipeline. The following mao just refers to it._
```hcl
locals {
  tags = {
    Environment      = var.environment-name
    ProjectName      = var.project-name
    GitHubRepository = var.github-repo
    GitHubRef        = var.github-ref
    GitHubURL        = var.github-url
    GitHubSHA        = var.github-sha
  }
}
```
#### Note

- To skip the creation of IAM role with AWS managed policy pass `aws-managed-policies = null`
- To skip the creation of IAM role with AWS customer policy pass `customer-managed-policies = null`
- To skip the creation of EC2 instance profile pass `ec2-instance-profile-name = null`

## Inputs

| Name                         | Description                                                     | Type   | Default       | Required |
|-                             |-                                                                |-       |-              |-         |
| project-name                 | The name of the project                                         | string       | n/a     | yes      |
| iam-custom-role-with-policies| The policy that grants an entity permission to assume the role  | map(object)  | n/a     | yes      |
| ec2-instance-profile-name    | The name of EC2 instance profile                                | string       | ""      | yes      |
| ci-build                     | A string representing the CI build identifier                   | string       | ""      | yes      |

## Outputs

| Name                  | Description                                      |
|-                      |-                                                 |
| role-id               | The ID of the IAM role.                          |
| role-name             | The name of the IAM role.                        |
| role-arn              | The ARN of the IAM role.                         |
| policy-arn            | The ARN of the customer managed policy.          |
| instance-profile-id   | The ID of the instance profile.                  |
| instance-profile-name | The name of the instance profile.                |
| instance-profile-arn  | The ARN of the instance profile.                 |