locals {
  subnets_by_region = {
    for region, subnets in {
      for name, subnet in var.subnets :
      subnet.region => {
        name   = name
        subnet = subnet
      }
    } :
    region => [for _, subnet in subnets : subnet]
  }

  cluster_ranges = {
    for name, subnet in var.subnets :
    name => {
      for item in flatten([
        for cluster, ranges in try(subnet.secondary.clusters, {}) :
        [
          { name = "cluster-${cluster}-pods", cidr = ranges.pods },
          { name = "cluster-${cluster}-svcs", cidr = ranges.svcs }
        ]
      ]) : item.name => item.cidr
    }
  }
}
