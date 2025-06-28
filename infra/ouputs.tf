output "sns_topic_arn" {
  description = "ARN do tópico SNS"
  value       = aws_sns_topic.sns_transacoes_financeiras.arn
}

output "sqs_transacao_pix_arn" {
  description = "ARN da fila SQS para transações Pix"
  value       = aws_sqs_queue.sqs_transacao_pix.arn
}

output "sqs_transacao_cartao_arn" {
  description = "ARN da fila SQS para transações Cartão"
  value       = aws_sqs_queue.sqs_transacao_cartao.arn
}

output "sqs_transacao_pix_url" {
  description = "URL da fila SQS para transações Pix"
  value       = aws_sqs_queue.sqs_transacao_pix.id
}

output "sqs_transacao_cartao_url" {
  description = "URL da fila SQS para transações Cartão"
  value       = aws_sqs_queue.sqs_transacao_cartao.id
}

output "kms_key_arn" {
  description = "ARN da chave KMS utilizada"
  value       = aws_kms_key.sns_sqs.arn
}