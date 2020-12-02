provider "template" {
  version = "2.1.2"
}

data "template_file" "user_data" {
  template = file("${path.module}/default-user-data.sh")

  vars = {
    ecs_cluster_name = local.name
  }
}

resource "aws_launch_configuration" "lc" {
  image_id             = data.aws_ami.ecs_ami.id
  name_prefix          = "${local.name}-"
  instance_type        = local.instance_type
  iam_instance_profile = aws_iam_instance_profile.ecsInstanceProfile.id
  security_groups      = [aws_security_group.default.id]
  user_data            = data.template_file.user_data.rendered
  enable_monitoring    = true

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "asg" {
  name                      = local.name
  vpc_zone_identifier       = [aws_subnet.public.id]
  min_size                  = 0
  max_size                  = 64
  health_check_type         = "EC2"
  health_check_grace_period = 60
  default_cooldown          = 30
  termination_policies      = ["OldestInstance"]
  launch_configuration      = aws_launch_configuration.lc.id

  enabled_metrics = [
    "GroupDesiredCapacity",
    "GroupInServiceCapacity",
    "GroupPendingCapacity",
    "GroupMinSize",
    "GroupMaxSize",
    "GroupInServiceInstances",
    "GroupPendingInstances",
    "GroupStandbyInstances",
    "GroupStandbyCapacity",
    "GroupTerminatingCapacity",
    "GroupTerminatingInstances",
    "GroupTotalCapacity",
    "GroupTotalInstances"
  ]

  tags = [{
    "propagate_at_launch" = true
  }]

  protect_from_scale_in = true

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_policy" "up" {
  name                   = "${local.name}-scaleUp"
  scaling_adjustment     = 2
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60
  policy_type            = "SimpleScaling"
  autoscaling_group_name = aws_autoscaling_group.asg.name
}

resource "aws_autoscaling_policy" "down" {
  name                   = "${local.name}-scaleDown"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60
  policy_type            = "SimpleScaling"
  autoscaling_group_name = aws_autoscaling_group.asg.name
}

resource "aws_cloudwatch_metric_alarm" "scaleUp" {
  alarm_name          = "${local.name}-scaleUp"
  alarm_description   = "ECS cluster scaling metric above threshold"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  statistic           = "Average"
  period              = 60
  threshold           = 80
  actions_enabled     = true
  alarm_actions       = [aws_autoscaling_policy.up.arn]

  dimensions = {
    ClusterName = local.name
  }
}

resource "aws_cloudwatch_metric_alarm" "scaleDown" {
  alarm_name          = "${local.name}-scaleDown"
  alarm_description   = "ECS cluster scaling metric under threshold"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  statistic           = "Average"
  period              = 60
  threshold           = 80
  actions_enabled     = true
  alarm_actions       = [aws_autoscaling_policy.down.arn]

  dimensions = {
    ClusterName = local.name
  }
}
