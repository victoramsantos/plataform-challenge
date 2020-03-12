variable "name_prefix" {}
variable "security_groups" {}
variable "instance_type" {}
variable "key_name" {}
variable "ec2_name" {
  default = "Cluster"
}
variable "ami_id" {
  default = "ami-0fc61db8544a617ed"
}
variable "create_before_destroy" {
  default = false
}

variable "default_image" {
}
variable "ec2_port" {
}
variable "container_port" {
}

variable "credential" {
}