resource "aws_sqs_queue" "my_first_sqs" {
  name = var.sqs_name
}

module "sqs_policy" {
    source              = "../../Policy/Sqs"
    queue_url           = aws_sqs_queue.my_first_sqs.id
    account_id          = var.account_id
    sqs_resource        = aws_sqs_queue.my_first_sqs.arn
}