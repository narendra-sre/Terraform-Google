# Terraform-Google
Terraform Hands-on with Google Cloud Resources

PROJECT STRUCTURE

```text
gcp-cloud-platform/
├── README.md
├── .gitignore
├── environments/
│   ├── dev/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   └── terraform.tfvars
│   └── prod/
│       ├── main.tf
│       ├── variables.tf
│       ├── outputs.tf
│       └── terraform.tfvars
└── modules/
    ├── compute/
    │   ├── main.tf
    │   ├── outputs.tf
    │   └── variables.tf
    ├── database/
    │   ├── main.tf
    │   ├── outputs.tf
    │   └── variables.tf
    ├── gke/
    │   ├── main.tf
    │   ├── outputs.tf
    │   └── variables.tf
    ├── iam/
    │   ├── main.tf
    │   ├── outputs.tf
    │   └── variables.tf
    ├── load-balancer/
    │   ├── main.tf
    │   ├── outputs.tf
    │   └── variables.tf
    ├── monitoring/
    │   ├── main.tf
    │   ├── outputs.tf
    │   └── variables.tf
    ├── network/
    │   ├── main.tf
    │   ├── outputs.tf
    │   └── variables.tf
    └── storage/
        ├── main.tf
        ├── outputs.tf
        └── variables.tf
```
