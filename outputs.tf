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