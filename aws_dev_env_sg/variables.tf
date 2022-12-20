variable "host_os" {
  type        = string
  default     = "linux"
  description = "default os being used to deploy"
}

variable "bucket_name" {
  type = string
  default = "dev-sgw"
}

variable "gateway_ip_address" {
  type = string
}

variable "gateway_name" {
  type = string
  default = "dev-gw"
}

variable "gateway_timezone" {
  type = string
  default = "GMT"
}