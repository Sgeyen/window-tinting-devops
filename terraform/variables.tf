variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "wiz-eks-cluster"
}

variable "aws_access_key" {
  description = "AWS Access Key"
  type        = string
}

variable "aws_secret_key" {
  description = "AWS Secret Key"
  type        = string
}
