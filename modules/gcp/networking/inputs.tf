variable "host_project_id" {
  description = "The GCP project_id to create the VPC networks and subnets into"
  type        = string
}

variable "service_project_number" {
  description = "The GCP project number to create log metrics to"
  type        = string
}

variable "region" {}
variable "vpc_name" {}

variable "subnet_k8s_nodes_ip_cidr_range" {}
variable "subnet_k8s_pods_ip_cidr_range" {}
variable "subnet_k8s_services_ip_cidr_range" {}

variable "subnet_vms_ip_cidr_range" {}
variable "subnet_dbs_ip_cidr_range" {}
