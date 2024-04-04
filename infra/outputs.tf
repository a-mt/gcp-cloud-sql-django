
#+-------------------------------------
#| CLOUD SQL
#+-------------------------------------

output "postgres_connection_name" {
  value     = google_sql_database_instance.postgres.connection_name
  sensitive = true
}

output "postgres_connection_json_key" {
  value     = google_service_account_key.cloudsql_sa_json_key.private_key
  sensitive = true
}

output "postgres_database_name" {
  value     = google_sql_database.db.name
  sensitive = true
}

output "postgres_database_user" {
  value     = google_sql_user.user.name
  sensitive = true
}

output "postgres_database_password" {
  value     = google_sql_user.user.password
  sensitive = true
}
