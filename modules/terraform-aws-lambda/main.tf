data "archive_file" "lambda" {
  type        = "zip"
  source_file = "${path.module}/lambda_function.py"
  output_path = "${path.module}/lambda_function_payload.zip"
}


resource "aws_lambda_function" "lambda" {
  filename      = "lambda_function_payload.zip"
  function_name = "lambda_function"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "lambda_function.lambda_handler"

   layers                         = ["arn:aws:lambda:ap-south-1:770693421928:layer:Klayers-p39-pillow:1"]
  source_code_hash = data.archive_file.lambda.output_base64sha256

  runtime = "python3.9"
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

resource "aws_sns_topic" "user_updates" {
  name = "user-updates-topic"
}


resource "aws_sns_topic_subscription" "user_updates_email" {
topic_arn = aws_sns_topic.user_updates.arn 
protocol = "email"
endpoint = "prakashvelusamy1999@gmail.com"
}

