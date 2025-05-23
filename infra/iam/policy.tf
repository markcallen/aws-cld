resource "aws_iam_policy" "access_keys" {
  name        = "${var.project}-Manage_Access_Keys"
  path        = "/"
  description = "Manage Access Keys"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowViewAccountInfo",
            "Effect": "Allow",
            "Action": [
                "iam:GetAccountPasswordPolicy",
                "iam:GetAccountSummary",
                "iam:GenerateServiceLastAccessedDetails"
            ],
            "Resource": "*"
        },
        {
            "Sid": "AllowViewOwnAccountInfo",
            "Effect": "Allow",
            "Action": [
                "iam:ListUserPolicies",
                "iam:ListAttachedUserPolicies",
                "iam:ListGroupsForUser",
                "iam:ListUserTags",
                "iam:ListServiceSpecificCredentials",
                "iam:GetLoginProfile",
                "iam:ListSigningCertificates"
            ],
            "Resource": "arn:aws:iam::*:user/$${aws:username}"
        },
        {
            "Sid": "AllowManageOwnAccessKeys",
            "Effect": "Allow",
            "Action": [
                "iam:CreateAccessKey",
                "iam:DeleteAccessKey",
                "iam:ListAccessKeys",
                "iam:UpdateAccessKey",
                "iam:GetAccessKeyLastUsed"
            ],
            "Resource": "arn:aws:iam::*:user/$${aws:username}"
        },
        {
            "Sid": "AllowManageOwnSigningCertificates",
            "Effect": "Allow",
            "Action": [
                "iam:DeleteSigningCertificate",
                "iam:ListSigningCertificates",
                "iam:UpdateSigningCertificate",
                "iam:UploadSigningCertificate"
            ],
            "Resource": "arn:aws:iam::*:user/$${aws:username}"
        },
        {
            "Sid": "AllowManageOwnSSHPublicKeys",
            "Effect": "Allow",
            "Action": [
                "iam:DeleteSSHPublicKey",
                "iam:GetSSHPublicKey",
                "iam:ListSSHPublicKeys",
                "iam:UpdateSSHPublicKey",
                "iam:UploadSSHPublicKey"
            ],
            "Resource": "arn:aws:iam::*:user/$${aws:username}"
        },
        {
            "Sid": "AllowManageOwnGitCredentials",
            "Effect": "Allow",
            "Action": [
                "iam:CreateServiceSpecificCredential",
                "iam:DeleteServiceSpecificCredential",
                "iam:ListServiceSpecificCredentials",
                "iam:ResetServiceSpecificCredential",
                "iam:UpdateServiceSpecificCredential"
            ],
            "Resource": "arn:aws:iam::*:user/$${aws:username}"
        }
    ]
}
  EOF
}

resource "aws_iam_policy" "mfa" {
  name        = "${var.project}-Manage_MFA"
  path        = "/"
  description = "Manage MFA"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowViewAccountInfo",
            "Effect": "Allow",
            "Action": [
                "iam:GetAccountPasswordPolicy",
                "iam:ListVirtualMFADevices",
                "iam:GetAccountSummary",
                "iam:GenerateServiceLastAccessedDetails"
            ],
            "Resource": "*"
        },
        {
            "Sid": "AllowManageOwnPasswords",
            "Effect": "Allow",
            "Action": [
                "iam:ChangePassword",
                "iam:GetUser"
            ],
            "Resource": "arn:aws:iam::*:user/$${aws:username}"
        },
        {
            "Sid": "AllowIndividualUserToManageTheirOwnMFA",
            "Effect": "Allow",
            "Action": [
                "iam:CreateVirtualMFADevice",
                "iam:DeleteVirtualMFADevice",
                "iam:ListMFADevices",
                "iam:EnableMFADevice",
                "iam:ResyncMFADevice"
            ],
            "Resource": [
                "arn:aws:iam::*:mfa/*",
                "arn:aws:iam::*:user/$${aws:username}"
            ]
        },
        {
            "Sid": "AllowIndividualUserToDeactivateOnlyTheirOwnMFAOnlyWhenUsingMFA",
            "Effect": "Allow",
            "Action": [
                "iam:DeactivateMFADevice"
            ],
            "Resource": [
                "arn:aws:iam::*:mfa/*",
                "arn:aws:iam::*:user/$${aws:username}"
            ],
            "Condition": {
                "Bool": {
                    "aws:MultiFactorAuthPresent": "true"
                }
            }
        },
        {
            "Sid": "DenyAllExceptListedIfNoMFA",
            "Effect": "Deny",
            "NotAction": [
                "iam:CreateVirtualMFADevice",
                "iam:EnableMFADevice",
                "iam:GetUser",
                "iam:GetMFADevice",
                "iam:ListMFADevices",
                "iam:ListVirtualMFADevices",
                "iam:ResyncMFADevice",
                "sts:GetSessionToken"
            ],
            "Resource": "*",
            "Condition": {
                "BoolIfExists": {
                    "aws:MultiFactorAuthPresent": "false"
                }
            }
        }
    ]
}
EOF
}

resource "aws_iam_policy" "ecr" {
  name        = "${var.project}-Publish_ECR"
  path        = "/"
  description = "Publish ECR"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowAccountPush",
            "Effect": "Allow",
            "Action": [
                "ecr:GetDownloadUrlForLayer",
                "ecr:BatchGetImage",
                "ecr:BatchCheckLayerAvailability",
                "ecr:PutImage",
                "ecr:InitiateLayerUpload",
                "ecr:UploadLayerPart",
                "ecr:CompleteLayerUpload"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_policy" "ssh_connect" {
  name        = "${var.project}-ssh_connect"
  path        = "/"
  description = "SSH Connect"
  policy      = <<EOF
{
   "Version":"2012-10-17",
   "Statement":[
      {
         "Sid": "AllowEc2InstanceConnect",
         "Effect": "Allow",
         "Action": "ec2-instance-connect:SendSSHPublicKey",
         "Resource": "arn:aws:ec2:*:691386466418:instance/*"
      },
      {
        "Sid": "AllowEc2DescribeInstances",
        "Effect": "Allow",
        "Action": "ec2:Describe*",
        "Resource": "*"
      }
   ]
}
EOF
}

# Following are from: https://docs.aws.amazon.com/eks/latest/userguide/security_iam_id-based-policy-examples.html
resource "aws_iam_policy" "eks_console" {
  name        = "${var.project}-eks_console"
  path        = "/"
  description = "Use the EKS console"
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "eks:*"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "iam:PassRole",
            "Resource": "*",
            "Condition": {
                "StringEquals": {
                    "iam:PassedToService": "eks.amazonaws.com"
                }
            }
        }
    ]
}
EOF
}

resource "aws_iam_policy" "lamda_serverless" {
  name        = "${var.project}-Lamda_Serverless"
  path        = "/"
  description = "use serverless to deploy lamba"
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
          "Sid": "ValidateCloudFormation",
          "Effect": "Allow",
          "Action": [
            "cloudformation:ValidateTemplate"
          ],
          "Resource": [
            "*"
          ]
        },
        {
          "Sid": "ExecuteCloudFormation",
          "Effect": "Allow",
          "Action": [
            "cloudformation:CreateChangeSet",
            "cloudformation:CreateStack",
            "cloudformation:DeleteChangeSet",
            "cloudformation:DeleteStack",
            "cloudformation:DescribeChangeSet",
            "cloudformation:DescribeStackEvents",
            "cloudformation:DescribeStackResource",
            "cloudformation:DescribeStackResources",
            "cloudformation:DescribeStacks",
            "cloudformation:ExecuteChangeSet",
            "cloudformation:ListStackResources",
            "cloudformation:SetStackPolicy",
            "cloudformation:UpdateStack",
            "cloudformation:UpdateTerminationProtection",
            "cloudformation:GetTemplate"
          ],
          "Resource": [
            "*"
          ]
        },
        {
          "Sid": "DeployLambdaFunctions",
          "Effect": "Allow",
          "Action": [
            "lambda:Get*",
            "lambda:List*",
            "lambda:CreateFunction",
            "lambda:DeleteFunction",
            "lambda:CreateFunction",
            "lambda:DeleteFunction",
            "lambda:UpdateFunctionConfiguration",
            "lambda:UpdateFunctionCode",
            "lambda:PublishVersion",
            "lambda:CreateAlias",
            "lambda:DeleteAlias",
            "lambda:UpdateAlias",
            "lambda:AddPermission",
            "lambda:RemovePermission",
            "lambda:InvokeFunction",
            "lambda:PublishLayerVersion"
          ],
          "Resource": [
            "*"
          ]
       },
       {
         "Sid": "DeployAPIGateway",
         "Effect": "Allow",
         "Action": [
            "apigateway:GET",
            "apigateway:POST",
            "apigateway:PUT",
            "apigateway:PATCH",
            "apigateway:DELETE"
          ],
          "Resource": [
           "*"
          ]
       },
       {
         "Sid": "DeployLogGroups",
         "Effect": "Allow",
         "Action": [
            "logs:CreateLogGroup",
            "logs:Get*",
            "logs:Describe*",
            "logs:List*",
            "logs:DeleteLogGroup",
            "logs:PutResourcePolicy",
            "logs:DeleteResourcePolicy",
            "logs:PutRetentionPolicy",
            "logs:DeleteRetentionPolicy",
            "logs:TagLogGroup",
            "logs:UntagLogGroup",
            "logs:CreateLogDelivery",
            "logs:DeleteLogDelivery",
            "logs:DescribeResourcePolicies",
            "logs:DescribeLogGroups"
          ],
          "Resource": [
           "*"
          ]
       }
    ]
}
EOF
}
