# Create User Table - Flink SQL Statement
# This file references external SQL file for better maintainability

# COMMENTED OUT: Flink statement resources due to authorization issues
# resource "confluent_flink_statement" "create_user_table" {
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
#   statement = templatefile("${path.module}/flink/sql/create_user_table.sql", {
#     project_name         = local.project_name
#     bootstrap_servers    = var.kafka_cluster_bootstrap_endpoint
#     topic_name          = confluent_kafka_topic.aws_dummy_topic_with_schema[keys(confluent_kafka_topic.aws_dummy_topic_with_schema)[0]].topic_name
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
