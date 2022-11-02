resource "aws_sns_topic" "dev_topic" {
  name = "dev_topic"
}

resource "aws_sns_topic_subscription" "Dev_Subscription" {
  topic_arn = aws_sns_topic.dev_topic.arn
  for_each  = toset(["YOUREMAIL"])
  protocol  = "email"
  endpoint  = each.value

  depends_on = [
    aws_sns_topic.dev_topic
  ]
}