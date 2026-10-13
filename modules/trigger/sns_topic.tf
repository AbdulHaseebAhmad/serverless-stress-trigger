resource aws_sns_topic stress_updates_topic {
  name = "${var.env_name}_stress_updates_topic.fifo"
  fifo_topic = true

  tags = {
    Environment = var.env_name
    Name = "${var.env_name}_stress_updates_topic.fifo"
  }
}

resource aws_sns_topic_subscription stress_updates_sqs_target {
  topic_arn = aws_sns_topic.stress_updates_topic.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.que_for_stress_updates.arn
}