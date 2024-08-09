# IAM

## Setup

Need to have a keybase username, can be for each user, or can be just one.

## Configure

Add additional AWS policies to default.tfvars as needed, or include them in policy.tf

## Plan

```
terraform plan -var-file=default.tfvars
```

## decrypting login key

```
terraform output password | base64 --decode --ignore-garbage | keybase pgp decrypt

```

## Migrate from 1.x to 2.x

Migrate iam_users to the new format

If the 1.x iam_users was

```
iam_users = ["mark"]
```

then the new version is

```
 iam_users = {
   mark = {
     terraform_managed = true
     console_access = true
     cli_access = true
     pgp_key = "keybase:markcallen"
   }
 }
```

Add `moved` directives for each of the managed users from iam_users to the new format.

```
moved {
  from = module.iam.aws_iam_user.user[0]
  to   = module.iam.aws_iam_user.user["mark"]
}
moved {
  from = module.iam.aws_iam_user_login_profile.login_profile[0]
  to   = module.iam.aws_iam_user_login_profile.login_profile["mark"]
}
moved {
  from = module.iam.aws_iam_user_policy_attachment.access_keys_attach[0]
  to   = module.iam.aws_iam_user_policy_attachment.access_keys_attach["mark"]
}
```
