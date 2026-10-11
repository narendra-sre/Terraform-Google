resource "google_container_cluster" "gke_cluster" {
  name     = "ace-gke-cluster"
  project  = var.project_id
  location = var.zone

  network    = var.network_id
  subnetwork = var.subnet_id

  networking_mode = "VPC_NATIVE"

  ip_allocation_policy {
    cluster_secondary_range_name  = "gke-pods"
    services_secondary_range_name = "gke-services"
  }

  remove_default_node_pool = true
  initial_node_count       = 1

  deletion_protection = false

  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }
}

resource "google_container_node_pool" "gke_nodes" {
  name     = "ace-gke-node-pool"
  project  = var.project_id
  location = var.zone
  cluster  = google_container_cluster.gke_cluster.name

  node_count = 1

  node_config {
    machine_type = "e2-medium"

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}
