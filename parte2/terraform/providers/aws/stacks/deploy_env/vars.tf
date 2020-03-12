variable "region" {
  default = "us-east-1"
}

variable "lc_name_prefix" {
  default = "lc-victoramorim"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "key_name" {
  default = "victorplayland"
}

variable "create_before_destroy" {
  default = true
}

variable "ag_name_prefix" {
  default = "ag-victoramorim"
}

variable "min_size" {
  default = "1"
}
variable "max_size" {
  default = "1"
}

variable "subnets" {
  default = ["subnet-022c7c109a4efbd7c", "subnet-0fbfcf71a1bd17a59"]
}

variable "vpc_id" {
  default = "vpc-0008f3605d99e41f1"
}

variable "tg_port" {
  default = 80
}

variable "tg_protocol" {
  default = "HTTP"
}

variable "hc_path" {
  default = "/health"
}
variable "hc_port" {
  default = 80
}
variable "hc_threshold" {
  default = 6
}
variable "hc_unhealthy_threshold" {
  default = 2
}
variable "hc_timeout" {
  default = 2
}
variable "hc_interval" {
  default = 5
}
variable "hc_status_code" {
  default = "200"
}

variable "public_subnets" {
  default = ["subnet-0709b247651159751", "subnet-0a5a7834e7803827a"]
}

variable "env_prefix" {
  default = "blue"
}

variable "appname" {
  default = "MyAppName"
}

variable "ec2_port" {
  default = "80"
}
variable "default_image" {
  default = "nginx"
}
variable "container_port" {
  default = "80"
}

variable "credential" {
}