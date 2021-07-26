resource "azurerm_resource_group" "rg_vnet" {
  name     = format("%s-vnet-rg", local.project)
  location = var.location

  tags = var.tags
}

# TODO use module azurerm
# source = "git::https://github.com/pagopa/azurerm.git//virtual_network?ref=v1.0.7"
resource "azurerm_virtual_network" "vnet" {
  name                = format("%s-vnet", local.project)
  location            = azurerm_resource_group.rg_vnet.location
  resource_group_name = azurerm_resource_group.rg_vnet.name
  address_space       = var.cidr_vnet

  tags = var.tags

}

# TODO use module azurerm
# source = "git::https://github.com/pagopa/azurerm.git//subnet?ref=v1.0.3"
module "subnet_db" {
  source                                         = "./modules/subnet"
  name                                           = format("%s-db-subnet", local.project)
  address_prefixes                               = var.cidr_subnet_db
  resource_group_name                            = azurerm_resource_group.rg_vnet.name
  virtual_network_name                           = azurerm_virtual_network.vnet.name
  service_endpoints                              = ["Microsoft.Sql"]
  enforce_private_link_endpoint_network_policies = true
}

# TODO use module azurerm
# source = "git::https://github.com/pagopa/azurerm.git//subnet?ref=v1.0.3"
module "subnet_wp" {
  source               = "./modules/subnet"
  name                 = format("%s-api-subnet", local.project)
  address_prefixes     = var.cidr_subnet
  resource_group_name  = azurerm_resource_group.rg_vnet.name
  virtual_network_name = azurerm_virtual_network.vnet.name

  delegation = {
    name = "default"

    service_delegation = {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }

  service_endpoints = [
    "Microsoft.Web",
    "Microsoft.Storage"
  ]

}

module "azdoa_snet" {
  source                                         = "git::https://github.com/pagopa/azurerm.git//subnet?ref=v1.0.3"
  count                                          = var.enable_azdoa ? 1 : 0
  name                                           = format("%s-azdoa-snet", local.project)
  address_prefixes                               = var.cidr_subnet_azdoa
  resource_group_name                            = azurerm_resource_group.rg_vnet.name
  virtual_network_name                           = azurerm_virtual_network.vnet.name
  enforce_private_link_endpoint_network_policies = true
}

# resource "azurerm_private_dns_zone" "cms_private_dns_zone" {
#   name                = var.cms_private_domain
#   resource_group_name = azurerm_resource_group.rg_vnet.name
# }

# resource "azurerm_private_dns_zone_virtual_network_link" "cms_private_dns_zone_virtual_network_link" {
#   name                  = format("%s-cms-private-dns-zone-link", local.project)
#   resource_group_name   = azurerm_resource_group.rg_vnet.name
#   private_dns_zone_name = azurerm_private_dns_zone.cms_private_dns_zone.name
#   virtual_network_id    = azurerm_virtual_network.vnet.id
# }

# resource "azurerm_private_dns_cname_record" "private_dns_cname_record_cms" {
#   name                = module.portal_backend.name
#   zone_name           = azurerm_private_dns_zone.cms_private_dns_zone.name
#   resource_group_name = azurerm_resource_group.rg_vnet.name
#   ttl                 = 300
#   records             = module.portal_backend.private_ip_addresses[0]
# }
