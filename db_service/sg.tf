resource "aws_security_group" "db_service" {
  name        = "${var.service_name}"
  description = "Security group for db service"
  vpc_id      = "${aws_vpc.db_service.id}"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
}