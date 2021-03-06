locals {
  bound_folder_iam_roles = toset([
    "roles/compute.instanceAdmin",
    "roles/iam.serviceAccountCreator",
    "roles/iam.serviceAccountDeleter",
    "roles/iam.serviceAccountUser",
    "roles/iam.serviceAccountTokenCreator",
    "roles/logging.configWriter",
    "roles/resourcemanager.folderCreator",
    "roles/resourcemanager.folderEditor",
    "roles/resourcemanager.projectCreator",
    "roles/resourcemanager.projectDeleter",
    "roles/accesscontextmanager.policyEditor",
  ])
  bound_organization_iam_roles = toset([
    "roles/accesscontextmanager.policyAdmin",
    "roles/resourcemanager.organizationViewer",
    "roles/compute.xpnAdmin",
    "roles/billing.user",
    "roles/orgpolicy.policyAdmin",
  ])
  bound_billing_account_iam_roles = toset([
    "roles/billing.admin",
    "roles/logging.admin"
  ])
}

resource "google_folder_iam_member" "terraform" {
  for_each = local.bound_folder_iam_roles
  folder   = data.google_folder.root.id
  role     = each.value
  member   = format("serviceAccount:%s", google_service_account.terraform.email)
}

resource "google_billing_account_iam_member" "terraform" {
  for_each           = local.bound_billing_account_iam_roles
  billing_account_id = var.billing_account_id
  member             = format("serviceAccount:%s", google_service_account.terraform.email)
  role               = each.value
}

resource "google_organization_iam_member" "terraform" {
  for_each = local.bound_organization_iam_roles
  member   = format("serviceAccount:%s", google_service_account.terraform.email)
  org_id   = var.org_id
  role     = each.value
}
