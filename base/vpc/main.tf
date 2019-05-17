resource "aws_vpc" "tfb" {
  cidr_block           = "${var.cidr}"
  enable_dns_hostnames = "${var.enable_dns_hostnames}"
  enable_dns_support   = "${var.enable_dns_support}"

  tags {
    Name = "${var.name}"
  }
}

resource "aws_internet_gateway" "tfb" {
  vpc_id = "${aws_vpc.tfb.id}"

  tags {
    Name = "${var.name}-igw"
  }
}

resource "aws_route" "internet_access" {
  route_table_id         = "${aws_vpc.tfb.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.tfb.id}"
}

resource "aws_subnet" "public" {
  vpc_id     = "${aws_vpc.tfb.id}"
  cidr_block = "${var.public_subnet}"

  tags {
    Name = "${var.name}-public"
  }
}

resource "aws_security_group" "instances" {
  #  name        = "${var.environment}-web_host"
  description = "Allow SSH and HTTP to instances"
  vpc_id      = "${aws_vpc.tfb.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = "${var.whitelist_ip}"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${aws_vpc.tfb.cidr_block}"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = "${var.whitelist_ip}"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "lb" {
  #  name        = "${var.environment}-web_host"
  description = "Allow SSH and HTTP to web hosts"
  vpc_id      = "${aws_vpc.tfb.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = "${var.whitelist_ip}"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = "${var.whitelist_ip}"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
