variable "shared_suffix" {
  default = "bki"
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
  default = "folders/747973543401" # CHANGE: folder in playground
}

variable "billing_account_id" {
  default = "01A29B-B56F30-AA7597" # DoiT Playground
}

variable "directory_customer_id" {
  type        = set(string)
  description = "Get organization DIRECTORY_CUSTOMER_ID field with 'gcloud alpha organizations list'"
  default = [
    "C01h4gmiw", # DoiT Playground org
    "C03rw2ty2", # DoiT org
  ]
}

variable "audit_logs_bucket_name" {
  default = "audit-logs"
}

# IAM groups (set up in Cloud Identity or GSuite)
# CHANGE: using personal domain for testing / demo
variable "group_org_admins" {
  type    = set(string)
  default = ["group:admingcp@example.corp"]
}

variable "group_billing_admins" {
  type    = set(string)
  default = ["group:billinggcp@example.corp"]
}

variable "group_security_admins" {
  type    = set(string)
  default = ["group:securitygcp@example.corp"]
}

variable "group_network_admins" {
  type    = set(string)
  default = ["group:networkgcp@example.corp"]
}

variable "group_devops" {
  type    = set(string)
  default = ["group:devopsgcp@example.corp"]
}

variable "group_developers" {
  type    = set(string)
  default = ["group:devopsgcp@example.corp"]
}

