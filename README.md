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

Log into the cloudflare dashboard using the main account and invite a user into the account.  Login with that user and create an API token with Edit:DNS.

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

Use [tflint](https://github.com/terraform-linters/tflint)

```
brew install tflint
```

Setup alias for terraform
```
alias tf=terraform
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
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  required_version = ">= 0.13"
}

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
terraform init
terraform workspace new dev
terraform workspace new prod
```

vpc && vpc-peering

Add to variables.tf

```
variable "cidr" {
  type = string
}
variable "region_us_east" {
  type = string
}
variable "region_us_west" {
  type = string
}
variable "subnet_count" {
  type = map(any)
}
```

Create main.tf

```
module "vpc" {
  source = "github.com/markcallen/aws-cld//env/vpc"

  project        = var.project
  environment    = var.environment
  region_us_east = var.region_us_east
  region_us_west = var.region_us_west
  cidr           = var.cidr
  subnet_count   = var.subnet_count
}

module "vpc_peering" {
  source = "github.com/markcallen/aws-cld//env/vpc-peering"

  project        = var.project
  environment    = var.environment
  region_us_east = var.region_us_east
  region_us_west = var.region_us_west
  vpc_id_us_east = module.vpc.us_east_vpc.vpc_id
  vpc_id_us_west = module.vpc.us_west_vpc.vpc_id
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
subnet_count   = 2
```

Need to target the module.vpc before setting up the vpc-peering

Make sure you are in the correct workspace

```
terraform workspace select dev
terraform init
terraform plan -var-file=dev.tfvars -target module.vpc
terraform apply -var-file=dev.tfvars -target module.vpc
```

```
terraform plan -var-file=dev.tfvars
terraform apply -var-file=dev.tfvars
```

Route53

Adding a set of environment domains

add to variables.tf

```
variable "domain" {
  type = string
}
variable "environment_dns_name" {
  type = string
}
```

add to main.tf

```
module "route53" {
  source = "github.com/markcallen/aws-cld//env/route53"

  project             = var.project
  environment         = var.environment
  environment_name    = var.environment_dns_name
  domain              = var.domain
}
```

add to dev.tfvars

```
domain = "mydomain.com"
environment_dns_name = "d"
```

Adding environment domains to a route53 root domain

```
module "route53ns" {
  source = "github.com/markcallen/aws-cld//env/route53-ns"

  project          = var.project
  environment      = var.environment
  environment_name = var.environment_dns_name
  domain           = var.domain
  name_servers     = module.route53.environment.name_servers

  depends_on = [
    module.route53.environment
  ]
}
```

ACM


```
module "acm" {
  source = "github.com/markcallen/aws-cld//env/acm"

  project          = var.project
  environment      = var.environment
  environment_name = var.environment_dns_name
  domain           = var.domain
  region_us_east   = var.region_us_east
  region_us_west   = var.region_us_west


  subject_alternative_names = [
    "*.${var.environment_dns_name}.${var.domain}",
  ]
}

```

subject_alternative_names can included specific domain names if a wildcard is needed


EKS

Add to variables.tf

```
variable "app_desired_count" {
}
variable "app_max_count" {
}
variable "app_min_count" {
}
variable "enable_us_east" {
}
variable "enable_us_west" {
}

```

Add to main.tf

```
module "eks" {
  source = "github.com/markcallen/aws-cld//env/eks"

  project           = var.project
  environment       = var.environment
  app_desired_count = var.app_desired_count
  app_min_count     = var.app_min_count
  app_max_count     = var.app_max_count

  enable_us_east = var.enable_us_east
  enable_us_west = var.enable_us_west
}

```

Add to dev.tfvars
```
app_desired_count = 1
app_max_count     = 5
app_min_count     = 1
enable_us_east    = 1
enable_us_west    = 0
```

Add to outputs.tf

```
output "cluster_id" {
  value = module.eks.cluster_id
}
```

Enable us_east and us_west clusters using enable_us_east or enable_us_west to a number greater than 0.
 - TODO: this is not working yet

Configure kubectl

Get the cluster name

```
terraform output cluster_id
```

```
aws eks update-kubeconfig --region <region> --name <cluster_id>
```

EC2

```
module "ec2" {
  source = "github.com/markcallen/aws-cld//env/ec2"

  project        = var.project
  environment    = var.environment
  region_us_east = var.region_us_east
  region_us_west = var.region_us_west

  route53_zone_id_us_east = module.route53.us_east.zone_id
  route53_zone_id_us_west = module.route53.us_west.zone_id

  ssh_keys = ["ssh-rsa AA... my@key"]

  instance_count_us_east = 1
  instance_count_us_west = 0

  extra_disk_size  = 100
  extra_disk_count = 1
}

```

Cloudflare

Adding environment domains to a cloudflare root domain

```
module "cloudflarens" {
  source = "github.com/markcallen/aws-cld//env/cloudflare-ns"

  project      = var.project
  environment  = var.environment
  name_servers = module.route53.environment.name_servers
  zone_id      = var.zone_id

  depends_on = [
    module.route53.environment
  ]
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
    docker_install_compose: true
    docker_users:
      - ubuntu
  become: true
  roles:
    - geerlingguy.docker
    - deekayen.awscli2
```

ansible/data.yaml
```
- hosts: all
  become: yes
  become_method: sudo
  roles:
    - role: aws-volumes
      vars:
        ebs_volumes:
          data:
            device_name: /dev/xvdh
            mount_point: "/data"
            fs: ext4
            mount_opts: noatime,nodiratime
            owner: ubuntu
            group: ubuntu
```

run

```
cd ansible
ansible-galaxy role install -r requirements.yaml
ansible-playbook -i dev -u ubuntu docker.yaml
ansible-playbook -i dev -u ubuntu data.yaml
```

## License

Distributed under the Apache-2.0 License. See `LICENSE` for more information.

## Contact

Your Name - [@markcallen](https://www.linkedin.com/in/markcallen/)

Project Link: [https://github.com/markcallen/aws-cld](https://github.com/markcallen/aws-cld)

