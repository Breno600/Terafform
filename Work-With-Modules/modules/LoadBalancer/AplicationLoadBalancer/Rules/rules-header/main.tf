resource "aws_lb_listener_rule" "alb_https_public_rule" {
  listener_arn = "${var.listener_https_arn}"

  action {
    type = "forward"
    target_group_arn = "${var.target_group_arn}"
  }

  condition {
    http_header {
      http_header_name = "${var.header}"
      values           = ["${var.ambiente}"]
    }
  }
}