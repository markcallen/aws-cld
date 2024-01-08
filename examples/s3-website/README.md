# aws-cld/examples/s3-website

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
```

Edit dev.tfvars and add

```
```

```
terraform init

terraform workspace new dev

terraform plan -var-file=dev.tfvars
terraform apply -var-file=dev.tfvars
```

To create a production environment add the following to prod.tfvars

```
```

```
terraform init

terraform workspace new prod

terraform plan -var-file=prod.tfvars
terraform apply -var-file=prod.tfvars
```

Upload index.html file

```
aws s3 cp index.html <website_endpoint>
```
