variable "aws_credentials" {
  type = object({
    access_key = string
    secret_key = string
  })
}

variable "aws_region" {
  type = string
}

variable "aws_instance" {
  type = object({
    ami = string
    instance_type = string
  })
}