terraform {
  backend "azurerm" {
    resource_group_name  = "prod-iac-management-rg"
    storage_account_name = "pro001diacsafebucket"
    container_name       = "terraformstatefile"
    key                  = "prod-aks.tfstate"
    use_azuread_auth     = true

  }
}