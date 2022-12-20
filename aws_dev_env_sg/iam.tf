resource "aws_iam_role" "EC2_dev_role" {
  name = "EC2_dev_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = {
      tag-key = "dev"
  }
}

resource "aws_iam_instance_profile" "dev_profile" {
  name = "dev_profile"
  role = "${aws_iam_role.EC2_dev_role.name}"
}

resource "aws_iam_role_policy" "s3-dev" {
  name = "s3-dev"
  role = "${aws_iam_role.EC2_dev_role.id}"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:*",
                "s3-object-lambda:*"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}
