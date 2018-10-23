# https:#us-west-2.console.aws.amazon.com/vpc/home?region=us-west-2#vpcs:
# console.aws.amazon.com/vpc/
#terraform {
#  required_version = ">= 0.8, < 0.11.9"
#}

provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "example" {
  # ami = "ami-40d28157" # p. 40 Brikman refers to this as Ubuntu 16.04

  # Ubuntu 16.04 build 2018-09-12
  # ami = "ami-0e32ec5bc225539f5"
  # build 2018-10-12:
  ami = "ami-01e0cf6e025c036e4"

  instance_type          = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.instance.id}"]

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, world" > index.html
              nohup busybox httpd -f -p "${var.server_port}" &
              EOF

  tags {
    Name = "terraform-example"
  }
}

resource "aws_security_group" "instance" {
  name = "terraform-example-instance"

  ingress {
    from_port   = "${var.server_port}"
    to_port     = "${var.server_port}"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
