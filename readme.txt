#Prerquisites, 
1. Need to configure the AWS Access key and secret key in the aws cli. Need preferably AWS CLI2. 

2. Need to terraform minimum 12 version. minimum version ==> 0.12.19

3. Create the S3 Bucket to store the state file remotely. modify the name of the s3 bucket in the backend.tf file. 


#execute below terraform commands

Checkout the complete git repository and execute below commands. 

        terraform init   --> initiate the provider binaries.  
        terraform plan   --> snapshot of complete infra that will be created.  
        terraform apply -no-color -auto-approve. --> this is for creating the infrastrucutre. 
        terraform destroy --> to destroy the infrastructure that is created. 
        

