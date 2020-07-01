output "redis" {
  value = aws_elasticache_cluster.redis.cache_nodes
}

output "rds" {
  value = aws_db_instance.rds.endpoint
}

output "vpc_id" {
  value = aws_vpc.this.id
}
