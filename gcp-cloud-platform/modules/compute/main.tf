resource "google_compute_instance" "web_instances" {
  count        = 2
  name         = "vm-${count.index + 1}"
  machine_type = var.machine_type
  zone         = var.zone
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }
  network_interface {
    network    = var.network_id
    subnetwork = var.subnet_id
  }
  service_account {
    email  = var.service_account_email
    scopes = ["cloud-platform"]
  }
  metadata_startup_script = <<-EOF
  #!/bin/bash
  set -e
  apt-get update -y
  apt-get install -y nginx
  systemctl enable nginx
  systemctl restart nginx
  echo "<h1>Hello from Backend VM: $(hostname)</h1>" > /var/www/html/index.html
  EOF
}

resource "google_compute_instance_group" "web_servers" {
  name        = "web-servers"
  description = "Unmanaged instance group containing web VMs"
  instances   = google_compute_instance.web_instances[*].self_link
  zone        = var.zone
  named_port {
    name = "http"
    port = 80
  }
}