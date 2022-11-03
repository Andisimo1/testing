provider "aws" {
  region = var.region
}
module "vpc" {
  source = "../modules/vpc"
}
module "alb" {
  source = "../modules/alb"
  vpc_id = module.vpc.vpc_id
  public_subnet = module.vpc.public_subnet
}
module "ecs" {
  source = "../modules/ecs"
  vpc_id = module.vpc.vpc_id
  private_subnet = module.vpc.private_subnet
  alb_listener = module.alb.alb_listener
  iam_role = module.ecs.iam_role
}
module "s3" {
  source = "../modules/s3"
}
module "codebuild" {
  source = "../modules/codebuild"
  vpc_id = module.vpc.vpc_id
  private_subnet = module.vpc.private_subnet
  region = module.vpc.region
}
module "init-build" {
  source = "../modules/init-build"
}