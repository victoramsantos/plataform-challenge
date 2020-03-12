data "template_file" "user_data" {
  template = "${file("${path.module}/setup.tpl")}"
  vars = {
    image = "${var.default_image}"
    ec2_port = "${var.ec2_port}"
    container_port = "${var.container_port}"
    credential = "${var.credential}"
  }
}

resource "aws_launch_configuration" "lifecycle_lc" {
  name_prefix = var.name_prefix
  key_name = var.key_name
  image_id = var.ami_id
  instance_type = var.instance_type
  security_groups = var.security_groups
  user_data = data.template_file.user_data.rendered

  lifecycle {
    create_before_destroy = true
  }
}