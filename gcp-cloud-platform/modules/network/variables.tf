variable "region" {
  type        = string
  description = "GCP Region"
}

variable "project_id" {
  type        = string
  description = "GCP Project ID"
}

variable "private_ip_range_name" {
  type        = string
  description = "Name of the reserved IP range for Google managed services."
  default     = "google-managed-services-range"
}