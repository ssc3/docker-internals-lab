variable "token" {}

variable "region" {
  default = "sfo1"
}

variable "ssh_fingerprint" {}

variable "pvt_key" {
  default = "./training.key"
}

variable "size" {
  default = "2gb"
}

variable "count" {
  default = "2"
}

variable "image" {
  default = "ubuntu-14-04-x64"
}

variable "name" {
  default = "training"
}
