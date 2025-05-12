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