locals {
  serviceusage = {
    r = [
      "serviceusage.apiKeys.get",
      "serviceusage.apiKeys.list",
      "serviceusage.operations.get",
      "serviceusage.operations.list",
      "serviceusage.services.get",
      "serviceusage.services.list",
    ]
    w = [
      "serviceusage.services.enable",
      "serviceusage.services.disable",
    ]
    x = []
    su = [
      "serviceusage.apiKeys.create",
      "serviceusage.apiKeys.delete",
      "serviceusage.apiKeys.undelete",
      "serviceusage.apiKeys.update",
    ]
  }
}
