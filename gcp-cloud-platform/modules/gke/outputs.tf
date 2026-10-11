output "cluster_name" {
  value = google_container_cluster.gke_cluster.name
}

output "cluster_endpoint" {
  value     = google_container_cluster.gke_cluster.endpoint
  sensitive = true
}

output "cluster_ca_certificate" {
  value     = google_container_cluster.gke_cluster.master_auth[0].cluster_ca_certificate
  sensitive = true
}