locals {
  eventarc = {
    r = [
      "eventarc.triggers.get",
      "eventarc.triggers.list",
      "eventarc.triggers.getIamPolicy",
      "eventarc.channels.get",
      "eventarc.channels.list",
      "eventarc.locations.get",
      "eventarc.locations.list",
    ]
    w = [
      # Less common, often covered by 'su' for create/delete
      "eventarc.triggers.update",
      "eventarc.channels.update",
    ]
    x = [
      # Permission required by the service account of the destination service
      # (e.g., Cloud Run, Cloud Functions) to receive events forwarded by Eventarc.
      "eventarc.events.receiveAuditLogWritten",
      "eventarc.events.receiveEvent",
    ]
    su = [
      "eventarc.triggers.create",
      "eventarc.triggers.delete",
      "eventarc.triggers.setIamPolicy",
      "eventarc.channels.create",
      "eventarc.channels.delete",
      "eventarc.channels.setIamPolicy",
    ]
  }
}
