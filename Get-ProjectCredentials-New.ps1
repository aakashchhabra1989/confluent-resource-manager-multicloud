# PowerShell script to retrieve project-specific credentials for development teams
# Usage: .\Get-ProjectCredentials.ps1 -Cloud [aws|azure] -Project [project_name]

param(
    [Parameter(Mandatory=$false)]
    [ValidateSet("aws", "azure", "all")]
    [string]$Cloud,
    
    [Parameter(Mandatory=$false)]
    [string]$Project = "sample_project",
    
    [Parameter(Mandatory=$false)]
    [switch]$Help
)

# Colors for output
$Colors = @{
    Red = "Red"
    Green = "Green" 
    Yellow = "Yellow"
    Blue = "Blue"
    Cyan = "Cyan"
}

function Write-Info {
    param([string]$Message)
    Write-Host "ℹ️  $Message" -ForegroundColor $Colors.Blue
}

function Write-Success {
    param([string]$Message)
    Write-Host "✅ $Message" -ForegroundColor $Colors.Green
}

function Write-Warning {
    param([string]$Message)
    Write-Host "⚠️  $Message" -ForegroundColor $Colors.Yellow
}

function Write-Error {
    param([string]$Message)
    Write-Host "❌ $Message" -ForegroundColor $Colors.Red
}

function Show-Usage {
    Write-Host "Usage: .\Get-ProjectCredentials.ps1 -Cloud [CLOUD] -Project [PROJECT]"
    Write-Host ""
    Write-Host "Parameters:"
    Write-Host "  -Cloud:   aws | azure | all"
    Write-Host "  -Project: Project name (default: sample_project)"
    Write-Host ""
    Write-Host "Examples:"
    Write-Host "  .\Get-ProjectCredentials.ps1 -Cloud aws                      # Get AWS project credentials"
    Write-Host "  .\Get-ProjectCredentials.ps1 -Cloud azure                    # Get Azure project credentials"
    Write-Host "  .\Get-ProjectCredentials.ps1 -Cloud all                      # Get all project credentials"
    Write-Host ""
    Write-Host "Note: Each project now uses a single service account with both producer and consumer permissions."
}

function Test-Prerequisites {
    # Check if terraform is available
    try {
        $null = Get-Command terraform -ErrorAction Stop
    }
    catch {
        Write-Error "Terraform is not installed or not in PATH"
        exit 1
    }
    
    # Check if terraform state exists
    if (-not (Test-Path "terraform.tfstate") -and -not (Test-Path ".terraform\terraform.tfstate")) {
        Write-Error "No Terraform state found. Make sure you've deployed the infrastructure first."
        exit 1
    }
}

function Get-TerraformOutput {
    param([string]$OutputName)
    
    try {
        $result = terraform output -json $OutputName 2>$null | ConvertFrom-Json
        return $result
    }
    catch {
        return $null
    }
}

function Get-ProjectCredentials {
    param(
        [string]$Cloud,
        [string]$Project
    )
    
    Write-Info "Retrieving $Cloud $Project application credentials..."
    
    # Get API key secret (sensitive output)
    $apiKeySecret = Get-TerraformOutput "${Cloud}_${Project}_secret"
    
    # Get access information
    $accessInfo = Get-TerraformOutput "${Cloud}_${Project}_access"
    
    if (-not $accessInfo -or $accessInfo -eq "null") {
        Write-Error "Failed to retrieve credentials for $Cloud $Project"
        return
    }
    
    $apiKeyId = $accessInfo.application.api_key_id
    $serviceAccountId = $accessInfo.application.service_account_id
    $bootstrapEndpoint = $accessInfo.cluster_info.bootstrap_endpoint
    $clusterId = $accessInfo.cluster_info.cluster_id
    $topicPattern = $accessInfo.access_patterns.topic_pattern
    $consumerGroupPattern = $accessInfo.access_patterns.consumer_group_pattern
    
    Write-Success "Credentials for $($Cloud.ToUpper()) $($Project.ToUpper()) (Producer + Consumer):"
    Write-Host ""
    Write-Host "🔐 Authentication:" -ForegroundColor $Colors.Cyan
    Write-Host "   API Key ID: $apiKeyId"
    Write-Host "   API Secret: $apiKeySecret"
    Write-Host "   Service Account: $serviceAccountId"
    Write-Host ""
    Write-Host "🌐 Cluster Information:" -ForegroundColor $Colors.Cyan
    Write-Host "   Bootstrap Endpoint: $bootstrapEndpoint"
    Write-Host "   Cluster ID: $clusterId"
    Write-Host ""
    Write-Host "📋 Access Patterns:" -ForegroundColor $Colors.Cyan
    Write-Host "   Topic Pattern: $topicPattern"
    Write-Host "   Consumer Group Pattern: $consumerGroupPattern"
    Write-Host ""
    Write-Host "📝 Application Properties:" -ForegroundColor $Colors.Cyan
    Write-Host "   bootstrap.servers=$bootstrapEndpoint"
    Write-Host "   security.protocol=SASL_SSL"
    Write-Host "   sasl.mechanism=PLAIN"
    Write-Host "   sasl.jaas.config=org.apache.kafka.common.security.plain.PlainLoginModule required username=`"$apiKeyId`" password=`"$apiKeySecret`";"
    Write-Host ""
    
    $exampleGroupId = $consumerGroupPattern -replace '\*', 'your-app-name'
    Write-Host "📊 Example Topic Names:" -ForegroundColor $Colors.Cyan
    $exampleTopic = $topicPattern -replace '\*', 'dev'
    $exampleTopic = $exampleTopic -replace '\*', 'user-events'
    Write-Host "   $exampleTopic"
    Write-Host ""
    Write-Host "👥 Example Consumer Group:" -ForegroundColor $Colors.Cyan
    Write-Host "   $exampleGroupId"
    Write-Host ""
}

function Show-Summary {
    Write-Info "Project Access Summary:"
    Write-Host ""
    
    $awsAccess = Get-TerraformOutput "aws_sample_project_access"
    $azureAccess = Get-TerraformOutput "azure_sample_project_access"
    
    if ($awsAccess -and $awsAccess -ne "null") {
        Write-Host "🌊 AWS Sample Project:" -ForegroundColor $Colors.Cyan
        Write-Host "   Service Account: $($awsAccess.application.service_account_id)"
        Write-Host "   API Key: $($awsAccess.application.api_key_id)"
        Write-Host "   Bootstrap: $($awsAccess.cluster_info.bootstrap_endpoint)"
        Write-Host "   Topic Pattern: $($awsAccess.access_patterns.topic_pattern)"
        Write-Host ""
    }
    
    if ($azureAccess -and $azureAccess -ne "null") {
        Write-Host "☁️  Azure Sample Project:" -ForegroundColor $Colors.Cyan
        Write-Host "   Service Account: $($azureAccess.application.service_account_id)"
        Write-Host "   API Key: $($azureAccess.application.api_key_id)"
        Write-Host "   Bootstrap: $($azureAccess.cluster_info.bootstrap_endpoint)"
        Write-Host "   Topic Pattern: $($azureAccess.access_patterns.topic_pattern)"
        Write-Host ""
    }
    
    Write-Info "Use -Cloud parameter to get detailed credentials for specific projects."
}

# Main script logic
if ($Help) {
    Show-Usage
    exit 0
}

# Interactive prompting if no parameters provided
if (-not $Cloud) {
    Write-Host "Available options:" -ForegroundColor $Colors.Yellow
    Write-Host "  aws   - Get AWS project credentials"
    Write-Host "  azure - Get Azure project credentials"
    Write-Host "  all   - Show summary of all projects"
    Write-Host ""
    $Cloud = Read-Host "Select cloud (aws/azure/all)"
}

if (-not $Cloud -or $Cloud -eq "") {
    Write-Warning "No cloud selected. Showing summary..."
    $Cloud = "all"
}

# Validate prerequisites
Test-Prerequisites

# Execute based on selection
switch ($Cloud.ToLower()) {
    "aws" {
        Get-ProjectCredentials -Cloud "aws" -Project $Project
    }
    "azure" {
        Get-ProjectCredentials -Cloud "azure" -Project $Project
    }
    "all" {
        Show-Summary
    }
    default {
        Write-Error "Invalid cloud selection: $Cloud"
        Show-Usage
        exit 1
    }
}

Write-Info "Done! 🎉"
