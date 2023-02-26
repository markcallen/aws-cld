# aws-cld/examples/ec2

## Run

```
cd bootstrap

terraform init
terraform plan
terraform apply
```

Will create files in infra and env.

There are no infra setting for this so go directly to the env directory.

Edit variables.tf and add

```
variable "cidr" {
  type = map(any)
}
variable "region_us_east" {
  type = string
}
variable "region_us_west" {
  type = string
}
variable "subnet_count" {
  type = number
}
variable "ssh_keys" {
  type = list(any)
}
```

Edit dev.tfvars and add

```
cidr = {
  us_east = "10.111.0.0/16"
  us_west = "10.112.0.0/16"
}
region_us_east = "us-east-1"
region_us_west = "us-west-1"
subnet_count   = 2

ssh_keys = ["ssh-rsa AA... my@key"]
```

```
terraform workspace new dev

terraform init
terraform plan -var-file=dev.tfvars -target=module.vpc
terraform apply -var-file=dev.tfvars -target=module.vpc
terraform plan -var-file=dev.tfvars
terraform apply -var-file=dev.tfvars
```

To create a production environment add the following to prod.tfvars

```
cidr = {
  us_east = "10.121.0.0/16"
  us_west = "10.122.0.0/16"
}
region_us_east = "us-east-1"
region_us_west = "us-west-1"
subnet_count   = 2

ssh_keys = ["ssh-rsa AA... my@key"]
```

```
terraform workspace new prod

terraform init
terraform plan -var-file=prod.tfvars -target=module.vpc
terraform apply -var-file=prod.tfvars -target=module.vpc
terraform plan -var-file=prod.tfvars
terraform apply -var-file=prod.tfvars
```
