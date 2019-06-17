variable "name" {
  description = "The name of the VPC."
}

variable "cidr" {
  description = "The CIDR of the VPC."
}

variable "public_subnet" {
  description = "The public subnet to create."
}

variable "enable_dns_hostnames" {
  description = "Should be true if you want to use private DNS within the VPC"
  default     = true
}

variable "enable_dns_support" {
  description = "Should be true if you want to use private DNS within the VPC"
  default     = true
}

variable "whitelist_ip" {
  default     = ["x.x.x.x/32"] #my ip
  type        = "list"
  description = "List of IPs that are allowed to connect"
}

output "public_subnet_id" {
  value = "${aws_subnet.public.id}"
}

output "vpc_id" {
  value = "${aws_vpc.tfb.id}"
}

output "cidr" {
  value = "${aws_vpc.tfb.cidr_block}"
}

output "security_group_instances" {
  value = "${aws_security_group.instances.id}"
}

output "security_group_lb" {
  value = "${aws_security_group.lb.id}"
}
