# Variables for billing budget configuration

variable "student_name" {
  description = "Student name or GitHub username (used to create unique resource names)"
  type        = string

  validation {
    condition     = length(var.student_name) > 0
    error_message = "Student name must not be empty."
  }
}

variable "alert_email" {
  description = "Email address for budget alerts (you will need to confirm the subscription)"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", var.alert_email))
    error_message = "Must provide a valid email address."
  }
}

variable "monthly_budget_limit" {
  description = "Monthly budget limit in USD (recommended: 20 for this course)"
  type        = string
  default     = "20"

  validation {
    condition     = can(regex("^[0-9]+$", var.monthly_budget_limit))
    error_message = "Budget limit must be a positive number."
  }
}
