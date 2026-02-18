locals {
  artifacts__common = {
    r = [
      "artifactregistry.files.get",
      "artifactregistry.files.list",
      "artifactregistry.packages.get",
      "artifactregistry.packages.list",
      "artifactregistry.tags.get",
      "artifactregistry.tags.list",
      "artifactregistry.versions.get",
      "artifactregistry.versions.list",
    ]
    w = [
      "artifactregistry.repositories.deleteArtifacts",
      "artifactregistry.repositories.uploadArtifacts",
      "artifactregistry.tags.create",
      "artifactregistry.tags.delete",
      "artifactregistry.tags.update",
    ]
    x = [
      "artifactregistry.files.get",
      "artifactregistry.tags.get",
      "artifactregistry.repositories.downloadArtifacts",
    ]
    su = []
  }
  artifacts = {
    repo = {
      r = [
        "artifactregistry.locations.get",
        "artifactregistry.locations.list",
        "artifactregistry.projectsettings.get",
        "artifactregistry.repositories.get",
        "artifactregistry.repositories.getIamPolicy",
        "artifactregistry.repositories.list",
        "artifactregistry.repositories.listEffectiveTags",
        "artifactregistry.repositories.listTagBindings",
      ]
      w = []
      x = [
        "artifactregistry.repositories.readViaVirtualRepository",
      ]
      su = [
        "artifactregistry.repositories.create",
        "artifactregistry.repositories.delete",
        "artifactregistry.repositories.setIamPolicy",
        "artifactregistry.repositories.update",
      ]
    }

    docker = {
      r = distinct(concat(
        local.artifacts__common.r,
        [
          "artifactregistry.dockerimages.get",
          "artifactregistry.dockerimages.list",
        ],
      ))
      w = local.artifacts__common.w

      x = distinct(concat(
        local.artifacts__common.w,
        [
          "artifactregistry.dockerimages.get",
        ],
      ))
      su = []
    }

    maven = {
      r = distinct(concat(
        local.artifacts__common.r,
        [
          "artifactregistry.mavenartifacts.get",
          "artifactregistry.mavenartifacts.list",
        ],
      ))
      w = local.artifacts__common.w
      x = [
        "artifactregistry.repositories.downloadArtifacts",
      ]
      su = []
    }

    npm = {
      r = distinct(concat(
        local.artifacts__common.r,
        [
          "artifactregistry.npmpackages.get",
          "artifactregistry.npmpackages.list",
        ],
      ))
      w = local.artifacts__common.w
      x = [
        "artifactregistry.repositories.downloadArtifacts",
      ]
      su = []
    }
    python = {
      r = distinct(concat(
        local.artifacts__common.r,
        [
          "artifactregistry.pythonpackages.get",
          "artifactregistry.pythonpackages.list",
        ],
      ))
      w = local.artifacts__common.w
      x = [
        "artifactregistry.repositories.downloadArtifacts",
      ]
      su = []
    }
  }
}
