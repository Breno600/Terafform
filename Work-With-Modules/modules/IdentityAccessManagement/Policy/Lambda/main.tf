resource "aws_iam_policy" "iam_policy_for_lambda" {
 
 name         = var.policy_lambda_function
 path         = "/"
 description  = "AWS IAM Policy for managing aws lambda role"
 policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": [
       "logs:CreateLogGroup",
       "logs:CreateLogStream",
       "logs:PutLogEvents"
     ],
     "Resource": "arn:aws:logs:*:*:*",
     "Effect": "Allow"
   }
 ]
}
EOF
}

output "policy_arn" {
  description = "The ARN of the created policy."
  value       = aws_iam_policy.iam_policy_for_lambda.arn
}