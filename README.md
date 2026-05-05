# Employee Management System (EMS) - AWS Infrastructure

This repository contains the Infrastructure as Code (IaC) and deployment configurations for the Employee Management System (EMS). It utilizes **Terraform** to provision a highly available, secure, and scalable environment on AWS, alongside a custom CI/CD pipeline and a database bootstrapping utility.

---

## 🏗️ Architecture Overview

The infrastructure is designed for high availability and automated deployments without downtime, utilizing the following AWS architecture:

- **Network (VPC):** Custom VPC spanning multiple Availability Zones.
  - **Public Subnets (2):** Hosts the EC2 Web Servers within an Auto Scaling Group (ASG) for internet-facing traffic.
  - **Private Subnets (2):** Hosts the RDS database instances securely, isolated from direct internet access.

- **CI/CD Pipeline:** Built natively on AWS using CodePipeline and CodeBuild.
  - **Deployment Flow:** The application is compiled into a `.jar`, and the artifact is stored in an S3 bucket. Instead of using CodeDeploy, deployments are handled by pulling the compiled JAR from S3 directly to the EC2 instances via `user-data.sh` scripts, followed by an **Auto Scaling Group Instance Refresh** to seamlessly cycle in the new application version.

- **Database Bootstrapping:** A custom Java-based AWS Lambda function (`lambda-db-bootstrap`) handles the initial data seeding required for the EMS application to function immediately upon launch.

- **Observability:** Application and system logs from the EC2 instances are shipped directly to **AWS CloudWatch** using the unified CloudWatch Agent, configured via `cw-agent.json`.

---

## 🛠️ Technology Stack

| Category | Technology |
|---|---|
| Infrastructure Provisioning | Terraform |
| Cloud Provider | Amazon Web Services (AWS) |
| Application Runtime | Java (OpenJDK 17) / Spring Boot |
| Build Tool | Maven |
| Compute & Scaling | EC2, Auto Scaling Groups (ASG), Application Load Balancer (ALB), AWS Lambda |
| Database | Amazon RDS |
| CI/CD | AWS CodePipeline, AWS CodeBuild, Amazon S3 |
| Monitoring | Amazon CloudWatch |

---

## 📁 Repository Structure

The repository is organized into reusable modules and environment-specific deployments.

```
.
├── Dev/                    # Terraform configurations for the Development environment
│   ├── main.tf             # Main environment entrypoint
│   ├── terraform.tfvars    # Dev-specific variables
│   ├── user-data.sh        # EC2 bootstrap script (fetches JAR from S3, starts app)
│   └── cw-agent.json       # CloudWatch agent configuration for Dev
├── SI/                     # Terraform configurations for the System Integration environment
│   ├── main.tf
│   ├── terraform.tfvars
│   └── user-data.sh
├── lambda-db-bootstrap/    # Java Lambda application for RDS data seeding
│   ├── pom.xml             # Maven configuration
│   └── src/main/java/...   # Lambda handler source code
└── modules/                # Reusable Terraform infrastructure modules
    ├── cloudwatch/         # Log groups configuration
    ├── codebuild/          # Application compilation and testing
    ├── codepipeline/       # Pipeline orchestration
    ├── ec2_iam_role/       # Instance profiles for S3/CloudWatch access
    ├── lambda-db-bootstrap/# Lambda function provisioning
    ├── loadbalancer/       # ALB configurations
    ├── rds/                # Relational Database Service provisioning
    ├── vpc/                # Virtual Private Cloud, Route Tables, Internet Gateways
    ├── subnets/            # Public (EC2) and Private (RDS) subnet configuration
    └── webservers/         # Launch Templates and Auto Scaling Groups
```

> **Note:** Although a `codedeploy` module directory exists, it is currently inactive as the deployment relies on S3 artifact fetching and ASG refreshes.

---

## 🚀 Prerequisites

Before you begin, ensure you have the following installed and configured:

- **Terraform:** v1.14.3 or later
- **AWS CLI:** Authenticated with appropriate permissions to provision the resources
- **Java & Maven:** OpenJDK 17 and Maven installed locally if you wish to build or test the `lambda-db-bootstrap` function outside of AWS CodeBuild

---

## ⚙️ Deployment Instructions

### 1. Build the Bootstrap Lambda *(Optional but recommended for updates)*

If you have made changes to the database seeding logic, package the Lambda function first:

```bash
cd lambda-db-bootstrap
./mvnw clean package
cd ..
```

### 2. Provision the Infrastructure

Navigate to your desired environment directory (`Dev` or `SI`):

```bash
cd Dev
```

Initialize Terraform to download providers and set up the state backend:

```bash
terraform init
```

Review the planned infrastructure changes:

```bash
terraform plan
```

Apply the configuration to provision resources in AWS:

```bash
terraform apply
```

### 3. Application Deployment Lifecycle

Once the infrastructure is up, pushing application code to your configured source repository will trigger **AWS CodePipeline**:

1. **CodeBuild** compiles the Java application and uploads the `.jar` to the designated S3 bucket.
2. Trigger an **Instance Refresh** on your Auto Scaling Group.
3. The new EC2 instances boot up, run `user-data.sh`, pull the latest `cw-agent.json` and the new application `.jar` from S3, and start the application.

---

## 📝 Logging and Monitoring

EC2 instances are configured with the **CloudWatch Agent**. You can view real-time application and system logs by navigating to:

**CloudWatch → Log Groups** in the AWS Management Console.

Application metrics and load balancer health checks are also available via CloudWatch metrics.

---

*Author: **Vivek***