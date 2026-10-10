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

resource "google_compute_router" "nat_router" {
  name    = "lb-nat-router"
  region  = var.region
  network = google_compute_network.vpc_network.id
}

resource "google_compute_router_nat" "cloud_nat" {
  name                               = "lb-cloud-nat"
  router                             = google_compute_router.nat_router.name
  region                             = var.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  subnetwork {
    name                    = google_compute_subnetwork.vpc_subnetwork.id
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
}

resource "google_compute_firewall" "allow_lb_health_check" {
  name    = "allow-lb-health-check"
  network = google_compute_network.vpc_network.name
  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
  source_ranges = [
    "35.191.0.0/16",
    "130.211.0.0/22"
  ]
  target_tags = ["lb-backend"]
}