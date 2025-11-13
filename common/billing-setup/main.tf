# AWS Billing Budget Configuration
# This configuration creates billing alerts to help you monitor costs

terraform {
  required_version = ">= 1.9.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Default provider - uses your AWS CLI configuration
provider "aws" {
  region = "us-east-1"
}

# AWS Budgets API requires us-east-1 region
# Using an alias to make this requirement explicit
provider "aws" {
  alias  = "billing"
  region = "us-east-1"
}

# SNS Topic for budget notifications
resource "aws_sns_topic" "budget_alerts" {
  provider = aws.billing
  name     = "budget-alerts-${var.student_name}"

  tags = {
    Name        = "Budget Alerts"
    ManagedBy   = "Terraform"
    Student     = var.student_name
    Environment = "Learning"
  }
}

# SNS Topic Subscription - Email notifications
resource "aws_sns_topic_subscription" "budget_email" {
  provider  = aws.billing
  topic_arn = aws_sns_topic.budget_alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email
}

# Monthly cost budget
resource "aws_budgets_budget" "monthly_cost" {
  provider     = aws.billing
  name         = "monthly-budget-${var.student_name}"
  budget_type  = "COST"
  limit_amount = var.monthly_budget_limit
  limit_unit   = "USD"
  time_unit    = "MONTHLY"

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 80
    threshold_type             = "PERCENTAGE"
    notification_type          = "ACTUAL"
    subscriber_email_addresses = [var.alert_email]
  }

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 100
    threshold_type             = "PERCENTAGE"
    notification_type          = "ACTUAL"
    subscriber_email_addresses = [var.alert_email]
  }

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 90
    threshold_type             = "PERCENTAGE"
    notification_type          = "FORECASTED"
    subscriber_email_addresses = [var.alert_email]
  }

  tags = {
    Name        = "Monthly Cost Budget"
    ManagedBy   = "Terraform"
    Student     = var.student_name
    Environment = "Learning"
  }
}

# Optional: Service-specific budget for EC2
# Uncomment if you want separate EC2 tracking
# resource "aws_budgets_budget" "ec2_budget" {
#   provider      = aws.billing
#   name          = "ec2-budget-${var.student_name}"
#   budget_type   = "COST"
#   limit_amount  = "10"
#   limit_unit    = "USD"
#   time_unit     = "MONTHLY"
# 
#   cost_filter {
#     name   = "Service"
#     values = ["Amazon Elastic Compute Cloud - Compute"]
#   }
# 
#   notification {
#     comparison_operator        = "GREATER_THAN"
#     threshold                  = 80
#     threshold_type            = "PERCENTAGE"
#     notification_type         = "ACTUAL"
#     subscriber_email_addresses = [var.alert_email]
#   }
# 
#   tags = {
#     Name        = "EC2 Cost Budget"
#     ManagedBy   = "Terraform"
#     Student     = var.student_name
#     Environment = "Learning"
#   }
# }
