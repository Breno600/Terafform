resource "aws_sqs_queue_policy" "my_sqs_policy" {
  queue_url = var.queue_url

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "sqspolicy",
  "Statement": [
    {
      "Sid": "First",
      "Effect": "Allow",
      "Principal": {
        "AWS": "${var.account_id}"
      },
      "Action": "sqs:*",
      "Resource": "${var.sqs_resource}"
    }
  ]
}
POLICY
}