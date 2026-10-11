output "instance_name" {
  description = "Cloud SQL instance name"
  value       = google_sql_database_instance.postgres.name
}

output "private_ip_address" {
  description = "Cloud SQL private IP address"
  value       = google_sql_database_instance.postgres.private_ip_address
}

output "database_name" {
  value = google_sql_database.app_database.name
}

output "database_user" {
  value = google_sql_user.app_user.name
}