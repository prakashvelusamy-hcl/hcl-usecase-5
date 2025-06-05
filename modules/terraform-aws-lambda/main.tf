data "archive_file" "lambda" {
  type        = "zip"
  source_file = "${path.module}/image_resizer.py"
  output_path = "${path.module}/image_resizer.zip"
}


resource "aws_lambda_function" "lambda" {
  filename      = "${path.module}/image_resizer.zip"
  function_name = "lambda_function"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "image_resizer.lambda_handler"

   layers       = ["arn:aws:lambda:ap-south-1:770693421928:layer:Klayers-p39-pillow:1"]
  source_code_hash = data.archive_file.lambda.output_base64sha256
  runtime = "python3.9"
  
  environment {
     variables = {
     SNS_TOPIC_ARN = var.sns_arn
     }
}
}


resource "aws_lambda_permission" "allow_s3" {
statement_id = "AllowS3Invoke" 
action       = "lambda:InvokeFunction"
function_name = aws_lambda_function.lambda.function_name
principal     = "s3.amazonaws.com"
source_arn     = "arn:aws:s3:::prakash-hcl-non-resized" #aws_s3_bucket.source_bucket.arn
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "lambda_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}



resource "aws_iam_policy" "lambda_s3_sns" {
  name        = "lambda_s3_sns_full_access"
  description = "Grants full access to S3, SNS, and Lambda services"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:*",
          "sns:*",
          "lambda:*"
        ],
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "*"
      }
    ]
  })
}


resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.lambda_s3_sns.arn
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = var.bucket_id

  lambda_function {
    lambda_function_arn = aws_lambda_function.lambda.arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [aws_lambda_permission.allow_s3]
}