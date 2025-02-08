provider "aws" {
  region = "us-east-1"
}

# Modules
module "s3" {
  source              = "./modules/s3"
  source_bucket       = var.source_bucket
  consolidated_bucket = var.consolidated_bucket
  cloudfront_arn      = module.cloudfront.cloudfront_arn
  lambda_role_arn     = module.iam.lambda_role_arn
  s3_vpc_endpoint_id  = module.vpn.s3_vpc_endpoint_id
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
  source                    = "./modules/cloudfront"
  s3_bucket_name            = module.s3.consolidated_bucket_name
  s3_bucket_arn             = module.s3.consolidated_bucket_arn
  s3_bucket_regional_domain = module.s3.s3_bucket_regional_domain
}

module "vpn" {
  source = "./modules/vpn"

}

