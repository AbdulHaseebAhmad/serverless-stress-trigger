resource aws_sqs_queue que_for_stress_updates {
  name                      = "${var.env_name}_que_for_stress_updates.fifo"
  delay_seconds             = 0
  max_message_size          = 2048
  message_retention_seconds = 86400
  receive_wait_time_seconds = 10
  fifo_queue                  = true


  tags = {
    Environment = var.env_name
    Name = "${var.env_name}_que_for_stress_updates.fifo"
  }
}

resource "aws_sqs_queue_policy" "stress_updates_queue_policy" {
  queue_url = aws_sqs_queue.que_for_stress_updates.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "sns.amazonaws.com"
        }
        Action   = "sqs:SendMessage"
        Resource = aws_sqs_queue.que_for_stress_updates.arn

        Condition = {
          ArnEquals = {
            "aws:SourceArn" = aws_sns_topic.stress_updates_topic.arn
          }
        }
      }
    ]
  })
}