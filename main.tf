terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.51.0"
    }
  }
}

provider "google" {
  project = "round-seeker-433011-t3"
  region  = "us-central1"  # Specify the region if needed for other resources
}

resource "google_storage_bucket" "my_bucket" {
  name     = "bucket251194"  # Must be globally unique
  location = "US"                      # Location of the bucket

  lifecycle {
    prevent_destroy = true             # Optional: Prevent the bucket from being accidentally destroyed
  }
}
