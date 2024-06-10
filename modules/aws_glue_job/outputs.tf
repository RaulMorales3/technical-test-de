output "job_arn" {
  value       = aws_glue_job.glue_job.arn
}

output "job_id" {
  value       = aws_glue_job.glue_job.id
}

output "job_role_arn" {
  value       = aws_iam_role.glue_job_role.arn
}

output "job_log_group_arn" {
  value       = aws_cloudwatch_log_group.log_group.arn
}