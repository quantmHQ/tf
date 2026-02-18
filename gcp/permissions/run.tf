locals {
  run = {
    svc = {
      r = [
        "run.configurations.get",
        "run.configurations.list",
        "run.locations.list",
        "run.operations.get",
        "run.operations.list",
        "run.revisions.get",
        "run.revisions.list",
        "run.routes.get",
        "run.routes.list",
        "run.services.get",
        "run.services.getIamPolicy",
        "run.services.list",
        "run.services.listEffectiveTags",
        "run.services.listTagBindings",
      ]
      w = [
        "run.revisions.delete",
        "run.services.update",
      ]
      x = [
        "run.routes.invoke",
      ]
      su = [
        "run.services.create",
        "run.services.delete",
        "run.services.setIamPolicy",
      ]
    }
    job = {
      r = [
        "run.executions.get",
        "run.executions.list",
        "run.jobs.get",
        "run.jobs.getIamPolicy",
        "run.jobs.list",
        "run.jobs.listEffectiveTags",
        "run.jobs.listTagBindings",
        "run.locations.list",
        "run.operations.get",
        "run.operations.list",
        "run.tasks.get",
        "run.tasks.list",
      ]
      w = [
        "run.jobs.update",
      ]
      x = [
        "run.executions.cancel",
        "run.jobs.run",
        "run.jobs.runWithOverrides",
      ]
      su = [
        "run.jobs.create",
        "run.jobs.delete",
        "run.jobs.setIamPolicy",
      ]
    }
    worker = {
      r = [
        "run.workerpools.get",
        "run.workerpools.getIamPolicy",
        "run.workerpools.list",
        "run.operations.get",
        "run.operations.list",
        "run.revisions.get",
        "run.revisions.list",
      ]
      w = [
        "run.workerpools.update",
      ]
      x = [
        "run.workerpools.update",
      ]
      su = [
        "run.workerpools.create",
        "run.workerpools.delete",
      ]
    }
  }
}
