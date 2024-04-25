# # Create an Application Load Balancer (ALB)
# resource "aws_lb" "my_alb" {
#   name               = "my-alb"
#   load_balancer_type = "application"
#   subnets            = [aws_subnet.levelupvpc-public-1.id, aws_subnet.levelupvpc-public-2.id]  # Specify your subnets
#   security_groups    = [aws_security_group.levelup-elb-securitygroup.id]  # Specify your security group(s)
# }

# # Create a listener for the ALB (e.g., HTTP on port 80)
# resource "aws_lb_listener" "my_listener" {
#   load_balancer_arn = aws_lb.my_alb.arn
#   port              = 80
#   protocol          = "HTTP"

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.my_target_group.arn
#   }
# }



# create application load balancer
resource "aws_lb" "application_load_balancer" {
  name               = "${var.environment}-my-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.levelup-elb-securitygroup.id]
  subnets            = [aws_subnet.levelupvpc-public-1.id, aws_subnet.levelupvpc-public-2.id]
  enable_deletion_protection = false

  tags   = {
    Name = "My-alb"
  }
}

# create target group
resource "aws_lb_target_group" "alb_target_group" {
  name        = "${var.environment}-my-tg"
  target_type = "instance"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.levelup_vpc.id

  health_check {
    enabled             = true
    interval            = 60
    path                = "/"
    timeout             = 30
    matcher             = 200
    healthy_threshold   = 5
    unhealthy_threshold = 5
  }

  lifecycle {
    create_before_destroy = true
  }
}

# create a listener on port 80 with redirect action
resource "aws_lb_listener" "alb_http_listener" {
  load_balancer_arn = aws_lb.application_load_balancer.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_target_group.arn
  }
}