
resource "aws_lb" "app" {
  name               = "main-app-${random_pet.app.id}-lb"
  internal           = false
  load_balancer_type = "application"
  subnets            = module.vpc.public_subnets
  security_groups    = [module.lb_security_group.this_security_group_id]
}


resource "aws_lb_listener" "app" {
  load_balancer_arn = aws_lb.app.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "forward"
    # target_group_arn = aws_lb_target_group.blue.arn

    forward {
      target_group {
        arn    = aws_lb_target_group.java-app.arn
        weight = 100 # lookup(local.traffic_dist_map[var.traffic_distribution], "blue", 100)
      }

      # target_group {
      #   arn    = aws_lb_target_group.green.arn
      #   weight = lookup(local.traffic_dist_map[var.traffic_distribution], "green", 0)
      # }

      stickiness {
        enabled  = false
        duration = 1
      }
    }
  }
}
