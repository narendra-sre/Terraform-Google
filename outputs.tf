output "created_service_account" {
  value       = google_service_account.ace_vm.account_id
  description = "List service accounts added to the project."
}

output "created_role" {
  value       = google_project_iam_member.ace_vm_storage_viewer.role
  description = "List the roles created in the project."
}