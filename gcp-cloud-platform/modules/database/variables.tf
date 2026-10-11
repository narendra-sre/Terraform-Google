variable "project_id" {
  type        = string
  description = "GCP project ID"
}

variable "region" {
  type        = string
  description = "Region for the cloud sql instance"
}

variable "network_id" {
  type        = string
  description = "VPC network ID for private connectivity"
}

variable "instance_name" {
  type        = string
  description = "Cloud SQL instance name"
  default     = "dev-postgres"
}

variable "database_version" {
  type        = string
  description = "Postgre SQL Database version"
  default     = "POSTGRES_16"
}

variable "machine_tier" {
  type        = string
  description = "Cloud SQL machine tier"
  default     = "db-custom-1-3840"
}

variable "db_password" {
  type        = string
  description = "Password for the application database user"
  sensitive   = true
}