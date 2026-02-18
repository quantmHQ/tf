locals {
  kms = {
    r = [
      "cloudkms.cryptoKeyVersions.get",
      "cloudkms.cryptoKeyVersions.list",
      "cloudkms.cryptoKeys.get",
      "cloudkms.cryptoKeys.getIamPolicy",
      "cloudkms.cryptoKeys.list",
      "cloudkms.keyRings.get",
      "cloudkms.keyRings.getIamPolicy",
      "cloudkms.keyRings.list",
      "cloudkms.locations.get",
      "cloudkms.locations.list",
      "cloudkms.ekmConfigs.get",
      "cloudkms.ekmConnections.get",
      "cloudkms.ekmConnections.list",
      "cloudkms.importJobs.get",
      "cloudkms.importJobs.list",
    ]
    w = [
      "cloudkms.cryptoKeyVersions.update",
      "cloudkms.cryptoKeys.update",
    ]
    x = [
      "cloudkms.cryptoKeyVersions.useToDecrypt",
      "cloudkms.cryptoKeyVersions.useToEncrypt",
      "cloudkms.cryptoKeyVersions.useToSign",
      "cloudkms.cryptoKeyVersions.useToVerify",
      "cloudkms.cryptoKeyVersions.useForMacSign",
      "cloudkms.cryptoKeyVersions.useForMacVerify",
    ]
    su = [
      "cloudkms.cryptoKeyVersions.destroy",
      "cloudkms.cryptoKeys.create",
      "cloudkms.cryptoKeys.delete",
      "cloudkms.cryptoKeys.setIamPolicy",
      "cloudkms.importJobs.create",
      "cloudkms.keyRings.create",
      "cloudkms.keyRings.setIamPolicy",
    ]
  }
}
