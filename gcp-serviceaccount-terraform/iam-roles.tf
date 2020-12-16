# Compute Instance Admin (tf-sa: org)
resource "google_folder_iam_binding" "folder_iam_compute_instance_admin" {
  folder = data.google_folder.root.id

  role = "roles/compute.instanceAdmin"

  members = [format("serviceAccount:%s", google_service_account.terraform.email)]
}

# Create Service Accounts (tf-sa: org)
resource "google_folder_iam_binding" "folder_iam_sa_creator" {
  folder = data.google_folder.root.id
  role   = "roles/iam.serviceAccountCreator"

  members = [format("serviceAccount:%s", google_service_account.terraform.email)]
}

# Delete Service Accounts (tf-sa: org)
resource "google_folder_iam_binding" "folder_iam_sa_deleter" {
  folder = data.google_folder.root.id
  role   = "roles/iam.serviceAccountDeleter"

  members = [format("serviceAccount:%s", google_service_account.terraform.email)]
}

# Service Account User (tf-sa: org)
resource "google_folder_iam_binding" "folder_iam_sa_user" {
  folder = data.google_folder.root.id
  role   = "roles/iam.serviceAccountUser"

  members = [format("serviceAccount:%s", google_service_account.terraform.email)]
}

# Service Account Token Creator (tf-sa: org)
resource "google_folder_iam_binding" "folder_iam_sa_token_creator" {
  folder = data.google_folder.root.id
  role   = "roles/iam.serviceAccountTokenCreator"

  members = [format("serviceAccount:%s", google_service_account.terraform.email)]
}

# Logs Configuration Writer (tf-sa: org)
resource "google_folder_iam_binding" "folder_iam_log_config_writer" {
  folder = data.google_folder.root.id
  role   = "roles/logging.configWriter"

  members = [format("serviceAccount:%s", google_service_account.terraform.email)]
}

# Folder Creator (tf-sa: org)
resource "google_folder_iam_binding" "folder_iam_folder_creator" {
  folder = data.google_folder.root.id
  role   = "roles/resourcemanager.folderCreator"

  members = [format("serviceAccount:%s", google_service_account.terraform.email)]
}

# Folder Editor (tf-sa: org)
resource "google_folder_iam_binding" "folder_iam_folder_editor" {
  folder = data.google_folder.root.id
  role   = "roles/resourcemanager.folderEditor"

  members = [format("serviceAccount:%s", google_service_account.terraform.email)]
}

# projects

# Project Creator (tf-sa: org)
resource "google_folder_iam_binding" "folder_iam_project_creator" {
  folder = data.google_folder.root.id
  role   = "roles/resourcemanager.projectCreator"

  members = [format("serviceAccount:%s", google_service_account.terraform.email)]
}

# Project Deleter (tf-sa: org)
resource "google_folder_iam_binding" "folder_iam_product_deleter" {
  folder = data.google_folder.root.id
  role   = "roles/resourcemanager.projectDeleter"

  members = [format("serviceAccount:%s", google_service_account.terraform.email)]
}

# Access Context Manager Editor (tf-sa: org)
resource "google_folder_iam_binding" "folder_iam_access_context_editor" {
  folder = data.google_folder.root.id
  role   = "roles/accesscontextmanager.policyEditor"

  members = [format("serviceAccount:%s", google_service_account.terraform.email)]
}
