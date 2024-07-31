output "rds_writer_endpoint" {
    description = "The writer endpoint of the RDS cluster"
    value       = aws_rds_cluster.aurora_mysql.endpoint
}

output "instance_public_ip" {
    description = "The public IP address of the EC2 instance"
    value       = aws_instance.web.public_ip
}
