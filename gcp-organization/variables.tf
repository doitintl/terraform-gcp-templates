variable "shared_suffix" {
  default = "gotamedia"
}

variable "region" {
  default = "europe-north1"
}

variable "location" {
  default = "EU"
}

variable "org_id" {
  default = "53708677662" # not used currently in shared playground (just used folders)
}

variable "folder_id" {
  default = "folders/854148447260" # CHANGE: folder in playground
}

variable "billing_account_id" {
  default = "0108E8-421216-F47AFD" # DoiT Playground
}

variable "directory_customer_id" {
  type        = set(string)
  description = "Get organization DIRECTORY_CUSTOMER_ID field with 'gcloud alpha organizations list'"
  default     = ["C03lk2tjc"]
}

variable "audit_logs_bucket_name" {
  default = "gotamedia-audit-logs"
}

# IAM groups (set up in Cloud Identity or GSuite)
# CHANGE: using personal domain for testing / demo
variable "group_org_admins" {
  default = "group:admingcp@gotamedia.se"
}

variable "group_billing_admins" {
  default = "group:billinggcp@gotamedia.se"
}

variable "group_security_admins" {
  default = "group:securitygcp@gotamedia.se"
}

variable "group_network_admins" {
  default = "group:networkgcp@gotamedia.se"
}

variable "group_devops" {
  default = "group:devopsgcp@gotamedia.se"
}

variable "group_developers" {
  default = "group:devopsgcp@gotamedia.se"
}

