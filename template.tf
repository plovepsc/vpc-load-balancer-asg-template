
#----------------------start -----------------
# resource "aws_launch_template" "example" {
#   name_prefix   = "my-launch-template-10-53pm"
#   description   = "my-launch-template-"
#   block_device_mappings {
#     device_name = "/dev/sda1"

#     # Example EBS volume configuration
#     ebs {
#       volume_size = 8
#       volume_type = "gp2"
#     }
#   }
#   credit_specification {
#     cpu_credits = "standard"
#   }

#   # Specify the instance type, AMI, and other instance settings
#   instance_type          = "t2.micro"
#   image_id               = "${var.please-insert-new-ami}"
#   key_name               = "levelup-key"

 
#   # lifecycle {
#   #   create_before_destroy = true
#   # }

#   # Network interfaces configuration
#   network_interfaces {
#     associate_public_ip_address = true
#     subnet_id                   = aws_subnet.levelupvpc-public-1.id
#     security_groups             = [aws_security_group.levelup-instance.id]
#   }

  

#   # Tags for the Launch Template
#   tag_specifications {
#     resource_type = "instance"
#     tags = {
#       Name        = "my-launch-template"
#       Environment = "Production"
#     }
#   }
  
# }

#-------------------------------------end-----------------

#----------------- auto scale start ----------------------
# resource "aws_autoscaling_group" "levelup-autoscaling" {
#   name = "levlup-autoscaling"
#   vpc_zone_identifier = [ aws_subnet.levelupvpc-public-1.id, aws_subnet.levelupvpc-public-2.id ]
#   launch_template {
#     id = aws_launch_template.example.id
#     version = "$Latest"

#   }
#   min_size = 1
#   max_size = 1 
#   desired_capacity = 1
#   health_check_grace_period = 200

#   health_check_type = "ELB"
#   force_delete = true
  
#   tag {
#     key = "Name"
#     value = "levelUp custom ec2 instance"
#     propagate_at_launch = true
#   }

# }

#----------------- end--------------------




resource "aws_launch_template" "my_launch_template" {
  name_prefix   = "${var.environment}-testTemp"
  description   = "My Launch Template"
  
  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      volume_size = 8
      volume_type = "gp2"
    }
  }
  
  network_interfaces {
    device_index         = 0
    associate_public_ip_address = true
    subnet_id            = aws_subnet.levelupvpc-public-1.id
    security_groups      = [aws_security_group.levelup-instance.id]
  }
  
  instance_type = "t2.micro"
  key_name = "levelup-key"
  image_id      = var.please-insert-new-ami
  tags = local.common_tags
}


resource "aws_autoscaling_group" "my_asg" {

  launch_template {
    id      = aws_launch_template.my_launch_template.id
    version = "$Latest"
  }
  name = "${var.environment}-testasg"
  min_size             = 1
  max_size             = 1
  desired_capacity     = 1
  vpc_zone_identifier  = [aws_subnet.levelupvpc-public-1.id, aws_subnet.levelupvpc-public-2.id]  # List of subnet IDs where instances will be launched
  
  # Optional: Additional ASG configuration
  health_check_type    = "ELB"
    termination_policies = [
    "OldestInstance"
  ]
  target_group_arns     = [aws_lb_target_group.alb_target_group.arn]
    tag {
    key                 = "Name"
    value               = "${var.environment}-testasg"
    propagate_at_launch = true
  }
}

# # Create a Target Group
# resource "aws_lb_target_group" "my_target_group" {
#   name     = "my-target-group"
#   port     = 80  # Specify the port your instances are listening on
#   protocol = "HTTP"
#   vpc_id = aws_vpc.levelup_vpc.id

#   health_check {
#     path                = "/"
#     protocol            = "HTTP"
#     timeout             = 5
#     interval            = 30
#     healthy_threshold   = 2
#     unhealthy_threshold = 2
#   }
# }

# # Attach the ALB target group to the Auto Scaling Group
# resource "aws_autoscaling_attachment" "my_asg_attachment" {
#   autoscaling_group_name = aws_autoscaling_group.levelup-autoscaling.name
#   lb_target_group_arn = aws_lb_target_group.my_target_group.arn
  
  
  
# }

# resource "aws_autoscaling_policy" "levelup-cpu-policy" {
#   name = "levelup-cpu-policy"
#   autoscaling_group_name = aws_autoscaling_group.levelup-autoscaling.name
#   adjustment_type = "ChangeInCapacity"
#   scaling_adjustment = "1"
#   cooldown = "200"
#   policy_type = "SimpleScaling"
  
# }

# # auto scaling cloud wathc monitorning 

# resource "aws_cloudwatch_metric_alarm" "levelup-cpu-alarm" {
#   alarm_name = "levelup-cpu-alarm"
#   alarm_description = "Alarm once CPU uses Increase"
#   comparison_operator = "GreaterThanOrEqualThreshold"
#   evaluation_periods = "2"
#   metric_name = "CPUUtilization"
#   namespace = "AWS/EC2"
#   period = "120"
#   statistic = "Average"
#   threshold = "30"

#   dimensions = {
#     "AutoscalingGroupName" = aws_autoscaling_group.levelup-autoscaling.name
#   }
#   actions_enabled = true
#   alarm_actions = [aws_autoscaling_policy.levelup-cpu-policy.arn]

# }


# #Auto Descaling Policy
# resource "aws_autoscaling_policy" "levelup-cpu-policy-scaledown" {
#   name                   = "levelup-cpu-policy-scaledown"
#   autoscaling_group_name = aws_autoscaling_group.levelup-autoscaling.name
#   adjustment_type        = "ChangeInCapacity"
#   scaling_adjustment     = "-1"
#   cooldown               = "200"
#   policy_type            = "SimpleScaling"
# }

# #Auto descaling cloud watch 
# resource "aws_cloudwatch_metric_alarm" "levelup-cpu-alarm-scaledown" {
#   alarm_name          = "levelup-cpu-alarm-scaledown"
#   alarm_description   = "Alarm once CPU Uses Decrease"
#   comparison_operator = "LessThanOrEqualToThreshold"
#   evaluation_periods  = "2"
#   metric_name         = "CPUUtilization"
#   namespace           = "AWS/EC2"
#   period              = "120"
#   statistic           = "Average"
#   threshold           = "10"

#   dimensions = {
#     "AutoScalingGroupName" = aws_autoscaling_group.levelup-autoscaling.name
#   }

#   actions_enabled = true
#   alarm_actions   = [aws_autoscaling_policy.levelup-cpu-policy-scaledown.arn]
# }


