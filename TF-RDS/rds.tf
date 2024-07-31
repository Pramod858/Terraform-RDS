resource "aws_db_subnet_group" "rds_subnet" {
    name       = "rds-subnet"
    subnet_ids = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]

    tags = {
        Name = "DB subnet group"
    }
}

resource "aws_rds_cluster_instance" "cluster_instance" {
    identifier           = "aurora-cluster-demo-1"
    cluster_identifier   = aws_rds_cluster.aurora_mysql.id
    engine               = "aurora-mysql"
    engine_version       = "8.0"  # Update to a valid version
    instance_class       = "db.t3.medium"
    db_subnet_group_name = aws_db_subnet_group.rds_subnet.name
    depends_on           = [aws_rds_cluster.aurora_mysql]
}

resource "aws_rds_cluster" "aurora_mysql" {
    cluster_identifier      = "aurora-cluster-demo"
    engine                  = "aurora-mysql"
    engine_version          = "8.0"  # Update to a valid version
    availability_zones      = ["${var.region}a"]
    database_name           = var.db_name
    master_username         = var.username
    master_password         = var.password

    db_subnet_group_name    = aws_db_subnet_group.rds_subnet.name
    vpc_security_group_ids  = [aws_security_group.db_sg.id]
    skip_final_snapshot     = true
}
