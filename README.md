# aws-cloud

Common setup for building out aws infrastructure for dev, stage and prod.  Includes kubernetes (EKS), databases (Aurora) and caches (ElasticCache)

## Concepts

Environments
dev, stage, prod

## Architecture

Infra is for setup that does not require an environment

Env is for setup that is specific to each environment
 - requires using terraform workspaces to keep everything seperate in the state files

Using S3 to store the state information
 - need to update each backend.tf to point to the correct file in S3, done manually

## Setup

### AWS

Log into AWS with the root account and create a new user and attach the AdministratorAccess policy.  Turn on MFA.  Create a secure password.  Create access key and secret.
 - this user will not be used in the iam setup, just for running these scripts.

### Cloudflare

Log into the cloudflare dashboard using the main account and invite a user into the account.  Login with that user and create an API token.

### Environment

Setup the following environment variables.  The cloudflare is only required to modify DNS.

AWS user should be an administrator.

```
export AWS_ACCESS_KEY_ID=
export AWS_SECRET_ACCESS_KEY=
export AWS_DEFAULT_REGION=us-east-1
export CLOUDFLARE_EMAIL=
export CLOUDFLARE_API_TOKEN=
```

Install gpg

```
brew install gpg
```

configure gpg if necessary.

Install [git-secret](https://git-secret.io/)

```
brew install git-secret
```

Install tfenv

```
brew install tfenv
```

Install terraform 1.1.7

```
tfenv install 1.1.7
```

Use terraform 1.1.7

```
tfenv use 1.1.7
terraform --version

Terraform v1.1.7
```

## Configure

create bootstrap, infra and env directories

```
mkdir bootstrap infra env
```

copy local_data.json into the local directory

Edit local_data.json for project specific info


### Bootstrap

```
cd bootstrap
```

Call the bootstrap module to create the storage s3 bucket

bootstrap/main.tf

```
module "bootstrap" {
  source = "../../aws-cloud/bootstrap"
}

output "project" {
  value = module.bootstrap.project_name
}
```

if you don't supply a project variable then a project name will be created for you

```
terraform init
terraform plan
terraform apply
```

to get the name of the project

```
terraform output
```

make sure you encrypt the terraform.tfstate file and add it to git


### Infra

```
cd infra
```


if using iam
```
gpg --export your.email@address.com | base64 > public-key.gpg
```

infra/main.tf
```
module "iam" {
  source = "../../aws-cloud/infra/iam"
  
  public_key_filename = "./public-key.gpg"

  iam_users = ["test1_eng", "test1_ops"]
  eng_users = ["test1_eng"]
  ops_users = ["test1_ops"]
}

module "iam" {
  source = "../../aws-cloud/infra/iam"
  
  ecr_repositories = ["example1", "example2"]
}
```


```
terraform init
terraform plan -var-file=default.tfvars
terraform apply -var-file=default.tfvars
```


