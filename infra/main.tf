
#+-------------------------------------
#| CLOUD SQL
#| https://cloud.google.com/python/django/kubernetes-engine
#+-------------------------------------

# Create an instance
resource "google_sql_database_instance" "postgres" {
  name                = "django-postgres"
  database_version    = "POSTGRES_15"
  region              = var.gcp_region
  deletion_protection = false

  settings {
    tier = "db-f1-micro"
  }

  timeouts {
    create = "20m"
  }
}

# Create a database
resource "google_sql_database" "db" {
  instance = google_sql_database_instance.postgres.name
  name     = "postgres-db"
}

# Create a database user
resource "google_sql_user" "user" {
  instance = google_sql_database_instance.postgres.name
  name     = "postgres-user"
  password = "postgres-password"
}

# ---
# Create a Service account
resource "google_service_account" "cloudsql_sa" {
  account_id   = "cloud-sql"
  display_name = "Cloud SQL"
}

# Add roles
# https://gcp.permissions.cloud/iam/cloudsql
resource "google_project_iam_member" "cloudsql_sa_roles" {
  for_each = toset([
    "roles/cloudsql.admin",
    "roles/cloudsql.editor",
    "roles/cloudsql.client",
  ])

  project = var.gcp_project_id
  role    = each.key
  member  = "serviceAccount:${google_service_account.cloudsql_sa.email}"
}

# Create a JSON key
resource "google_service_account_key" "cloudsql_sa_json_key" {
  service_account_id = google_service_account.cloudsql_sa.name
  public_key_type    = "TYPE_X509_PEM_FILE"
}
