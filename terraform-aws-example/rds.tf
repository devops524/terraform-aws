resource "aws_security_group" "rds_sg" {
  name        = "rds-sg"
  description = "Security group for Rds instances"
  vpc_id      = aws_vpc.this.id

}
resource "aws_security_group_rule" "inbound_rds" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = aws_security_group.rds_sg.id
  source_security_group_id = aws_security_group.this.id
}

resource "aws_db_subnet_group" "rds_subnet_grp" {
  name        = "rds-subnet-grp"
  description = "Rds subnet group"
  subnet_ids  = [aws_subnet.private.*.id[0], aws_subnet.private.*.id[1], aws_subnet.private.*.id[2]]

}

resource "aws_db_instance" "rds" {
  allocated_storage      = 10
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t3.medium"
  identifier             = var.application_name
  name                   = "master"
  username               = "root"
  password               = var.mysql_pass
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_grp.id
  multi_az               = false
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  storage_type           = "gp2"
  skip_final_snapshot    = true

}