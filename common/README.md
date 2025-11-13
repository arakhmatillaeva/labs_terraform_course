# Common Configuration Files

This directory contains reusable Terraform configuration templates and ready-to-use modules for the course.

## Directory Structure

### Backend Configuration
- **`backend.tf.example`** - S3 backend configuration with native state locking (Terraform 1.9+)
- **`terraform.tfvars.example`** - Common variable definitions template

### Billing Setup (Ready to Use)
- **`billing-setup/`** - Complete, ready-to-deploy billing budget configuration
  - `main.tf` - AWS Budgets and SNS resources
  - `variables.tf` - Input variables with validation
  - `outputs.tf` - Helpful outputs and next steps
  - `terraform.tfvars.example` - Template for your values
  - `README.md` - Complete usage instructions
  - `.gitignore` - Protects sensitive data

## Using the Billing Setup

The `billing-setup/` directory contains a complete, production-ready Terraform configuration for AWS billing budgets.

### Quick Start

1. Navigate to the billing setup directory:
```bash
cd common/billing-setup
```

2. Create your configuration file:
```bash
cp terraform.tfvars.example terraform.tfvars
```

3. Edit `terraform.tfvars` with your information:
```hcl
student_name         = "your-github-username"
alert_email          = "your-email@example.com"
monthly_budget_limit = "20"
```

4. Deploy:
```bash
terraform init
terraform plan
terraform apply
```

5. Confirm the SNS subscription email sent to your address.

See `billing-setup/README.md` for detailed instructions and troubleshooting.

## What the Billing Setup Creates

- **Monthly Cost Budget**: Tracks total AWS spending with your specified limit
- **SNS Topic**: For sending email notifications
- **Email Subscription**: Sends alerts to your specified email
- **Multi-Tier Notifications**:
  - Alert at 80% of budget (actual spending)
  - Alert at 90% of budget (forecasted spending)
  - Alert at 100% of budget (actual spending)

## Backend Configuration

The `backend.tf.example` file shows how to configure S3 remote state with native locking (Terraform 1.9+):

```hcl
terraform {
  backend "s3" {
    bucket       = "terraform-state-YOUR-ACCOUNT-ID"
    key          = "week-XX/lab-YY/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true  # Native S3 locking (no DynamoDB needed)
  }
}
```

## Important Notes

- **Billing Setup**: The `billing-setup/` directory is ready to use - no copying required
- **Protected Files**: `.gitignore` prevents committing `terraform.tfvars` with sensitive data
- **Cost**: AWS Budgets is free for the first 2 budgets per account
- **Email Confirmation**: You must click the confirmation link in the SNS subscription email
- **Keep Active**: Billing budgets should remain active throughout the course for cost monitoring
