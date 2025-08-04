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