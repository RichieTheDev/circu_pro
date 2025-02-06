# if something goes wrong, you can review the failure and retry or investigate.
resource "aws_sqs_queue" "lambda_dlq" {
  name = "lambda_dlq"
}
# Deploy Lambda function to process S3 objects
resource "aws_lambda_function" "zipper" {
  filename                       = "lambda_function.zip"
  function_name                  = var.lambda_function_name
  role                           = var.lambda_role_arn
  handler                        = "index.lambda_handler"
  runtime                        = "python3.8"
  memory_size                    = 2048 # Increased to 2048MB for larger files
  timeout                        = 300  # Increased timeout to 300 seconds
  reserved_concurrent_executions = 10
  environment {
    variables = {
      SOURCE_BUCKET       = var.source_bucket
      CONSOLIDATED_BUCKET = var.consolidated_bucket
    }
  }
  dead_letter_config {
    target_arn = aws_sqs_queue.lambda_dlq.arn
  }
}



