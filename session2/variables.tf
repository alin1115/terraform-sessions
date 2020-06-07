variable "instance_type" {
  type = string
  default = "t2.micro"
  description = "This vaviable is used to set the type of the instance for webserver"
}

variable "webserver_port" {
    type = number
    default = 80
}