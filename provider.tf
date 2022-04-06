provider "google" {
  credentials = "service-account.json"
}
provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}