
#Create aws application loadbalancere
#Create ALB
resource "aws_lb" "e-learning-alb" {
  name               = "${var.project_name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.webserver_security_group.id]
  subnets            = [aws_subnet.public_subnets[0].id, aws_subnet.public_subnets[1].id]

  enable_deletion_protection = false

  tags = {
    Name = "${var.project_name}-alb"
  }
}

#create target group
resource "aws_alb_target_group" "e-learning-ntg" {
  name        = "${var.project_name}-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.e-learning.id
  target_type = "ip"

  health_check {
    enabled             = true
    healthy_threshold   = 5
    interval            = 30
    #protocol            = "HTTP"
    matcher             = "200"
    timeout             = 5
    path                = "/"
    unhealthy_threshold = 3
  }

  lifecycle {
    create_before_destroy = true
  }
}

# create a listener on port 80 with redirect action
resource "aws_lb_listener" "e-learning-http" {
  load_balancer_arn = aws_lb.e-learning-alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = 443
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}


# create a listener on port 443 with forward action
resource "aws_lb_listener" "alb_https_listener" {
  load_balancer_arn = aws_lb.e-learning-alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.acm_certificate.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.e-learning-ntg.arn
  }
}


#Create ECR
resource "aws_ecr_repository" "elearning-repo" {
  name                 = "elearning-repo"
  image_tag_mutability = "IMMUTABLE"
}

resource "aws_ecr_lifecycle_policy" "e-learning" {
  repository = aws_ecr_repository.elearning-repo.name

  policy = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Keep last 10 images",
            "selection": {
                "tagStatus": "tagged",
                "tagPrefixList": ["v"],
                "countType": "imageCountMoreThan",
                "countNumber": 10
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF

}


#create a cluster
resource "aws_iam_role" "ecs_task_role" {
  name = "e-learningTaskRole"

  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "ecs-tasks.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
}
]
}
EOF
}

#Task role
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "e-learning-ecsTaskExecutionRole"

  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "ecs-tasks.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
}
]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecs-task-execution-role-policy-attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}


# Creating task definition without json file(create some variables)
resource "aws_ecs_task_definition" "e-learning-td" {
  family = "e-learning-service"
  #task_role_arn            = aws_iam_role.ecs_task_execution_role.arn
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  container_definitions = jsonencode([
    {

      name      = "e-learning-web"
      cpu       = 1024
      memory    = 2048
      image     = "public.ecr.aws/i5f9a9t2/mysite:latest"
      essential = true
      portMappings = [
        {
          protocol      = "tcp"
          containerPort = 80
          hostPort      = 80
        }
      ]
    }
  ])
}

resource "aws_ecs_cluster" "e-learning-cluster" {
  name = "myapp-cluster"
}


#Create cluster service
resource "aws_ecs_service" "elearningservice" {
  name            = "e-learning-service"
  cluster         = aws_ecs_cluster.e-learning-cluster.id
  task_definition = aws_ecs_task_definition.e-learning-td.arn
  desired_count   = var.app_count
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [aws_security_group.webserver_security_group.id]
    subnets          = [aws_subnet.private_subnets[0].id, aws_subnet.private_subnets[1].id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.e-learning-ntg.arn
    container_name   = "e-learning-web"
    container_port   = 80
  }

  lifecycle {
    ignore_changes = [task_definition, desired_count]
  }
}

# Create autoscaling group
resource "aws_appautoscaling_target" "e-learning-asg" {
  max_capacity       = 4
  min_capacity       = 2
  resource_id        = "service/${aws_ecs_cluster.e-learning-cluster.name}/${aws_ecs_service.elearningservice.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

#Application auto-scaling policy
resource "aws_appautoscaling_policy" "ecs_policy_memory" {
  name               = "memory-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.e-learning-asg.resource_id
  scalable_dimension = aws_appautoscaling_target.e-learning-asg.scalable_dimension
  service_namespace  = aws_appautoscaling_target.e-learning-asg.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }

    target_value = 80
  }
}

