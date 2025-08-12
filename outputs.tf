# Main Terraform Outputs

# Environment Outputs
output "environment_id" {
  description = "The ID of the Confluent environment"
  value       = confluent_environment.main.id
}

output "environment_name" {
  description = "The name of the Confluent environment"
  value       = confluent_environment.main.display_name
}

# AWS Cluster Outputs
output "aws_cluster_id" {
  description = "The ID of the AWS Kafka cluster"
  value       = module.aws_cluster.kafka_cluster_id
}

output "aws_cluster_bootstrap_endpoint" {
  description = "The bootstrap endpoint of the AWS Kafka cluster"
  value       = module.aws_cluster.kafka_cluster_bootstrap_endpoint
}

output "aws_flink_compute_pool_id" {
  description = "The ID of the AWS Flink compute pool"
  value       = module.aws_cluster.flink_compute_pool_id
}

# Azure Cluster Outputs
output "azure_cluster_id" {
  description = "The ID of the Azure Kafka cluster"
  value       = module.azure_cluster.azure_kafka_cluster_id
}

output "azure_cluster_bootstrap_endpoint" {
  description = "The bootstrap endpoint of the Azure Kafka cluster"
  value       = module.azure_cluster.azure_kafka_cluster_bootstrap_endpoint
}

output "azure_flink_compute_pool_id" {
  description = "The ID of the Azure Flink compute pool"
  value       = module.azure_cluster.azure_flink_compute_pool_id
}

# Project-Specific Outputs for Development Teams
# These outputs provide the necessary information for dev teams to connect their applications

# AWS Sample Project Team Credentials (Simplified - Single Service Account)
output "aws_sample_project_access" {
  description = "Access credentials and patterns for AWS sample project development team (single service account for producer + consumer)"
  value = {
    application = {
      service_account_id = module.aws_cluster.aws_sample_project_app_service_account_id
      api_key_id         = module.aws_cluster.aws_sample_project_app_api_key_id
      # Note: API key secret is sensitive and should be retrieved separately via: terraform output -json aws_sample_project_secret
    }
    access_patterns = {
      topic_pattern          = module.aws_cluster.aws_sample_project_topic_pattern
      consumer_group_pattern = module.aws_cluster.aws_sample_project_consumer_group_pattern
    }
    cluster_info = {
      bootstrap_endpoint = module.aws_cluster.kafka_cluster_bootstrap_endpoint
      cluster_id         = module.aws_cluster.kafka_cluster_id
    }
  }
}

# Azure Sample Project Team Credentials (Simplified - Single Service Account)
output "azure_sample_project_access" {
  description = "Access credentials and patterns for Azure sample project development team (single service account for producer + consumer)"
  value = {
    application = {
      service_account_id = module.azure_cluster.azure_sample_project_app_service_account_id
      api_key_id         = module.azure_cluster.azure_sample_project_app_api_key_id
      # Note: API key secret is sensitive and should be retrieved separately via: terraform output -json azure_sample_project_secret
    }
    access_patterns = {
      topic_pattern          = module.azure_cluster.azure_sample_project_topic_pattern
      consumer_group_pattern = module.azure_cluster.azure_sample_project_consumer_group_pattern
    }
    cluster_info = {
      bootstrap_endpoint = module.azure_cluster.azure_kafka_cluster_bootstrap_endpoint
      cluster_id         = module.azure_cluster.azure_kafka_cluster_id
    }
  }
}

# Sensitive outputs (must be accessed separately)
output "aws_sample_project_secret" {
  description = "API Key Secret for AWS sample project application (sensitive)"
  value       = module.aws_cluster.aws_sample_project_app_api_key_secret
  sensitive   = true
}

output "azure_sample_project_secret" {
  description = "API Key Secret for Azure sample project application (sensitive)"
  value       = module.azure_cluster.azure_sample_project_app_api_key_secret
  sensitive   = true
}