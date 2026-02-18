variable "projectName" {
  description = "The name of the project"
  type        = string
  default     = "fiap-eks-terraform"
}

variable "region_default" {
  description = "The default region"
  type        = string
  default     = "us-east-1"
}

variable "cidr_vpc" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "tags" {
  description = "A map of tags to assign to resources"
  type        = map(string)
  default = {
    Name = "fiap-eks-terraform"
  }

}

variable "instance_type" {
  description = "The instance type for the EKS nodes"
  type        = string
  default     = "t3.small"
}

variable "api_backend_url" {
  description = "The backend base URL (including protocol), e.g., http://<elb-dns>:8080. The HTTP API proxy route is ANY /{proxy+}, so the full incoming path (e.g., /v1/ping) is forwarded as-is to this base URL."
  type        = string
  default     = "http://a9c25c256e87143a98d6817f703df844-1100326549.us-east-1.elb.amazonaws.com:8080"
}

variable "jwt_secret" {
  description = "Segredo HS256 usado para assinar/validar o JWT emitido pelo /v1/login"
  type        = string
  default     = ""
  sensitive   = true
}
