# Azure Module Outputs

# Cluster Outputs
output "azure_kafka_cluster_id" {
  description = "The ID of the Azure Kafka cluster"
  value       = confluent_kafka_cluster.azure_basic.id
}

output "azure_kafka_cluster_name" {
  description = "The name of the Azure Kafka cluster"
  value       = confluent_kafka_cluster.azure_basic.display_name
}

output "azure_kafka_cluster_bootstrap_endpoint" {
  description = "The bootstrap endpoint of the Azure Kafka cluster"
  value       = confluent_kafka_cluster.azure_basic.bootstrap_endpoint
}

output "azure_kafka_cluster_rest_endpoint" {
  description = "The REST endpoint of the Azure Kafka cluster"
  value       = confluent_kafka_cluster.azure_basic.rest_endpoint
}

# Service Account Outputs
output "azure_service_account_id" {
  description = "The ID of the Azure app manager service account"
  value       = confluent_service_account.azure_app_manager.id
}

output "azure_admin_service_account_id" {
  description = "The ID of the Azure admin service account"
  value       = confluent_service_account.azure_admin_manager.id
}

# API Key Outputs (IDs only, secrets are sensitive)
output "azure_app_manager_kafka_api_key_id" {
  description = "The ID of the Azure app manager Kafka API key"
  value       = confluent_api_key.azure_app_manager_kafka_api_key.id
}

output "azure_admin_manager_kafka_api_key_id" {
  description = "The ID of the Azure admin manager Kafka API key"
  value       = confluent_api_key.azure_admin_manager_kafka_api_key.id
}

# Flink Outputs
output "azure_flink_compute_pool_id" {
  description = "The ID of the Azure Flink compute pool"
  value       = var.enable_flink ? confluent_flink_compute_pool.azure_flink_pool[0].id : null
}

output "azure_flink_compute_pool_name" {
  description = "The name of the Azure Flink compute pool"
  value       = var.enable_flink ? confluent_flink_compute_pool.azure_flink_pool[0].display_name : null
}

# Project-Specific Service Account Outputs for Development Teams
output "azure_sample_project_app_service_account_id" {
  description = "The ID of the Azure sample project application service account (producer + consumer)"
  value       = confluent_service_account.azure_sample_project_app.id
}

output "azure_sample_project_app_service_account_name" {
  description = "The name of the Azure sample project application service account (producer + consumer)"
  value       = confluent_service_account.azure_sample_project_app.display_name
}

# Project-Specific API Key Outputs (Sensitive)
output "azure_sample_project_app_api_key_id" {
  description = "The API Key ID for Azure sample project application (producer + consumer)"
  value       = confluent_api_key.azure_sample_project_app_api_key.id
  sensitive   = true
}

output "azure_sample_project_app_api_key_secret" {
  description = "The API Key secret for Azure sample project application (producer + consumer)"
  value       = confluent_api_key.azure_sample_project_app_api_key.secret
  sensitive   = true
}

# Project-Specific Topic Patterns for Development Teams
output "azure_sample_project_topic_pattern" {
  description = "The topic pattern that Azure sample project teams can access"
  value       = "azure.*.sample_project.*"
}

output "azure_sample_project_consumer_group_pattern" {
  description = "The consumer group pattern that Azure sample project teams can use"
  value       = "azure-sample-project-*"
}

# Structured output for easier credential management by development teams
output "azure_sample_project_access" {
  description = "Complete access information for Azure sample project development teams"
  value = {
    cluster_info = {
      cluster_id         = confluent_kafka_cluster.azure_basic.id
      bootstrap_endpoint = confluent_kafka_cluster.azure_basic.bootstrap_endpoint
    }
    application = {
      service_account_id = confluent_service_account.azure_sample_project_app.id
      api_key_id         = confluent_api_key.azure_sample_project_app_api_key.id
    }
    access_patterns = {
      topic_pattern          = "azure.sample_project.*"
      consumer_group_pattern = "azure-sample-project-*"
    }
  }
}

# Sensitive credentials (separate output)
output "azure_sample_project_secret" {
  description = "API key secret for Azure sample project (sensitive)"
  value       = confluent_api_key.azure_sample_project_app_api_key.secret
  sensitive   = true
}