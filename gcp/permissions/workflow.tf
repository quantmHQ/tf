locals {
  workflow = {
    r = [
      "workflows.workflows.get",
      "workflows.workflows.list",
      "workflows.executions.get",
      "workflows.executions.list",
      "workflows.locations.get",
      "workflows.locations.list",
      "workflows.operations.get",
      "workflows.operations.list",
      "workflows.callbacks.list",
      "workflows.stepEntries.get",
      "workflows.stepEntries.list",
      "workflows.workflows.listRevision",
    ]
    w = [
      "workflows.workflows.update",
    ]
    x = [
      "workflows.callbacks.send",
      "workflows.callbacks.list",
      "workflows.executions.create",
      "workflows.executions.cancel",

    ]
    su = [
      "workflows.workflows.create",
      "workflows.workflows.delete",
    ]
  }
}
