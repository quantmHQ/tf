locals {
  sql = {
    r = [
      "cloudsql.instances.get",
      "cloudsql.instances.getIamPolicy",
      "cloudsql.instances.list",
      "cloudsql.databases.get",
      "cloudsql.databases.list",
      "cloudsql.users.list",
      "cloudsql.backupRuns.get",
      "cloudsql.backupRuns.list",
      "cloudsql.sslCerts.get",
      "cloudsql.sslCerts.list",
    ]
    w = [
      "cloudsql.databases.create",
      "cloudsql.databases.delete",
      "cloudsql.databases.update",
      "cloudsql.users.create",
      "cloudsql.users.delete",
      "cloudsql.users.update",
      "cloudsql.instances.promoteReplica",
      "cloudsql.instances.rotateServerCa",
    ]
    x = [
      "cloudsql.instances.connect",
    ]
    su = [
      "cloudsql.instances.restart",
      "cloudsql.instances.startReplica",
      "cloudsql.instances.stopReplica",
      "cloudsql.instances.create",
      "cloudsql.instances.delete",
      "cloudsql.instances.setIamPolicy",
      "cloudsql.instances.update",
      "cloudsql.instances.export",
      "cloudsql.instances.import",
      "cloudsql.instances.restoreBackup",
    ]
  }
}
