resource "google_container_cluster" "default" {
  name     = "gke-autopilot-basic"
  location = "us-central1"

  enable_autopilot = true
  deletion_protection = false

  release_channel {
    channel = "REGULAR"
  }
}

data "google_client_config" "current" {}

data "google_container_cluster" "default" {
  name     = "gke-autopilot-basic"
  location = "us-central1"
}

provider "kubernetes" {
  host  = "https://${data.google_container_cluster.my_cluster.endpoint}"
  token = data.google_service_account_access_token.my_kubernetes_sa.access_token
  cluster_ca_certificate = base64decode(
    data.google_container_cluster.my_cluster.master_auth[0].cluster_ca_certificate,
  )
}

#provider "kubernetes" {
#  host                   = "https://${google_container_cluster.default.endpoint}"
#  cluster_ca_certificate = base64decode(google_container_cluster.default.master_auth.0.cluster_ca_certificate)
#  token                  = data.google_client_config.current.access_token
#}