# Project-Specific ACLs for AWS Sample Project
# This file defines ACLs and credentials that can be granted to development teams for their specific applications

# Create a single service account per project with both producer and consumer permissions
# This simplifies credential management for applications that need to both produce and consume
resource "confluent_service_account" "aws_sample_project_app" {
  display_name = "aws-sample-project-app-${var.environment_type}"
  description  = "Service account for AWS sample project applications (producer + consumer) in ${var.environment_type} environment"

  lifecycle {
    prevent_destroy = false
  }
}

# API Key for project-specific service account
resource "confluent_api_key" "aws_sample_project_app_api_key" {
  display_name = "aws-sample-project-app-api-key-${var.environment_type}"
  description  = "API Key for AWS sample project application service account (producer + consumer)"

  owner {
    id          = confluent_service_account.aws_sample_project_app.id
    api_version = confluent_service_account.aws_sample_project_app.api_version
    kind        = confluent_service_account.aws_sample_project_app.kind
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

# ACLs for AWS Sample Project Application (Combined Producer + Consumer permissions)
# Allow application to describe the cluster
resource "confluent_kafka_acl" "aws_sample_project_app_describe_cluster" {
  kafka_cluster {
    id = confluent_kafka_cluster.basic.id
  }
  resource_type = "CLUSTER"
  resource_name = "kafka-cluster"
  pattern_type  = "LITERAL"
  principal     = "User:${confluent_service_account.aws_sample_project_app.id}"
  host          = "*"
  operation     = "DESCRIBE"
  permission    = "ALLOW"
  rest_endpoint = confluent_kafka_cluster.basic.rest_endpoint

  credentials {
    key    = confluent_api_key.admin_kafka_api_key.id
    secret = confluent_api_key.admin_kafka_api_key.secret
  }

  lifecycle {
    prevent_destroy = false
  }
}

# Allow application to create project-specific topics
resource "confluent_kafka_acl" "aws_sample_project_app_create_topics" {
  kafka_cluster {
    id = confluent_kafka_cluster.basic.id
  }
  resource_type = "TOPIC"
  resource_name = "aws.sample_project"
  pattern_type  = "PREFIXED"
  principal     = "User:${confluent_service_account.aws_sample_project_app.id}"
  host          = "*"
  operation     = "CREATE"
  permission    = "ALLOW"
  rest_endpoint = confluent_kafka_cluster.basic.rest_endpoint

  credentials {
    key    = confluent_api_key.admin_kafka_api_key.id
    secret = confluent_api_key.admin_kafka_api_key.secret
  }

  lifecycle {
    prevent_destroy = false
  }
}

# Allow application to write to project-specific topics (Producer permission)
resource "confluent_kafka_acl" "aws_sample_project_app_write_topics" {
  kafka_cluster {
    id = confluent_kafka_cluster.basic.id
  }
  resource_type = "TOPIC"
  resource_name = "aws.sample_project"
  pattern_type  = "PREFIXED"
  principal     = "User:${confluent_service_account.aws_sample_project_app.id}"
  host          = "*"
  operation     = "WRITE"
  permission    = "ALLOW"
  rest_endpoint = confluent_kafka_cluster.basic.rest_endpoint

  credentials {
    key    = confluent_api_key.admin_kafka_api_key.id
    secret = confluent_api_key.admin_kafka_api_key.secret
  }

  lifecycle {
    prevent_destroy = false
  }
}

# Allow application to read from project-specific topics (Consumer permission)
resource "confluent_kafka_acl" "aws_sample_project_app_read_topics" {
  kafka_cluster {
    id = confluent_kafka_cluster.basic.id
  }
  resource_type = "TOPIC"
  resource_name = "aws.sample_project"
  pattern_type  = "PREFIXED"
  principal     = "User:${confluent_service_account.aws_sample_project_app.id}"
  host          = "*"
  operation     = "READ"
  permission    = "ALLOW"
  rest_endpoint = confluent_kafka_cluster.basic.rest_endpoint

  credentials {
    key    = confluent_api_key.admin_kafka_api_key.id
    secret = confluent_api_key.admin_kafka_api_key.secret
  }

  lifecycle {
    prevent_destroy = false
  }
}

# Allow application to describe project-specific topics
resource "confluent_kafka_acl" "aws_sample_project_app_describe_topics" {
  kafka_cluster {
    id = confluent_kafka_cluster.basic.id
  }
  resource_type = "TOPIC"
  resource_name = "aws.sample_project"
  pattern_type  = "PREFIXED"
  principal     = "User:${confluent_service_account.aws_sample_project_app.id}"
  host          = "*"
  operation     = "DESCRIBE"
  permission    = "ALLOW"
  rest_endpoint = confluent_kafka_cluster.basic.rest_endpoint

  credentials {
    key    = confluent_api_key.admin_kafka_api_key.id
    secret = confluent_api_key.admin_kafka_api_key.secret
  }

  lifecycle {
    prevent_destroy = false
  }
}

# Allow application to use project-specific consumer groups
resource "confluent_kafka_acl" "aws_sample_project_app_group_read" {
  kafka_cluster {
    id = confluent_kafka_cluster.basic.id
  }
  resource_type = "GROUP"
  resource_name = "aws-sample-project-*"
  pattern_type  = "PREFIXED"
  principal     = "User:${confluent_service_account.aws_sample_project_app.id}"
  host          = "*"
  operation     = "READ"
  permission    = "ALLOW"
  rest_endpoint = confluent_kafka_cluster.basic.rest_endpoint

  credentials {
    key    = confluent_api_key.admin_kafka_api_key.id
    secret = confluent_api_key.admin_kafka_api_key.secret
  }

  lifecycle {
    prevent_destroy = false
  }
}

# Allow application to describe project-specific consumer groups
resource "confluent_kafka_acl" "aws_sample_project_app_group_describe" {
  kafka_cluster {
    id = confluent_kafka_cluster.basic.id
  }
  resource_type = "GROUP"
  resource_name = "aws-sample-project-*"
  pattern_type  = "PREFIXED"
  principal     = "User:${confluent_service_account.aws_sample_project_app.id}"
  host          = "*"
  operation     = "DESCRIBE"
  permission    = "ALLOW"
  rest_endpoint = confluent_kafka_cluster.basic.rest_endpoint

  credentials {
    key    = confluent_api_key.admin_kafka_api_key.id
    secret = confluent_api_key.admin_kafka_api_key.secret
  }

  lifecycle {
    prevent_destroy = false
  }
}
