# aws-cloud/infra

Run these in the following order

## S3

This is the terraform to build the bucket where the terraforms will be stored.  Its is the only one where a terraform.state file will be kept.  All others will use the S3 provider.

Make sure you checkin the terraform.state file into github using git-secret.

## iam

Creating users and managing groups and policies

## ecr

Docker container registry

## acm

Certificates
 - needs to be run after creating route53 specific environment zones
