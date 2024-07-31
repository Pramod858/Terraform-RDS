variable "vpc_cidr" {
    description = "The CIDR block for the VPC"
    default     = "10.0.0.0/16"
}

variable "public_sb1_cidr" {
    description = "The CIDR block for the first public subnet"
    default     = "10.0.0.0/24"
}

variable "private_sb1_cidr" {
    description = "The CIDR block for the first private subnet"
    default     = "10.0.1.0/24"
}

variable "public_sb2_cidr" {
    description = "The CIDR block for the second public subnet"
    default     = "10.0.2.0/24"
}

variable "private_sb2_cidr" {
    description = "The CIDR block for the second private subnet"
    default     = "10.0.3.0/24"
}

variable "instance_type" {
    description = "The instance type for the EC2 instance"
    default     = "t2.micro" 
}

variable "username" {
    description = "The master username for the RDS cluster"
    default     = "admin"
}

variable "password" {
    description = "The master password for the RDS cluster"
    default     = "admin123"
}

variable "region" {
    description = "AWS region"
    default     = "us-east-1"
}

variable "db_name" {
    description = "Database Name"
    default     = "mydb" 
}

variable "key_pair" {
    description = "key_pair"
    default     = "AWS"
}