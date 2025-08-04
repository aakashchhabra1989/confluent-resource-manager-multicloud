# Confluent Cloud Multi-Cloud Terraform Project

This Terraform project creates Confluent Cloud infrastructure across AWS and Azure with Flink compute pools and sample projects. The project supports multiple environments (sandbox, non-prod, production) with environment-specific configurations.

## 🏗️ Architecture

```
Confluent Environment
├── AWS Cluster
│   ├── Basic Kafka Cluster (us-east-1)
│   ├── Flink Compute Pool (5-10 CFU)
│   ├── Service Accounts & API Keys
│   ├── RBAC Roles & ACLs
│   └── Sample Project
│       ├── Topics (dummy_topic, dummy_topic_with_schema, http_source_topic)
│       ├── HTTP Source Connector
│       └── Schema Registry Integration (Basic tier compatible)
└── Azure Cluster
    ├── Basic Kafka Cluster (eastus)
    ├── Flink Compute Pool (5-10 CFU)
    ├── Service Accounts & API Keys
    ├── RBAC Roles & ACLs
    └── Sample Project
        ├── Topics (dummy_topic, dummy_topic_with_schema, http_source_topic)
        ├── HTTP Source Connector
        └── Schema Registry Integration (Basic tier compatible)
```

## 🚀 **Deployment Status**

✅ **Successfully Deployed** - Infrastructure is currently running with:
- **Environment**: `sandbox-env` (ID: `env-67yrg6`)
- **AWS Cluster**: `lkc-8rgn0m` 
- **Azure Cluster**: `lkc-0z30g9`
- **Total Resources**: 35 resources deployed
- **Deployment Time**: ~10 minutes

## 📋 Prerequisites

1. **Confluent Cloud Account**: Sign up at [https://confluent.cloud](https://confluent.cloud)
2. **API Keys**: Create Cloud API Keys in Confluent Cloud Console
3. **Terraform**: Install Terraform >= 1.0
4. **Environment Access**: Ensure billing is enabled for Flink features

## 🔧 Quick Setup

### 1. Clone and Configure

```bash
git clone <your-repo>
cd confluent-resource-manager-multicloud
```

### 2. Choose Your Environment

The project includes three pre-configured environments:

- **`terraform.tfvars`** - Sandbox environment (currently deployed)
- **`non-prod.tfvars`** - Non-production environment
- **`prod.tfvars`** - Production environment

### 3. Configure Credentials

```bash
# For sandbox (current deployment)
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your actual API credentials

# For other environments
# Edit non-prod.tfvars or prod.tfvars with environment-specific credentials
```

### 4. Deploy to Your Chosen Environment

```bash
# Initialize Terraform
terraform init

# Deploy to Sandbox (current configuration)
terraform plan
terraform apply

# Deploy to Non-Production
terraform plan -var-file="non-prod.tfvars"
terraform apply -var-file="non-prod.tfvars"

# Deploy to Production
terraform plan -var-file="prod.tfvars"
terraform apply -var-file="prod.tfvars"
```

## ⚙️ Environment Configurations

### 🏖️ **Sandbox Environment** (`terraform.tfvars`)
- **Purpose**: Testing and development
- **Environment**: `sandbox-env` 
- **Sub-environments**: `["sandbox"]`
- **Clusters**: Single-zone deployment
- **Flink CFU**: 5
- **Features**: All sample topics and connectors enabled
- **Status**: ✅ Currently deployed

### 🔧 **Non-Production Environment** (`non-prod.tfvars`)
- **Purpose**: Development, QA, and UAT
- **Environment**: `non-prod-env`
- **Sub-environments**: `["dev", "qa", "uat"]`
- **Clusters**: Single-zone (cost-effective)
- **Flink CFU**: 5
- **Partitions**: 3 (standard)
- **Features**: Dummy topics enabled for testing

### 🏭 **Production Environment** (`prod.tfvars`)
- **Purpose**: Production workloads
- **Environment**: `prod-env`
- **Sub-environments**: `["prod"]`
- **Clusters**: Multi-zone (high availability)
- **Flink CFU**: 10 (higher performance)
- **Partitions**: 6 (higher throughput)
- **Features**: Dummy topics disabled, production-ready configuration

## 📊 **Current Deployment Details**

### **Active Resources (Sandbox)**
```
Environment ID: env-67yrg6
Environment Name: sandbox-env

AWS Infrastructure:
├── Cluster ID: lkc-8rgn0m
├── Bootstrap: SASL_SSL://pkc-p11xm.us-east-1.aws.confluent.cloud:9092
├── Flink Pool: lfcp-rmjy87
└── HTTP Connector: lcc-69g5p6

Azure Infrastructure:
├── Cluster ID: lkc-0z30g9
├── Bootstrap: SASL_SSL://pkc-56d1g.eastus.azure.confluent.cloud:9092
├── Flink Pool: lfcp-2g1mz2
└── HTTP Connector: lcc-w32nrj
```

## 📋 **Configuration Variables**

### **Global Variables**

| Variable | Description | Default | Sandbox | Non-Prod | Production |
|----------|-------------|---------|---------|----------|------------|
| `confluent_cloud_api_key` | Confluent Cloud API Key | **Required** | ✅ | ✅ | ✅ |
| `confluent_cloud_api_secret` | Confluent Cloud API Secret | **Required** | ✅ | ✅ | ✅ |
| `environment_name` | Environment name | `terraform-env` | `sandbox-env` | `non-prod-env` | `prod-env` |
| `environment_type` | Environment type | `non-prod` | `sandbox` | `non-prod` | `prod` |
| `sub_environments` | Sub-environments list | `["dev"]` | `["sandbox"]` | `["dev","qa","uat"]` | `["prod"]` |

### **AWS Configuration**

| Variable | Description | Sandbox | Non-Prod | Production |
|----------|-------------|---------|----------|------------|
| `aws_cluster_name` | AWS cluster name | `aws-sandbox-cluster` | `aws-nonprod-cluster` | `aws-prod-cluster` |
| `aws_cluster_region` | AWS region | `us-east-1` | `us-east-1` | `us-east-1` |
| `aws_cluster_availability` | Availability zone config | `SINGLE_ZONE` | `SINGLE_ZONE` | `MULTI_ZONE` |
| `aws_topic_base_prefix` | Topic prefix | `aws.myorg` | `aws.myorg` | `aws.myorg` |

### **Azure Configuration**

| Variable | Description | Sandbox | Non-Prod | Production |
|----------|-------------|---------|----------|------------|
| `azure_cluster_name` | Azure cluster name | `azure-sandbox-cluster` | `azure-nonprod-cluster` | `azure-prod-cluster` |
| `azure_cluster_region` | Azure region | `eastus` | `eastus` | `eastus` |
| `azure_cluster_availability` | Availability zone config | `SINGLE_ZONE` | `SINGLE_ZONE` | `MULTI_ZONE` |
| `azure_topic_base_prefix` | Topic prefix | `azure.myorg` | `azure.myorg` | `azure.myorg` |

### **Flink Configuration**

| Variable | Description | Sandbox | Non-Prod | Production |
|----------|-------------|---------|----------|------------|
| `enable_flink` | Enable Flink compute pools | `true` | `true` | `true` |
| `flink_max_cfu` | Maximum Confluent Flink Units | `5` | `5` | `10` |
| `create_aws_dummy_topic` | Create test topics | `true` | `true` | `false` |
| `default_topic_partition` | Topic partitions | `3` | `3` | `6` |

## 🏗️ **Project Structure**

```
confluent-resource-manager-multicloud/
├── main.tf                           # Main Terraform configuration
├── variables.tf                      # Variable definitions
├── outputs.tf                        # Output definitions
├── terraform.tfvars                  # Sandbox environment config (deployed)
├── non-prod.tfvars                   # Non-production environment config
├── prod.tfvars                       # Production environment config
├── terraform.tfvars.example          # Example configuration template
├── .gitignore                        # Git ignore rules
├── README.md                         # This documentation
├── AWS/                              # AWS module
│   ├── aws_cluster.tf                # AWS Kafka cluster resources
│   ├── aws_flink.tf                  # AWS Flink compute pool
│   ├── variables.tf                  # AWS module variables
│   ├── outputs.tf                    # AWS module outputs
│   ├── sample_project_integration.tf # Sample project integration
│   └── sample_project/               # AWS sample project
│       ├── main.tf                   # Sample project main
│       ├── topics.tf                 # Kafka topics
│       ├── schemas.tf                # Schema definitions
│       ├── http_source_connector.tf  # HTTP source connector
│       ├── flink_*.tf                # Flink SQL resources
│       └── schemas/                  # Avro schema files
└── AZURE/                            # Azure module
    ├── azure_cluster.tf              # Azure Kafka cluster resources
    ├── azure_flink.tf                # Azure Flink compute pool
    ├── variables.tf                  # Azure module variables
    ├── outputs.tf                    # Azure module outputs
    ├── azure_sample_project_integration.tf # Sample project integration
    └── sample_project/               # Azure sample project
        ├── main.tf                   # Sample project main
        ├── topics.tf                 # Kafka topics
        ├── http_source_connector.tf  # HTTP source connector
        ├── flink_*.tf                # Flink SQL resources
        └── schemas/                  # Avro schema files
```

## 📦 **Resources Created**

### **Per Cloud Provider (AWS + Azure):**
- 1 Kafka Cluster (Basic tier)
- 1 Flink Compute Pool (5-10 CFU based on environment)
- 2 Service Accounts (app-manager, admin-manager)
- 2-4 API Keys (Kafka and Flink access)
- 5-8 Role Bindings (RBAC permissions)
- 3-9 Topics (based on sub-environments)
- 1 HTTP Source Connector
- Multiple ACLs for secure access

### **Total Resources by Environment:**
- **Sandbox**: 35 resources (currently deployed)
- **Non-Prod**: ~50-60 resources (3 sub-environments)
- **Production**: ~25-30 resources (optimized, no test topics)

## 📤 **Outputs Available**

After deployment, you can access these outputs:

```bash
terraform output  # View all outputs

# Key outputs include:
terraform output aws_cluster_bootstrap_endpoint
terraform output azure_cluster_bootstrap_endpoint
terraform output environment_id
```

### **Current Deployment Outputs:**
```
aws_cluster_bootstrap_endpoint = "SASL_SSL://pkc-p11xm.us-east-1.aws.confluent.cloud:9092"
aws_cluster_id = "lkc-8rgn0m"
aws_flink_compute_pool_id = "lfcp-rmjy87"
azure_cluster_bootstrap_endpoint = "SASL_SSL://pkc-56d1g.eastus.azure.confluent.cloud:9092"
azure_cluster_id = "lkc-0z30g9"
azure_flink_compute_pool_id = "lfcp-2g1mz2"
environment_id = "env-67yrg6"
environment_name = "sandbox-env"
```

## 🔄 **Environment Management**

### **Switch Between Environments**

```bash
# Deploy to different environments
terraform workspace list                    # View workspaces (optional)

# Sandbox (current deployment)
terraform plan -var-file="terraform.tfvars"
terraform apply -var-file="terraform.tfvars"

# Non-Production
terraform plan -var-file="non-prod.tfvars"
terraform apply -var-file="non-prod.tfvars"

# Production
terraform plan -var-file="prod.tfvars"  
terraform apply -var-file="prod.tfvars"
```

### **Environment Isolation**

For complete environment isolation, consider using:

```bash
# Use Terraform workspaces
terraform workspace new sandbox
terraform workspace new non-prod
terraform workspace new production

# Or use separate state backends
terraform init -backend-config="key=sandbox/terraform.tfstate"
terraform init -backend-config="key=non-prod/terraform.tfstate"
terraform init -backend-config="key=prod/terraform.tfstate"
```

## 🧹 **Cleanup**

### **Destroy Current Environment**
```bash
# Destroy sandbox (current)
terraform destroy

# Destroy specific environment
terraform destroy -var-file="non-prod.tfvars"
terraform destroy -var-file="prod.tfvars"
```

### **Partial Cleanup**
```bash
# Remove only sample project resources
terraform destroy -target=module.aws_cluster.module.sample_project
terraform destroy -target=module.azure_cluster.module.azure_sample_project
```

## 🔒 **Security Best Practices**

### **Credential Management**
- ✅ Never commit `*.tfvars` files with real credentials to version control
- ✅ API secrets are marked as sensitive in Terraform state
- ✅ Use environment variables for CI/CD deployments
- ✅ Rotate API keys regularly
- ✅ Use separate API keys per environment

### **Infrastructure Security**
- ✅ RBAC properly configured with least-privilege access
- ✅ Service accounts isolated per cluster
- ✅ ACLs configured for topic-level access control
- ✅ Multi-zone deployment available for production
- ⚠️ Basic tier clusters have limited security features

### **Production Recommendations**
- Use Dedicated or Enterprise clusters for production
- Enable private networking (VPC peering/private endpoints)
- Implement monitoring and alerting
- Regular backup and disaster recovery testing

## 🔧 **Troubleshooting**

### **Common Issues**

| Issue | Solution |
|-------|----------|
| **API Key Permission Errors** | Ensure your Confluent Cloud API keys have sufficient permissions (Environment Admin recommended) |
| **Region Availability** | Verify Flink is available in your chosen regions (check Confluent Cloud console) |
| **Billing Requirements** | Some features require active billing account (Flink, connectors) |
| **Resource Limits** | Check your account limits for clusters, CFU, and connectors |
| **Long Deployment Times** | Connector creation can take 5-10 minutes, this is normal |

### **Validation Commands**

```bash
# Validate configuration
terraform validate

# Check formatting
terraform fmt -check

# Plan without applying
terraform plan -var-file="non-prod.tfvars"

# View current state
terraform show

# List all resources
terraform state list
```

### **Support Resources**

- 📚 [Confluent Cloud Documentation](https://docs.confluent.io)
- 🔧 [Terraform Confluent Provider](https://registry.terraform.io/providers/confluentinc/confluent)
- 💬 [Confluent Community Forum](https://forum.confluent.io)
- 🎓 [Confluent Developer Portal](https://developer.confluent.io)

## 📈 **Next Steps**

1. **Connect Applications**: Use the bootstrap endpoints to connect your applications
2. **Explore Flink**: Try stream processing with the deployed Flink pools
3. **Add Custom Topics**: Create your own topics and schemas
4. **Set Up Monitoring**: Implement monitoring and alerting
5. **Scale Up**: Consider upgrading to Dedicated clusters for production workloads

---

**🎉 Project Status: ✅ Successfully Deployed and Operational**

*Last Updated: August 4, 2025*
