# AWS Cluster Creation Module
# This file contains AWS-specific Confluent Kafka cluster and related resources

terraform {
  required_providers {
    confluent = {
      source = "confluentinc/confluent"
    }
  }
}

# Create a Basic Kafka Cluster
resource "confluent_kafka_cluster" "basic" {
  display_name = var.aws_cluster_name
  availability = var.aws_cluster_availability
  cloud        = var.aws_cluster_cloud
  region       = var.aws_cluster_region
  basic {}

  environment {
    id = var.environment_id
  }

  lifecycle {
    prevent_destroy = false
  }
}

# Create a Service Account for the Kafka cluster
resource "confluent_service_account" "app_manager" {
  display_name = "${var.aws_cluster_name}-app-manager"
  description  = "Service account to manage Kafka cluster ${var.aws_cluster_name}"

  lifecycle {
    prevent_destroy = false
  }
}

# Create an Admin Service Account for ACL management
resource "confluent_service_account" "admin_manager" {
  display_name = "${var.aws_cluster_name}-admin-manager"
  description  = "Admin service account for ACL management in cluster ${var.aws_cluster_name}"

  lifecycle {
    prevent_destroy = false
  }
}

# Create role binding for admin service account (Environment Admin)
resource "confluent_role_binding" "admin_environment_admin" {
  principal   = "User:${confluent_service_account.admin_manager.id}"
  role_name   = "EnvironmentAdmin"
  crn_pattern = var.environment_resource_name

  lifecycle {
    prevent_destroy = false
  }
}

# Create role binding for admin service account (Flink Admin)
resource "confluent_role_binding" "admin_flink_admin" {
  principal   = "User:${confluent_service_account.admin_manager.id}"
  role_name   = "FlinkAdmin"
  crn_pattern = var.environment_resource_name

  lifecycle {
    prevent_destroy = false
  }
}

# Create Admin API Key for the admin service account (Cloud API Key)
resource "confluent_api_key" "admin_api_key" {
  display_name = "${var.aws_cluster_name}-admin-api-key"
  description  = "Admin API Key for ACL management"

  owner {
    id          = confluent_service_account.admin_manager.id
    api_version = confluent_service_account.admin_manager.api_version
    kind        = confluent_service_account.admin_manager.kind
  }

  depends_on = [
    confluent_role_binding.admin_environment_admin,
    confluent_role_binding.admin_flink_admin
  ]

  lifecycle {
    prevent_destroy = false
  }
}

# Create Kafka Cluster-specific API Key for ACL and topic operations
resource "confluent_api_key" "admin_kafka_api_key" {
  display_name = "${var.aws_cluster_name}-admin-kafka-api-key"
  description  = "Kafka API Key for admin operations (ACLs and topics)"

  owner {
    id          = confluent_service_account.admin_manager.id
    api_version = confluent_service_account.admin_manager.api_version
    kind        = confluent_service_account.admin_manager.kind
  }

  managed_resource {
    id          = confluent_kafka_cluster.basic.id
    api_version = confluent_kafka_cluster.basic.api_version
    kind        = confluent_kafka_cluster.basic.kind

    environment {
      id = var.environment_id
    }
  }

  depends_on = [
    confluent_role_binding.admin_environment_admin,
    confluent_role_binding.admin_flink_admin
  ]

  lifecycle {
    prevent_destroy = false
  }
}

# Create API Key for the Service Account
resource "confluent_api_key" "app_manager_kafka_api_key" {
  display_name = "${var.aws_cluster_name}-kafka-api-key"
  description  = "Kafka API Key that is owned by '${confluent_service_account.app_manager.display_name}' service account"
  owner {
    id          = confluent_service_account.app_manager.id
    api_version = confluent_service_account.app_manager.api_version
    kind        = confluent_service_account.app_manager.kind
  }

  managed_resource {
    id          = confluent_kafka_cluster.basic.id
    api_version = confluent_kafka_cluster.basic.api_version
    kind        = confluent_kafka_cluster.basic.kind

    environment {
      id = var.environment_id
    }
  }

  lifecycle {
    prevent_destroy = false
  }
}

# Create ACLs for the Service Account using Admin API Key
resource "confluent_kafka_acl" "app_manager_describe_cluster" {
  kafka_cluster {
    id = confluent_kafka_cluster.basic.id
  }
  resource_type = "CLUSTER"
  resource_name = "kafka-cluster"
  pattern_type  = "LITERAL"
  principal     = "User:${confluent_service_account.app_manager.id}"
  host          = "*"
  operation     = "DESCRIBE"
  permission    = "ALLOW"
  rest_endpoint = confluent_kafka_cluster.basic.rest_endpoint

  # Use the admin cluster API key for ACL operations
  credentials {
    key    = confluent_api_key.admin_kafka_api_key.id
    secret = confluent_api_key.admin_kafka_api_key.secret
  }

  lifecycle {
    prevent_destroy = false
  }
}

resource "confluent_kafka_acl" "app_manager_create_topics" {
  kafka_cluster {
    id = confluent_kafka_cluster.basic.id
  }
  resource_type = "TOPIC"
  resource_name = "*"
  pattern_type  = "LITERAL"
  principal     = "User:${confluent_service_account.app_manager.id}"
  host          = "*"
  operation     = "CREATE"
  permission    = "ALLOW"
  rest_endpoint = confluent_kafka_cluster.basic.rest_endpoint

  # Use the admin cluster API key for ACL operations
  credentials {
    key    = confluent_api_key.admin_kafka_api_key.id
    secret = confluent_api_key.admin_kafka_api_key.secret
  }

  lifecycle {
    prevent_destroy = false
  }
}

resource "confluent_kafka_acl" "app_manager_write_topics" {
  kafka_cluster {
    id = confluent_kafka_cluster.basic.id
  }
  resource_type = "TOPIC"
  resource_name = "*"
  pattern_type  = "LITERAL"
  principal     = "User:${confluent_service_account.app_manager.id}"
  host          = "*"
  operation     = "WRITE"
  permission    = "ALLOW"
  rest_endpoint = confluent_kafka_cluster.basic.rest_endpoint

  # Use the admin cluster API key for ACL operations
  credentials {
    key    = confluent_api_key.admin_kafka_api_key.id
    secret = confluent_api_key.admin_kafka_api_key.secret
  }

  lifecycle {
    prevent_destroy = false
  }
}

resource "confluent_kafka_acl" "app_manager_read_topics" {
  kafka_cluster {
    id = confluent_kafka_cluster.basic.id
  }
  resource_type = "TOPIC"
  resource_name = "*"
  pattern_type  = "LITERAL"
  principal     = "User:${confluent_service_account.app_manager.id}"
  host          = "*"
  operation     = "READ"
  permission    = "ALLOW"
  rest_endpoint = confluent_kafka_cluster.basic.rest_endpoint

  # Use the admin cluster API key for ACL operations
  credentials {
    key    = confluent_api_key.admin_kafka_api_key.id
    secret = confluent_api_key.admin_kafka_api_key.secret
  }

  lifecycle {
    prevent_destroy = false
  }
}

# COMMENTED OUT: Schema Registry for sandbox environment (not available for basic clusters)
# Uncomment when using a dedicated or enterprise cluster with Schema Registry

# # Reference the existing Schema Registry Cluster
# data "confluent_schema_registry_cluster" "essentials" {
#   environment {
#     id = var.environment_id
#   }
# }

# # Create API Key for Schema Registry
# resource "confluent_api_key" "schema_registry_api_key" {
#   display_name = "schema-registry-api-key"
#   description  = "Schema Registry API Key that is owned by 'admin_manager' service account"

#   owner {
#     id          = confluent_service_account.admin_manager.id
#     api_version = confluent_service_account.admin_manager.api_version
#     kind        = confluent_service_account.admin_manager.kind
#   }

#   managed_resource {
#     id          = data.confluent_schema_registry_cluster.essentials.id
#     api_version = data.confluent_schema_registry_cluster.essentials.api_version
#     kind        = data.confluent_schema_registry_cluster.essentials.kind

#     environment {
#       id = var.environment_id
#     }
#   }

#   lifecycle {
#     # prevent_destroy = false
#   }
# }
