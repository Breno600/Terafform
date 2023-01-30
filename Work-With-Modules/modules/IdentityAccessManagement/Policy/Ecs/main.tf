resource "aws_iam_policy" "policy" {
  name        = "${var.name_aplication}"
  path        = "/"
  description = "My policy ${var.name_aplication}"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ecs:**",
          "logs:*",
          "ec2:*",
          "ecr:*",
          "sqs:*",
          "s3:*"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

output "policy_arn" {
  description = "The ARN of the created policy."
  value       = aws_iam_policy.policy.arn
}