env_short       = "u"
env_long        = "uat"
prefix          = "scorp"
ad_group_prefix = "sitecorporate"
tags = {
  CreatedBy   = "Terraform"
  Environment = "Uat"
  Owner       = "site-corporate"
  Source      = "https://github.com/pagopa/corporate-site-infrastructure"
  CostCenter  = "TS300 - PRODOTTI E SERVIZI"
}
public_hostname                     = "https://scorp-u-portal-backend.azurewebsites.net"
dns_zone_prefix                     = "uat.sitecorporate"
external_domain                     = "pagopa.it"
db_sku_name                         = "GP_Gen5_4"
db_version                          = "5.7"
db_storage_mb                       = "5120"
db_collation                        = "utf8_unicode_ci"
db_ssl_enforcement_enabled          = true
database_name                       = "ppawp"
enable_azdoa                        = true
cidr_vnet                           = ["10.0.0.0/16"]
cidr_subnet_db                      = ["10.0.1.0/24"]
cidr_subnet                         = ["10.0.2.0/24"]
cidr_subnet_public                  = ["10.0.3.0/24"]
cidr_subnet_wp                      = ["10.0.4.0/24"]
cidr_subnet_azdoa                   = ["10.0.5.0/24"]
cidr_subnet_vpn                     = ["10.0.6.0/24"]
cidr_subnet_dnsforwarder            = ["10.0.7.0/29"]
devops_service_connection_object_id = "563d202b-d1ff-414b-b123-170cdcb409fe"
