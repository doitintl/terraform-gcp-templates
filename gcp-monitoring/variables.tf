variable "shared_suffix" {
  default = "bki"
}

variable "region" {
  default = "europe-north1"
}

# IAM groups (set up in Cloud Identity or GSuite)
# CHANGE: using personal domain for testing / demo
variable "group_org_admins" {
  default = "group:admingcp@example.corp"
}

variable "group_billing_admins" {
  default = "group:billinggcp@example.corp"
}

variable "group_security_admins" {
  default = "group:securitygcp@example.corp"
}

variable "group_network_admins" {
  default = "group:networkgcp@example.corp"
}

variable "group_devops" {
  default = "group:devopsgcp@example.corp"
}

variable "group_developers" {
  default = "group:devopsgcp@example.corp"
}

