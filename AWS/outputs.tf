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

# Project-Specific Service Account Outputs for Development Teams
output "aws_sample_project_app_service_account_id" {
  description = "The ID of the AWS sample project application service account (producer + consumer)"
  value       = confluent_service_account.aws_sample_project_app.id
}

output "aws_sample_project_app_service_account_name" {
  description = "The name of the AWS sample project application service account (producer + consumer)"
  value       = confluent_service_account.aws_sample_project_app.display_name
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

# Project-Specific API Key Outputs (Sensitive)
output "aws_sample_project_app_api_key_id" {
  description = "The API Key ID for AWS sample project application (producer + consumer)"
  value       = confluent_api_key.aws_sample_project_app_api_key.id
  sensitive   = true
}

output "aws_sample_project_app_api_key_secret" {
  description = "The API Key secret for AWS sample project application (producer + consumer)"
  value       = confluent_api_key.aws_sample_project_app_api_key.secret
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

# Project-Specific Topic Patterns for Development Teams
output "aws_sample_project_topic_pattern" {
  description = "The topic pattern that AWS sample project teams can access"
  value       = "aws.*.sample_project.*"
}

output "aws_sample_project_consumer_group_pattern" {
  description = "The consumer group pattern that AWS sample project teams can use"
  value       = "aws-sample-project-*"
}

# Structured output for easier credential management by development teams
output "aws_sample_project_access" {
  description = "Complete access information for AWS sample project development teams"
  value = {
    cluster_info = {
      cluster_id         = confluent_kafka_cluster.basic.id
      bootstrap_endpoint = confluent_kafka_cluster.basic.bootstrap_endpoint
    }
    application = {
      service_account_id = confluent_service_account.aws_sample_project_app.id
      api_key_id         = confluent_api_key.aws_sample_project_app_api_key.id
    }
    access_patterns = {
      topic_pattern          = "aws.sample_project.*"
      consumer_group_pattern = "aws-sample-project-*"
    }
  }
}

# Sensitive credentials (separate output)
output "aws_sample_project_secret" {
  description = "API key secret for AWS sample project (sensitive)"
  value       = confluent_api_key.aws_sample_project_app_api_key.secret
  sensitive   = true
}


