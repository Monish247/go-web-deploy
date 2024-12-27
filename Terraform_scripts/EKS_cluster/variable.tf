variable "ssh_key_name" {
  description = "Name of the SSH key pair"
  type        = string
  default     = "prime_clone"  
}
variable "pem_key_path" {
  description = "Path to the PEM key file"
  type        = string
  default     = "./prime_clone.pem"  
}
