# aws-cld

Common setup for building out AWS infrastructure for dev, stage and prod.  Includes kubernetes (EKS), databases (Aurora), caches (ElasticCache) and ec2 instances.
N
## Concepts

Bootstrap creates the s3 bucket that all state will be stored.  It will generate the backend.tf and tfvar files.

Infra stores configurations that are for the entire project such as IAM users and roles.

Env includes configurations for different environments.  By default they are dev, stage and prod.
 - requires using terraform workspaces to keep everything seperate in the state files

## Architecture


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
  source = "github.com/markcallen/aws-cld//bootstrap/"
  project = "myproject"
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
variable "project" {
}

module "iam" {
  source = "github.com/markcallen/aws-cld//infra/iam"

  project             = var.project
  public_key_filename = "./public-key.gpg"
  iam_users           = ["test1_eng", "test1_ops"]
  eng_users           = ["test1_eng"]
  ops_users           = ["test1_ops"]
}

module "ecr" {
  source = "github.com/markcallen/aws-cld//infra/ecr"

  project          = var.project
  ecr_repositories = ["example1", "example2"]
}
```

If you already have users created in IAM and just want to add them to the project then
leave the iam_users array empty and include the users you want in this project to 
eng_users and ops_users.


```
terraform init
terraform plan -var-file=default.tfvars
terraform apply -var-file=default.tfvars
```

### Env

Create workspaces for each environment

```
terraform workspace new {dev, prod}
```

vpc && vpc-peering

```
module "vpc" {
  source = "../../aws-cloud/env/vpc"

  project        = var.project
  environment    = var.environment
  region_us_east = var.region_us_east
  region_us_west = var.region_us_west
  cidr           = var.cidr
  subnet_count   = var.subnet_count
}

module "vpc_peering" {
  source = "../../aws-cloud/env/vpc-peering"

  project        = var.project
  environment    = var.environment
  region_us_east = var.region_us_east
  region_us_west = var.region_us_west
  vpc_id_us_east = module.vpc.us_east_vpc.vpc_id
  vpc_id_us_west = module.vpc.us_west_vpc.vpc_id
}
```

add to variables.tf

```
variable "cidr" {
}
variable "region_us_east" {
}
variable "region_us_west" {
}
```

add to dev.tfvars
```
cidr = {
  us_east = "10.111.0.0/16"
  us_west = "10.112.0.0/16"
}
region_us_east = "us-east-1"
region_us_west = "us-west-1"
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

Route53

add to dev.tfvars

```
domain = "mydomain.com"
```

```
module "route53" {
  source = "../../aws-cloud/env/route53"

  project        = var.project
  environment    = var.environment
  domain         = var.domain
}
```

EC2

```
module "ec2" {
  source = "../../aws-cloud/env/ec2"

  project        = var.project
  environment    = var.environment
  region_us_east = var.region_us_east
  region_us_west = var.region_us_west
  vpc_id_us_east = module.vpc.us_east_vpc.vpc_id
  vpc_id_us_west = module.vpc.us_west_vpc.vpc_id

  name = "my project"

  route53_zone_id_us_east = module.route53.us_east.zone_id
  route53_zone_id_us_west = module.route53.us_west.zone_id

  ssh_keys = ["ssh-rsa AA... my@key"]
}

```

Ansible

To create an inventory file for ansible add the following:

```
resource "local_file" "inventory" {
  content         = format("%s", module.ec2.inventory)
  file_permission = "0644"
  filename        = "${path.module}/ansible/${var.environment}"
}
```

ansible/requirements.yaml
```
- name: geerlingguy.docker
- name: deekayen.awscli2
```

ansible/docker.yaml
```
- hosts: all
  vars:
  ⦙ docker_install_compose: true
  ⦙ docker_users:
  ⦙ ⦙ - ubuntu
  become: true
  roles:
  ⦙ - geerlingguy.docker
  ⦙ - deekayen.awscli2
```

run

```
cd ansible
ansible-galaxy role install -r requirements.yaml
ansible-playbook -i dev -u ubuntu docker.yaml
```
