# Billing Budget Setup

This directory contains Terraform configuration to create AWS billing budgets and alerts for cost monitoring throughout the course.

## Quick Start

### 1. Create Your Configuration File

Copy the example file and edit it with your information:

```bash
cp terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars`:
```hcl
student_name         = "your-github-username"
alert_email          = "your-email@example.com"
monthly_budget_limit = "20"
```

### 2. Deploy the Budget

```bash
# Initialize Terraform
terraform init

# Review what will be created
terraform plan

# Create the budget
terraform apply
```

### 3. Confirm Email Subscription

Check your email for an SNS subscription confirmation and click the confirmation link.

## What Gets Created

- **Monthly Cost Budget**: Tracks total AWS spending with your specified limit
- **SNS Topic**: For sending email notifications
- **Email Subscription**: Sends alerts to your specified email
- **Notifications**:
  - Alert at 80% of budget (actual spending)
  - Alert at 90% of budget (forecasted spending)
  - Alert at 100% of budget (actual spending)

## Cost

AWS Budgets is **free** for the first 2 budgets per account. Additional budgets cost $0.02/day.

## Important Notes

- **Keep Active**: Leave this budget active throughout the course to monitor costs
- **Email Confirmation Required**: You must confirm the SNS subscription via email
- **Region**: Budgets are created in `us-east-1` (AWS requirement) regardless of where you deploy resources
- **Unique Names**: The `student_name` variable ensures unique resource names if multiple students share an account

## Troubleshooting

### Email Not Received
- Check your spam/junk folder
- Verify the email address in `terraform.tfvars`
- Check AWS Console → SNS → Subscriptions for pending confirmations

### Permission Errors
Ensure your IAM user/role has permissions for:
- `budgets:CreateBudget`
- `budgets:ViewBudget`
- `sns:CreateTopic`
- `sns:Subscribe`

### Budget Not Visible
- Budgets can take a few minutes to appear
- Check AWS Console → Billing → Budgets

## Modifying Your Budget

To change your budget limit:
1. Edit `monthly_budget_limit` in `terraform.tfvars`
2. Run `terraform apply`

## Cleanup

**Not Recommended During Course**: Keep the budget active to monitor costs.

If you need to remove it:
```bash
terraform destroy
```

## Next Steps

After deploying your budget:
1. Confirm the email subscription
2. Continue with the rest of Lab 0
3. Monitor your costs throughout the course
