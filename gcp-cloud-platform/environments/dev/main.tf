terraform {
  backend "gcs" {
    bucket = "project-dca5b643-1729-421e-831-terraform-state"
    prefix = "gcp-cloud-platform/dev"
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 7.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }
}

data "google_client_config" "default" {}

provider "kubernetes" {
  host                   = "https://${module.gke.cluster_endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke.cluster_ca_certificate)
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

module "load-balancer" {
  source            = "../../modules/load-balancer"
  instance_group_id = module.compute.instance_group_id
}

module "database" {
  source           = "../../modules/database"
  project_id       = var.project_id
  region           = var.region
  network_id       = module.network.vpc_id
  instance_name    = "dev-postgres"
  database_version = "POSTGRES_16"
  machine_tier     = "db-custom-1-3840"
  depends_on       = [module.network]
  db_password      = var.db_password
}

module "gke" {
  source = "../../modules/gke"

  project_id = var.project_id
  zone       = var.zone
  network_id = module.network.vpc_id
  subnet_id  = module.network.subnet_id

  depends_on = [
    module.network
  ]
}

module "kubernetes-app" {
  source     = "../../modules/kubernetes-app"
  depends_on = [module.gke]
}

module "monitoring" {
  source      = "../../modules/monitoring"
  project_id  = var.project_id
  alert_email = var.alert_email
}