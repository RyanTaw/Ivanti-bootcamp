param(
    [Parameter(Mandatory = $true, Position = 0)]
    [ValidateSet("DEV", "QA", "UAT", "PROD")]
    [string]$Environment,

    [switch]$Apply
)

$ErrorActionPreference = "Stop"

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

    $planFile = "tfplan"
    $planJson = "tfplan.json"
    $planText = "terraform-plan.txt"

    Remove-Item $planFile, $planJson, $planText -Force -ErrorAction SilentlyContinue

    Write-Host ""
    Write-Host "Environment : $Environment"
    Write-Host "Folder      : $TerraformFolder"
    Write-Host "Variables   : $tfvars"
    Write-Host "Apply       : $Apply"
    Write-Host ""

    terraform fmt -recursive
    if ($LASTEXITCODE -ne 0) { throw "Terraform fmt failed." }

    terraform init
    if ($LASTEXITCODE -ne 0) { throw "Terraform init failed." }

    terraform validate
    if ($LASTEXITCODE -ne 0) { throw "Terraform validate failed." }

    Write-Host ""
    Write-Host "Running terraform plan..."

    terraform plan "-var-file=$tfvars" "-out=$planFile"

    if ($LASTEXITCODE -ne 0) {
        throw "Terraform plan failed."
    }

    if (!(Test-Path $planFile)) {
        throw "Terraform plan file was not created: $TerraformFolder\$planFile"
    }

    Write-Host ""
    Write-Host "Generating Terraform plan outputs..."

    terraform show -json $planFile | Out-File -FilePath $planJson -Encoding UTF8
    if ($LASTEXITCODE -ne 0) { throw "Terraform JSON plan generation failed." }

    terraform show -no-color $planFile | Out-File -FilePath $planText -Encoding UTF8
    if ($LASTEXITCODE -ne 0) { throw "Terraform text plan generation failed." }

    Write-Host ""
    Write-Host "Plan files created:"
    Write-Host "Binary : $TerraformFolder\$planFile"
    Write-Host "JSON   : $TerraformFolder\$planJson"
    Write-Host "Text   : $TerraformFolder\$planText"

    if ($Apply) {
        Write-Host ""
        Write-Host "Applying Terraform..." -ForegroundColor Green

        terraform apply -auto-approve $planFile

        if ($LASTEXITCODE -ne 0) {
            throw "Terraform apply failed."
        }

        Write-Host ""
        Write-Host "Deployment completed successfully." -ForegroundColor Green
    }
    else {
        Write-Host ""
        Write-Host "Plan completed successfully." -ForegroundColor Yellow
        Write-Host "To deploy, run:"
        Write-Host ".\prepare_template1.ps1 $Environment -Apply"
    }
}
finally {
    Pop-Location
}