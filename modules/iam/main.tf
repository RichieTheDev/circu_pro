# IAM role for Lambda execution
resource "aws_iam_role" "lambda_exec" {
  name = "lambda_exec_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action    = "sts:AssumeRole",
      Effect    = "Allow",
      Principal = { Service = "lambda.amazonaws.com" }
    }]
  })
}

# IAM policy for Lambda to access S3
resource "aws_iam_policy" "lambda_s3_access" {
  name        = "lambda_s3_access_policy"
  description = "Policy allowing Lambda to access specific S3 buckets"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["s3:ListBucket"]
        Resource = var.source_bucket_arn
      },
      {
        Effect = "Allow"
        Action = ["s3:GetObject", "s3:PutObject"]
        Resource = [
          "${var.source_bucket_arn}/*",
          "${var.consolidated_bucket_arn}/*"
        ]
      }
    ]
  })
}

# Attach policy to Lambda execution role
resource "aws_iam_role_policy_attachment" "attach_lambda_policy" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = aws_iam_policy.lambda_s3_access.arn
}
