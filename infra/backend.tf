terraform {
  backend "s3" {
    bucket = "fiap-eks-terraform-01"
    key    = "terraform-aula-tfstate"
    region = "us-east-1"
  }
}
