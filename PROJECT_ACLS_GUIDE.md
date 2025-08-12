# Project-Specific ACLs for Development Teams

This document explains how to use the project-specific ACLs that have been implemented for the AWS and Azure Confluent Cloud clusters.

## Overview

We have implemented a **simplified single service account per project** approach that provides both producer and consumer permissions. This eliminates the complexity of managing separate credentials while maintaining security boundaries between projects.

## Project Structure

### AWS Sample Project
- **Cluster**: AWS Kafka cluster (us-east-1)
- **Topic Pattern**: `aws.*.sample_project.*`
- **Consumer Group Pattern**: `aws-sample-project-*`

### Azure Sample Project
- **Cluster**: Azure Kafka cluster (eastus)
- **Topic Pattern**: `azure.*.sample_project.*`
- **Consumer Group Pattern**: `azure-sample-project-*`

## Service Accounts Created

For each project, **one service account** is created with combined producer and consumer permissions:

### AWS Sample Project Service Account
- `aws-sample-project-app-{environment}` (Producer + Consumer)

### Azure Sample Project Service Account
- `azure-sample-project-app-{environment}` (Producer + Consumer)

## Permissions Granted

Each service account has the following permissions:

### Combined Application Permissions
- **DESCRIBE** on cluster
- **CREATE** topics matching pattern `{cloud}.*.{project}.*`
- **WRITE** to topics matching pattern `{cloud}.*.{project}.*` (Producer)
- **READ** from topics matching pattern `{cloud}.*.{project}.*` (Consumer)
- **DESCRIBE** topics matching pattern `{cloud}.*.{project}.*`
- **READ** from consumer groups matching pattern `{cloud}-{project}-*`
- **DESCRIBE** consumer groups matching pattern `{cloud}-{project}-*`

## How to Access Credentials

### 1. Using Automated Scripts (Recommended)

We provide scripts to simplify credential retrieval:

#### PowerShell (Windows)
```powershell
# Get AWS project credentials
.\Get-ProjectCredentials.ps1 -Cloud aws

# Get Azure project credentials
.\Get-ProjectCredentials.ps1 -Cloud azure

# Get summary of all projects
.\Get-ProjectCredentials.ps1 -Cloud all
```

#### Bash (Linux/Mac)
```bash
# Get AWS project credentials
./get_project_credentials.sh aws

# Get Azure project credentials
./get_project_credentials.sh azure

# Get summary of all projects
./get_project_credentials.sh all
```

### 2. Manual Terraform Commands

#### Get Service Account Information
```bash
# Get all project access information
terraform output aws_sample_project_access
terraform output azure_sample_project_access
```

#### Get Sensitive API Keys
```bash
# AWS project application credentials
terraform output -json aws_sample_project_secret

# Azure project application credentials
terraform output -json azure_sample_project_secret
```

## Development Team Usage

### For Application Configuration

#### Application Configuration (AWS) - Producer + Consumer
```properties
# Kafka connection
bootstrap.servers=${AWS_CLUSTER_BOOTSTRAP_ENDPOINT}
security.protocol=SASL_SSL
sasl.mechanism=PLAIN
sasl.jaas.config=org.apache.kafka.common.security.plain.PlainLoginModule required username="${AWS_PROJECT_API_KEY}" password="${AWS_PROJECT_SECRET}";

# Producer settings
key.serializer=org.apache.kafka.common.serialization.StringSerializer
value.serializer=org.apache.kafka.common.serialization.StringSerializer

# Consumer settings
key.deserializer=org.apache.kafka.common.serialization.StringDeserializer
value.deserializer=org.apache.kafka.common.serialization.StringDeserializer
group.id=aws-sample-project-${APPLICATION_NAME}

# Topic naming convention (must follow pattern)
topic.prefix=aws.${ENVIRONMENT}.sample_project
topic.pattern=aws.*.sample_project.*
```

#### Application Configuration (Azure) - Producer + Consumer
```properties
# Kafka connection
bootstrap.servers=${AZURE_CLUSTER_BOOTSTRAP_ENDPOINT}
security.protocol=SASL_SSL
sasl.mechanism=PLAIN
sasl.jaas.config=org.apache.kafka.common.security.plain.PlainLoginModule required username="${AZURE_PROJECT_API_KEY}" password="${AZURE_PROJECT_SECRET}";

# Producer settings
key.serializer=org.apache.kafka.common.serialization.StringSerializer
value.serializer=org.apache.kafka.common.serialization.StringSerializer

# Consumer settings
key.deserializer=org.apache.kafka.common.serialization.StringDeserializer
value.deserializer=org.apache.kafka.common.serialization.StringDeserializer
group.id=azure-sample-project-${APPLICATION_NAME}

# Topic naming convention (must follow pattern)
topic.prefix=azure.${ENVIRONMENT}.sample_project
topic.pattern=azure.*.sample_project.*
```

#### Consumer Application (Azure)
```properties
# Kafka connection
bootstrap.servers=${AZURE_CLUSTER_BOOTSTRAP_ENDPOINT}
security.protocol=SASL_SSL
sasl.mechanism=PLAIN
sasl.jaas.config=org.apache.kafka.common.security.plain.PlainLoginModule required username="${AZURE_CONSUMER_API_KEY}" password="${AZURE_CONSUMER_SECRET}";

# Consumer settings
key.deserializer=org.apache.kafka.common.serialization.StringDeserializer
value.deserializer=org.apache.kafka.common.serialization.StringDeserializer
group.id=azure-sample-project-${APPLICATION_NAME}

# Topic pattern to subscribe to
topic.pattern=azure.*.sample_project.*
```

### Example Topic Names

#### AWS Sample Project Topics
- `aws.sandbox.sample_project.user_events.0`
- `aws.dev.sample_project.order_updates.0`
- `aws.prod.sample_project.metrics.0`

#### Azure Sample Project Topics
- `azure.sandbox.sample_project.user_events.0`
- `azure.dev.sample_project.order_updates.0`
- `azure.prod.sample_project.metrics.0`

### Example Consumer Group Names

#### AWS Sample Project Consumer Groups
- `aws-sample-project-user-service`
- `aws-sample-project-analytics-app`
- `aws-sample-project-notification-service`

#### Azure Sample Project Consumer Groups
- `azure-sample-project-user-service`
- `azure-sample-project-analytics-app`
- `azure-sample-project-notification-service`

## Security Best Practices

### 1. Credential Management
- Store API keys securely (e.g., in secret management systems)
- Rotate API keys regularly
- Never commit credentials to source code

### 2. Topic Naming Convention
- Always follow the established pattern: `{cloud}.{environment}.{project}.{topic_name}.{version}`
- Use descriptive topic names
- Include version numbers for schema evolution

### 3. Consumer Group Naming
- Use descriptive names that identify the application
- Follow the pattern: `{cloud}-{project}-{application_name}`
- Avoid generic names like "consumer" or "app"

### 4. Monitoring and Auditing
- Monitor topic access patterns
- Review ACL usage regularly
- Alert on unauthorized access attempts

## Adding New Projects

To add a new project, you would need to:

1. Create new ACL files similar to the existing ones
2. Update the topic patterns and service account names
3. Add outputs for the new project credentials
4. Update this documentation

## Troubleshooting

### Common Issues

1. **Access Denied Errors**
   - Verify the topic name follows the correct pattern
   - Check that the API key belongs to the correct service account
   - Ensure the consumer group name follows the pattern

2. **Topic Creation Failed**
   - Verify the producer service account has CREATE permissions
   - Check the topic name pattern
   - Ensure the cluster is reachable

3. **Consumer Group Access Denied**
   - Verify the consumer group name follows the pattern
   - Check that the consumer service account is being used
   - Ensure READ permissions are granted

### Getting Help

If you encounter issues:
1. Check this documentation first
2. Verify your configuration against the examples
3. Contact the platform team with specific error messages

## Environment-Specific Deployment

The ACLs are environment-aware and will be created for each environment (sandbox, non-prod, prod) when deployed. Make sure to use the appropriate credentials for each environment.

```bash
# Deploy to different environments
terraform apply -var-file="terraform.tfvars"     # sandbox
terraform apply -var-file="non-prod.tfvars"     # non-prod
terraform apply -var-file="prod.tfvars"         # production
```
