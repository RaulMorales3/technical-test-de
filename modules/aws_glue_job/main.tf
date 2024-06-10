locals {
  glue_job_name     = "${var.project}-${var.environment}-${var.name}"
  arguments         = {
    "--job-language"                          = var.job_language
    "--class"                                 = var.class
    "--extra-py-files"                        = length(var.extra_py_files) > 0 ? join(",", var.extra_py_files) : null
    "--extra-jars"                            = length(var.extra_jars) > 0 ? join(",", var.extra_jars) : null
    "--user-jars-first"                       = var.user_jars_first
    "--use-postgres-driver"                   = var.use_postgres_driver
    "--extra-files"                           = length(var.extra_files) > 0 ? join(",", var.extra_files) : null
    "--job-bookmark-option"                   = var.job_bookmark_option
    "--additional-python-modules"             = length(var.additional_python_modules) > 0 ? join(",", var.additional_python_modules) : null
    "--continuous-log-logGroup"               = aws_cloudwatch_log_group.log_group.name
  }
  default_arguments = merge(var.additional_arguments, local.arguments)
}

resource "aws_iam_role" "glue_job_role" {
  name  = "${local.glue_job_name}-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": ["glue.amazonaws.com"]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

}

resource "aws_iam_policy" "policy_json" {
  count  = var.custom_policy == "" ? 0 : 1
  name   = "${var.project}-${var.environment}-${local.glue_job_name}-policy"
  policy = var.custom_policy
}

resource "aws_iam_role_policy_attachment" "policy_json_attachment" {
  count      = var.custom_policy == "" ? 0 : 1
  policy_arn = aws_iam_policy.policy_json.*.arn[count.index]
  role       = aws_iam_role.role.name
}


resource "aws_glue_job" "glue_job" {
  name                   = local.glue_job_name
  role_arn               = aws_iam_role.glue_job_role.arn
  connections            = var.connections
  description            = var.description
  glue_version           = var.glue_version
  max_retries            = var.max_retries
  timeout                = var.timeout
  execution_class        = var.execution_class
  worker_type            = var.worker_type
  number_of_workers      = var.number_of_workers

  command {
    name            = "glueetl"
    script_location = var.script_location
    python_version  = var.python_version
  }

  default_arguments = local.default_arguments

  execution_property {
    max_concurrent_runs = var.max_concurrent_runs
  }

  dynamic "notification_property" {
    for_each = var.notify_delay_after == null ? [] : [1]
    content {
      notify_delay_after = var.notify_delay_after
    }
  }

  tags = {
    Name        = local.glue_job_name
    Project     = var.project
    Environment = var.environment
  }
}

resource "aws_cloudwatch_log_group" "log_group" {
  name = "/aws-glue/jobs/${local.glue_job_name}"
  tags = {
    Name        = local.glue_job_name
    Project     = var.project
    Environment = var.environment
  }
}


 