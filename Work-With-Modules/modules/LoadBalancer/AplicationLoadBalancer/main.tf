resource "aws_alb" "alb" {
  name            = "alb-${var.project}"
  security_groups = ["${var.security_groups_id}"]
  subnets         = ["${var.subnet_az1}","${var.subnet_az2}"]

  tags = {
    Project = "${var.project}"
    Terraform = "true"
  }
}