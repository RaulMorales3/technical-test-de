
output "function_name" {
  value = aws_lambda_function.lambda.function_name
}

output "arn" {
  value = aws_lambda_function.lambda.arn
}

output "invoke_arn" {
  value = aws_lambda_function.lambda.invoke_arn
}

output "iam_role_name" {
  value = aws_iam_role.role.name
}

output "iam_role_arn" {
  value = aws_iam_role.role.arn
}