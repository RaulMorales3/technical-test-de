output "table_arn" {
  value = aws_dynamodb_table.dynamo_table.arn
}
output "table_id" {
  value = aws_dynamodb_table.dynamo_table.id
}
output "table_name" {
  value = local.name
}
output "table_stream_arn" {
  value = aws_dynamodb_table.dynamo_table.stream_arn
}