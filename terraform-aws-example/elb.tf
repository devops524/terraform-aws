resource "aws_security_group" "elb" {
  name        = "elb-security-grp"
  description = "Security group for elb"
  vpc_id      = aws_vpc.this.id

}
resource "aws_security_group_rule" "inbound_elb" {
  type                     = "ingress"
  from_port                = 8444
  to_port                  = 8984
  protocol                 = "tcp"
  security_group_id        = aws_security_group.elb.id
  source_security_group_id = aws_security_group.elb.id
}

resource "aws_elb" "this" {
  name               = "${var.application_name}-elb"
  availability_zones = var.az
  subnets            = [aws_subnet.private.*.id[0], aws_subnet.private.*.id[1], aws_subnet.private.*.id[2]]
  listener {
    instance_port     = 8984
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  listener {
    instance_port      = 8984
    instance_protocol  = "http"
    lb_port            = 443
    lb_protocol        = "https"
    ssl_certificate_id = var.certificate_arn

  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:8984/"
    interval            = 30
  }

  #instances                   = [aws_instance.this.*.id[0],aws_instance.this.*.id[1],aws_instance.this.*.id[2]]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400
  #   security_groups  = [aws_security_group.elb.id]

  tags = {
    Name = "${var.application_name}-elb"
  }
}

resource "aws_elb_attachment" "this" {
  count    = 3
  elb      = aws_elb.this.id
  instance = aws_instance.this.*.id[count.index]
}