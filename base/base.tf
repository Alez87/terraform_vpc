# Terraform example test2

/*terraform {
  required_version = ">= 0.10.6"
  backend "s3" {
    region     = "us-east-1"
    bucket     = "tf-state-altran"
    # lock_table = "ts-state-lock-altran"
    key        = "alessandro/terraform.state"
    # encrypt = "true"
  }
}*/

provider "aws" {
  region = "${var.region}"
}

provider "aws" {
  #  access_key = "${var.access_key}"
  #  secret_key = "${var.secret_key}"
  region = "${var.region}"

  alias = "nvirginia1"
}

provider "aws" {
  #  access_key = "${var.access_key}"
  #  secret_key = "${var.secret_key}"
  region = "${var.region}"

  alias = "nvirginia2"
}

module "vpc" {
  source        = "./vpc"
  name          = "web"
  cidr          = "10.0.0.0/16"
  public_subnet = "10.0.1.0/24"

  providers = {
    "aws" = "aws.nvirginia1"
  }
}

resource "aws_instance" "base" {
  ami = "${lookup(var.ami, var.region)}"
  # otherwise: ami = var.ami[“us-east-1”]

  instance_type               = "${var.instance_type}"
  key_name                    = "${var.key_name}"
  subnet_id                   = "${module.vpc.public_subnet_id}"
  associate_public_ip_address = true
  #user_data                  = "${file("files/bootstrap.sh")}" #without config. manag.

  #vpc_security_group_ids = "${var.security_group_list}"
  vpc_security_group_ids = ["${module.vpc.security_group_instances}"]

  tags {
    Name = "web-${format("%03d", count.index)}"
  }

  count = "${length(var.instance_ips)}" #count = 2

  # configuration management:
  connection {
    user        = "ubuntu"
    private_key = "${file(var.key_path)}"
  }
  provisioner "file" {
    content     = "${element(data.template_file.index.*.rendered, count.index)}"
    destination = "/tmp/index.html"
  }
  provisioner "remote-exec" {
    script = "files/bootstrap_puppet.sh"
  }
  provisioner "remote-exec" { 
    inline = ["sudo mv /tmp/index.html /var/www/html/index.html"]
  }
}

data "template_file" "index" {
  count    = "${length(var.instance_ips)}"
  template = "${file("files/index.html.tpl")}"
  vars = {
    hostname = "web-${format("%03d", count.index+1)}"
  }
}

resource "aws_elb" "base" {
  name    = "web-elb"
  subnets = ["${module.vpc.public_subnet_id}"]
  security_groups = ["${module.vpc.security_group_lb}"]

  listener = {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  instances = ["${aws_instance.base.*.id}"]
}

/*
resource "aws_eip" "base" {
  count    = "${length(var.instance_ips)}"
  instance = "${element(aws_instance.base.*.id, count.index)}"
  #instance = "${aws_instance.base.*.id}"
  vpc = true
}
*/
