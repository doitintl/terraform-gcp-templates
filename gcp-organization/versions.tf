terraform {
  required_version = "~> 0.14.2"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 3.51"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 3.51"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0.0"
    }
  }
  //  backend "gcs" {
  //    bucket  = terraform-automation-examplecorp"
  //    prefix  = "states/organization"
  //  }
}

provider "google" {
  region = var.region
}

provider "google-beta" {
  region = var.region
}
