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

Setup loki to view cluster through a UI

azureServiceConnection: 'YOUR-AZURE-SERVICE-CONNECTION-NAME'
acrName: 'avantibootcampdevacr'
containerRegistry: 'avantibootcampdevacr.azurecr.io'
resourceGroupName: 'avanti-bootcamp-dev-rg'
aksClusterName: 'avanti-bootcamp-dev-aks'
imagePullSecret: 'avanti-acr-auth'

Terraform state
az group create --name avanti-tfstate-rg --location eastus

az storage account create --resource-group avanti-tfstate-rg --name avantitfstate001 --sku Standard_LRS --kind StorageV2

az storage container create --account-name avantitfstate001 --name tfstate --auth-mode login


Aks Cmds
az login --use-device-code
az aks get-credentials --resource-group avanti-bootcamp-rg --name avanti-bootcamp-aks --overwrite-existing
kubectl logs deployment/containerapp-webapp-deploy -n bootcamp 
kubectl get services --all-namespaces
kubectl get pods --all-namespaces 

SQLdb cmds
az sql server create --name avanti-bootcamp-sql --resource-group avanti-bootcamp-rg --location centralus --admin-user sqladminuser --admin-password "Ryanpassword123!"

az sql db create --resource-group avanti-bootcamp-rg --server avanti-bootcamp-sql --name bootcampdb --service-objective Basic

az sql server firewall-rule create --resource-group avanti-bootcamp-rg --server avanti-bootcamp-sql --name AllowAzureServices --start-ip-address 0.0.0.0 --end-ip-address 0.0.0.0

kubectl create secret generic sql-connection-secret --namespace bootcamp --from-literal=SQL_CONNECTION_STRING="Server=tcp:avanti-bootcamp-sql.database.windows.net,1433;Initial Catalog=bootcampdb;Persist Security Info=False;User ID=sqladminuser;Password=Ryanpassword123!;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;" --dry-run=client -o yaml | kubectl apply -f -


docker build -f dotnet-container-app/src/ContainerApp.WebApp/Dockerfile -t avantibootcampacr.azurecr.io/containerapp-web:fix-newtonsoft dotnet-container-app/src

docker push avantibootcampacr.azurecr.io/containerapp-web:fix-newtonsoft

kubectl set image deployment/containerapp-webapp-deploy containerapp-webapp=avantibootcampacr.azurecr.io/containerapp-web:fix-newtonsoft -n bootcamp

kubectl rollout restart deployment/containerapp-webapp-deploy -n bootcamp
kubectl rollout status deployment/containerapp-webapp-deploy -n bootcamp

Endpoint
http://20.242.237.226