resource "azurerm_resource_group" "grp" {
    name     = var.resource_group_name
    location = var.location

    lifecycle {
        prevent_destroy = true
    }
}
