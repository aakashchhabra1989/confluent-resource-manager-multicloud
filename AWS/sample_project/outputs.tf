# Sample Project Module Outputs

# COMMENTED OUT: HTTP Source Connector Outputs (resource is commented out)
# Uncomment these outputs when HTTP source connector is enabled

# output "http_source_connector_ids" {
#   description = "The IDs of the HTTP source connectors"
#   value       = { for env, connector in confluent_connector.http_source : env => connector.id }
# }

# output "http_source_connector_names" {
#   description = "The names of the HTTP source connectors"
#   value       = { for env in var.sub_environments : env => "HttpSourceConnector_${var.aws_cluster_name}_${env}_${local.project_name}" }
# }

# Flink Outputs (these should be working)
output "flink_compute_pool_id" {
  description = "The ID of the Flink compute pool"
  value       = var.flink_compute_pool_id
}

output "organization_id" {
  description = "The ID of the organization"
  value       = var.organization_id
}
