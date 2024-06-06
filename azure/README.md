# Create Kubernetes clusters in Azure with Terraform

## Login to Azure

az login

## Set up needed credentials

run

```bash
    source setup_azure_subscription.sh your_desired_subscription_name
```

## Create the clusters

```bash
    cd azure
    terraform init
    terraform plan
    terraform apply
    terraform destroy  # to cleanup resources an not pay for them
```


