variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "rg-gladwell-aks"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "westus2"
}

variable "cluster_name" {
  description = "Name of the AKS cluster"
  type        = string
  default     = "aks-gladwell-cluster"
}

variable "node_count" {
  description = "Number of nodes in the cluster"
  type        = number
  default     = 2
}

variable "node_vm_size" {
  description = "Size of the VMs"
  type        = string
  default     = "Standard_D2s_v3"
}

variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.33"
}
