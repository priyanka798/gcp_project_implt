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
  region  = "us-central1"  # Region for the Cloud Function
  zone    = "us-central1-a"  # Zone for the Compute Engine instance
}

# Cloud Function Resource
resource "google_cloudfunctions_function" "my_function" {
  name        = "my-cloud-function"
  runtime     = "python39"
  entry_point = "function_entry_point"

  available_memory_mb   = 256
  source_archive_bucket = "bucket251294"
  source_archive_object = "function-source.zip"

  # Event Trigger
  event_trigger {
    event_type = "google.storage.object.finalize"
    resource   = "bucket251294"
  }

  environment_variables = {
    VAR_NAME = "value"
  }
}

# Compute Engine Instance Resource
resource "google_compute_instance" "my_instance" {
  name         = "my-instance"
  machine_type = "e2-medium"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = "default"

    access_config {
      # Provides the instance with a public IP address
    }
  }

  metadata_startup_script = <<-EOF
    #!/bin/bash
    echo "Hello, World!" > /var/www/html/index.html
  EOF
}

# Outputs
output "instance_ip" {
  value = google_compute_instance.my_instance.network_interface[0].access_config[0].nat_ip
}
