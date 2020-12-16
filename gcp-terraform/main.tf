resource "google_project" "terraform_automation" {
  name                = "terraform-automation"
  project_id          = "terraform-automation"
  org_id              = var.org_id
  auto_create_network = false
  billing_account     = var.billing_account_id
  labels = {
    "dept" = "devops"
  }
}

resource "google_service_account" "terraform" {
  account_id   = "terraform"
  display_name = "terraform"
  project      = google_project.terraform_automation.project_id
}
