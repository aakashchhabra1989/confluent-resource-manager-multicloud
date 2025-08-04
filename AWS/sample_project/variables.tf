# Sample Project Module Variables
# All variables needed for the sample project resources

variable "project_name" {
  description = "Project name to be included in resource naming"
  type        = string
  default     = "sample_project"
}

# Project name is hardcoded for this module
locals {
  project_name = var.project_name
}

variable "environment_id" {
  description = "The ID of the Confluent Environment"
  type        = string
}

variable "environment_resource_name" {
  description = "The resource name of the Confluent Environment"
  type        = string
}

variable "environment_type" {
  description = "The type of environment (prod, non-prod, or sandbox)"
  type        = string
}

variable "sub_environments" {
  description = "List of sub-environments to create resources for"
  type        = list(string)
}

variable "aws_topic_base_prefix" {
  description = "Base prefix for topic naming"
  type        = string
}

variable "aws_cluster_name" {
  description = "Name of the AWS Kafka cluster"
  type        = string
}

variable "aws_cluster_region" {
  description = "AWS region for the cluster"
  type        = string
}

variable "aws_cluster_cloud" {
  description = "Cloud provider for the cluster"
  type        = string
}

variable "create_aws_dummy_topic" {
  description = "Whether to create AWS dummy topics"
  type        = bool
  default     = true
}

variable "default_topic_partition" {
  description = "Default number of partitions for topics"
  type        = number
  default     = 3
}

# Cluster and service account references
variable "kafka_cluster_id" {
  description = "ID of the Kafka cluster"
  type        = string
}

variable "kafka_cluster_rest_endpoint" {
  description = "REST endpoint of the Kafka cluster"
  type        = string
}

variable "kafka_cluster_bootstrap_endpoint" {
  description = "Bootstrap endpoint of the Kafka cluster"
  type        = string
}

variable "admin_kafka_api_key_id" {
  description = "Admin Kafka API key ID"
  type        = string
}

variable "admin_kafka_api_key_secret" {
  description = "Admin Kafka API key secret"
  type        = string
  sensitive   = true
}

variable "app_manager_kafka_api_key_id" {
  description = "App manager Kafka API key ID"
  type        = string
}

variable "app_manager_kafka_api_key_secret" {
  description = "App manager Kafka API key secret"
  type        = string
  sensitive   = true
}

variable "admin_service_account_id" {
  description = "Admin service account ID"
  type        = string
}

variable "schema_registry_cluster_id" {
  description = "Schema Registry cluster ID"
  type        = string
}

variable "schema_registry_rest_endpoint" {
  description = "Schema Registry REST endpoint"
  type        = string
}

variable "schema_registry_api_key_id" {
  description = "Schema Registry API key ID"
  type        = string
}

variable "schema_registry_api_key_secret" {
  description = "Schema Registry API key secret"
  type        = string
  sensitive   = true
}

variable "flink_compute_pool_id" {
  description = "Flink compute pool ID"
  type        = string
}

variable "organization_id" {
  description = "Organization ID"
  type        = string
}
