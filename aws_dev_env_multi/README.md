# aws_dev_env_multi

This is based on the aws_dev_env folder but has been modified to use more than one instances using COUNT.
Within main.tf under dev_node you can change the number of COUNT to the number of instances that you want. The Cloudwatch alarms are also tied into this. You will need to change the count under to each alarm. You could move the count into variables.tf to link it all together.
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
- IAM role to allow the instance to communicate with AWS CloudWatch
- IAM profile to attach to the instance
- SNS Topic
  - You need to change the email address within sns.tf if you want email to come through.
- Cloudwatch monitoring and alarms
  - CPU system
  - CPU user
  - RAM usage
  - Swap usage
  - Status Check Failed status
  - Disk usage

You can test the alarms by running the following stress tests:
```BASH
sudo apt install stress
```

```BASH
sudo stress --cpu 12
```
This will max out the CPU.

```BASH
fallocate -l 6.8GB test.img
```
Will take storage to 95%.

> There is a template file for cloudwatch in this repo called cloudwatch.config that you can use in place of the one being used in the userdata

The **userdata** will update the instance, install and set up the cloudwatch configuration file, install docker and add the user to the docker group.
This will give you a good base to develop from. Furhter reading check out the Terraform [Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)