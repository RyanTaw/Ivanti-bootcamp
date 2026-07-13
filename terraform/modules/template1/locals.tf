locals {
  prefix = "${var.resource_name}"

  tags = {
    Environment = "DEV"
    Email       = "ryan4shift@gmail.com"
    Owner       = "ryan4shift@gmail.com"
    Project     = "bootcamp"
  }
}