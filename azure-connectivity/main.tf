module "test_infra" {
  source                    = "./deployments/network"
  vm_ssh_keys               = ["xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"] 
  }

  resource "azapi_resource_action" "encryption_at_host" {
  type = "Microsoft.Resources/subscriptions@2021-07-01"

  resource_id = "/subscriptions/${module.ids.subscriptions["shared-test"]}"
  action      = "/providers/Microsoft.Features/providers/Microsoft.Compute/features/EncryptionAtHost/register"
  method      = "POST"
}
