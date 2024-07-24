variable "subscription_id" {
  type        = string
  description = "Azure subscription_id"
  default = []
}

variable "tenant_id" {
  type        = string
  description = "Azure tenant id"
  default = []
}
variable "client_id" {
  type        = string
  description = "Azure client id"
  default = []
}
variable "client_secret" {
  type        = string
  description = "Azure client secret"
  default = []
}

variable "username" {
  type        = string
  description = "O usuario que vai ser usado pra acessar a VM."
  default     = "acmeadmin"
}

variable "password" {
  type        = string
  description = "Senha do usuario default criado."
  default     = "teste@123"
}

variable  "qtdade_resources" {
  type = number
  default = 2
  description = "Quantidade de VMs que deseja subir" 
}

variable "resource_group_location" {
  type        = string
  default     = "eastus"
  description = "Local do grupo de recursos"
}


variable "resource_group_name_prefix" {
  type        = string
  default     = "resource_group"
  description = "Prefixo para o grupo de recursos que vai ser combinado com um nome randomico."
}