variable "vpc_id" {}
variable "private_subnet" {}
variable "github_token" {
    default = ""
}
variable "region" {}
variable "buildspec" {
  default = "project/config/buildspec.yaml"
}