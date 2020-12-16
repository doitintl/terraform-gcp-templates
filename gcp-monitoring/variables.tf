variable "shared_suffix" {
  default = "gotamedia"
}

variable "region" {
  default = "europe-north1"
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

