variable "region" {
  default = "eu-central-1"
  type    = string
}
variable "cidr_block_vpc" {
  description = "CIDR Block for VPC"
  default     = "10.0.0.0/16"
  type        = string
}

variable "PublicRouteTable" {
  type = map(object({
    cidr_block = string
    tags       = map(string)
  }))
  default = {
    Public1 = {
      cidr_block = "0.0.0.0/0"
      tags = {
        "Name" = "Public Route Table"
      }
    }
    Public2 = {
      cidr_block = "0.0.0.0/0"
      tags = {
        "Name" = "Public Route Table"
      }
    }
  }
}
variable "PrivateRouteTable" {
  type = map(object({
    cidr_block = string
    tags       = map(string)
  }))
  default = {
    Private1 = {
      cidr_block = "0.0.0.0/0"
      tags = {
        "Name" = "Private Route Table"
      }
    }
    Private2 = {
      cidr_block = "0.0.0.0/0"
      tags = {
        "Name" = "Private Route Table"
      }
    }
  }
}

variable "cidr_block" {
  description = "CIDR Block for Access from and to Internet"
  default     = "0.0.0.0/0"
  type        = string
}
variable "public_subnets" {
  type = map(object({
    cidr_block              = string
    availability_zone       = string
    map_public_ip_on_launch = bool
    tags                    = map(string)
  }))
  default = {
    Public1 = {
      cidr_block              = "10.0.3.0/24"
      availability_zone       = "eu-central-1a"
      map_public_ip_on_launch = true
      tags = {
        "Name" = "Public Subnet 1"
      }
    }
    Public2 = {
      cidr_block              = "10.0.4.0/24"
      availability_zone       = "eu-central-1b"
      map_public_ip_on_launch = true
      tags = {
        "Name" = "Public Subnet 2"
      }
    }
  }
}
variable "private_subnets" {
  type = map(object({
    cidr_block              = string
    availability_zone       = string
    map_public_ip_on_launch = bool
    tags                    = map(string)
  }))
  default = {
    "Private1" = {
      cidr_block              = "10.0.1.0/24"
      availability_zone       = "eu-central-1a"
      map_public_ip_on_launch = false
      tags = {
        "Name" = "Private Subnet 1"
      }
    }
    "Private2" = {
      cidr_block              = "10.0.2.0/24"
      availability_zone       = "eu-central-1b"
      map_public_ip_on_launch = false
      tags = {
        "Name" = "Private Subnet 2"
      }
    }
  }
}