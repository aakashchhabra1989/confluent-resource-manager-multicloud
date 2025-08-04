# Production terraform.tfvars file
# Confluent Cloud Terraform configuration for Production deployment

# Confluent Cloud API Credentials
# You can get these from the Confluent Cloud Console -> Cloud API Keys
confluent_cloud_api_key    = "EM73E7VI53E4QDT2"
confluent_cloud_api_secret = "d094RC2JG5VuAoQEqVJoQ1ds+5GX8Df8r71xFmpbvRQEw2MobmBIAOZW04c3+WPX"

environment_name = "prod-env"
environment_type = "prod"
sub_environments = ["prod"]
schema_base_path = "schemas"

# Azure Configuration
azure_topic_base_prefix = "azure.myorg"
azure_cluster_name = "azure-prod-cluster"
azure_cluster_region = "eastus"
azure_cluster_availability = "MULTI_ZONE"  # Multi-zone for production resilience
azure_cluster_cloud = "AZURE"

# AWS Configuration
aws_topic_base_prefix = "aws.myorg"
aws_cluster_name = "aws-prod-cluster"
aws_cluster_region = "us-east-1"
aws_cluster_availability = "MULTI_ZONE"  # Multi-zone for production resilience
aws_cluster_cloud = "AWS"

# Topic Configuration for Production
create_aws_dummy_topic = false  # Disable dummy topics in production
default_topic_partition = 6  # More partitions for production throughput

# Flink Configuration (shared for both Azure and AWS)
flink_max_cfu = 10  # Higher CFU for production workloads
enable_flink = true
