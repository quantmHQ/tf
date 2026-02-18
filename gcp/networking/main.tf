################################################################################
# VPC Network
################################################################################
resource "google_compute_network" "default" {
  name                     = "${var.environment}-${var.name}"
  project                  = var.project
  description              = "VPC network for ${var.environment}-${var.name}"
  auto_create_subnetworks  = false
  routing_mode             = "GLOBAL"
  enable_ula_internal_ipv6 = true
}

################################################################################
# Subnetworks
#
# TODO: Add secondary ranges later
################################################################################
resource "google_compute_subnetwork" "default" {
  for_each = var.subnets

  name          = "${var.environment}-${var.name}-${each.key}"
  project       = var.project
  ip_cidr_range = each.value.cidr
  region        = each.value.region
  description   = each.value.description != null ? each.value.description : "Subnet for ${var.environment}-${var.name}-${each.key}"
  stack_type    = each.value.dual_stack ? "IPV4_IPV6" : "IPV4_ONLY"

  network                    = google_compute_network.default.id
  private_ip_google_access   = true
  private_ipv6_google_access = "ENABLE_OUTBOUND_VM_ACCESS_TO_GOOGLE"
  ipv6_access_type           = "INTERNAL"

  dynamic "secondary_ip_range" {
    for_each = local.cluster_ranges[each.key]

    content {
      range_name    = "${var.environment}-${var.name}-${secondary_ip_range.key}"
      ip_cidr_range = secondary_ip_range.value
    }
  }

  depends_on = [google_compute_network.default]

  lifecycle {
    precondition {
      # Check region validity for each subnet instance using data from the 'valid' module
      condition     = contains(module.valid.regions, each.value.region)
      error_message = "Subnet '${each.key}' uses region '${each.value.region}', which is not in the allowed."
    }
  }
}

################################################################################
# Peering Ranges for VPC Service Networking
################################################################################

resource "google_compute_global_address" "peering" {
  for_each = toset(var.peering_ranges)

  name          = "peering-${var.environment}-${var.name}-${replace(replace(each.key, "/", "-"), ".", "-")}"
  project       = var.project
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  network       = google_compute_network.default.id
  address       = split("/", each.key)[0]
  prefix_length = tonumber(split("/", each.key)[1])

  labels = {
    environment = var.environment
    purpose     = "peering"
    network     = google_compute_network.default.name
  }
}

resource "google_service_networking_connection" "peering" {
  count = length(var.peering_ranges) > 0 ? 1 : 0

  network                 = google_compute_network.default.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = values(google_compute_global_address.peering)[*].name

  depends_on = [google_compute_global_address.peering]
}

################################################################################
# Routing and NAT
################################################################################

resource "google_compute_router" "default" {
  for_each = local.subnets_by_region

  name        = "${var.environment}-${var.name}-${each.key}-router"
  project     = var.project
  region      = each.key
  network     = google_compute_network.default.id
  description = "Default router for ${var.environment}-${var.name}"

  depends_on = [google_compute_network.default]
}

resource "google_compute_address" "gateway" {
  for_each = local.subnets_by_region

  name        = "${var.environment}-${var.name}-gateway-${each.key}"
  region      = each.key
  project     = var.project
  description = "Regional NAT gateway for ${var.environment}-${var.name}-${each.key}"

  labels = {
    environment = var.environment
    network     = var.name
  }

  depends_on = [google_compute_network.default]
}

# ... inside the Routing and NAT section ...

resource "google_compute_router_nat" "router_nat" {
  # Change this loop from subnets to regions
  for_each = local.subnets_by_region

  name                   = "${var.environment}-${var.name}-nat-${each.key}" // each.key is now the region
  project                = var.project
  router                 = google_compute_router.default[each.key].name
  region                 = each.key
  nat_ip_allocate_option = "MANUAL_ONLY"

  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  nat_ips = [
    google_compute_address.gateway[each.key].self_link
  ]

  depends_on = [
    google_compute_address.gateway,
    google_compute_router.default,
  ]
}


################################################################################
# Firewall
#
# TODO: Implement more granular rules for ingress and egress traffic
################################################################################

resource "google_compute_firewall" "egress__default" {
  name               = "${var.environment}-${var.name}-egress-default"
  description        = "Default egress firewall rule (allow all) for ${var.environment}-${var.name}"
  project            = var.project
  network            = google_compute_network.default.id
  direction          = "EGRESS"
  destination_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "all"
  }

  depends_on = [google_compute_network.default]
}

resource "google_compute_firewall" "ingress__default" {
  name          = "${var.environment}-${var.name}-ingress-default"
  description   = "Default ingress firewall rule (block all) for ${var.environment}-${var.name}"
  project       = var.project
  network       = google_compute_network.default.id
  direction     = "INGRESS"
  source_ranges = ["0.0.0.0/0"]

  deny {
    protocol = "all"
  }

  depends_on = [google_compute_network.default]
}

resource "google_compute_firewall" "ingress__allow__internal" {
  name        = "${var.environment}-${var.name}-ingress-allow-internal"
  description = "Allow internal traffic within the VPC"
  project     = var.project
  network     = google_compute_network.default.id
  direction   = "INGRESS"
  priority    = 900

  source_ranges = [for s in var.subnets : s.cidr]

  allow {
    protocol = "all"
  }

  depends_on = [google_compute_network.default]
}

resource "google_compute_firewall" "ingress__allow__rules" {
  for_each = var.ingress_rules

  name        = "${var.environment}-${var.name}-ingress-allow-${each.key}"
  description = "${each.key} ingress rule for ${var.environment}-${var.name}"
  project     = var.project
  network     = google_compute_network.default.id
  direction   = "INGRESS"
  priority    = 900

  source_ranges = each.value.source_ranges
  target_tags   = each.value.target_tags

  allow {
    protocol = each.value.protocol
    ports    = each.value.ports
  }

  depends_on = [google_compute_network.default]
}
