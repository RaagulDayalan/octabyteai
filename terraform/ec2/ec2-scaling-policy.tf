resource "aws_autoscaling_policy" "app-scale-up-policy" {
  autoscaling_group_name = aws_autoscaling_group.app_asg.name
  name                   = "${var.infra_prefix}-app-asg-scale-up-policy"
  policy_type            = "SimpleScaling"
  adjustment_type = "ChangeInCapacity"
  scaling_adjustment = 1
  enabled = true 
  cooldown = 300 
}
resource "aws_autoscaling_policy" "app-scale-down-policy" {
  autoscaling_group_name = aws_autoscaling_group.app_asg.name
  name                   = "${var.infra_prefix}-app-asg-scale-down-policy"
  policy_type            = "SimpleScaling"
  adjustment_type = "ChangeInCapacity"
  scaling_adjustment = -1
  enabled = true 
  cooldown = 300 
}


resource "aws_cloudwatch_metric_alarm" "app-scale-up-alarm" {
  alarm_name                = "${var.infra_prefix}-app-scale-up-alarm"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = 2
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = 300
  statistic                 = "Average"
  threshold                 = 70
  alarm_description         = "This metric monitors ec2 cpu utilization, if it goes above 70% for 2 periods it will trigger an alarm."
  insufficient_data_actions = []
  alarm_actions = [
      "${aws_autoscaling_policy.app-scale-up-policy.arn}"
  ]
}
resource "aws_cloudwatch_metric_alarm" "app-scale-down-alarm" {
  alarm_name                = "${var.infra_prefix}-app-scale-down-alarm"
  comparison_operator       = "LessThanOrEqualToThreshold"
  evaluation_periods        = 2
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = 300
  statistic                 = "Average"
  threshold                 = 40
  alarm_description         = "This metric monitors ec2 cpu utilization, if it goes below 40% for 2 periods it will trigger an alarm."
  insufficient_data_actions = []
  alarm_actions = [
      "${aws_autoscaling_policy.app-scale-down-policy.arn}"
  ]
}
