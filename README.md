# Terraform AWS RDS Cluster Setup

This project contains Terraform configuration files to set up an Amazon RDS (Relational Database Service) Aurora MySQL cluster along with relevant AWS infrastructure such as VPCs, subnets, security groups, and an EC2 instance.

## Project Structure

The Terraform configuration files are located in the `Terraform` directory:

- `provider.tf`: Contains the AWS provider configuration.
- `backend.tf`: Configures the backend for Terraform state storage in an S3 bucket.
- `variables.tf`: Defines all the input variables used in the Terraform scripts.
- `vpc.tf`: Configures VPC and subnet resources, with Internet Gateway, NAT Gateway, and route tables.
- `security.tf`: Defines security groups.
- `instance.tf`: Defines EC2 instance launch configuration.
- `rds.tf`: Configures the RDS Aurora MySQL cluster and its instances.
- `outputs.tf`: Defines outputs to display after applying the Terraform configuration.

## Setting Up Remote Backend

To enable remote state storage in an S3 bucket:

1. **Add Backend Configuration to an existing S3 bucket**:

    Create `backend.tf` in the `Terraform` directory:

    ```hcl
    terraform {
      backend "s3" {
        bucket = "your-terraform-state-bucket" # replace with your S3 bucket
        key    = "terraform/state/terraform.tfstate"
        region = "us-east-1 # replace with your region
      }
    }
    ```

    Replace `your-terraform-state-bucket` with your S3 bucket name.

## Variables

Define variables in the `variables.tf` file:

```hcl
variable "region" {
  description = "The AWS region"
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "public_sb1_cidr" {
  description = "The CIDR block for the first public subnet"
  default     = "10.0.1.0/24"
}

variable "private_sb1_cidr" {
  description = "The CIDR block for the first private subnet"
  default     = "10.0.2.0/24"
}

variable "public_sb2_cidr" {
  description = "The CIDR block for the second public subnet"
  default     = "10.0.3.0/24"
}

variable "private_sb2_cidr" {
  description = "The CIDR block for the second private subnet"
  default     = "10.0.4.0/24"
}

variable "instance_type" {
  description = "The instance type for the EC2 instance"
  default     = "t2.micro"
}

variable "db_name" {
  description = "The name of the database"
  default     = "mydb"
}

variable "username" {
  description = "The username for the RDS database"
  default     = "admin"
}

variable "password" {
  description = "The password for the RDS database"
  default     = "yourpassword"
}

variable "key_pair" {
  description = "The name of the EC2 key pair"
  default     = "AWS"
}
```

## GitHub Actions Setup

1. **Configure AWS Credentials in GitHub Secrets**:

    - Go to your GitHub repository.
    - Click on `Settings`.
    - Navigate to `Secrets and variables > Actions`.
    - Add the following secrets:
        - `AWS_ACCESS_KEY_ID`
        - `AWS_SECRET_ACCESS_KEY`
        - `AWS_REGION`

2. **Create a GitHub Action Workflow**:

    Create a `.github/workflows/terraform.yml` file with the following content:

    ```yaml
    name: 'Terraform AWS RDS Cluster Setup'

    on:
      push:
        branches:
          - main

    jobs:
      terraform:
        runs-on: ubuntu-latest
        steps:
          - name: Checkout code
            uses: actions/checkout@v2

          - name: Setup Terraform
            uses: hashicorp/setup-terraform@v1
            with:
              terraform_version: 1.0.0

          - name: Terraform Init
            run: terraform init

          - name: Terraform Validate
            run: terraform validate

          - name: Terraform Plan
            run: terraform plan

          - name: Terraform Apply
            run: terraform apply -auto-approve
            env:
              AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
              AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
              AWS_REGION: ${{ secrets.AWS_REGION }}
    ```

## Local Setup

1. **Clone the Repository**:

    ```sh
    git clone <your-repo-url>
    cd Terraform
    ```

2. **Install Terraform**:

    Download and install Terraform from [here](https://www.terraform.io/downloads).

3. **Install AWS CLI**:

    Follow the installation guide [here](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html).

4. **Configure AWS CLI**:

    ```sh
    aws configure
    ```

    Enter your AWS Access Key ID, Secret Access Key, region, and output format.

5. **Initialize Terraform**:

    ```sh
    terraform init
    ```

6. **Validate the Configuration**:

    ```sh
    terraform validate
    ```

7. **Plan the Deployment**:

    ```sh
    terraform plan
    ```

8. **Apply the Configuration**:

    ```sh
    terraform apply
    ```

    You will be prompted to confirm the apply action. Type `yes` to proceed.

9. **Check the Output**:

    After the apply is complete, you will see the outputs defined in the `outputs.tf` file, including the RDS writer endpoint and port. Use the `username`, `password`, and database name defined in the `variables.tf` file, and copy the RDS writer endpoint to paste it into the application deployed in the EC2 instance to access the database.

## Clean Up

To destroy the infrastructure managed by Terraform, use the following command:

```sh
terraform destroy
```

## References

- [Terraform AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Amazon RDS Documentation](https://docs.aws.amazon.com/rds/index.html)

By following this guide, users can set up and use Terraform to provision AWS resources using automated workflows via GitHub Actions, while securely managing the Terraform state with an S3 backend and an AWS key pair for accessing EC2 instances.

### Additional Notes

- Ensure your IAM user has the necessary permissions to manage the S3 bucket, EC2 instances, and other AWS resources.
- The `.gitignore` file should exclude sensitive files like `terraform.tfstate` and `.tfvars`.
