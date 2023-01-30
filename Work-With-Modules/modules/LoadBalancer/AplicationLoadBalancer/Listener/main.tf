resource "aws_alb_listener" "listener_http" {
  load_balancer_arn = "${var.load_balancer_arn}"
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "${var.certificate_https_arn}"

  default_action {
    target_group_arn = "${var.target_group_arn}"
    type             = "forward"
  }

  tags = {
    Project = "${var.project}"
    Terraform = "true"
  }
}