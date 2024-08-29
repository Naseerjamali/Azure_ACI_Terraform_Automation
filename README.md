# Azure_ACI_Terraform_Automation
This repository aims to automate the deployment of Azure Container Instances with ACR using Terraform.
All in all, you do not have to run Terraform commands as well, the provided bash script (terra-auto.sh) will do it for you.

Clone this repo and then run the bash script it will:
1. Create Azure Container Registry
2. Create Azure Container Instances with a sample image
3. Run terraform commands and deploys the services
4. Outputs the ACI weblink, ACR name.
5. Logs into the ACR
6. Pushes the docker image
7. ACR will automatically detects the new image and creates a new container.

The script will ask you for the image name present in your local and then registry name.
