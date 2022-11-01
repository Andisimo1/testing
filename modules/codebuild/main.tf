resource "aws_s3_bucket" "example" {
  bucket = "codebuild-2132137"
}

resource "aws_s3_bucket_acl" "example" {
  bucket = aws_s3_bucket.example.id
  acl    = "private"
}

resource "null_resource" "import_source_credentials" {

  
  triggers = {
    github_oauth_token = var.github_token
  }

  provisioner "local-exec" {
    command = <<EOF
      aws --region ${var.region} codebuild import-source-credentials \
                                                             --token ${var.github_token} \
                                                             --server-type GITHUB \
                                                             --auth-type PERSONAL_ACCESS_TOKEN
EOF
  }
}

resource "aws_security_group" "codebuild_sg" {
  name        = "allow_vpc_connectivity"
  description = "Allow Codebuild connectivity to all the resources within our VPC"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_iam_role" "example" {
  name = "codebuild"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}



resource "aws_iam_role_policy" "example" {
  role = aws_iam_role.example.name

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
            "ec2:CreateNetworkInterface",
            "ec2:DescribeDhcpOptions",
            "ec2:DescribeNetworkInterfaces",
            "ec2:DeleteNetworkInterface",
            "ec2:DescribeSubnets",
            "ec2:DescribeSecurityGroups",
            "ec2:DescribeVpcs",
            "ssm:GetParameters",
            "logs:PutLogEvents",
            "logs:CreateLogStream",
            "logs:CreateLogGroup",
            "ecr:UploadLayerPart",
            "ecr:PutImage",
            "ecr:InitiateLayerUpload",
            "ecr:GetAuthorizationToken",
            "ecr:CompleteLayerUpload",
            "ecr:BatchCheckLayerAvailability"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:CreateNetworkInterfacePermission"
      ],
      "Resource": "arn:aws:ec2:eu-central-1:366915744137:network-interface/*",
      "Condition": {
        "StringEquals": {
          "ec2:AuthorizedService": "codebuild.amazonaws.com"
        },
        "ArnEquals": {
          "ec2:Subnet": [
            "arn:aws:ec2:eu-central-1:366915744137:subnet/*"
          ]
        }
      }
    }
  ]
}
POLICY
}

resource "aws_codebuild_project" "example" {
  depends_on = [null_resource.import_source_credentials]
  name          = "test-project"
  description   = "test_codebuild_project"
  build_timeout = "5"
  service_role  = aws_iam_role.example.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  cache {
    type     = "S3"
    location = aws_s3_bucket.example.bucket
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image = "aws/codebuild/standard:4.0"
    type = "LINUX_CONTAINER"
    privileged_mode = true
    image_pull_credentials_type = "CODEBUILD"

    environment_variable {
      name = "CI"
      value = "true"
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "log-group"
      stream_name = "log-stream"
    }

    s3_logs {
      status   = "ENABLED"
      location = "${aws_s3_bucket.example.id}/build-log"
    }
  }

  source {
    type            = "GITHUB"
    location        = "https://github.com/Andisimo1/CatsApp-DockerHub.git"
    git_clone_depth = 1

    git_submodules_config {
      fetch_submodules = true
    }
  }

  source_version = "main"

  vpc_config {
    vpc_id = var.vpc_id
    subnets = var.private_subnet
    security_group_ids = [aws_security_group.codebuild_sg.id]
  }
}
