# Daily User Registration Count Stream - Flink SQL Statement
# This file references external SQL file for counting users registered on particular dates

# COMMENTED OUT: Flink statement resources due to authorization issues
# resource "confluent_flink_statement" "daily_user_registration_stream" {
#   depends_on = [confluent_flink_statement.create_user_table]
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
#   # Reference external SQL file for daily user registration counting
#   statement = templatefile("${path.module}/flink/sql/user_activity_stream.sql", {
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
