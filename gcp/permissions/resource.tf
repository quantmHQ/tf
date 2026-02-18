locals {
  resourcemanager = {
    r = [
      "resourcemanager.projects.get",
      "resourcemanager.projects.getIamPolicy",
      "resourcemanager.projects.list",
    ]
    w = [
      "resourcemanager.projects.updateLiens",
    ]
    x = []
    su = [
      "resourcemanager.projects.setIamPolicy",
      "resourcemanager.projects.update",
    ]
  }
}
