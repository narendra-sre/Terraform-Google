resource "google_service_account" "app_sa" {
  display_name = "Application Service Account"
  account_id   = "app-sa"
}

resource "google_project_iam_member" "app_sa_membership" {
  project = var.project_id
  role    = "roles/storage.objectViewer"
  member  = "serviceAccount:${google_service_account.app_sa.email}"
}