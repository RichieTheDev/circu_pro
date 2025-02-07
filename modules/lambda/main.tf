# Create an AWS Lambda function to handle zipping and file processing
resource "aws_lambda_function" "zipper" {
  s3_bucket                      = var.consolidated_bucket  # S3 bucket where the Lambda function code is stored
  s3_key                         = "lambda_function.zip"    # Name of the Lambda function deployment package
  function_name                  = var.lambda_function_name # Name of the Lambda function
  role                           = var.lambda_role_arn      # IAM role that Lambda will assume
  handler                        = "index.lambda_handler"   # Entry point for the Lambda function
  runtime                        = "python3.8"              # Runtime environment for the function
  memory_size                    = 2048                     # Allocate 2GB of memory to the function
  timeout                        = 300                      # Set the execution timeout to 5 minutes
  reserved_concurrent_executions = 10                       # Limit concurrent executions to 10

  # Define environment variables for the Lambda function
  environment {
    variables = {
      SOURCE_BUCKET       = var.source_bucket       # Source S3 bucket for input files
      CONSOLIDATED_BUCKET = var.consolidated_bucket # Destination S3 bucket for zipped files
    }
  }
}

# Configure an S3 event trigger to invoke the Lambda function on file uploads
resource "aws_s3_bucket_notification" "s3_trigger" {
  bucket = var.source_bucket # S3 bucket that will trigger the Lambda function

  lambda_function {
    lambda_function_arn = aws_lambda_function.zipper.arn # ARN of the Lambda function
    events              = ["s3:ObjectCreated:*"]         # Trigger the function when an object is created in the bucket
    filter_suffix       = ".zip"                         # Only trigger when the uploaded file has a .zip extension
  }
}

# Grant permission for S3 to invoke the Lambda function
resource "aws_lambda_permission" "allow_s3" {
  statement_id  = "AllowExecutionFromS3"
  action        = "lambda:InvokeFunction"                  # Allow S3 to invoke the Lambda function
  function_name = aws_lambda_function.zipper.function_name # Reference the function
  principal     = "s3.amazonaws.com"                       # Specify S3 as the service that can invoke the function
  source_arn    = var.source_bucket_arn                    # Restrict invocation to the specified S3 bucket
}
