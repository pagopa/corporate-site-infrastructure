plugin "azurerm" {
  enabled = true
  version = "0.10.1"
  source  = "github.com/terraform-linters/tflint-ruleset-azurerm"
}
config {
  module = true
}
