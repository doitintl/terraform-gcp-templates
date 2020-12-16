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
    "roles/compute.xpnAdmin",
  ])
}

resource "google_folder_iam_binding" "terraform" {
  for_each = local.bound_folder_iam_roles
  folder   = data.google_folder.root.id
  role     = each.value
  members  = [format("serviceAccount:%s", google_service_account.terraform.email)]
}
