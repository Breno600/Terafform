resource "aws_iam_role" "role" {
  name = "${var.name_aplication}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    Project = "${var.project}"
    Terraform = "true"
    Request   = "${var.manager_project}"  
  }
}

output "role_arn" {
  description = "The ARN of the created policy."
  value       = aws_iam_role.role.arn
}