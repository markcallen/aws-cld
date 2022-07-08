# aws-cloud

Where all the instracture is built

## Setup

Setup the following environment variables.  The cloudflare is only required to modify DNS.

AWS user should be an administrator.

```
export AWS_ACCESS_KEY_ID=
export AWS_SECRET_ACCESS_KEY=
export AWS_DEFAULT_REGION=us-east-1
export CLOUDFLARE_EMAIL=
export CLOUDFLARE_API_TOKEN=
```

Install [git-secret](https://git-secret.io/)

```
brew install git-secret
```

Create your public key

```
gpg --armor --export your.email@address.com > public-key.gpg
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

Edit local_data.json in the local directory for project specific info


