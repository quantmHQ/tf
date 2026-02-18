locals {
  iam = {
    r = [
      "iam.serviceAccounts.get",
      "iam.serviceAccounts.getIamPolicy",
      "iam.serviceAccounts.list",
      "iam.serviceAccountKeys.get",
      "iam.serviceAccountKeys.list",
    ]
    w = [
      "iam.serviceAccountKeys.create",
      "iam.serviceAccountKeys.delete",
      "iam.serviceAccounts.update",
      "iam.serviceAccounts.enable",
      "iam.serviceAccounts.disable",
    ]
    x = [
      "iam.serviceAccounts.actAs",
      "iam.serviceAccounts.getAccessToken",
      "iam.serviceAccounts.getOpenIdToken",
      "iam.serviceAccounts.signBlob",
      "iam.serviceAccounts.signJwt",
    ]
    su = [
      "iam.serviceAccounts.create",
      "iam.serviceAccounts.delete",
      "iam.serviceAccounts.setIamPolicy",
      "iam.serviceAccounts.undelete",
    ]
  }
}
