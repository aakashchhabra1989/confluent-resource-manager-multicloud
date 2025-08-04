-- Create User Profiles Source Table
-- This SQL creates a source table from the Kafka topic with JSON format (no Schema Registry required)
-- Template variables are substituted by Terraform
-- Added computed column for date extraction for user registration analysis

CREATE TABLE tbl_${project_name}_user_profiles_source (
  id STRING,
  username STRING,
  email STRING,
  registrationDate TIMESTAMP(3),
  registration_date_only AS DATE_FORMAT(registrationDate, 'yyyy-MM-dd'),
  WATERMARK FOR registrationDate AS registrationDate - INTERVAL '5' SECOND
) WITH (
  'connector' = 'confluent-kafka',
  'kafka.bootstrap.servers' = '${bootstrap_servers}',
  'value.format' = 'json',
  'topic' = '${topic_name}'
);
