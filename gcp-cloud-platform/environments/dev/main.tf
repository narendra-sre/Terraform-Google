terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 7.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

module "network" {
  source     = "../../modules/network"
  project_id = var.project_id
  region     = var.region
}

module "iam" {
  source     = "../../modules/iam"
  project_id = var.project_id
}

module "compute" {
  source                = "../../modules/compute"
  project_id            = var.project_id
  zone                  = var.zone
  machine_type          = var.machine_type
  network_id            = module.network.vpc_id
  subnet_id             = module.network.subnet_id
  service_account_email = module.iam.service_account_email
}

module "storage" {
  source      = "../../modules/storage"
  project_id  = var.project_id
  bucket_name = var.bucket_name
  location    = var.location
}