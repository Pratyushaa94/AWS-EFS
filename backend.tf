terraform {
  backend "s3" {
    bucket  = "prathyusha-tfstatefile-efs"
    key     = "terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}
