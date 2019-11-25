#!/bin/bash
wget https://releases.hashicorp.com/terraform/0.12.16/terraform_0.12.16_linux_amd64.zip
unzip terraform_0.12.16_linux_amd64.zip
sudo mkdir $HOME/bin && cp ./terraform $HOME/bin/terraform && export PATH=$HOME/bin:$PATH
terraform -version
ARTIFACT=`packer build -machine-readable example.json |awk -F, '$0 ~/artifact,0,id/ {print $6}'`
AMI_ID=`echo $ARTIFACT | cut -d ':' -f2`
echo 'variable "AMI_ID" { default = "'${AMI_ID}'" }' > amivar.tf
ssh-keygen -P "" -f keypair
terraform init
terraform plan
terraform apply

