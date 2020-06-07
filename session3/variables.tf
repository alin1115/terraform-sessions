variable "instance_type" {
  type = string
  default = "t2.micro"
  description = "This vaviable is used to set the type of the instance for webserver"
}

variable "webserver_port" {
    type = number
    default = 80
}

variable "ami_id" {
  default = "ami-0affd4508a5d2481b"
}

variable "name" {
  default = "webserver"
}

variable "asg_min" {
  default = "1"
  description = "Minimum number if instances for autoscaling group"
}

variable "asg_max" {
  default = "1"
  description = "Maximum number if instances for autoscaling group"
}

variable "greet" {
  default = "Hello"
}