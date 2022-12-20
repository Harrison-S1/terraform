  resource "aws_instance" "dev_gateway" {
  instance_type          = "m5.xlarge"
  ami                    = data.aws_ami.server_ami_gw.id
  key_name               = aws_key_pair.clouddev_auth.id
  vpc_security_group_ids = [aws_security_group.main_gateway_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.dev_profile.name
  subnet_id              = aws_subnet.main_public_subnet.id

  root_block_device {
    volume_size = 80
    volume_type = "gp3"
  }

  tags = {
    Name = "dev-gateway"
  }
  }

resource "aws_ebs_volume" "dev-cache" {
  availability_zone = "eu-west-2a"
  size = 150
  type = "gp3"
  encrypted = true

  tags = {
    Name = "dev-cache"
  }
    depends_on = [
    aws_instance.dev_gateway
  ]
}

resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/xvds"
  volume_id   = aws_ebs_volume.dev-cache.id
  instance_id = aws_instance.dev_gateway.id
}

data "aws_storagegateway_local_disk" "example" {
  disk_node   = "/dev/xvds"
  gateway_arn = aws_storagegateway_gateway.g1.arn
}

resource "aws_storagegateway_cache" "dev-cache" {
  disk_id     = data.aws_storagegateway_local_disk.example.id
  gateway_arn = aws_storagegateway_gateway.g1.arn
}


// NOTE: Ingress / Egress rules taken from AWS:
// https://docs.aws.amazon.com/storagegateway/latest/userguide/Resource_Ports.html
resource "aws_security_group" "main_gateway_sg" {
  name        = "dev-gateway"
  description = "Security Group for NFS File Gateway."
  vpc_id      = aws_vpc.mainvpc.id

  // Activation
  //////////////
  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  // NFS
  ///////
  ingress {
    protocol    = "tcp"
    from_port   = 20048
    to_port     = 20048
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol    = "udp"
    from_port   = 20048
    to_port     = 20048
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol    = "tcp"
    from_port   = 111
    to_port     = 111
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol    = "udp"
    from_port   = 111
    to_port     = 111
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol    = "tcp"
    from_port   = 2049
    to_port     = 2049
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol    = "udp"
    from_port   = 2049
    to_port     = 2049
    cidr_blocks = ["0.0.0.0/0"]
  }

  // DNS (?)
  ///////////
  ingress {
    protocol    = "tcp"
    from_port   = 53
    to_port     = 53
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol    = "udp"
    from_port   = 53
    to_port     = 53
    cidr_blocks = ["0.0.0.0/0"]
  }

  // Allow all egress
  ////////////////////
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_storagegateway_gateway" "g1" {
  gateway_name       = var.gateway_name
  gateway_timezone   = var.gateway_timezone
  gateway_type       = "FILE_S3"
  gateway_ip_address = aws_instance.dev_gateway.public_ip

  depends_on = [
    aws_instance.dev_gateway
  ]

}

resource "aws_storagegateway_nfs_file_share" "file_share" {
  client_list  = ["0.0.0.0/0"]
  gateway_arn  = aws_storagegateway_gateway.g1.arn
  location_arn = aws_s3_bucket.gate_buc.arn
  role_arn     = aws_iam_role.role.arn
}

resource "aws_iam_policy" "policy" {
  name        = "S3_policy"
  description = "Providing limited S3 powers"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
      "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "s3:GetAccelerateConfiguration",
                "s3:GetBucketLocation",
                "s3:GetBucketVersioning",
                "s3:ListBucket",
                "s3:ListBucketVersions",
                "s3:ListBucketMultipartUploads"
            ],
            "Resource": "arn:aws:s3:::${var.bucket_name}",
            "Effect": "Allow"
        },
        {
            "Action": [
                "s3:AbortMultipartUpload",
                "s3:DeleteObject",
                "s3:DeleteObjectVersion",
                "s3:GetObject",
                "s3:GetObjectAcl",
                "s3:GetObjectVersion",
                "s3:ListMultipartUploadParts",
                "s3:PutObject",
                "s3:PutObjectAcl"
            ],
            "Resource": "arn:aws:s3:::${var.bucket_name}/*",
            "Effect": "Allow"
        }
    ]
  })
}

resource "aws_iam_role" "role" {
  name = "gateway_role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "storagegateway.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    tag-key = "tag-value"
  }
}

resource "aws_iam_role_policy_attachment" "test-attach" {
  role       = aws_iam_role.role.name
  policy_arn = aws_iam_policy.policy.arn
}

resource "aws_s3_bucket" "gate_buc" {
  bucket = var.bucket_name

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }

}