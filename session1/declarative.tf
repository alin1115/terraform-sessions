resource "aws_instance" "example" {
    count = 1
    ami           = "ami-0affd4508a5d2481b"
    instance_type = "t2.micro"
}
