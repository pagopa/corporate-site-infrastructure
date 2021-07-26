env_short       = "p"
env_long        = "production"
prefix          = "scorp"
ad_group_prefix = "sitecorporate"
tags = {
  CreatedBy   = "Terraform"
  Environment = "Prod"
  Owner       = "site-corporate"
  Source      = "https://github.com/pagopa/corporate-site-infrastructure"
  CostCenter  = "TS300 - PRODOTTI E SERVIZI"
}
dns_zone_prefix                     = "sitecorporate"
external_domain                     = "pagopa.it"
db_sku_name                         = "GP_Gen5_4"
db_version                          = "5.7"
db_storage_mb                       = "5120"
db_collation                        = "utf8_unicode_ci"
db_ssl_enforcement_enabled          = true
cms_base_url                        = "https://cms.sitecorporate.pagopa.it"
cms_env                             = "production"
cms_tls_certificate_name            = "cms-sitecorporate-pagopa-it"
database_name                       = "ppawp"
enable_azdoa                        = true
cidr_vnet                           = ["10.0.0.0/16"]
cidr_subnet_db                      = ["10.0.1.0/24"]
cidr_subnet_cms                     = ["10.0.2.0/24"]
cidr_subnet_azdoa                   = ["10.0.5.0/24"]
cidr_subnet_vpn                     = ["10.0.6.0/24"]
cidr_subnet_dnsforwarder            = ["10.0.8.0/29"]
devops_service_connection_object_id = "be53c8fa-9780-419c-8f45-f3166b767951"
backend_sku = {
  tier     = "PremiumV2"
  size     = "P1v2"
  capacity = 1
}
