locals {
  /*
   Permissions with the principal of least privilege.

   r:  read only permissions.
   w:  Write/modify resource config, gennerally during ci/cd.
   x:  Minimum runtime permissions required to operate the resource.
   su: Superuser/Administer resource lifecycle & access control (create/delete top-level resources, set IAM).
  */

  storage = {
    r = [
      "storage.buckets.get",
      "storage.buckets.getIamPolicy",
      "storage.buckets.list",
      "storage.objects.get",
      "storage.objects.getIamPolicy",
      "storage.objects.list",
      "storage.multipartUploads.listParts",
    ]
    w = [
      "storage.objects.create",
      "storage.objects.createContext",
      "storage.objects.delete",
      "storage.objects.deleteContext",
      "storage.objects.list",
      "storage.objects.move",
      "storage.objects.overrideUnlockedRetention",
      "storage.objects.restore",
      "storage.objects.setIamPolicy",
      "storage.objects.setRetention",
      "storage.objects.update",
      "storage.objects.updateContext",
      "storage.multipartUploads.create",
      "storage.multipartUploads.abort",
    ]
    x = []
    su = [
      "storage.buckets.create",
      "storage.buckets.delete",
      "storage.buckets.update",
      "storage.buckets.setIamPolicy",
      "storage.objects.setIamPolicy",
      "storage.managedFolders.create",
      "storage.managedFolders.delete",
      "storage.managedFolders.get",
      "storage.managedFolders.list",
      "storage.managedFolders.getIamPolicy",
      "storage.managedFolders.setIamPolicy",
    ]
  }
}
