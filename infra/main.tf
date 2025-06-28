provider "aws" {
  region = var.region
}

resource "aws_kms_key" "sns_sqs" {
  description = "Chave KMS para SNS e SQS"
}

resource "aws_sns_topic" "sns_transacoes_financeiras" {
  name              = var.sns_topic_name
  kms_master_key_id = aws_kms_key.sns_sqs.arn
}

resource "aws_sqs_queue" "sqs_transacao_pix" {
  name                              = var.sqs_pix_name
  kms_master_key_id                 = aws_kms_key.sns_sqs.arn
  kms_data_key_reuse_period_seconds = 300
}

resource "aws_sqs_queue" "sqs_transacao_cartao" {
  name                              = var.sqs_cartao_name
  kms_master_key_id                 = aws_kms_key.sns_sqs.arn
  kms_data_key_reuse_period_seconds = 300
}

# politica de acesso do sqs

resource "aws_sqs_queue_policy" "sqs_transacao_pix_policy" {
  queue_url = aws_sqs_queue.sqs_transacao_pix.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = "*"
        Action = "SQS:SendMessage"
        Resource = aws_sqs_queue.sqs_transacao_pix.arn
        Condition = {
          ArnEquals = {
            "aws:SourceArn" = aws_sns_topic.sns_transacoes_financeiras.arn
          }
        }
      }
    ]
  })
}

resource "aws_sqs_queue_policy" "sqs_transacao_cartao_policy" {
  queue_url = aws_sqs_queue.sqs_transacao_cartao.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = "*"
        Action = "SQS:SendMessage"
        Resource = aws_sqs_queue.sqs_transacao_cartao.arn
        Condition = {
          ArnEquals = {
            "aws:SourceArn" = aws_sns_topic.sns_transacoes_financeiras.arn
          }
        }
      }
    ]
  })
}


# subscricao dos topicos

resource "aws_sns_topic_subscription" "cartao" {
  topic_arn     = aws_sns_topic.sns_transacoes_financeiras.arn
  protocol      = "sqs"
  endpoint      = aws_sqs_queue.sqs_transacao_cartao.arn
  filter_policy = jsonencode({
    origem = ["cartao"]
  })
}

resource "aws_sns_topic_subscription" "pix" {
  topic_arn     = aws_sns_topic.sns_transacoes_financeiras.arn
  protocol      = "sqs"
  endpoint      = aws_sqs_queue.sqs_transacao_pix.arn
  filter_policy = jsonencode({
    origem = ["pix"]
  })
}