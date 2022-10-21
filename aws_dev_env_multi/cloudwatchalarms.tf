resource "aws_cloudwatch_metric_alarm" "devcpu90" {
  count                     = 2
  alarm_name                = "WARNING-dev_node-${count.index+1}CPUUtilization"
  evaluation_periods        = "1"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  metric_name               = "cpu_usage_system"
  namespace                 = "dev/sam"
  period                    = "60"
  statistic                 = "Maximum"
  threshold                 = "90"
  alarm_description         = "This metric monitors ec2 cpu utilization system"
  insufficient_data_actions = []
  alarm_actions             = [aws_sns_topic.dev_topic.arn]
  ok_actions                = [aws_sns_topic.dev_topic.arn]

    dimensions = {
    InstanceId = aws_instance.dev_node[count.index].id
  }
}

resource "aws_cloudwatch_metric_alarm" "devcpuuser90" {
  count                     = 2
  alarm_name                = "WARNING-dev_node-${count.index+1}CPUUtilizationUser"
  evaluation_periods        = "1"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  metric_name               = "cpu_usage_user"
  namespace                 = "dev/sam"
  period                    = "60"
  statistic                 = "Maximum"
  threshold                 = "90"
  alarm_description         = "This metric monitors ec2 cpu utilization user"
  insufficient_data_actions = []
  alarm_actions             = [aws_sns_topic.dev_topic.arn]
  ok_actions                = [aws_sns_topic.dev_topic.arn]

    dimensions = {
    InstanceId = aws_instance.dev_node[count.index].id
  }
}

resource "aws_cloudwatch_metric_alarm" "devcpu95" {
  count                     = 2
  alarm_name                = "CRITICAL-dev_node-${count.index+1}CPUUtilization"
  evaluation_periods        = "1"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  metric_name               = "cpu_usage_system"
  namespace                 = "dev/sam"
  period                    = "30"
  statistic                 = "Maximum"
  threshold                 = "95"
  alarm_description         = "This metric monitors ec2 cpu utilization system"
  insufficient_data_actions = []
  alarm_actions             = [aws_sns_topic.dev_topic.arn]
  ok_actions                = [aws_sns_topic.dev_topic.arn]

    dimensions = {
    InstanceId = aws_instance.dev_node[count.index].id
  }

}

resource "aws_cloudwatch_metric_alarm" "devcpu95user" {
  count                     = 2
  alarm_name                = "CRITICAL-dev_node-${count.index+1}CPUUtilizationUser"
  evaluation_periods        = "1"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  metric_name               = "cpu_usage_user"
  namespace                 = "dev/sam"
  period                    = "30"
  statistic                 = "Maximum"
  threshold                 = "95"
  alarm_description         = "This metric monitors ec2 cpu utilization user"
  insufficient_data_actions = []
  alarm_actions             = [aws_sns_topic.dev_topic.arn]
  ok_actions                = [aws_sns_topic.dev_topic.arn]

    dimensions = {
    InstanceId = aws_instance.dev_node[count.index].id
  }

}

resource "aws_cloudwatch_metric_alarm" "devswap90" {
  count                     = 2
  alarm_name                = "WARNING-dev_node-${count.index+1}SwapUtilization"
  evaluation_periods        = "1"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  metric_name               = "swap_used_percent"
  namespace                 = "dev/sam"
  period                    = "60"
  statistic                 = "Maximum"
  threshold                 = "90"
  alarm_description         = "This metric monitors swap utilization"
  insufficient_data_actions = []
  alarm_actions             = [aws_sns_topic.dev_topic.arn]
  ok_actions                = [aws_sns_topic.dev_topic.arn]

    dimensions = {
    InstanceId = aws_instance.dev_node[count.index].id
  }
}

resource "aws_cloudwatch_metric_alarm" "devswap95" {
  count                     = 2
  alarm_name                = "CRITICAL-dev_node-${count.index+1}SwapUtilization"
  evaluation_periods        = "1"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  metric_name               = "swap_used_percent"
  namespace                 = "dev/sam"
  period                    = "60"
  statistic                 = "Maximum"
  threshold                 = "95"
  alarm_description         = "This metric monitors swap utilization"
  insufficient_data_actions = []
  alarm_actions             = [aws_sns_topic.dev_topic.arn]
  ok_actions                = [aws_sns_topic.dev_topic.arn]

    dimensions = {
    InstanceId = aws_instance.dev_node[count.index].id
  }
}

resource "aws_cloudwatch_metric_alarm" "mem_used90" {
  count                     = 2
  alarm_name                = "WARNING-dev_node-${count.index+1}mem_used"
  evaluation_periods        = "1"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  metric_name               = "mem_used_percent"
  namespace                 = "dev/sam"
  period                    = "60"
  statistic                 = "Maximum"
  threshold                 = "90"
  alarm_description         = "This metric monitors memory utilization"
  insufficient_data_actions = []
  alarm_actions             = [aws_sns_topic.dev_topic.arn]
  ok_actions                = [aws_sns_topic.dev_topic.arn]

    dimensions = {
    InstanceId = aws_instance.dev_node[count.index].id
  }
}

resource "aws_cloudwatch_metric_alarm" "mem_used95" {
  count                     = 2
  alarm_name                = "CRITICAL-dev_node-${count.index+1}mem_used"
  evaluation_periods        = "1"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  metric_name               = "mem_used_percent"
  namespace                 = "dev/sam"
  period                    = "60"
  statistic                 = "Maximum"
  threshold                 = "95"
  alarm_description         = "This metric monitors memory utilization"
  insufficient_data_actions = []
  alarm_actions             = [aws_sns_topic.dev_topic.arn]
  ok_actions                = [aws_sns_topic.dev_topic.arn]

    dimensions = {
    InstanceId = aws_instance.dev_node[count.index].id
  }
}

resource "aws_cloudwatch_metric_alarm" "ec2_instancedisks_low_space" {
    count                     = 2  
    alarm_name                = "WARNING-dev_node-${count.index+1}disk_used"
    comparison_operator       = "GreaterThanOrEqualToThreshold"
    evaluation_periods        = "2"
    metric_name               = "disk_used_percent"
    namespace                 = "dev/sam"
    period                    = "30"
    statistic                 = "Average"
    threshold                 = "90"
    alarm_description         = "This metric monitors root disk utilization"
    insufficient_data_actions = []
    alarm_actions             = [aws_sns_topic.dev_topic.arn]
    ok_actions                = [aws_sns_topic.dev_topic.arn]
    treat_missing_data        = "notBreaching"
  
    dimensions = {
      InstanceId = aws_instance.dev_node[count.index].id
      path       = "/"
      device     = "xvda1"
      fstype     = "ext4"
      ImageId = "ami-09b93cc9c91e4ee20"
      InstanceType = "t2.micro"
    }
}

resource "aws_cloudwatch_metric_alarm" "StatusCheckFailed" {
  count                     = 2
  alarm_name                = "CRITICAL-dev_node-${count.index+1}StatusCheckFailed"
  evaluation_periods        = "1"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  metric_name               = "StatusCheckFailed"
  namespace                 = "AWS/EC2"
  period                    = "300"
  statistic                 = "Maximum"
  threshold                 = "1"
  alarm_description         = "This metric monitors StatusCheckFailed"
  insufficient_data_actions = []
  alarm_actions             = [aws_sns_topic.dev_topic.arn]
  ok_actions                = [aws_sns_topic.dev_topic.arn]

    dimensions = {
    InstanceId = aws_instance.dev_node[count.index].id
  }
}