resource "google_storage_bucket" "ace_bucket" {
  name                        = "${var.project_id}-${var.bucket_name}"
  location                    = var.location
  uniform_bucket_level_access = true
  versioning {
    enabled = true
  }
}