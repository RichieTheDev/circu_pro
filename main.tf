provider "aws" {
  region = var.region
}

# Modules
module "s3" {
  source              = "./modules/s3"
  source_bucket       = var.source_bucket
  consolidated_bucket = var.consolidated_bucket
}

module "iam" {
  source                  = "./modules/iam"
  source_bucket_arn       = module.s3.source_bucket_arn
  consolidated_bucket_arn = module.s3.consolidated_bucket_arn
}

module "lambda" {
  source               = "./modules/lambda"
  lambda_function_name = var.lambda_function_name
  lambda_role_arn      = module.iam.lambda_role_arn
  source_bucket        = module.s3.source_bucket_name
  consolidated_bucket  = module.s3.consolidated_bucket_name
  source_bucket_arn    = module.s3.source_bucket_arn
}

module "cloudfront" {
  source                = "./modules/cloudfront"
  s3_origin_domain_name = "${module.s3.consolidated_bucket_name}.s3.amazonaws.com"
}

module "vpn" {
  source = "./modules/vpn"

}

