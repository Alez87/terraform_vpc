variable "access_key" {
  default     = "access_key"          #env variable
  type        = "string"
  description = "The AWS access key."
}

variable "secret_key" {
  default     = "secret_key"          #env variable
  type        = "string"
  description = "The AWS secret key."
}

variable "instance_type" {
  default     = "t2.micro"
  type        = "string"
  description = "Type of instance EC2"
}

variable "region" {
  default     = "us-east-1"
  type        = "string"
  description = "The AWS region"
}

variable "key_name" {
  default     = "myKeyPair"
  type        = "string"
  description = "The AWS key pair to use for resources"
}

variable "key_path" {
  default     = "ssh_key/myKeyPair.pem"
  type        = "string"
  description = "The AWS key pair path to use for resources"
}

variable "region_list" {
  default     = ["us-east-1a", "us-east-1b"]
  type        = "list"
  description = "The AWS region list"
}

variable "ami" {
  default = {
    us-east-1 = "ami-0d729a60"
    us-west-1 = "ami-0d729a60"
  }

  type        = "map"
  description = "AMIs to use per region"
}

variable "instance_ips" {
  default     = ["10.0.1.20", "10.0.1.21"]
  type        = "list"
  description = "List of IPs available for instances"
}
