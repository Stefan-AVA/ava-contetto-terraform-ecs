variable "account_id" {
  type = string
}

variable "app_name" {
  type = string
}

variable "service_name" {
  type = string
}

variable "env" {
  type = string
}

variable "region" {
  type = string
}

variable "ecr" {
  type = string
}

variable "repo_name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "listener_arn" {
  type = string
}

variable "path_pattern" {
  type    = string
  default = "/"
}

variable "cluster_name" {
  type = string
}

variable "container_port" {
  type    = number
  default = 80
}

variable "health_check_path" {
  type     = string
  nullable = true
}


variable "max_capacity" {
  type    = number
  default = 3
}

variable "min_capacity" {
  type    = number
  default = 1
}

variable "desired_count" {
  type    = number
  default = 1
}

variable "cpu" {
  type    = number
  default = 256
}

variable "memory" {
  type    = number
  default = 512
}
