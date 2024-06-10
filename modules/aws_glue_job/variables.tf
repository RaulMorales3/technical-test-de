variable "project" {}
variable "environment" {}
variable "name" {}


variable "script_location" {
  type        = string
  description = "Specifies the S3 path to a script that executes a job."
}

variable "python_version" {
  type        = number
  default     = 3
  description = "The Python version being used to execute a Python shell job."
}

variable "execution_class" {
    type        = string
    default     = "FLEX"
    description = "standard execution class is ideal for time-sensitive workloads that require fast job startup and dedicated resources FLEX | STANDARD"
}

variable "connections" {
  type        = list(string)
  default     = []
  description = "The list of connections used for this job."
}

variable "description" {
  type        = string
  default     = ""
  description = "Description of the job."
}

variable "max_concurrent_runs" {
  type        = number
  default     = 1
  description = "The maximum number of concurrent runs allowed for a job."
}

variable "glue_version" {
  type        = string
  default     = "4.0"
  description = "The version of glue to use."
}

variable "max_retries" {
  type        = number
  default     = 0
  description = "The maximum number of times to retry this job if it fails."
}

variable "notify_delay_after" {
  type        = number
  default     = null
  description = "After a job run starts, the number of minutes to wait before sending a job run delay notification."
}

variable "create_role" {
  type        = bool
  default     = false
  description = "Create AWS IAM role associated with the job."
}

variable "timeout" {
  type        = number
  default     = 120
  description = "The job timeout in minutes."
}

variable "worker_type" {
  type        = string
  default     = "G.1X"
  description = "The type of predefined worker that is allocated when a job runs."
}

variable "number_of_workers" {
  type        = number
  default     = 2
  description = "The number of workers of a defined workerType that are allocated when a job runs."
}

variable "log_group_retention_in_days" {
  type        = number
  default     = 7
  description = "The default number of days log events retained in the glue job log group."
}


variable "job_language" {
  type        = string
  default     = "python"
  description = "The script programming language 'scala' or 'python'."
}

variable "class" {
  type        = string
  default     = null
  description = "The Scala class that serves as the entry point for your Scala script."
}

variable "extra_py_files" {
  type        = list(string)
  default     = []
  description = "The Amazon S3 paths to additional Python modules that AWS Glue adds to the Python path before executing your script."
}

variable "extra_jars" {
  type        = list(string)
  default     = []
  description = "The Amazon S3 paths to additional Java .jar files that AWS Glue adds to the Java classpath before executing your script."
}

variable "user_jars_first" {
  type        = bool
  default     = null
  description = "Prioritizes the customer's extra JAR files in the classpath."
}

variable "use_postgres_driver" {
  type        = bool
  default     = null
  description = "Prioritizes the Postgres JDBC driver in the class path to avoid a conflict with the Amazon Redshift JDBC driver."
}

variable "extra_files" {
  type        = list(string)
  default     = []
  description = "The Amazon S3 paths to additional files, such as configuration files that AWS Glue copies to the working directory of your script before executing it."
}

variable "job_bookmark_option" {
  type        = string
  default     = "job-bookmark-disable"
  description = "Controls the behavior of a job bookmark."
}

variable "additional_python_modules" {
  type        = list(string)
  default     = []
  description = "List of Python modules to add a new module or change the version of an existing module."
}

variable "additional_arguments" {
    type = map(string)
    default = {}
    description = "additional arguments to pass to glue job."
}

variable "custom_policy" {
  default = ""
  description = "custom policy for glue job"
}