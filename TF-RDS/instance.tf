# Data source to get the latest Ubuntu AMI
data "aws_ami" "latest_ubuntu" {
    most_recent = true
    owners      = ["amazon"] # Canonical
    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
    }

    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }

    filter {
        name   = "root-device-type"
        values = ["ebs"]
    }
}

resource "aws_instance" "web" {
    ami                    = data.aws_ami.latest_ubuntu.id
    instance_type          = var.instance_type
    key_name               = "AWS"
    vpc_security_group_ids = [aws_security_group.instance_sg.id]
    subnet_id              = aws_subnet.public_subnet_1.id
    user_data              = file("rds_script.sh")

    tags = {
        Name = "rds_access"
    }
}