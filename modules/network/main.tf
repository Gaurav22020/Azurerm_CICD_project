resource "azurerm_virtual_network" "Vnet" {
  name                = var.vn_name
  resource_group_name = var.resource_group_name
  location            = var.location
  address_space       = ["10.0.0.0/16"]

}
resource "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.vn_name
  address_prefixes     = ["10.0.1.0/24"]
  depends_on           = [azurerm_virtual_network.Vnet]
}
