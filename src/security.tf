resource "azurerm_resource_group" "sec_rg" {
  name     = format("%s-sec-rg", local.project)
  location = var.location

  tags = var.tags
}

# Create Key Vault
module "key_vault" {
  source              = "git::https://github.com/pagopa/azurerm.git//key_vault?ref=v1.0.33"
  name                = format("%s-kv-common", local.project)
  location            = azurerm_resource_group.sec_rg.location
  resource_group_name = azurerm_resource_group.sec_rg.name
  tenant_id           = data.azurerm_client_config.current.tenant_id

  tags = var.tags
}

#
# POLICIES
#

data "azuread_group" "adgroup_admin" {
  display_name = format("%s-adgroup-admin", local.ad_group_prefix)
}

## ad group policy ##
resource "azurerm_key_vault_access_policy" "adgroup_admin_policy" {
  key_vault_id = module.key_vault.id

  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = data.azuread_group.adgroup_admin.object_id

  key_permissions     = ["Get", "List", "Update", "Create", "Import", "Delete", ]
  secret_permissions  = ["Get", "List", "Set", "Delete", ]
  storage_permissions = []
  certificate_permissions = [
    "Get", "List", "Update", "Create", "Import",
    "Delete", "Restore", "Purge", "Recover"
  ]
}

data "azuread_group" "adgroup_contributors" {
  display_name = format("%s-adgroup-contributors", local.ad_group_prefix)
}

# ad group policy ##
resource "azurerm_key_vault_access_policy" "adgroup_contributors_policy" {
  count        = (var.env_short == "d" || var.env_short == "u") ? 1 : 0
  key_vault_id = module.key_vault.id

  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = data.azuread_group.adgroup_contributors.object_id

  key_permissions     = ["Get", "List", "Update", "Create", "Import", "Delete", ]
  secret_permissions  = ["Get", "List", "Set", "Delete", ]
  storage_permissions = []
  certificate_permissions = [
    "Get", "List", "Update", "Create", "Import",
    "Delete", "Restore", "Purge", "Recover"
  ]
}

## azure devops cert az ##
resource "azurerm_key_vault_access_policy" "cert_renew_policy" {
  count        = var.devops_service_connection_object_id == null ? 0 : 1
  key_vault_id = module.key_vault.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = var.devops_service_connection_object_id

  secret_permissions = [
    "Get",
    "List",
    "Set",
  ]

  certificate_permissions = [
    "Get",
    "List",
    "Import",
  ]
}

## azure appservice cms ##
# data "azuread_service_principal" "web_app_resource_provider" {
#   application_id = "abfa0a7c-a6b6-4736-8310-5855508787cd"
# }

resource "azurerm_key_vault_access_policy" "cms_policy" {
  key_vault_id = module.key_vault.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = var.azuread_service_principal_web_app_resource_provider_id

  secret_permissions = [
    "Get",
  ]

  certificate_permissions = [
    "Get",
  ]
}

## azure cdn frontdoor ##
## remember to do this: https://docs.microsoft.com/it-it/azure/frontdoor/standard-premium/how-to-configure-https-custom-domain#register-azure-front-door
# data "azuread_service_principal" "azure_cdn_frontdoor" {
#   application_id = "205478c0-bd83-4e1b-a9d6-db63a3e1e1c8"
# }

resource "azurerm_key_vault_access_policy" "azure_cdn_frontdoor_policy" {
  key_vault_id = module.key_vault.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = var.azuread_service_principal_azure_cdn_frontdoor_id

  secret_permissions = [
    "Get",
  ]

  certificate_permissions = [
    "Get",
  ]
}
