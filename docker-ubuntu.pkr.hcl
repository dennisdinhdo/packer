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

build {
  name = "learn-packer"
  sources = [
    "source.docker.ubuntu"
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

  provisioner "shell" {
    inline = ["echo Runnig ${var.docker_image} Docker image and test this change in github desktop"]
  }

}