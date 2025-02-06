# Deploy Lambda function to process S3 objects
resource "aws_lambda_function" "zipper" {
  filename      = "lambda_function.zip"
  function_name = var.lambda_function_name
  role          = var.lambda_role_arn
  handler       = "index.lambda_handler"
  runtime       = "python3.8"
  memory_size   = 1024
  timeout       = 180

  environment {
    variables = {
      SOURCE_BUCKET       = var.source_bucket
      CONSOLIDATED_BUCKET = var.consolidated_bucket
    }
  }
}
