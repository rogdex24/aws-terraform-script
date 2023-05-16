data "aws_ami" "ubuntu_arm64" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/*"]
  }
  filter {
    name   = "architecture"
    values = ["arm64"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  owners = ["099720109477"] # Canonical
}

data "template_file" "envfile" {
  template = file("./templates/envfile.tpl")

  vars = {
    WORDPRESS_ROOT_PASSWORD = var.database.mysql_root_pass
    WORDPRESS_DB_USER       = var.database.mysql_user
    WORDPRESS_DB_PASSWORD   = var.database.mysql_pass
    mysql_db_name           = var.database.mysql_db_name
    EMAIL                   = var.email
  }
}

data "template_file" "dockercompose" {
  template = file("./templates/docker-compose.tpl")

  vars = {
    WORDPRESS_ROOT_PASSWORD = "$${WORDPRESS_ROOT_PASSWORD}"
    WORDPRESS_DB_USER       = "$${WORDPRESS_DB_USER}"
    WORDPRESS_DB_PASSWORD   = "$${WORDPRESS_DB_PASSWORD}"
    email                   = "$${email}"
    domain                  = var.domain
  }
}

data "template_file" "userdata" {
  template = file("./templates/startup.tpl")

  vars = {
    dockercompose = data.template_file.dockercompose.rendered
    envfile       = data.template_file.envfile.rendered
    EMAIL         = var.email

  }

}
