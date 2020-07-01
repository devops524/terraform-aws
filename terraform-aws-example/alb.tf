resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Security group for alb"
  vpc_id      = aws_vpc.this.id

}
resource "aws_security_group_rule" "inbound_alb" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.alb_sg.id
  source_security_group_id = aws_security_group.alb_sg.id
}
resource "aws_lb" "web" {
  name               = "web-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.public.*.id[0], aws_subnet.public.*.id[1]]

  enable_deletion_protection = false

  #   access_logs {
  #     bucket  = "${aws_s3_bucket.lb_logs.bucket}"
  #     prefix  = "test-lb"
  #     enabled = true
  #   }

  tags = {
    Environment = "${var.application_name}-web-alb"
  }
}

resource "aws_lb" "content" {
  name               = "content-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.public.*.id[0], aws_subnet.public.*.id[1]]

  enable_deletion_protection = false

  #   access_logs {
  #     bucket  = "${aws_s3_bucket.lb_logs.bucket}"
  #     prefix  = "test-lb"
  #     enabled = true
  #   }

  tags = {
    Environment = "${var.application_name}-content-alb"
  }
}

resource "aws_lb_target_group" "web" {
  name     = "alb-targets-web"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.this.id
}
resource "aws_lb_target_group" "content" {
  name     = "alb-targets-content"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.this.id
}

resource "aws_lb_target_group_attachment" "web" {
  count            = 3
  target_group_arn = aws_lb_target_group.web.arn
  target_id        = aws_instance.this.*.id[count.index]
  port             = 80
}

resource "aws_lb_target_group_attachment" "content" {
  count            = 3
  target_group_arn = aws_lb_target_group.content.arn
  target_id        = aws_instance.this.*.id[count.index]
  port             = 80
}