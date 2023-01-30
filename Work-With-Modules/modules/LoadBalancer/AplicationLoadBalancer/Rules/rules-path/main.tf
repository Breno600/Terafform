resource "aws_lb_listener_rule" "alb_https_public_rule" {
  listener_arn = "${var.arn_alb_listener}"
  #depends_on = [aws_lb_target_group.ecs_target]
  action {
    type = "forward"
    target_group_arn = "${var.target_group_arn}"
  }
  
  condition {
    path_pattern {
      values = ["/${var.path}/*"]
    }
  }
}