data "google_billing_account" "account" {
  billing_account = var.billing_account_id
}

# folders
data "google_folder" "root" {
  folder              = var.folder_id
  lookup_organization = true
}

resource "google_folder" "shared_services" {
  display_name = "shared-services"
  parent       = data.google_folder.root.name
}

resource "google_folder" "engineering" {
  display_name = "engineering"
  parent       = data.google_folder.root.name
}

resource "google_folder" "product_x" {
  display_name = "product-x"
  parent       = google_folder.engineering.name
}

resource "google_folder" "non_production" {
  display_name = "non-production"
  parent       = google_folder.product_x.name
}

resource "google_folder" "production" {
  display_name = "production"
  parent       = google_folder.product_x.name
}
