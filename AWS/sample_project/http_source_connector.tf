# HTTP Source Connector Resource
# Creates HTTP source connectors for each sub-environment

# Create HTTP Source Connector for each sub-environment
resource "confluent_connector" "http_source" {
  for_each = toset(var.sub_environments)

  environment {
    id = var.environment_id
  }

  kafka_cluster {
    id = var.kafka_cluster_id
  }

  # Enhanced connector configuration
  config_nonsensitive = {
    "connector.class"     = "HttpSource"
    "name"                = "HttpSource_${each.key}"
    "kafka.auth.mode"     = "KAFKA_API_KEY"
    "kafka.api.key"       = var.admin_kafka_api_key_id
    "topic.name.pattern"  = "${var.aws_topic_base_prefix}.${each.key}.${local.project_name}.http_source_data.source-connector.0"
    "output.data.format"  = "JSON"
    "http.initial.offset" = "0"
    "http.offset.mode"    = "SIMPLE_INCREMENTING"
    "http.offset.field"   = "id"
    "url"                 = "https://jsonplaceholder.typicode.com/users"
    "method"              = "GET"
    "headers"             = "Content-Type:application/json"
    "request.interval.ms" = "60000"
    "request.timeout.ms"  = "30000"
    "retry.backoff.ms"    = "5000"
    "max.retries"         = "5"
    "tasks.max"           = "1"
    "user.agent"          = "Confluent-HTTP-Source-Connector"
  }

  config_sensitive = {
    "kafka.api.secret" = var.admin_kafka_api_key_secret
  }

  lifecycle {
    prevent_destroy = false
  }
}

# Create ACL for HTTP Source Connector to read from the topic for each sub-environment
resource "confluent_kafka_acl" "http_source_read" {
  for_each = toset(var.sub_environments)

  kafka_cluster {
    id = var.kafka_cluster_id
  }
  resource_type = "TOPIC"
  resource_name = "${var.aws_topic_base_prefix}.${each.key}.${local.project_name}.http_source_data.source-connector.0"
  pattern_type  = "LITERAL"
  principal     = "User:${var.admin_service_account_id}"
  host          = "*"
  operation     = "READ"
  permission    = "ALLOW"
  rest_endpoint = var.kafka_cluster_rest_endpoint

  credentials {
    key    = var.admin_kafka_api_key_id
    secret = var.admin_kafka_api_key_secret
  }

  lifecycle {
    prevent_destroy = false
  }
}

# Create ACL for HTTP Source Connector to write to the topic for each sub-environment
resource "confluent_kafka_acl" "http_source_write" {
  for_each = toset(var.sub_environments)

  kafka_cluster {
    id = var.kafka_cluster_id
  }
  resource_type = "TOPIC"
  resource_name = "${var.aws_topic_base_prefix}.${each.key}.${local.project_name}.http_source_data.source-connector.0"
  pattern_type  = "LITERAL"
  principal     = "User:${var.admin_service_account_id}"
  host          = "*"
  operation     = "WRITE"
  permission    = "ALLOW"
  rest_endpoint = var.kafka_cluster_rest_endpoint

  credentials {
    key    = var.admin_kafka_api_key_id
    secret = var.admin_kafka_api_key_secret
  }

  lifecycle {
    prevent_destroy = false
  }
}
