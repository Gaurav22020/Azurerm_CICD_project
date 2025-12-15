module "resource_group" {
  source              = "../../modules/resourcegroup"
  resource_group_name = var.rg_name
  location            = var.location


}
module "virtual_network" {
  source              = "../../modules/network"
  vn_name             = var.vnet_name
  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.location
  subnet_name         = var.subnet_name
  depends_on          = [module.resource_group]
}

module "acr" {
  source              = "../../modules/acr"
  acr_name            = var.acr_name
  location            = module.resource_group.location
  resource_group_name = module.resource_group.resource_group_name
  depends_on          = [module.resource_group]

}
module "aks" {
  source              = "../../modules/aks"
  cluster_name        = "dev-aks"
  location            = module.resource_group.location
  resource_group_name = module.resource_group.resource_group_name
  subnet_id           = module.virtual_network.subnet_id
}

resource "azurerm_role_assignment" "aks_acr_pull" {
  scope                = module.acr.acr_id
  role_definition_name = "AcrPull"
  principal_id         = module.aks.kubelet_identity_object_id
}
