
variable "aws_region" {
  type = string
}

variable "access_key" {
  type = string
}
variable "secret_key" {
  type = string
}

variable "aws_instance" {
  type = object({
    ami = string
    instance_type = string
  })
}