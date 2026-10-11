resource "google_sql_database_instance" "postgres" {
  project             = var.project_id
  name                = var.instance_name
  region              = var.region
  database_version    = var.database_version
  deletion_protection = false

  settings {
    tier    = var.machine_tier
    edition = "ENTERPRISE"
    ip_configuration {
      ipv4_enabled    = false
      private_network = var.network_id
    }
    backup_configuration {
      enabled                        = true
      point_in_time_recovery_enabled = true
    }
  }
}

resource "google_sql_database" "app_database" {
  project  = var.project_id
  name     = "application-db"
  instance = google_sql_database_instance.postgres.name
}

resource "google_sql_user" "app_user" {
  project  = var.project_id
  name     = "app_user"
  instance = google_sql_database_instance.postgres.name
  password = var.db_password
}
