# AWS Module Outputs

# Cluster Outputs
output "kafka_cluster_id" {
  description = "The ID of the AWS Kafka cluster"
  value       = confluent_kafka_cluster.basic.id
}

output "kafka_cluster_name" {
  description = "The name of the AWS Kafka cluster"
  value       = confluent_kafka_cluster.basic.display_name
}

output "kafka_cluster_bootstrap_endpoint" {
  description = "The bootstrap endpoint of the AWS Kafka cluster"
  value       = confluent_kafka_cluster.basic.bootstrap_endpoint
}

output "kafka_cluster_rest_endpoint" {
  description = "The REST endpoint of the AWS Kafka cluster"
  value       = confluent_kafka_cluster.basic.rest_endpoint
}

# Service Account Outputs
output "service_account_id" {
  description = "The ID of the app manager service account"
  value       = confluent_service_account.app_manager.id
}

output "service_account_name" {
  description = "The name of the app manager service account"
  value       = confluent_service_account.app_manager.display_name
}

output "admin_service_account_id" {
  description = "The ID of the admin service account"
  value       = confluent_service_account.admin_manager.id
}

output "admin_service_account_name" {
  description = "The name of the admin service account"
  value       = confluent_service_account.admin_manager.display_name
}

# API Key Outputs
output "kafka_api_key_id" {
  description = "The ID of the app manager Kafka API key"
  value       = confluent_api_key.app_manager_kafka_api_key.id
  sensitive   = true
}

output "kafka_api_key_secret" {
  description = "The secret of the app manager Kafka API key"
  value       = confluent_api_key.app_manager_kafka_api_key.secret
  sensitive   = true
}

output "admin_api_key_id" {
  description = "The ID of the admin API key"
  value       = confluent_api_key.admin_api_key.id
  sensitive   = true
}

output "admin_api_key_secret" {
  description = "The secret of the admin API key"
  value       = confluent_api_key.admin_api_key.secret
  sensitive   = true
}

output "admin_kafka_api_key_id" {
  description = "The ID of the admin Kafka API key"
  value       = confluent_api_key.admin_kafka_api_key.id
  sensitive   = true
}

output "admin_kafka_api_key_secret" {
  description = "The secret of the admin Kafka API key"
  value       = confluent_api_key.admin_kafka_api_key.secret
  sensitive   = true
}

# Topic Outputs - temporarily disabled until sample_project resources are working
# output "aws_dummy_topic_names" {
#   description = "The names of the AWS dummy topics (if created)"
#   value       = module.sample_project.aws_dummy_topic_names
# }

# output "aws_dummy_topic_with_schema_names" {
#   description = "The names of the AWS dummy topics with schema"
#   value       = module.sample_project.aws_dummy_topic_with_schema_names
# }

# output "aws_dummy_topic_key_schema_ids" {
#   description = "The IDs of the key schemas for AWS dummy topics with schema"
#   value       = module.sample_project.aws_dummy_topic_key_schema_ids
# }

# output "aws_dummy_topic_value_schema_ids" {
#   description = "The IDs of the value schemas for AWS dummy topics with schema"
#   value       = module.sample_project.aws_dummy_topic_value_schema_ids
# }

# output "aws_dummy_topic_key_schema_versions" {
#   description = "The versions of the key schemas for AWS dummy topics with schema"
#   value       = module.sample_project.aws_dummy_topic_key_schema_versions
# }

# output "aws_dummy_topic_value_schema_versions" {
#   description = "The versions of the value schemas for AWS dummy topics with schema"
#   value       = module.sample_project.aws_dummy_topic_value_schema_versions
# }

# COMMENTED OUT: Schema Registry Outputs (not available for basic clusters in sandbox)
# Uncomment when using a dedicated or enterprise cluster with Schema Registry

# output "schema_registry_cluster_id" {
#   description = "The ID of the Schema Registry cluster"
#   value       = data.confluent_schema_registry_cluster.essentials.id
# }

# output "schema_registry_rest_endpoint" {
#   description = "The REST endpoint of the Schema Registry cluster"
#   value       = data.confluent_schema_registry_cluster.essentials.rest_endpoint
# }

# output "schema_registry_api_key_id" {
#   description = "The ID of the Schema Registry API key"
#   value       = confluent_api_key.schema_registry_api_key.id
# }

# output "schema_registry_api_key_secret" {
#   description = "The secret of the Schema Registry API key"
#   value       = confluent_api_key.schema_registry_api_key.secret
#   sensitive   = true
# }

# Flink Compute Pool Outputs
output "flink_compute_pool_id" {
  description = "The ID of the Flink compute pool"
  value       = confluent_flink_compute_pool.main.id
}

# HTTP Source Connector Outputs
# output "http_source_topic_names" {
#   description = "The names of the HTTP source topics"
#   value       = module.sample_project.http_source_topic_names
# }

# COMMENTED OUT: HTTP Source Connector Outputs (resource is commented out)
# Uncomment these outputs when HTTP source connector is enabled

# output "http_source_connector_ids" {
#   description = "The IDs of the HTTP source connectors"
#   value       = module.sample_project.http_source_connector_ids
# }

# output "http_source_connector_names" {
#   description = "The names of the HTTP source connectors"
#   value       = module.sample_project.http_source_connector_names
# }


