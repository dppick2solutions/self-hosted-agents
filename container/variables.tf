variable "azure_subscription_id" {
  type        = string
  description = "Azure Subscription Id."
}
variable "azure_client_id" {
  type        = string
  description = "Azure Client Id of Terraform service principal."
}

variable "image_name" {
  type = string
  description = "ADO self hosted agent image name."
}

variable "azure_devops_url" {
  type = string
  description = "Azure DevOps url."
}

variable "azure_devops_personal_access_token" {
  type = string
  description = "Personal Access Token for agent registration."
}