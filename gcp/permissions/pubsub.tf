locals {
  pubsub = {
    publisher = {
      r = [
        "pubsub.topics.get",
        "pubsub.topics.list",
        "pubsub.topics.getIamPolicy",
        "pubsub.schemas.get",           # If using schemas
        "pubsub.schemas.list",          # If using schemas
        "pubsub.schemas.listRevisions", # If using schemas
        "pubsub.schemas.getIamPolicy",  # If using schemas
      ]
      w = [
        "pubsub.schemas.commit",   # If publisher manages schema revisions
        "pubsub.schemas.rollback", # If publisher manages schema revisions
      ]
      x = [
        "pubsub.topics.publish",
        "pubsub.schemas.validate", # If publisher validates before sending
      ]
      su = [
        "pubsub.topics.create",
        "pubsub.topics.delete",
        "pubsub.topics.setIamPolicy",
        "pubsub.topics.update",          # Managing the topic itself
        "pubsub.topics.updateTag",       # Managing the topic itself
        "pubsub.schemas.attach",         # Linking schema to topic
        "pubsub.schemas.create",         # If publisher manages schema lifecycle
        "pubsub.schemas.delete",         # If publisher manages schema lifecycle
        "pubsub.schemas.deleteRevision", # If publisher manages schema lifecycle
        "pubsub.schemas.setIamPolicy",   # If publisher manages schema lifecycle
      ]
    }
    subscriber = {
      r = [
        "pubsub.subscriptions.get",
        "pubsub.subscriptions.list",
        "pubsub.subscriptions.getIamPolicy",
        "pubsub.topics.get",             # To see the source topic
        "pubsub.topics.list",            # To see the source topic
        "pubsub.topics.getIamPolicy",    # To see the source topic policy
        "pubsub.snapshots.get",          # If using snapshots/seeking
        "pubsub.snapshots.list",         # If using snapshots/seeking
        "pubsub.snapshots.getIamPolicy", # If using snapshots/seeking
      ]
      w = [
        "pubsub.subscriptions.modifyAckDeadline", # Granular
        "pubsub.snapshots.update",                # If subscriber manages snapshot metadata
      ]
      x = [
        "pubsub.snapshots.seek",        # If subscriber manages snapshots (needs sub.consume on source sub)
        "pubsub.subscriptions.consume", # High-level
      ]
      su = [
        "pubsub.subscriptions.create", # Needs topics.attachSubscription on topic
        "pubsub.subscriptions.delete",
        "pubsub.subscriptions.setIamPolicy",
        "pubsub.subscriptions.update",           # Managing the subscription itself
        "pubsub.subscriptions.modifyPushConfig", # Managing the subscription itself
        "pubsub.subscriptions.detach",           # Unlinking subscription
        "pubsub.topics.attachSubscription",      # Needed *on topic* to allow subscription creation
        "pubsub.topics.detachSubscription",      # Needed *on topic* to allow subscription deletion/detachment
        "pubsub.snapshots.create",               # If subscriber manages snapshots (needs sub.consume on source sub)
        "pubsub.snapshots.delete",               # If subscriber manages snapshots
        "pubsub.snapshots.setIamPolicy",         # If subscriber manages snapshots
      ]
    }
  }
}
