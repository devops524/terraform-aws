resource "aws_security_group" "this" {
  name        = "application-sg"
  description = "Security group for app instances"
  vpc_id      = aws_vpc.this.id

}
resource "aws_security_group_rule" "inbound_app" {
  type                     = "ingress"
  from_port                = 8444
  to_port                  = 8984
  protocol                 = "tcp"
  security_group_id        = aws_security_group.this.id
  source_security_group_id = aws_security_group.this.id
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

resource "aws_instance" "this" {
  count         = 3
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.private.*.id[count.index]

  tags = {
    Name = var.application_name
  }
}