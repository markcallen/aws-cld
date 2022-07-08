# IAM

## Setup

Create your public key
 - requires gpg setup to be completed 

```
gpg --armor --export your.email@address.com > public-key.gpg
```

## Configure

Add additional AWS policies to default.tfvars as needed, or include them in policy.tf

## Plan

```
terraform plan -var-file=default.tfvars
```

## decrypting login key

```
terraform show
```

copy the value from the passwords object for the user to get their initial password

echo "wcDMA4ABLtqBCTqMAQwAktzKCdZ9+QiYBzCtC3VV02BCk24b/GdHXswu19EYOicdKiNhi1TbNqsf+4aEqXJ9xR2t70WRdN4tTphmIO6WuhZ4MyZhI643P2wSGvkT3qt0IwaHpG5G3dUoilsQgGkMMvH5Ic71Fihiqy0yigUaMGn4vmCgAPP4NEYv1eFLf5v/db/nfgmR1U7LmIFas+IU0n1BxzuU42BGeWBKn/E4KpRhYGGauskIECDzn4j7oYFMnkB+ZpUoZZutfbn+sHyfQJi9c7NG07j7eHRYvHM6MkVJ1Tmmh3iVZQYnhvAuwyd764LJwiVrrm53AdWNJtE41EqjXommC+wZwJBB0nZ0zebVbHeaYf7okVJBrvXQ88pjVZ4u/8GhGOcIFroecjt9IMS9L3sKMyq1wFSQgqaik8v1qGoYCRDiP6vbsxgPruV+9xqvIbufSa+UvfQAYupYFl6SvQ4QjolxVj+++AvtuGNtaKbu+Myu5bc/GMsNPirjr6NtzzF8W7Wu8Hq8arOE0uAB5Mzv/kmOGUXKT0Rw6EywYfvhoungO+CH4Yzx4FPiYxyCluCU5KRsOserJK7eH37+9iupA6XgneIuate04ErkeiyYLuUpBcUbMae3KdFuJeID4MH64SpWAA==" | base64 -d > out.gpg

gpg -d --pinentry-mode loopback out.gpg
