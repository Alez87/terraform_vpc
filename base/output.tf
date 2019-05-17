output "elb_address" {
  value = "${aws_elb.base.dns_name}"
}

output "addresses" {
  value = "${aws_instance.base.*.public_ip}"
}

output "public_subnet_id" {
  value = "${module.vpc.public_subnet_id}"
}
