resource "google_compute_health_check" "instance_health_check" {
  name               = "web-server-health-check"
  timeout_sec        = 1
  check_interval_sec = 1
  http_health_check {
    port = 80
  }
}

resource "google_compute_backend_service" "instance_backend_service" {
  name          = "backend-service"
  health_checks = [google_compute_health_check.instance_health_check.id]
  backend {
    group = var.instance_group_id
  }
}

resource "google_compute_url_map" "default_backend_service" {
  name            = "web-url-map"
  default_service = google_compute_backend_service.instance_backend_service.id
}

resource "google_compute_target_http_proxy" "http_proxy" {
  name    = "http-proxy"
  url_map = google_compute_url_map.default_backend_service.id
}

resource "google_compute_global_address" "global_address" {
  name        = "global-loadbalancer-address"
  description = "Global external IP for the main loadbalancer"
}

resource "google_compute_global_forwarding_rule" "global_forwarding_rule" {
  name                  = "global-http-forwarding-rule"
  provider              = google
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL"
  port_range            = "80"
  target                = google_compute_target_http_proxy.http_proxy.id
  ip_address            = google_compute_global_address.global_address.address
}