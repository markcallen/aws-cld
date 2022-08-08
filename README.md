# aws-cloud

Common setup for building out aws infrastructure for dev, stage and prod.  Includes kubernetes (EKS), databases (Aurora) and caches (ElasticCache)

## Concepts

Bootstrap creates the s3 bucket that all state will be stored.  It will generate the backend.tf and tfvar files.

Infra stores configurations that are for the entire project such as IAM users and roles.

Env includes configurations for different environments.  By default they are dev, stage and prod.

## Architecture

Infra is for setup that does not require an environment

Env is for setup that is specific to each environment
 - requires using terraform workspaces to keep everything seperate in the state files

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

if you don't supply a project variable in the bootstrap module then a project name will be created for you

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

module "ecr" {
  source = "../../aws-cloud/infra/iam"
  
  ecr_repositories = ["example1", "example2"]
}
```


```
terraform init
terraform plan -var-file=default.tfvars
terraform apply -var-file=default.tfvars
```

### Env

Create workspaces for each environment

```
terraform workspace new {dev, stage, prod}
```

vpc && vpc-peering

```
module "vpc" {
  source = "../../aws-cloud/env/vpc"

  project        = var.project
  region_us_east = var.region_us_east
  region_us_west = var.region_us_west
  cidr           = var.cidr
  subnet_count   = var.subnet_count
  environment    = var.environment
}

module "vpc_peering" {
  source = "../../aws-cloud/env/vpc-peering"

  project        = var.project
  region_us_east = var.region_us_east
  region_us_west = var.region_us_west
  vpc_us_east_id = module.vpc.us_east_vpc.vpc_id
  vpc_us_west_id = module.vpc.us_west_vpc.vpc_id
  environment    = var.environment
}
```

Need to target the module.vpc before setting up the vpc-peering

```
terraform init
terraform plan -var-file=dev.tfvars -target module.vpc
terraform apply -var-file=dev.tfvars -target module.vpc
```

```
terraform plan -var-file=dev.tfvars
terraform apply -var-file=dev.tfvars
```

