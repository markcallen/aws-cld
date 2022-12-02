# aws-cld/env

Environment specific configurations

Need to use the correct workspace

```
terraform workspace select <dev|stage|prod>
```

## modules

Reusable modules

## route53

Environment specific DNS zones for Route53.
 - not using for prod

## cloudflare

Environment specific DNS zones for Route53.
 - setting up DNS manually for api and app

## vpc

Creates VPCs

## vpc-peering

Creates peerings between vpcs

## aurora

Creates the Aurora databases

## eks_v2

Creates EKS cluster

## asm

Create AWS Secrets Manager keys
