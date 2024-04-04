
# Google Cloud Platform
variable "gcp_credentials" {
  type        = string
  description = "GCP: Credentials (JSON key content without newlines)"
}
variable "gcp_project_name" {
  type        = string
  description = "GCP: Project name — test-django"
}
variable "gcp_project_id" {
  type        = string
  description = "GCP: Project name — test-django-419014"
}
variable "gcp_project_number" {
  type        = string
  description = "GCP: Project number — 8575900557"
}
variable "gcp_region" {
  type        = string
  description = "GCP: Default region to manage resources"
  default     = "us-west1"
}
