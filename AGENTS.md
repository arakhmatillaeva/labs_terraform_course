# AGENTS.md for labs_terraform_course

**Repository**: https://github.com/shart-cloud/labs_terraform_course

## Repository Context
This is a Terraform learning repository with a monorepo structure. Labs are organized in `week-XX/lab-YY/` directories. Students work in `student-work/` subdirectories.

## Terraform Requirements
- **Minimum Version**: Terraform 1.9.0+ (required for S3 native state locking)
- **AWS Provider**: ~> 5.0
- Always include `required_version = ">= 1.9.0"` in terraform blocks

## Build/Lint/Test Commands
- Format code: `terraform fmt` (or `terraform fmt -recursive` for all files)
- Check formatting: `terraform fmt -check`
- Validate configuration: `terraform validate`
- Initialize: `terraform init`
- Plan changes: `terraform plan`
- Cost estimation: `infracost breakdown --path .`

## Code Style Guidelines
- **Indentation**: 2 spaces (HCL standard)
- **Resource naming**: Use descriptive names with underscores (e.g., `aws_s3_bucket.student_work`)
- **Variable naming**: Use lowercase with underscores (e.g., `student_name`)
- **Required tags**: All resources must include:
  - `Name` - Descriptive resource name
  - `Environment` - Typically "Learning"
  - `ManagedBy` - "Terraform"
  - `Student` - Student's GitHub username
  - `AutoTeardown` - "8h" (for cost management)
- **No hardcoded credentials**: Use AWS credentials from environment or CLI
- **Encryption**: Enable encryption for S3 buckets and other storage resources

## Backend Configuration
- Use S3 backend with native locking (no DynamoDB needed)
- Backend config template available in `common/backend.tf.example`
- Set `use_lockfile = true` for S3 native locking

## Repository Structure
- `week-XX/` - Weekly content
- `week-XX/lab-YY/README.md` - Lab instructions
- `week-XX/lab-YY/SUBMISSION.md` - Grading criteria
- `week-XX/lab-YY/student-work/` - Where students write code
- `modules/` - Reusable Terraform modules
- `common/` - Shared configuration examples
- `scripts/` - Utility scripts (e.g., setup.sh)

## Cost Management
- Always run `infracost breakdown` before applying
- Use smallest instance types for learning (t3.micro, t3.nano)
- Include `AutoTeardown = "8h"` tag on all resources
- Resources auto-destroy after 8 hours via GitHub Actions

Ensure all code adheres to these standards for consistency and quality.