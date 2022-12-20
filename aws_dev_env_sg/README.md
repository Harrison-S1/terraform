# aws_dev_env_sg

This is based on the aws_dev_env_mulyi folder but has had a Storage Gateway added. This is in its own seperat tf file, aka `sgwtf.tf`
> Note with this conifg the storage gateway does have a public IP, which is accessable on port 80 and is used during activation, but the nfs protocol use the private IP's

Read more here: https://docs.aws.amazon.com/filegateway/latest/files3/Requirements.html

Within main.tf under dev_node you can change the number of COUNT to the number of instances that you want. This is no Cloudwatch or SNS in this config.
You will also need to add the number of instance created into the output.tf file and address each one individually [Like a array]   

--------------------------------------------------------------------------------------------------------------------------------------
Terraform AWS dev environment

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

This will build the following:

- VPC
- Public subnet
- Internet Gateway
- Route Table
- Route Table Association
- Security Group
- Key Pair
- Ubuntu 22.04 instance (t2 micro), with the AMI detailed in the datasources.tf file
- Sinle S3 bucket
- IAM profile to attach to the instance
- Storage Gateway
  - Gateway role
  - S3 butcket
   - S3 policy
  - Storage gateway EC2 instance
    - Set the root block device to 80GB
    - 150GB EBS volume for the cahce disk
  - Ingress / Egress rules taken from AWS: https://docs.aws.amazon.com/storagegateway/latest/userguide/Resource_Ports.html
  - nfs file share