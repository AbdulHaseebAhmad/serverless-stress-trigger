# Serverless Stress Trigger

A serverless AWS project that provides an HTTP endpoint to start and stop a CPU stress test on an EC2 instance using **API Gateway, Lambda, AWS Systems Manager (SSM), and Terraform**.

## Architecture

```text
Client
  │
  ▼
API Gateway
  │
  ▼
Lambda
  │
  ▼
AWS Systems Manager
  │
  ▼
SSM Agent
  │
  ▼
EC2 Instance
  │
  ▼
stress-ng
```

## AWS Services

- **API Gateway HTTP API** — exposes the HTTP endpoint.
- **AWS Lambda** — receives the request and sends the SSM command.
- **AWS Systems Manager (SSM)** — manages the remote command execution.
- **SSM Document (`AWS-RunShellScript`)** — defines the shell-script operation.
- **EC2** — target instance where the stress test runs.
- **SSM Agent** — runs on the EC2 instance and executes the command.
- **IAM** — provides the required permissions between the services.
- **Terraform** — provisions the infrastructure.

## API Endpoints

The API exposes:

```text
GET /stress?action=start
GET /stress?action=stop
```

### Start stress test

```bash
curl "https://<api-id>.execute-api.<region>.amazonaws.com/dev/stress?action=start"
```

This sends the following command to the EC2 instance through SSM:

```bash
sudo systemctl start stress-ng.service
```

### Stop stress test

```bash
curl "https://<api-id>.execute-api.<region>.amazonaws.com/dev/stress?action=stop"
```

This sends:

```bash
sudo systemctl stop stress-ng.service
```

## Lambda

The Lambda function uses the AWS SDK for JavaScript to communicate with SSM.

The EC2 instance ID is provided to Lambda through an environment variable:

```text
INSTANCE_ID
```

The Lambda then creates a `SendCommandCommand` using the `AWS-RunShellScript` SSM document and sends it through the SSM client.

## EC2 Stress Test

The EC2 instance installs `stress-ng` and creates a systemd service:

```text
stress-ng.service
```

The service runs:

```bash
/usr/bin/stress-ng --cpu 0 --cpu-load 100
```

The service is not automatically started when the instance boots. It is controlled through the API.

## IAM

Two separate IAM roles are used.

### Lambda IAM Role

The Lambda role allows:

- `ssm:SendCommand`
- CloudWatch logging through `AWSLambdaBasicExecutionRole`

### EC2 IAM Role

The EC2 instance uses:

```text
AmazonSSMManagedInstanceCore
```

This allows the SSM Agent to communicate with AWS Systems Manager.

## Terraform Structure

```text
serverless-stress-trigger/
├── envs/
│   └── dev/
├── modules/
│   └── trigger/
├── .gitignore
└── README.md
```

Terraform provisions the API Gateway, Lambda, IAM roles and policies, EC2 instance, SSM configuration, networking resources, and supporting infrastructure.

## Deployment

Initialize Terraform:

```bash
terraform init
```

Review the infrastructure:

```bash
terraform plan
```

Apply the infrastructure:

```bash
terraform apply
```

After deployment, Terraform outputs the API endpoint.

## Request Flow

When a request is made:

```text
GET /stress?action=start
        │
        ▼
API Gateway
        │
        ▼
Lambda
        │
        ▼
SSM SendCommand
        │
        ▼
AWS-RunShellScript
        │
        ▼
SSM Agent
        │
        ▼
EC2
        │
        ▼
systemd
        │
        ▼
stress-ng
```

## Purpose

This project demonstrates how to build a simple serverless control plane for an EC2 workload, using Terraform to provision the infrastructure and AWS managed services to handle API requests, execution, permissions, and remote command management.
