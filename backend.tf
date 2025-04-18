# We are using Terraform Cloud as backend
terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "dhanabalan-gcp-org"

    workspaces {
      name = "gke-cluster"
    }
  }
}