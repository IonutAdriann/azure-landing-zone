variable "project" {
  type = string
  description = "Project name"
}

variable "environment" {
  type = string
  description = "Environment (dev / stage / prod)"
}

variable "location" {
  type = string
  description = "Azure region"
}

variable "subscription_id" {
    type = string 
    default = "c5ba957a-9d8a-432c-80e3-02f476a1361b"
}