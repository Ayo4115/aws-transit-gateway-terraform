variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "ami_id" {
  description = "AMI ID for EC2"
  type        = string
  default     = "ami-0c3389a4fa5bddaad"
}

variable "key_name" {
  description = "EC2 Key Pair name"
  type        = string
  default     = "EC2-Test-Key Pair"
}

variable "vpc_cidrs" {
  description = "CIDR blocks for VPCs"
  type        = map(string)
  default = {
    vpc1 = "10.1.0.0/16"
    vpc2 = "10.2.0.0/16"
    vpc3 = "10.3.0.0/16"
  }
}

variable "subnet_cidrs" {
  description = "CIDR blocks for Subnets"
  type        = map(string)
  default = {
    subnet1 = "10.1.1.0/24"
    subnet2 = "10.2.1.0/24"
    subnet3 = "10.3.1.0/24"
  }
}

