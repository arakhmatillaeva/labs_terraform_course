# Lab 00 Validator

This directory contains the validation script for Lab 00 that runs during automated grading.

## What It Checks

The validator (`validate.sh`) parses the Terraform plan JSON and validates:

### Required Resources (30 points total)
1. **S3 Bucket** (7 points)
   - Resource type: `aws_s3_bucket`
   - Bucket name includes "lab-00" or "terraform" (bonus 2 pts)

2. **S3 Bucket Versioning** (8 points)
   - Resource type: `aws_s3_bucket_versioning`
   - Status must be "Enabled" (bonus 3 pts)

3. **S3 Bucket Encryption** (7 points)
   - Resource type: `aws_s3_bucket_server_side_encryption_configuration`
   - Algorithm must be "AES256" or "aws:kms" (bonus 2 pts)

4. **Required Tags** (8 points)
   - All resources must have these tags:
     - `Name`
     - `Environment`
     - `ManagedBy`
     - `Student`
     - `AutoTeardown`

5. **Provider Configuration** (2 points)
   - AWS provider properly configured

## How It Works

The validator is called by the GitHub Actions workflow:

```yaml
- name: Run lab-specific validation
  run: |
    bash week-00/lab-00/.validator/validate.sh /tmp/plan.json
```

## Testing Locally

You can test the validator on your local machine:

```bash
# Navigate to your student-work directory
cd week-00/lab-00/student-work

# Generate a plan
terraform init
terraform plan -out=tfplan
terraform show -json tfplan > plan.json

# Run the validator
bash ../.validator/validate.sh plan.json
```

## Customizing for Other Labs

To create validators for other labs:

1. Copy this directory structure:
   ```
   week-XX/lab-YY/.validator/
   ├── validate.sh
   └── README.md
   ```

2. Modify `validate.sh` to check your lab's specific requirements

3. Update the points allocation as needed

4. Test thoroughly with sample student submissions

## Validator Exit Codes

- `0`: All checks passed or minor issues (≥15 points)
- `1`: Validation failed (<15 points)

The GitHub Actions workflow uses these exit codes to determine if the lab requirements are met.
