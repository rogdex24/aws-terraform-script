variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-southeast-1"
}

// Configuration settings for the EC2
variable "config" {
  description = "Infrastructure Configuration"
  type        = map(any)
  default = {
    "ec2" = {
      count         = 1           // the number of EC2 instances
      instance_type = "t4g.small" // the EC2 instance type
      root_vol_size = 8
      root_vol_type = "gp3"
    }
  }
}

variable "database" {
  description = "database config"
  type        = map(any)
  default = {
    mysql_root_pass = "supersecret"
    mysql_user      = "talha"
    mysql_pass      = "talha1234"
    mysql_db_name   = "rogdex"
  }
}

variable "domain" {
  description = "wordpress domain"
  type        = string
}

variable "email" {
  description = "email"
  type        = string
}

# // AWS Access
# variable "access_key" {
#   description = "AWS access key"
#   type        = string
#   sensitive   = true
# }

# variable "secret_key" {
#   description = "AWS secret key"
#   type        = string
#   sensitive   = true
# }
