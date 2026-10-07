variable "project_id" {
  type        = string
  description = "GCP project ID"
}

variable "zone" {
  type        = string
  description = "Zone under which resources are created"
}

variable "machine_type" {
  type        = string
  description = "Compute Engine resource type"
}

variable "network_id" {
  type        = string
  description = "ID of the Network"
}

variable "subnet_id" {
  type        = string
  description = "ID of the Subnet"
}

variable "service_account_email" {
  type        = string
  description = "Service Account Email"
}