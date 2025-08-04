# Sample Project Module Integration
# This file integrates the sample_project module with the main AWS infrastructure

module "sample_project" {
  source = "./sample_project"

  # Environment variables
  environment_id               = var.environment_id
  environment_resource_name    = var.environment_resource_name
  environment_type            = var.environment_type
  sub_environments            = var.sub_environments
  aws_topic_base_prefix       = var.aws_topic_base_prefix
  project_name                = "sample_project"

  # AWS cluster variables
  aws_cluster_name    = var.aws_cluster_name
  aws_cluster_region  = var.aws_cluster_region
  aws_cluster_cloud   = var.aws_cluster_cloud

  # Topic configuration
  create_aws_dummy_topic    = var.create_aws_dummy_topic
  default_topic_partition   = var.default_topic_partition

  # Cluster and service account references from main AWS module
  kafka_cluster_id                      = confluent_kafka_cluster.basic.id
  kafka_cluster_rest_endpoint           = confluent_kafka_cluster.basic.rest_endpoint
  kafka_cluster_bootstrap_endpoint      = confluent_kafka_cluster.basic.bootstrap_endpoint
  admin_kafka_api_key_id               = confluent_api_key.admin_kafka_api_key.id
  admin_kafka_api_key_secret           = confluent_api_key.admin_kafka_api_key.secret
  app_manager_kafka_api_key_id         = confluent_api_key.app_manager_kafka_api_key.id
  app_manager_kafka_api_key_secret     = confluent_api_key.app_manager_kafka_api_key.secret
  admin_service_account_id             = confluent_service_account.admin_manager.id
  # COMMENTED OUT: Schema Registry for sandbox environment (not available for basic clusters)
  # schema_registry_cluster_id           = data.confluent_schema_registry_cluster.essentials.id
  # schema_registry_rest_endpoint        = data.confluent_schema_registry_cluster.essentials.rest_endpoint
  # schema_registry_api_key_id           = confluent_api_key.schema_registry_api_key.id
  # schema_registry_api_key_secret       = confluent_api_key.schema_registry_api_key.secret
  schema_registry_cluster_id           = ""
  schema_registry_rest_endpoint        = ""
  schema_registry_api_key_id           = ""
  schema_registry_api_key_secret       = ""
  flink_compute_pool_id                = confluent_flink_compute_pool.main.id
  organization_id                      = data.confluent_organization.main.id
}
