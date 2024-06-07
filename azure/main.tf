terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.105.0"
    }
  }
  required_version = ">= 1.1.0"
}

variable "subscription_id" {
  description = "The subscription ID to use"
}

variable "client_id" {
  description = "The client ID to use"
}

variable "client_secret" {
  description = "The client secret to use"
}

variable "tenant_id" {
  description = "The tenant ID to use"
}

provider "azurerm" {
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id

  features {}
}