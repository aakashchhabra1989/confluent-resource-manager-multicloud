# Non-Production terraform.tfvars file
# Confluent Cloud Terraform configuration for Non-Production deployment

# Confluent Cloud API Credentials
# You can get these from the Confluent Cloud Console -> Cloud API Keys
confluent_cloud_api_key = "your-api-key"
confluent_cloud_api_secret = "your-api-secret"

environment_name = "non-prod-env"
environment_type = "non-prod"
sub_environments = ["dev", "qa", "uat"]
schema_base_path = "schemas"

# Azure Configuration
azure_topic_base_prefix = "azure.myorg"
azure_cluster_name = "azure-nonprod-cluster"
azure_cluster_region = "eastus"
azure_cluster_availability = "SINGLE_ZONE"
azure_cluster_cloud = "AZURE"

# AWS Configuration
aws_topic_base_prefix = "aws.myorg"
aws_cluster_name = "aws-nonprod-cluster"
aws_cluster_region = "us-east-1"
aws_cluster_availability = "SINGLE_ZONE"
aws_cluster_cloud = "AWS"

# Topic Configuration for Non-Prod
create_aws_dummy_topic = true
default_topic_partition = 3

# Flink Configuration (shared for both Azure and AWS)
flink_max_cfu = 5
enable_flink = true
