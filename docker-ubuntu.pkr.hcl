packer {
  required_plugins {
    docker = {
      version = ">= 0.0.7"
      source  = "github.com/hashicorp/docker"
    }
  }
}

variable "docker_image" {
    type = string
    default = "ubuntu:xenial"
}

source "docker" "ubuntu" {
  image  = var.docker_image
  commit = true
}

source "docker" "ubuntu-bionic" {
    image = "ubuntu:bionic"
    commit = true
}

build {
  name = "learn-packer"
  sources = [
    "source.docker.ubuntu",
    "source.docker.ubuntu-bionic",
  ]

  provisioner "shell" {
    environment_vars = [
        "F00=hello world",
    ]
    inline = [
        "echo adding file to docker container",
        "echo \"F00 is $F00\" > example.txt",
    ]
  }

  provisioner "shell"{
    inline = ["echo Runnig ${var.docker_image} Docker image."]
  }

  post-processor "docker-tag" {
    repository = "learn-packer"
    tags = ["ubuntu-xenial", "packer-rocks"]
    only = ["docker.ubuntu"]
  }

  post-processor "docker-tag" {
    repository = "learn-packer"
    tags = ["ubuntu-bionix", "packer-sucks"]
    only = ["docker.ubuntu-bionic"]
  }

}