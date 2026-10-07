variable "project_id" {
  type        = string
  description = "GCP project ID"
}

variable "region" {
  type        = string
  description = "GCP region"
  default     = "asia-south1"
}

variable "zone" {
  type        = string
  description = "Zone for deploying resources"
  default     = "asia-south1-a"
}

variable "machine_type" {
  type        = string
  description = "Compute Engine Machine Type"
  default     = "e2-micro"
}

variable "bucket_name" {
  type        = string
  description = "Bucket Name"
  default     = "ace-cloud"
}

variable "location" {
  type        = string
  description = "Location of Storage bucket"
  default     = "asia-south1"
}