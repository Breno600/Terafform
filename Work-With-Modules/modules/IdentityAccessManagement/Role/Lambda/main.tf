resource "aws_iam_role" "lambda_role" {
name   = var.role_lambda_name
assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "lambda.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
}

output "role_arn" {
  description = "The ARN of the created policy."
  value       = aws_iam_role.lambda_role.arn
}