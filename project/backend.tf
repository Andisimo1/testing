# terraform {
#   backend "s3" {
#     bucket         = "terraform-backend"
#     key            = "terraform.tfstate"
#     region         = "eu-central-1"
#     dynamodb_table = "terraform-state"
#   }
# }