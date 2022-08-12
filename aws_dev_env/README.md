This is a dev enviroment for AWS. You will need to create a user in AWS to deploy this.

- Log into your AWS account.
- Navigate to IAM and select Users on the left hand menu
- Select "Add users"
- Create the username
- Select "Access key - Programmatic access" and click next
- Select "Attach existing policies directly" and use the "AdministratorAccess" policy
> Dont do this for productions
- Tags are optional, so just click next, then create user

Now on the next page you need to add the details from user, access key ID and Secret access key to the aws credentials file.
```bash
~/.aws/credentials
```

> For example
```bash
[terraformuser]

# This key identifies your AWS account.

aws_access_key_id = QKIAUDRQURVLS2JCIV4

# Treat this secret key like a password. Never share it or store it in source

# control. If your secret key is ever disclosed, immediately use IAM to delete

# the key pair and create a new one.

aws_secret_access_key = nBhpjpTCyerter3sdf0l3QZ7zxV78ptCF
```

You will also want to create a new ssh key for this env called `clouddev` with
```BASH
ssh-keygen -t ed25519
```