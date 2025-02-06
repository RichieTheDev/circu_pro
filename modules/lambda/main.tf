resource "aws_lambda_function" "zipper" {
  filename      = "lambda_function.zip" # This zip must contain your Python code (see below)
  function_name = var.lambda_function_name
  role          = var.lambda_role_arn
  handler       = "index.lambda_handler" # Make sure your zip file has an index.py file with lambda_handler() defined
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
