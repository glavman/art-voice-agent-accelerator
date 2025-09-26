# AI Foundry module wiring for the core deployment

locals {
  foundry_name_seed = lower(replace("aif${var.name}${var.environment_name}", "-", ""))
  foundry_name_prefix      = substr(local.foundry_name_seed, 0, 16)
  foundry_account_name     = substr("${local.foundry_name_prefix}${local.resource_token}", 0, 24)
  foundry_project_name     = substr("${local.foundry_account_name}proj", 0, 24)
  foundry_project_display  = "AI Foundry ${var.environment_name}"
  foundry_project_desc     = "AI Foundry project for ${var.environment_name} environment"
}

module "ai_foundry" {
  source = "./modules/ai"

  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  tags                = local.tags

  disable_local_auth            = var.disable_local_auth
  foundry_account_name          = local.foundry_account_name
  foundry_custom_subdomain_name = local.foundry_account_name

  project_name         = local.foundry_project_name
  project_display_name = local.foundry_project_display
  project_description  = local.foundry_project_desc

  log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id
  account_principal_ids = distinct([
    azurerm_user_assigned_identity.backend.principal_id,
    azurerm_user_assigned_identity.frontend.principal_id,
    azapi_resource.acs.identity[0].principal_id,
    local.principal_id
  ])
}

output "ai_foundry_account_id" {
  description = "Resource ID of the AI Foundry account"
  value       = module.ai_foundry.account_id
}

output "ai_foundry_account_endpoint" {
  description = "Endpoint URI for the AI Foundry account"
  value       = module.ai_foundry.endpoint
}

output "ai_foundry_project_id" {
  description = "Resource ID of the AI Foundry project"
  value       = module.ai_foundry.project_id
}

output "ai_foundry_project_identity_principal_id" {
  description = "Managed identity principal ID assigned to the AI Foundry project"
  value       = module.ai_foundry.project_identity_principal_id
}
