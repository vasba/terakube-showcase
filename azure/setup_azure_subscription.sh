#!/bin/bash

# Name of the subscription
subscription_name=$1

# Get the subscription details
subscription=$(az account list --query "[?name=='$subscription_name']" --output json)

# Export the subscription details as environment variables
export TF_VAR_subscription_id=$(echo $subscription | jq -r '.[0].id')
export TF_VAR_tenant_id=$(echo $subscription | jq -r '.[0].tenantId')

# Get the service principal details
sp=$(az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/$TF_VAR_subscription_id")

# Export the service principal details as environment variables
export TF_VAR_client_id=$(echo $sp | jq -r '.appId')
export TF_VAR_client_secret=$(echo $sp | jq -r '.password')

# List the environment variables
echo "TF_VAR_subscription_id: $TF_VAR_subscription_id"
echo "TF_VAR_tenant_id: $TF_VAR_tenant_id"
echo "TF_VAR_client_id: $TF_VAR_client_id"
echo "TF_VAR_client_secret: $TF_VAR_client_secret"