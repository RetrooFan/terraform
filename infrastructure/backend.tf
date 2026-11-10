terraform {
  backend "s3" {
    bucket       = "krzysieksobol93-terraform-states"
    key          = "terraform-infrastructure.tfstate"
    region       = "eu-central-1"
    use_lockfile = true
    encrypt      = true
    profile      = "krzysieksobol93"
  }
}
