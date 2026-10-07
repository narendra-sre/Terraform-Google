resource "google_compute_network" "vpc_network" {
  name                    = "ace-vpc"
  project                 = var.project_id
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "vpc_subnetwork" {
  name          = "ace-subnet"
  ip_cidr_range = "10.10.0.0/24"
  project       = var.project_id
  region        = var.region
  network       = google_compute_network.vpc_network.id
}