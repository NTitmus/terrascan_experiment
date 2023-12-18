terraform {
  required_version = ">= 1.0.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }


  backend "s3" {
    # This backend configuration is filled in automatically at test time by Terratest. If you wish to run this example
    # manually, uncomment and fill in the config below.

    bucket         = "terraform-book-state-nt2"
    key            = "simple_module/terraform.tfstate"
    region         = "eu-west-2"
    dynamodb_table = "terraform-book-locks2"
    encrypt        = true
  }
}

resource "aws_vpc" "new_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "Project VPC"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.new_vpc.id
  cidr_block = "10.0.4.0/24"

  tags = {
    Name = "Private Subnet Project VPC"
  }
}

resource "aws_instance" "example" {
  instance_type = "t2.micro"
  ami           = "ami-0cfd0973db26b893b"
  subnet_id     = aws_subnet.private_subnet.id

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

}
