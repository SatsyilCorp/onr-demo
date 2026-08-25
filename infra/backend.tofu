terraform {
  backend "s3" {
    bucket = "bharath-opentofu"
    key    = "opentofu/onr/onr-workspace.tfstate"
    region = "us-east-1"
  }
}
