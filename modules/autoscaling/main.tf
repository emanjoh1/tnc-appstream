####################################
# AutoScaling
####################################

resource "aws_appautoscaling_target" "user" {
  max_capacity       = var.max_user_fleet_capacity
  min_capacity       = var.min_lrm_stream_instances
  resource_id        = "fleet/${var.aws_account_name}-user-fleet"
  scalable_dimension = "appstream:fleet:DesiredCapacity"
  service_namespace  = "appstream"

  lifecycle {
    ignore_changes = [
      tags_all
    ]
  }

  depends_on = [var.user_fleet]
}

resource "aws_appautoscaling_policy" "user" {
  name               = "${var.aws_account_name}-user-stack-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.user.resource_id
  scalable_dimension = aws_appautoscaling_target.user.scalable_dimension
  service_namespace  = aws_appautoscaling_target.user.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "AppStreamAverageCapacityUtilization"
    }

    target_value       = 60
    scale_in_cooldown  = 900
    scale_out_cooldown = 0
  }
}

resource "aws_appautoscaling_scheduled_action" "sched_start" {
  count              = var.cost_optimization_enabled ? 1 : 0
  name               = "${var.aws_account_name}-sched-start"
  resource_id        = aws_appautoscaling_target.user.resource_id
  scalable_dimension = aws_appautoscaling_target.user.scalable_dimension
  service_namespace  = aws_appautoscaling_target.user.service_namespace
  schedule           = "cron(0 10 ? * MON-FRI *)"

  scalable_target_action {
    min_capacity = var.min_lrm_stream_instances
    max_capacity = var.max_user_fleet_capacity
  }
}

resource "aws_appautoscaling_scheduled_action" "sched_stop" {
  count              = var.cost_optimization_enabled ? 1 : 0
  name               = "${var.aws_account_name}-sched-stop"
  resource_id        = aws_appautoscaling_target.user.resource_id
  scalable_dimension = aws_appautoscaling_target.user.scalable_dimension
  service_namespace  = aws_appautoscaling_target.user.service_namespace
  schedule           = "cron(0 2 ? * MON-FRI *)"

  scalable_target_action {
    min_capacity = 0
    max_capacity = 0
  }
}
