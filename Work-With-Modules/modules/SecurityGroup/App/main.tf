resource "aws_security_group" "sg-alb" {
  name        = "${var.sg_name}"
  description = "${var.sg_name}"
  vpc_id      = "${var.account_vpc_id}"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["172.16.0.0/12","10.0.0.0/16"]
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["172.16.0.0/12","10.0.0.0/16"]
  }

  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["172.16.0.0/12","10.0.0.0/16"]
  }

  ingress {
    from_port = 3000
    to_port = 3000
    protocol = "tcp"
    cidr_blocks = ["172.16.0.0/12","10.0.0.0/16"]
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