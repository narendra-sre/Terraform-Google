resource "google_service_account" "ace_vm" {
  account_id   = "ace-vm-id"
  display_name = "ACE VM Service Account"
  description  = "service account for the ACE learning project"
}

resource "google_project_iam_member" "ace_vm_storage_viewer" {
  project = var.gcp_project_id
  role    = "roles/storage.objectViewer"
  member  = "serviceAccount:${google_service_account.ace_vm.email}"
}