locals {
  google_folder_organization_policy_boolean = toset([
    "compute.skipDefaultNetworkCreation",
    "iam.disableServiceAccountKeyCreation",
    "compute.requireShieldedVm",
    "appengine.disableCodeDownload",
  ])
}

resource "google_folder_organization_policy" "default_network_policy" {
  for_each   = local.google_folder_organization_policy_boolean
  folder     = data.google_folder.root.id
  constraint = each.value
  boolean_policy {
    enforced = true
  }
}

resource "google_folder_organization_policy" "allow_only_policy_member_domains" {
  folder     = data.google_folder.root.id
  constraint = "constraints/iam.allowedPolicyMemberDomains"
  list_policy {
    allow {
      values = var.directory_customer_id
    }
  }
}

resource "google_folder_organization_policy" "restrict_vm_external_ip_policy" {
  folder     = data.google_folder.root.id
  constraint = "compute.vmExternalIpAccess"
  list_policy {
    deny {
      all = true
    }
  }
}

