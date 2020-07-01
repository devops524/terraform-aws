resource "aws_security_group" "redis_sg" {
  name        = "redis-sg"
  description = "Security group for redis instances"
  vpc_id      = aws_vpc.this.id

}
resource "aws_security_group_rule" "inbound_redis" {
  type                     = "ingress"
  from_port                = 6379
  to_port                  = 6379
  protocol                 = "tcp"
  security_group_id        = aws_security_group.redis_sg.id
  source_security_group_id = aws_security_group.this.id
}


resource "aws_elasticache_subnet_group" "redis_subnet_grp" {
  name        = "redis-subnet-grp"
  description = "Redis subnet group"
  subnet_ids  = [aws_subnet.private.*.id[0], aws_subnet.private.*.id[1], aws_subnet.private.*.id[2]]

}

resource "aws_elasticache_cluster" "redis" {
  cluster_id         = var.application_name
  engine             = "redis"
  engine_version     = "5.0"
  node_type          = "cache.t3.small"
  port               = "6379"
  num_cache_nodes    = 1
  subnet_group_name  = aws_elasticache_subnet_group.redis_subnet_grp.name
  security_group_ids = [aws_security_group.redis_sg.id]

}