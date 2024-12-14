resource "aws_s3_bucket" "a-bucket" {
  bucket = "a-bucket"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "a-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-west-2a", "us-west-2b", "us-west-2c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}

resource "aws_instance" "an-instance" {
  ami           = "ami-09b60b3866c88e536"
  instance_type = "t3.micro"

  tags = {
    Name = "an-instance"
  }
}