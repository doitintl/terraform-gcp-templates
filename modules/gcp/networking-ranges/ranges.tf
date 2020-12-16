locals {
  subnetworks = {
    dbs = {
      development = "10.0.0.0/24"
      devops      = "10.1.0.0/24"
      production  = "10.2.0.0/24"
      staging     = "10.3.0.0/24"
    }
    vms = {
      development = "10.0.1.0/24"
      devops      = "10.1.1.0/24"
      production  = "10.2.1.0/24"
      staging     = "10.3.1.0/24"
    }
    # NOTE: these are for a single k8s cluster,
    # modify accordingly if you plan on having more than
    # one GKE cluster per GCP project
    k8s_nodes = {
      development = "10.0.4.0/22"
      devops      = "10.1.4.0/22"
      production  = "10.2.4.0/22"
      staging     = "10.3.4.0/22"
    }
    k8s_pods = {
      development = "10.0.64.0/18"
      devops      = "10.1.64.0/18"
      production  = "10.2.64.0/18"
      staging     = "10.3.64.0/18"
    }
    k8s_services = {
      development = "10.0.8.0/22"
      devops      = "10.1.8.0/22"
      production  = "10.2.8.0/22"
      staging     = "10.3.8.0/22"
    }
  }
}

output "subnetworks" {
  value = local.subnetworks
}