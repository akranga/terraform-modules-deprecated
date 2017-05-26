variable "server" {
  type = "string"
  description = "url of kubernetes cluster"
  default = "http://localhost:8080"
}

variable "apply" {
  type = "string"
  description = "true (default) or false: apply kubeconfig"
  default = "true"
}

variable "ca_pem" {
  type = "string"
  description = "content of ca cert for kubernetes"
}

variable "client_pem" {
  type = "string"
  description = "content of client cert for kubernetes"
}

variable "client_key" {
  type = "string"
  description = "content of client cert private key kubernetes"
}

variable "namespace" {
  type = "string"
  description = "kubenretes namespace"
  default = "default"
}

variable "use_context" {
  type = "string"
  description = "true or false (default): switch current context to this"
  default = "false"
}