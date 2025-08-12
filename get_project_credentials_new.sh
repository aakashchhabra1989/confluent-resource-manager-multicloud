#!/bin/bash

# Script to retrieve project-specific credentials for development teams
# Usage: ./get_project_credentials.sh [aws|azure] [project_name]

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Function to print colored output
print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Function to show usage
show_usage() {
    echo "Usage: $0 [CLOUD] [PROJECT]"
    echo ""
    echo "Parameters:"
    echo "  CLOUD:   aws | azure | all"
    echo "  PROJECT: Project name (default: sample_project)"
    echo ""
    echo "Examples:"
    echo "  $0 aws                      # Get AWS project credentials"
    echo "  $0 azure                    # Get Azure project credentials"
    echo "  $0 all                      # Get all project credentials"
    echo ""
    echo "Note: Each project now uses a single service account with both producer and consumer permissions."
}

# Function to check if terraform is available
check_terraform() {
    if ! command -v terraform &> /dev/null; then
        print_error "Terraform is not installed or not in PATH"
        exit 1
    fi
    
    # Check if terraform state exists
    if [[ ! -f "terraform.tfstate" && ! -f ".terraform/terraform.tfstate" ]]; then
        print_error "No Terraform state found. Make sure you've deployed the infrastructure first."
        exit 1
    fi
}

# Function to get terraform output
get_terraform_output() {
    local output_name="$1"
    terraform output -json "$output_name" 2>/dev/null || echo "null"
}

# Function to get project credentials
get_project_credentials() {
    local cloud="$1"
    local project="$2"
    
    print_info "Retrieving $cloud $project application credentials..."
    
    # Get API key secret (sensitive output)
    local api_key_secret
    api_key_secret=$(get_terraform_output "${cloud}_${project}_secret" | jq -r '.')
    
    # Get access information
    local access_info
    access_info=$(get_terraform_output "${cloud}_${project}_access")
    
    if [[ "$access_info" == "null" || -z "$access_info" ]]; then
        print_error "Failed to retrieve credentials for $cloud $project"
        return 1
    fi
    
    local api_key_id
    local service_account_id
    local bootstrap_endpoint
    local cluster_id
    local topic_pattern
    local consumer_group_pattern
    
    api_key_id=$(echo "$access_info" | jq -r '.application.api_key_id')
    service_account_id=$(echo "$access_info" | jq -r '.application.service_account_id')
    bootstrap_endpoint=$(echo "$access_info" | jq -r '.cluster_info.bootstrap_endpoint')
    cluster_id=$(echo "$access_info" | jq -r '.cluster_info.cluster_id')
    topic_pattern=$(echo "$access_info" | jq -r '.access_patterns.topic_pattern')
    consumer_group_pattern=$(echo "$access_info" | jq -r '.access_patterns.consumer_group_pattern')
    
    print_success "Credentials for $(echo $cloud | tr '[:lower:]' '[:upper:]') $(echo $project | tr '[:lower:]' '[:upper:]') (Producer + Consumer):"
    echo ""
    echo -e "${CYAN}🔐 Authentication:${NC}"
    echo "   API Key ID: $api_key_id"
    echo "   API Secret: $api_key_secret"
    echo "   Service Account: $service_account_id"
    echo ""
    echo -e "${CYAN}🌐 Cluster Information:${NC}"
    echo "   Bootstrap Endpoint: $bootstrap_endpoint"
    echo "   Cluster ID: $cluster_id"
    echo ""
    echo -e "${CYAN}📋 Access Patterns:${NC}"
    echo "   Topic Pattern: $topic_pattern"
    echo "   Consumer Group Pattern: $consumer_group_pattern"
    echo ""
    echo -e "${CYAN}📝 Application Properties:${NC}"
    echo "   bootstrap.servers=$bootstrap_endpoint"
    echo "   security.protocol=SASL_SSL"
    echo "   sasl.mechanism=PLAIN"
    echo "   sasl.jaas.config=org.apache.kafka.common.security.plain.PlainLoginModule required username=\"$api_key_id\" password=\"$api_key_secret\";"
    echo ""
    
    local example_topic
    local example_group_id
    example_topic=$(echo "$topic_pattern" | sed 's/\*/dev/' | sed 's/\*/user-events/')
    example_group_id=$(echo "$consumer_group_pattern" | sed 's/\*/your-app-name/')
    
    echo -e "${CYAN}📊 Example Topic Names:${NC}"
    echo "   $example_topic"
    echo ""
    echo -e "${CYAN}👥 Example Consumer Group:${NC}"
    echo "   $example_group_id"
    echo ""
}

# Function to show summary
show_summary() {
    print_info "Project Access Summary:"
    echo ""
    
    local aws_access
    local azure_access
    
    aws_access=$(get_terraform_output "aws_sample_project_access")
    azure_access=$(get_terraform_output "azure_sample_project_access")
    
    if [[ "$aws_access" != "null" && -n "$aws_access" ]]; then
        echo -e "${CYAN}🌊 AWS Sample Project:${NC}"
        echo "   Service Account: $(echo "$aws_access" | jq -r '.application.service_account_id')"
        echo "   API Key: $(echo "$aws_access" | jq -r '.application.api_key_id')"
        echo "   Bootstrap: $(echo "$aws_access" | jq -r '.cluster_info.bootstrap_endpoint')"
        echo "   Topic Pattern: $(echo "$aws_access" | jq -r '.access_patterns.topic_pattern')"
        echo ""
    fi
    
    if [[ "$azure_access" != "null" && -n "$azure_access" ]]; then
        echo -e "${CYAN}☁️  Azure Sample Project:${NC}"
        echo "   Service Account: $(echo "$azure_access" | jq -r '.application.service_account_id')"
        echo "   API Key: $(echo "$azure_access" | jq -r '.application.api_key_id')"
        echo "   Bootstrap: $(echo "$azure_access" | jq -r '.cluster_info.bootstrap_endpoint')"
        echo "   Topic Pattern: $(echo "$azure_access" | jq -r '.access_patterns.topic_pattern')"
        echo ""
    fi
    
    print_info "Use cloud parameter to get detailed credentials for specific projects."
}

# Main script logic
CLOUD="$1"
PROJECT="${2:-sample_project}"

# Check if help is requested
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    show_usage
    exit 0
fi

# Interactive prompting if no parameters provided
if [[ -z "$CLOUD" ]]; then
    echo -e "${YELLOW}Available options:${NC}"
    echo "  aws   - Get AWS project credentials"
    echo "  azure - Get Azure project credentials"
    echo "  all   - Show summary of all projects"
    echo ""
    read -p "Select cloud (aws/azure/all): " CLOUD
fi

if [[ -z "$CLOUD" ]]; then
    print_warning "No cloud selected. Showing summary..."
    CLOUD="all"
fi

# Check prerequisites
check_terraform

# Check if jq is available for JSON parsing
if ! command -v jq &> /dev/null; then
    print_error "jq is not installed. Please install jq to parse JSON output."
    exit 1
fi

# Execute based on selection
case "${CLOUD,,}" in
    "aws")
        get_project_credentials "aws" "$PROJECT"
        ;;
    "azure")
        get_project_credentials "azure" "$PROJECT"
        ;;
    "all")
        show_summary
        ;;
    *)
        print_error "Invalid cloud selection: $CLOUD"
        show_usage
        exit 1
        ;;
esac

print_info "Done! 🎉"
