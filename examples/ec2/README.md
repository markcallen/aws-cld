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

```
cd env

terraform workspace new dev

terraform init
terraform plan -var-file=dev.tfvars
terraform apply -var-file=dev.tfvars
```
