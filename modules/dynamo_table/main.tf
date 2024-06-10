locals {
  name                 = "${var.project}-${var.environment}-${var.name}"
  max_capacity_reading = coalesce(var.reading_max_capacity, var.environment == "production" ? 30 : 5)
  min_capacity_reading = coalesce(var.reading_min_capacity, var.environment == "production" ? 3 : 1)
  reading_target_value = coalesce(var.reading_target_value, var.environment == "production" ? 60 : 70)
  max_capacity_writing = coalesce(var.writing_max_capacity, var.environment == "production" ? 30 : 5)
  min_capacity_writing = coalesce(var.writing_min_capacity, var.environment == "production" ? 3 : 1)
  writing_target_value = coalesce(var.writing_target_value, var.environment == "production" ? 60 : 70)
  write_capacity       = coalesce(var.write_capacity, var.environment == "production" ? 20 : 5)
  read_capacity        = coalesce(var.read_capacity, var.environment == "production" ? 20 : 5)
  enable_alarms        = var.billing_mode == "PAY_PER_REQUEST" ? false : var.environment == "production" ? true : var.enable_alarms
}


resource "aws_dynamodb_table" "dynamo_table" {
  name             = local.name
  read_capacity    = var.billing_mode == "PAY_PER_REQUEST" ? 0 : local.min_capacity_reading
  write_capacity   = var.billing_mode == "PAY_PER_REQUEST" ? 0 : local.min_capacity_writing
  hash_key         = var.hash_key
  range_key        = var.range_key
  stream_enabled   = var.stream_enabled
  stream_view_type = var.stream_type
  billing_mode     = var.billing_mode


  dynamic "attribute" {
    for_each = var.attributes
    content {
      name = attribute.value.name
      type = attribute.value.type
    }
  }

  dynamic "global_secondary_index" {
    for_each = var.global_secondary_indexes
    content {
      hash_key           = global_secondary_index.value.hash_key
      name               = global_secondary_index.value.name
      projection_type    = global_secondary_index.value.projection_type
      write_capacity     = local.write_capacity
      read_capacity      = local.read_capacity
      non_key_attributes = global_secondary_index.value.non_key_attributes
      range_key          = try(global_secondary_index.value.range_key, null)
    }
  }

  dynamic "local_secondary_index" {
    for_each = var.local_secondary_indexes
    content {
      range_key          = local_secondary_index.value.range_key
      name               = local_secondary_index.value.name
      projection_type    = local_secondary_index.value.projection_type
      non_key_attributes = local_secondary_index.value.non_key_attributes
    }
  }

  point_in_time_recovery {
    enabled = var.recovery
  }

  tags = {
    Name        = local.name
    Project     = var.project
    Environment = var.environment
  }
}

################################################
# autoscaling policy for dynamo table
################################################

resource "aws_appautoscaling_target" "autoscaling_target_read" {
  count              = var.billing_mode == "PAY_PER_REQUEST" ? 0 : 1
  max_capacity       = local.max_capacity_reading
  min_capacity       = local.min_capacity_reading
  resource_id        = "table/${aws_dynamodb_table.dynamo_table.name}"
  scalable_dimension = "dynamodb:table:ReadCapacityUnits"
  service_namespace  = "dynamodb"
}

resource "aws_appautoscaling_policy" "autoscaling_policy_read" {
  count              = var.billing_mode == "PAY_PER_REQUEST" ? 0 : 1
  name               = "DynamoDBReadCapacityUtilization:table/${aws_dynamodb_table.dynamo_table.name}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.autoscaling_target_read[0].resource_id
  scalable_dimension = aws_appautoscaling_target.autoscaling_target_read[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.autoscaling_target_read[0].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBReadCapacityUtilization"
    }

    target_value = local.reading_target_value
  }
}

resource "aws_appautoscaling_target" "autoscaling_target_write" {
  count              = var.billing_mode == "PAY_PER_REQUEST" ? 0 : 1
  max_capacity       = local.max_capacity_writing
  min_capacity       = local.min_capacity_writing
  resource_id        = "table/${aws_dynamodb_table.dynamo_table.name}"
  scalable_dimension = "dynamodb:table:WriteCapacityUnits"
  service_namespace  = "dynamodb"
}

resource "aws_appautoscaling_policy" "autoscaling_policy_write" {
  name               = "DynamoDBWriteCapacityUtilization:table/${aws_dynamodb_table.dynamo_table.name}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.autoscaling_target_write[0].resource_id
  scalable_dimension = aws_appautoscaling_target.autoscaling_target_write[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.autoscaling_target_write[0].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBWriteCapacityUtilization"
    }

    target_value = local.writing_target_value
  }
}


################################################################################################################
#max_auto_scaling_capacity_reached
################################################################################################################

resource "aws_cloudwatch_metric_alarm" "max-asg-capacity-reading" {
  count                     = local.enable_alarms ? 1 : 0
  alarm_name                = "${local.name}-max-reading-asg-capacity"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = 1
  threshold                 = local.max_capacity_reading
  alarm_description         = "reading autoscaling has been at maximum capacity for at least ten minutes, please increase the max capacity to avoid failures"
  insufficient_data_actions = []
  alarm_actions             = var.alarm_actions
  ok_actions                = var.ok_actions
  metric_query {
    id          = "m1"
    return_data = true
    label       = "Provisioned Read Capacity Units"
    metric {
      metric_name = "ProvisionedReadCapacityUnits"
      stat        = "Maximum"
      unit        = "Count"
      namespace   = "AWS/DynamoDB"
      period      = 600
      dimensions  = {
        "TableName" = aws_dynamodb_table.dynamo_table.name
      }
    }
  }
}

resource "aws_cloudwatch_metric_alarm" "max-asg-capacity-writing" {
  count                     = local.enable_alarms ? 1 : 0
  alarm_name                = "${local.name}-max-writing-asg-capacity"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = 1
  threshold                 = local.max_capacity_reading
  alarm_description         = "writing autoscaling has been at maximum capacity for at least ten minutes, please increase the max capacity to avoid failures"
  insufficient_data_actions = []
  alarm_actions             = var.alarm_actions
  ok_actions                = var.ok_actions
  metric_query {
    id          = "m1"
    return_data = true
    label       = "Provisioned Write Capacity Units"
    metric {
      metric_name = "ProvisionedWriteCapacityUnits"
      stat        = "Maximum"
      unit        = "Count"
      namespace   = "AWS/DynamoDB"
      period      = 600
      dimensions  = {
        "TableName" = aws_dynamodb_table.dynamo_table.name
      }
    }
  }
}