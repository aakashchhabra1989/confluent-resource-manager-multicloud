# AWS Module Variables

# Environment Variables
variable "environment_id" {
  description = "The ID of the Confluent environment"
  type        = string
}

variable "environment_resource_name" {
  description = "The resource name of the Confluent environment"
  type        = string
}

variable "environment_type" {
  description = "Environment type (non-prod, prod, sandbox)"
  type        = string
  default     = "non-prod"
}

variable "sub_environments" {
  description = "List of sub-environments to create resources for"
  type        = list(string)
  default     = ["dev"]
}

variable "project_name" {
  description = "Project name to be included in resource naming"
  type        = string
  default     = "sample_project"
}

variable "schema_base_path" {
  description = "Base path for schema files"
  type        = string
  default     = "schemas"
}

variable "aws_topic_base_prefix" {
  description = "Base prefix for topic names"
  type        = string
  default     = "aws.myorg"
}

# AWS Cluster Configuration
variable "aws_cluster_name" {
  description = "Name for the AWS Kafka cluster"
  type        = string
}

variable "aws_cluster_availability" {
  description = "The availability zone configuration of the AWS Kafka cluster"
  type        = string
}

variable "aws_cluster_cloud" {
  description = "The cloud service provider (AWS)"
  type        = string
}

variable "aws_cluster_region" {
  description = "The AWS region where the Kafka cluster will be created"
  type        = string
}

# Topic Variables
variable "create_aws_dummy_topic" {
  description = "Whether to create an AWS dummy topic"
  type        = bool
  default     = true
}

variable "default_topic_partition" {
  description = "Number of partitions for the AWS dummy topic"
  type        = number
  default     = 3
}

# Flink/Tableflow Configuration
variable "flink_max_cfu" {
  description = "Maximum Confluent Flink Units for the compute pool"
  type        = number
  default     = 5
}

variable "enable_flink" {
  description = "Enable Flink compute pool for Tableflow"
  type        = bool
  default     = true
}
