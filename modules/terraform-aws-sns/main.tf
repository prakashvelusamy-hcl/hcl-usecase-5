resource "aws_sns_topic" "user_updates" {
  name = "user-updates-topic"
}

resource "aws_sns_topic_subscription" "user_updates_email" {
topic_arn = aws_sns_topic.user_updates.arn 
protocol = "email"
endpoint = "prakashvelusamy1999@gmail.com"
}