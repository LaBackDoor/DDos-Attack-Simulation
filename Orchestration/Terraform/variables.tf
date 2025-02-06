# variables.tf
variable "template_name" {
  description = "Name of the source VM template"
  type        = string
  default     = "DDoS Ubuntu Template"
}

variable "resource_pool" {
  description = "Resource pool for VM deployment"
  type        = string
  default     = "Subnet A"
}

variable "network_adapter" {
  description = "Network adapter name"
  type        = string
  default     = "ds-resh-294"
}

variable "vm_count" {
  description = "Number of VMs to deploy"
  type        = number
  default     = 60
}

variable "network_config" {
  description = "Network configuration"
  type = object({
    network     = string
    gateway     = string
    dns_server  = string
    start_ip    = string
    netmask     = string
  })

  sensitive = true

  default = {
    network     = "10.0.1.0"
    gateway     = "10.0.1.0"
    dns_server  = "10.0.1.0"
    start_ip    = "10.0.1.160"
    netmask     = "255.255.255.0"
  }
}

variable "vm_name_prefix" {
  description = "Prefix for VM names"
  type        = string
  default     = "ubuntu-vm"
}