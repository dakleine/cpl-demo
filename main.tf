terraform {
    backend "gcs" { 
      bucket  = "tf-state-cpl-demo"
      prefix  = "prod"
    }
}

provider "google" {
  project = var.project
  region = var.region
}

resource "google_project_service" "multiple_apis" {
  for_each = toset([
    "cloudresourcemanager.googleapis.com",
    "serviceusage.googleapis.com",
    "storage.googleapis.com",
    "compute.googleapis.com",
    "container.googleapis.com",
  ])
  service                    = each.value
}