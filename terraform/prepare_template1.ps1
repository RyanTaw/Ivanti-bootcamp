param(
    [Parameter(Mandatory = $true, Position = 0)]
    [ValidateSet("DEV", "QA", "PROD")]
    [string]$Environment,

    [switch]$Apply,

    [switch]$Destroy
)

$ErrorActionPreference = "Stop"

if ($Apply -and $Destroy) {
    throw "Use either -Apply or -Destroy, not both."
}

$TerraformFolder = Join-Path $PSScriptRoot "modules\template1"

if (!(Test-Path $TerraformFolder)) {
    throw "Terraform folder not found: $TerraformFolder"
}

Push-Location $TerraformFolder

try {
    $tfvars = "$($Environment.ToLower()).tfvars"

    if (!(Test-Path $tfvars)) {
        throw "Variables file not found: $tfvars"
    }

    $backendKey = "bootcamp-$($Environment.ToLower()).tfstate"

    $planFile = "tfplan"
    $planJson = "tfplan.json"
    $planText = "terraform-plan.txt"

    Remove-Item $planFile, $planJson, $planText -Force -ErrorAction SilentlyContinue

    Write-Host "Environment : $Environment"
    Write-Host "Folder      : $TerraformFolder"
    Write-Host "Variables   : $tfvars"
    Write-Host "State Key   : $backendKey"
    Write-Host "Apply       : $Apply"
    Write-Host "Destroy     : $Destroy"

    terraform fmt -recursive
    if ($LASTEXITCODE -ne 0) {
        throw "Terraform fmt failed."
    }

    terraform init `
        -reconfigure `
        "-backend-config=resource_group_name=avanti-tfstate-rg" `
        "-backend-config=storage_account_name=avantitfstate001" `
        "-backend-config=container_name=tfstate" `
        "-backend-config=key=$backendKey"

    if ($LASTEXITCODE -ne 0) {
        throw "Terraform init failed."
    }

    terraform validate
    if ($LASTEXITCODE -ne 0) {
        throw "Terraform validate failed."
    }

    if ($Destroy) {
        Write-Host "Running terraform destroy plan..."

        terraform plan `
            -destroy `
            "-var-file=$tfvars" `
            "-out=$planFile"
    }
    else {
        Write-Host "Running terraform plan..."

        terraform plan `
            "-var-file=$tfvars" `
            "-out=$planFile"
    }

    if ($LASTEXITCODE -ne 0) {
        throw "Terraform plan failed."
    }

    if (!(Test-Path $planFile)) {
        throw "Terraform plan file was not created: $TerraformFolder\$planFile"
    }

    terraform show -json $planFile | Out-File -FilePath $planJson -Encoding UTF8

    if ($LASTEXITCODE -ne 0) {
        throw "Terraform JSON plan generation failed."
    }

    terraform show -no-color $planFile | Out-File -FilePath $planText -Encoding UTF8

    if ($LASTEXITCODE -ne 0) {
        throw "Terraform text plan generation failed."
    }

    Write-Host ""
    Write-Host "Plan files created:"
    Write-Host "Binary : $TerraformFolder\$planFile"
    Write-Host "JSON   : $TerraformFolder\$planJson"
    Write-Host "Text   : $TerraformFolder\$planText"
    Write-Host ""

    if ($Apply) {
        Write-Host "Running terraform apply..."

        terraform apply -auto-approve $planFile

        if ($LASTEXITCODE -ne 0) {
            throw "Terraform apply failed."
        }

        Write-Host ""
        Write-Host "Deployment completed successfully."
    }
    elseif ($Destroy) {
        Write-Host "Running terraform destroy..."

        terraform apply -auto-approve $planFile

        if ($LASTEXITCODE -ne 0) {
            throw "Terraform destroy failed."
        }

        Write-Host ""
        Write-Host "Infrastructure destroyed successfully."
    }
    else {
        Write-Host ""
        Write-Host "Terraform plan completed successfully."
        Write-Host ""
        Write-Host "Apply:"
        Write-Host "  .\prepare_template1.ps1 $Environment -Apply"
        Write-Host ""
        Write-Host "Destroy:"
        Write-Host "  .\prepare_template1.ps1 $Environment -Destroy"
    }
}
finally {
    Pop-Location
}