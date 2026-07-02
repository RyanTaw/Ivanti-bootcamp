param(
    [Parameter(Mandatory = $true, Position = 0)]
    [ValidateSet("DEV", "QA", "UAT", "PROD")]
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

    $planFile = "tfplan"
    $planJson = "tfplan.json"
    $planText = "terraform-plan.txt"

    Remove-Item $planFile, $planJson, $planText -Force -ErrorAction SilentlyContinue

    Write-Host "Environment : $Environment"
    Write-Host "Folder      : $TerraformFolder"
    Write-Host "Variables   : $tfvars"
    Write-Host "Apply       : $Apply"
    Write-Host "Destroy     : $Destroy"


    terraform fmt -recursive
    if ($LASTEXITCODE -ne 0) { throw "Terraform fmt failed." }
    terraform init
    if ($LASTEXITCODE -ne 0) { throw "Terraform init failed." }
    terraform validate
    if ($LASTEXITCODE -ne 0) { throw "Terraform validate failed." }

    if ($Destroy) {
        Write-Host "Running terraform destroy"

        terraform plan -destroy "-var-file=$tfvars" "-out=$planFile"
    }
    else {
        Write-Host "Running terraform plan..."

        terraform plan "-var-file=$tfvars" "-out=$planFile"
    }

    if ($LASTEXITCODE -ne 0) {
        throw "Terraform plan failed."
    }

    terraform show -json $planFile | Out-File -FilePath $planJson -Encoding UTF8
    terraform show -no-color $planFile | Out-File -FilePath $planText -Encoding UTF8

    Write-Host "Plan files created:"
    Write-Host "Binary : $TerraformFolder\$planFile"
    Write-Host "JSON   : $TerraformFolder\$planJson"
    Write-Host "Text   : $TerraformFolder\$planText"

    if ($Apply -or $Destroy) {
        terraform apply -auto-approve $planFile

        if ($LASTEXITCODE -ne 0) {
            throw "Terraform apply failed."
        }
        if ($Destroy) {
            Write-Host "Destroy complete."
        }
        else {
            Write-Host "Deployment completed successfully."
        }
    }
    else {
        Write-Host "Plan completed successfully."
        Write-Host "Deploy:  .\prepare_template1.ps1 $Environment -Apply"
        Write-Host "Destroy: .\prepare_template1.ps1 $Environment -Destroy"
    }
}
finally {
    Pop-Location
}