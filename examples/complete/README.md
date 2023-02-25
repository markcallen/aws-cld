# aws-cld/examples/complete

## Run

```
cd bootstrap

terraform init
terraform plan
terraform apply
```

Will create files in infra and env.

Create infra

```
cd infra

gpg --export your.email@address.com | base64 > public-key.gpg

terraform init
terraform plan -var-file=default.tfvars
terraform apply -var-file=default.tfvars
```

Create env

```
cd env

terraform workspace new dev

terraform init
terraform plan -var-file=dev.tfvars
terraform apply -var-file=dev.tfvars
```

