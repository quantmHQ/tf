locals {
  k8s = {
    r = [
      "container.clusters.get",
      "container.clusters.list",
      "container.deployments.get",
      "container.deployments.list",
      "container.jobs.get",
      "container.jobs.list",
      "container.namespaces.get",
      "container.namespaces.list",
      "container.nodes.get",
      "container.nodes.list",
      "container.pods.get",
      "container.pods.list",
      "container.services.get",
      "container.services.list",
    ]
    w = [
      "container.deployments.create",
      "container.deployments.delete",
      "container.deployments.update",
      "container.jobs.create",
      "container.jobs.delete",
      "container.jobs.update",
      "container.namespaces.create",
      "container.namespaces.delete",
      "container.namespaces.update",
      "container.pods.create",
      "container.pods.delete",
      "container.pods.update",
      "container.services.create",
      "container.services.delete",
      "container.services.update",
    ]
    x = [
      "container.clusters.getCredentials",
      "container.pods.exec",
      "container.pods.portForward",
      "container.pods.attach",
    ]
    su = [
      "container.clusters.create",
      "container.clusters.delete",
      "container.clusters.setIamPolicy",
      "container.clusters.update",
      "container.nodepools.create",
      "container.nodepools.delete",
      "container.nodepools.update",
      "container.roles.escalate",
    ]
  }
}
