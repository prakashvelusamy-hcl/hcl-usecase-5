data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name               = "iam_for_lambda"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "archive_file" "lambda" {
  type        = "zip"
  source_file = "${path.module}/lambda.py"
  output_path = "lambda_function_payload.zip"
}


resource "aws_lambda_function" "lambda" {
  filename      = "lambda_function_payload.zip"
  function_name = "lambda_function"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "index.lambda_handler"

  source_code_hash = data.archive_file.lambda.output_base64sha256

  runtime = "python3.11"
}

resource "aws_sns_topic" "user_updates" {
  name = "user-updates-topic"
}


resource "aws_sns_topic_subscription" "user_updates_email" {
topic_arn = aws_sns_topic.user_updates.arn 
protocol = "email"
endpoint = "prakashvelusamy1999@gmail.com"
}
