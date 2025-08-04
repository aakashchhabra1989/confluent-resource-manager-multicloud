# AWS Schema Registry Resources
# This file contains all Schema Registry related resources for AWS environment

# COMMENTED OUT: Schema Registry resources for sandbox environment (not available for basic clusters)
# Uncomment when using a dedicated or enterprise cluster with Schema Registry

# # Create Schema Registry Schemas for aws_dummy_topic_with_schema for each sub-environment
# resource "confluent_schema" "aws_dummy_topic_key_schema" {
#   for_each = toset(var.sub_environments)

#   schema_registry_cluster {
#     id = var.schema_registry_cluster_id
#   }
#   rest_endpoint = var.schema_registry_rest_endpoint
#   subject_name  = "${var.aws_topic_base_prefix}.${each.key}.${local.project_name}.dummy_topic_with_schema-key"
#   format        = "AVRO"
#   schema        = file("${path.module}/schemas/${upper(each.key)}/user_id_key.avsc")

#   credentials {
#     key    = var.schema_registry_api_key_id
#     secret = var.schema_registry_api_key_secret
#   }

#   lifecycle {
#     prevent_destroy = false
#   }
# }

# resource "confluent_schema" "aws_dummy_topic_value_schema" {
#   for_each = toset(var.sub_environments)

#   schema_registry_cluster {
#     id = var.schema_registry_cluster_id
#   }
#   rest_endpoint = var.schema_registry_rest_endpoint
#   subject_name  = "${var.aws_topic_base_prefix}.${each.key}.${local.project_name}.dummy_topic_with_schema-value"
#   format        = "AVRO"
#   schema        = file("${path.module}/schemas/${upper(each.key)}/user_profile_value.avsc")

#   credentials {
#     key    = var.schema_registry_api_key_id
#     secret = var.schema_registry_api_key_secret
#   }

#   lifecycle {
#     prevent_destroy = false
#   }
# }
