output "rds_writer_endpoint" {
    description = "The writer endpoint of the RDS cluster"
    value       = aws_rds_cluster.aurora_mysql.endpoint
}