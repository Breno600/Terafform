resource "aws_security_group" "sg-db" {
  name        = "${var.sg_name}"
  description = "${var.sg_name}"
  vpc_id      = "${var.account_vpc_id}"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["172.16.0.0/12"]
  }

  # Allow all outbound traffic.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Project = "${var.project}"
    Terraform = "true"
  }
}