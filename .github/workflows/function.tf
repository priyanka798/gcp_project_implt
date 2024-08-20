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
  region  = "us-central1"  # Specify the region for the Cloud Function
  zone    = "us-central1-a"  # Specify the zone for the Compute Engine instance
}

# Cloud Function Resource
resource "google_cloudfunctions_function" "my_function" {
  name        = "my-cloud-function"              # The name of your Cloud Function
  runtime     = "python39"                       # The runtime environment (e.g., python39, nodejs14)
  entry_point = "function_entry_point"           # The name of the function to execute

  available_memory_mb   = 256                    # Memory allocation for the function
  source_archive_bucket = "bucket251294"         # Bucket containing the source code
  source_archive_object = "function-source.zip"  # Zip file containing the source code

  # Event Trigger
  event_trigger {
    event_type = "google.storage.object.finalize"  # Trigger event type (e.g., Cloud Storage)
    resource   = "bucket251294"                    # Resource triggering the event (your bucket name)
  }

  environment_variables = {
    VAR_NAME = "value"  # Set any environment variables your function needs
  }
}

# Compute Engine Instance Resource
resource "google_compute_instance" "my_instance" {
  name         = "my-instance"
  machine_type = "e2-medium"
  zone         = "us-central1-a"  # Specify the zone

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"  # Using Debian 11 as the base image
    }
  }

  network_interface {
    network = "default"

    access_config {
      # This provides the instance with a public IP address
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
