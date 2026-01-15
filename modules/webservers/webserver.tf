resource "aws_launch_template" "webservers-launch-template" {
  name   = "${var.env}-ems-webservers-launch-template"
  image_id      = "${data.aws_ami.ubuntu.id}"
  instance_type = "${data.aws_ec2_instance_types.free_tier_instances_type.instance_types[0]}"

  iam_instance_profile {
    name = var.instance_profile
  }

  user_data = base64encode(templatefile("user-data.sh", {
      ENVIRONMENT =  "${var.env}"
      cw_agent_config = templatefile("cw-agent.json",{
      ENVIRONMENT = "${var.env}"
      })
    }))

  vpc_security_group_ids = [var.webservers-security-group-id]
  key_name = var.webservers-key-pair-key_name
  
#   root_block_device {
#     volume_type = "gp2"
#     volume_size = "20"
#   }
}

resource "aws_autoscaling_group" "webserver-autoscaling-group" {
  name                      = "${var.env}-ems-webserver-autoscaling-group"
  max_size                  = 2
  min_size                  = 1
  health_check_grace_period = 30
  health_check_type         = "EC2"
  desired_capacity          = 1
  force_delete              = true
  launch_template {
        id = aws_launch_template.webservers-launch-template.id   
  }      
  vpc_zone_identifier       = [var.public_subnet-1_id, var.public_subnet-2_id]
  target_group_arns         = [var.load-balancer-target-group-arn]
}

#Resource key pair
resource "aws_key_pair" "webservers-key-pair" {
  key_name      = "${var.env}-ems-webservers-key-pair"
  public_key    = file("${var.env}-ems-webservers-key-pair.pub")
}
