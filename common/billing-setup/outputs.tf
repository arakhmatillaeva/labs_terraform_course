# Outputs for billing budget configuration

output "budget_name" {
  description = "Name of the created budget"
  value       = aws_budgets_budget.monthly_cost.name
}

output "sns_topic_arn" {
  description = "ARN of the SNS topic for budget alerts"
  value       = aws_sns_topic.budget_alerts.arn
}

output "budget_alert_email" {
  description = "Email address receiving budget alerts"
  value       = var.alert_email
  sensitive   = true
}

output "monthly_budget_limit" {
  description = "Monthly budget limit in USD"
  value       = "${var.monthly_budget_limit} USD"
}

output "next_steps" {
  description = "What to do next"
  value       = <<-EOT
    
    ✅ Budget Created Successfully!
    
    Next Steps:
    1. Check your email (${var.alert_email}) for an SNS subscription confirmation
    2. Click the "Confirm subscription" link in the email
    3. You will receive budget alerts at 80%, 90% (forecasted), and 100% of your $${var.monthly_budget_limit} budget
    
    Keep this budget active throughout the course to monitor your AWS spending.
  EOT
}
