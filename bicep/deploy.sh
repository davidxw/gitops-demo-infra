# *nix only
export RG="gitops-demo"
export LOCATION="australiaeast"

# Create resource group
az group create -n $RG -l $LOCATION

# Deploy all infrastructure and reddog apps
az deployment group create -n gitops-demo -g $RG -f ./main.bicep

# Show outputs for bicep deployment
az deployment group show -n gitops-demo -g $RG -o json --query properties.outputs.urls.value