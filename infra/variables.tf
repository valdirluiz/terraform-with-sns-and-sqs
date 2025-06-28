variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "sns_topic_name" {
  description = "Nome do tópico SNS"
  type        = string
  default     = "sns-transacoes-financeiras"
}

variable "sqs_pix_name" {
  description = "Nome da fila SQS para transações Pix"
  type        = string
  default     = "sqs-transacao-pix"
}

variable "sqs_cartao_name" {
  description = "Nome da fila SQS para transações Cartão"
  type        = string
  default     = "sqs-transacao-cartao"
}