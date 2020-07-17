provider "docker" {
  }

resource "docker_container" "nginx" {
  image = "nginx"
  name  = "enginecks"
  ports {
    internal = "80"
    external = "80"
  }
}

resource "docker_image" "nginx" {
  name = "nginx:latest"
}
