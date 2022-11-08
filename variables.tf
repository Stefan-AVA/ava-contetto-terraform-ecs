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
  type = string
}

variable "cluster_id" {
  type = string
}

variable "cluster_name" {
    type = string
}

variable "container_port" {
  type = number
}

variable "health_check_path" {
  type = string
}