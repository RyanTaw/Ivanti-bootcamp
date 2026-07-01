This repo is for an Ivanti assignment

The dotnet-application was pulled from a pre-existing public gitub repo

The ./terraform folder has all of the terraform files in it and is ready for a terraform apply.

To run terraform apply, in terminal:

Navigate to ~/Ivanti-bootcamp/terraform

Run **terraform init**

Run **./prepare_template1.ps1 DEV** to run the powershell script which runs terraform plan.
Insert the azure client id

Run **./prepare_template1.ps1 DEV -Apply**



Still working on the azure-devops.yml
azure-devops workflow:

1. Install terraform
2. Az Login
3. Run terraform plan
4. Publish terraform plan - wait for all resources to complete creation
5. Build dotnet app docker image
6. Deploy image to AKS