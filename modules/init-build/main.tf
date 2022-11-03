resource "null_resource" "build" {
  provisioner "local-exec" {
    command = "make build"
    working_dir = "/"
    environment = {
        TAG = "latest"
        REGISTRY_ID = "366915744137"
        REPOSITORY_REGION = "eu-central-1"
        APP_NAME = "catsapp"
        ENV_NAME = "project"
    }
  }
}