output "self_link" {
  description = "The self-link of the created Cloud SQL instance."
  value       = google_sql_database_instance.default.self_link
}

output "ip" {
  description = "The private IP address assigned to the Cloud SQL instance within the specified VPC network."
  value       = google_sql_database_instance.default.private_ip_address
}

output "password" {
  description = "The randomly generated password for the database user"
  value       = random_password.default.result
  sensitive   = true
}
