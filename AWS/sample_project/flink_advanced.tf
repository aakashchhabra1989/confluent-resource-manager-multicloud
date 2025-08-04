# Advanced Flink SQL Statements for User Registration Analytics
# This file references external SQL files for daily user registration counting

# COMMENTED OUT: Flink statement resources due to authorization issues
# # Create a sink table to write daily user registration counts back to Kafka
# resource "confluent_flink_statement" "create_daily_registration_sink" {
#   depends_on = [confluent_flink_statement.daily_user_registration_stream]
# 
#   organization {
#     id = var.organization_id
#   }
# 
#   environment {
#     id = var.environment_id
#   }
# 
#   compute_pool {
#     id = var.flink_compute_pool_id
#   }
# 
#   principal {
#     id = var.admin_service_account_id
#   }
# 
#   # Reference external SQL file with variable substitution
#   statement = templatefile("${path.module}/flink/sql/create_sink_table.sql", {
#     project_name         = local.project_name
#     bootstrap_servers    = var.kafka_cluster_bootstrap_endpoint
#     topic_name_prefix    = var.aws_topic_base_prefix
#   })
# 
#   properties = {
#     "sql.current-catalog"  = var.environment_id
#     "sql.current-database" = var.kafka_cluster_id
#   }
# 
#   rest_endpoint = "https://flink.${var.aws_cluster_region}.${lower(var.aws_cluster_cloud)}.confluent.cloud"
# 
#   credentials {
#     key    = var.admin_kafka_api_key_id
#     secret = var.admin_kafka_api_key_secret
#   }
# 
#   lifecycle {
#     prevent_destroy = false
#   }
# }
# 
# # Insert daily user registration counts into the sink table
# resource "confluent_flink_statement" "populate_daily_registration_sink" {
#   depends_on = [confluent_flink_statement.create_daily_registration_sink]
# 
#   organization {
#     id = var.organization_id
#   }
# 
#   environment {
#     id = var.environment_id
#   }
# 
#   compute_pool {
#     id = var.flink_compute_pool_id
#   }
# 
#   principal {
#     id = var.admin_service_account_id
#   }
# 
#   # Reference external SQL file for daily registration count population
#   statement = templatefile("${path.module}/flink/sql/populate_sink.sql", {
#     project_name = local.project_name
#   })
# 
#   properties = {
#     "sql.current-catalog"  = var.environment_id
#     "sql.current-database" = var.kafka_cluster_id
#   }
# 
#   rest_endpoint = "https://flink.${var.aws_cluster_region}.${lower(var.aws_cluster_cloud)}.confluent.cloud"
# 
#   credentials {
#     key    = var.admin_kafka_api_key_id
#     secret = var.admin_kafka_api_key_secret
#   }
# 
#   lifecycle {
#     prevent_destroy = false
#   }
# }
