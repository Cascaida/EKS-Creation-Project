# Private-EKS-Creation

![ss](https://user-images.githubusercontent.com/29406860/144292888-a04cf3e4-b2fa-4ce6-b4f5-b6197b9c3f64.PNG)


This repository is intended to create a private EKS cluster in private subnets in two different availability zones with Terraform. Here are step-by-step guide to have fresh installation.

1- Terraform needs to be installed in your host machine to start the initial process. Follow the steps in below document to install Terraform according to your OS.

https://learn.hashicorp.com/tutorials/terraform/install-cli

2- Pull the repository with either SSH or HTTPS.

3- Go to your AWS account and gather the "Secret Access Key" and "Access Key ID" information. You may receive them according to below document.

https://docs.aws.amazon.com/powershell/latest/userguide/pstools-appendix-sign-up.html

3- Create a file called "secret-variables.auto.tfvars" in the root of the project and fill it with below information. (it's already in .**gitignore** file but never push this file to any git repository)

```
aws_access_key_id     = ""
aws_secret_access_key = ""
```

4- Run below command for Terraform to install necessary modules and files.
```
terraform init
```

5- Run below command to see what's going to be created by Terraform.

```
terraform plan
```

6- If the plan looks alright for you, run the below command for Terraform to launch the resources.

```
terraform apply --auto-approve
```
