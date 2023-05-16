module "networks" {
  source = "./networks"
}

resource "aws_instance" "wordpress_web" {
  count = var.config.ec2.count

  ami           = data.aws_ami.ubuntu_arm64.id
  instance_type = var.config.ec2.instance_type

  vpc_security_group_ids = [module.networks.wordpress_ec2_sg.id]

  // Startup Script
  user_data = data.template_file.userdata.rendered

  root_block_device {
    volume_size           = var.config.ec2.root_vol_size
    volume_type           = var.config.ec2.root_vol_type
    encrypted             = true
    delete_on_termination = true
  }

  tags = {
    Name = "wp_web_${count.index}"
  }
}

// Elastic IP for the EC2 instance
resource "aws_eip" "wordpress_web_eip" {
  count = var.config.ec2.count

  instance = aws_instance.wordpress_web[count.index].id
  vpc      = true

  tags = {
    Name = "wp_web_eip_${count.index}"
  }
}
