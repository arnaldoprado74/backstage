locals {
  base_domain = "arnaldopradohotmail.onmicrosoft.com" // regex("[.*\\.]?([a-zA-Z0-9]+[\\.][a-zA-Z0-9]+[\\.][a-zA-Z0-9-]+)\\z", var.internal_domain)[0]

  staff_users = {
    "0001" = zipmap(["first","last","email"],["Arnaldo", "Prado", "arnaldo_prado_hotmail.com#EXT#@arnaldopradohotmail.onmicrosoft.com"])
  }

  environment = "${replace(terraform.workspace, "/.*-/", "")}"
  in-dft-wksp = local.environment == "default" ? true : false
}

resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "_%@"
}

# staff users
resource "azuread_user" "staff_users" {
  for_each = (local.in-dft-wksp ? local.staff_users : {})
  
  user_principal_name = join("", [lower(each.value["first"]), ".", lower(each.value["last"]), "@", local.base_domain])
  display_name        = join(" ", [each.value["first"], each.value["last"]])  
  password            = random_password.password.result
}

# users certificates
resource "azurerm_key_vault_certificate" "kv_user_cert" {
  for_each = fileset(join("/",[path.module, "..", "..", "certs", "users"]), "*.noext")
  
  name = replace(each.value,".","-")
  key_vault_id = var.kv_id

  certificate {
    contents = filebase64( join("/", [path.module, "..", "..", "certs", "users", each.value]) )
    password = random_password.password.result
  }

  certificate_policy {
    issuer_parameters {
      name = "Self"
    }

    key_properties {
      exportable = true
      key_size   = 2048
      key_type   = "RSA"
      reuse_key  = false
    }

    secret_properties {
      content_type = "application/x-pkcs12"
    }
  }
}
