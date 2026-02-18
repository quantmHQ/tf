output "name" {
  value       = google_compute_network.default.name
  description = "Name of the VPC network"
}

output "id" {
  value       = google_compute_network.default.id
  description = "ID of the VPC network"
}

output "self_link" {
  value       = google_compute_network.default.self_link
  description = "Self link of the VPC network"
}

output "subnets" {
  description = "Map of subnets with their IDs and self_links"
  value = {
    for k, v in google_compute_subnetwork.default :
    k => {
      id        = v.id
      name      = v.name
      self_link = v.self_link
    }
  }
}
