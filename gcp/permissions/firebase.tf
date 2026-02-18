locals {
  firebase = {
    auth = {
      r = [
        "firebaseauth.configs.get",
        "firebaseauth.users.get",
      ]
      w = [
        "firebaseauth.configs.update",
        "firebaseauth.users.update",
      ]
      x = [
        "firebaseauth.users.createSession",
        "firebaseauth.users.sendEmail",
      ]
      su = [
        "firebaseauth.configs.create",
        "firebaseauth.users.create",
        "firebaseauth.users.delete",
      ]
    }

    hosting = {
      r = [
        "firebasehosting.sites.get",
        "firebasehosting.sites.list",
      ]
      w = [
        # This is for updating an existing site, like deploying a new version.
        "firebasehosting.sites.update",
      ]
      x = [] # Hosting itself doesn't have a direct "execute" action for a runtime.
      su = [
        "firebasehosting.sites.create",
        "firebasehosting.sites.delete",
      ]
    }

    projects = {
      r = [
        "firebase.projects.get",
        "firebase.projects.list",
      ]
      w = [
        "firebase.projects.update",
      ]
      x = []
      su = [
        "firebase.projects.create",
        "firebase.projects.delete",
      ]
    }

    clients = {
      r = [
        "firebase.clients.get",
        "firebase.clients.list",
      ]
    }
  }
}
