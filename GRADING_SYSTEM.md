# Automated Grading System Documentation

This document explains the automated grading system for the Terraform course.

## Overview

The grading system uses GitHub Actions to automatically evaluate student submissions when they create Pull Requests in their forked repositories.

## Student Workflow Summary

1. **Student forks** `shart-cloud/labs_terraform_course` to their account
2. **Student configures** GitHub Secrets in their fork (AWS creds, Infracost API key)
3. **Student completes** lab work in `week-XX/lab-YY/student-work/`
4. **Student creates PR** within their own fork (branch → main in their fork)
5. **GitHub Actions runs** automatically in their fork
6. **Grading bot posts** results as a PR comment
7. **Student tags instructor** when ready for review
8. **Instructor reviews** grade in student's fork

## Grading Workflow

### Trigger
- **Event**: Pull request opened, synchronized, or reopened
- **Path filter**: Only runs if changes are in `week-*/lab-*/student-work/**`
- **Location**: Runs in the student's fork using their secrets

### Permissions Required
```yaml
permissions:
  contents: read
  pull-requests: write
  issues: write
```

### Tools Installed
- Terraform 1.9.0+
- Infracost
- jq (JSON parser)
- tflint (Terraform linter)
- Checkov (security scanner)

## Grading Categories

### 1. Code Quality (25 points)

| Check | Points | Description |
|-------|--------|-------------|
| Terraform Formatting | 5 | `terraform fmt -check` passes |
| Terraform Validation | 5 | `terraform validate` passes |
| No Hardcoded Credentials | 5 | No AWS keys or passwords in code |
| Naming Conventions | 5 | Proper resource naming, main.tf exists |
| Terraform Version Requirement | 5 | `required_version = ">= 1.9.0"` present |

### 2. Functionality (30 points)

| Check | Points | Description |
|-------|--------|-------------|
| Lab-Specific Requirements | 20 | Validated by `.validator/validate.sh` script |
| Outputs Defined | 5 | `outputs.tf` exists with valid outputs |
| Resources in Plan | 5 | Plan includes resource creation |

### 3. Cost Management (20 points)

| Check | Points | Description |
|-------|--------|-------------|
| Infracost Analysis | 5 | Cost breakdown generated successfully |
| Within Budget | 10 | Monthly cost ≤ $5 (configurable per lab) |
| AutoTeardown Tag | 5 | Resources have `AutoTeardown = "8h"` tag |

### 4. Security (15 points)

| Check | Points | Description |
|-------|--------|-------------|
| Checkov Security Scan | 15 | Points based on failed checks:<br>• 0 failures = 15 pts<br>• 1-3 failures = 10 pts<br>• 4-5 failures = 5 pts<br>• 6+ failures = 0 pts |

### 5. Documentation (10 points)

| Check | Points | Description |
|-------|--------|-------------|
| Code Comments | 5 | At least 5 comment lines in .tf files |
| README | 5 | README.md exists and is non-empty |

## Lab-Specific Validators

Each lab has a custom validator script at `week-XX/lab-YY/.validator/validate.sh` that checks lab-specific requirements.

### Example: Lab 00 Validator

The Lab 00 validator checks:
- S3 bucket resource exists (7 pts)
- Bucket versioning enabled (8 pts)
- All required tags present (8 pts)
- Provider configuration (2 pts)

### Creating a Lab Validator

1. Create directory: `week-XX/lab-YY/.validator/`
2. Create script: `validate.sh`
3. Make executable: `chmod +x validate.sh`
4. Script should:
   - Accept plan JSON file path as argument
   - Use `jq` to parse the plan
   - Return exit code 0 for pass, 1 for fail
   - Print helpful error messages

Example structure:
```bash
#!/bin/bash
PLAN_FILE="${1:-/tmp/plan.json}"
POINTS=0
ERRORS=0

# Check for required resource
if jq -e '.planned_values.root_module.resources[] | select(.type == "aws_instance")' "$PLAN_FILE" > /dev/null; then
  POINTS=$((POINTS + 10))
  echo "✅ EC2 instance found"
else
  ERRORS=$((ERRORS + 1))
  echo "❌ EC2 instance not found"
fi

# Exit based on results
if [ $ERRORS -eq 0 ]; then
  exit 0
else
  exit 1
fi
```

## Grading Output

The bot posts a detailed comment on the PR with:

### Header Section
- Student GitHub username
- Lab identifier (Week X, Lab Y)
- Submission and grading timestamps
- **Final Grade**: X/100 (Letter Grade)

### Breakdown Section
Detailed results for each category with:
- ✅ Checks that passed
- ❌ Checks that failed
- ⚠️ Partial credit items
- Subtotals for each category

### Cost Information
- Estimated monthly cost from Infracost
- Budget compliance status

### Security Information
- Number of failed Checkov checks
- Points awarded based on severity

### Next Steps
- Congratulations message (if grade ≥ 90)
- Suggestions for improvement (if grade < 70)
- Instructions for resubmission

### Artifacts Links
- Link to full workflow run
- Links to detailed reports

## Improving Grades

Students can improve their grades by:
1. Reading the feedback in the PR comment
2. Fixing the issues
3. Committing and pushing changes
4. The workflow automatically re-runs
5. The bot updates the grade comment

## Instructor View

As an instructor, you can:

### Option 1: Monitor Student Forks
Bookmark student forks:
- `https://github.com/student1/labs_terraform_course/pulls`
- `https://github.com/student2/labs_terraform_course/pulls`
- etc.

### Option 2: Use GitHub API
Query for tagged PRs:
```bash
# Get all PRs where you're mentioned
gh api /notifications --jq '.[] | select(.reason == "mention")'
```

### Option 3: Student Submission Form
Have students submit a form with:
- Their GitHub username
- Link to their graded PR
- Final grade achieved
- Any questions/comments

### Option 4: Automated Tracking
Create a script that:
```bash
#!/bin/bash
STUDENTS=("student1" "student2" "student3")

for student in "${STUDENTS[@]}"; do
  echo "Checking $student..."
  gh pr list --repo "$student/labs_terraform_course" --state all --json number,title,createdAt,url
done
```

## Cost Considerations

### For Students
- Infracost API: Free tier (10,000 requests/month)
- AWS Resources: Students pay for what they deploy
- GitHub Actions: 2,000 minutes/month free for public repos

### For Instructor
- No costs - everything runs in student forks with their credentials
- You don't need to provide AWS credentials or Infracost keys
- Students are responsible for their own costs

## Security Model

### What's Secure
✅ Students use their own AWS credentials (stored as secrets in their fork)  
✅ Students use their own Infracost API keys  
✅ No credentials are shared between students  
✅ Instructor doesn't need to manage student credentials  
✅ Workflow only runs on PRs (not arbitrary code execution)  
✅ No deployment happens automatically (students deploy manually)

### What to Watch For
⚠️ Students must never commit credentials to their code  
⚠️ Students should use IAM users with appropriate restrictions  
⚠️ Students should monitor their AWS spending  
⚠️ Students should clean up resources after labs  

## Troubleshooting

### Workflow Doesn't Run
- Check GitHub Actions is enabled in student's fork
- Verify changes are in `week-*/lab-*/student-work/` path
- Check PR is created within the fork (not to main repo)

### Authentication Errors
- Verify secrets are set correctly in student's fork
- Check secret names match exactly (case-sensitive)
- Test credentials work locally first

### Validator Not Found
- Ensure `.validator/validate.sh` exists
- Check file is executable
- Verify path matches lab directory structure

### Low Grades Despite Good Code
- Check detailed breakdown in PR comment
- Review workflow logs for errors
- Ensure all required files exist (outputs.tf, etc.)
- Verify tags are present on resources

## Future Enhancements

Potential improvements to consider:

### Terraform Testing
- Add native Terraform test files (`.tftest.hcl`)
- Run `terraform test` in addition to validators
- Create shared test modules

### Deployment Verification
- Optional step to actually deploy and verify
- Use temporary credentials with short expiry
- Auto-destroy after verification

### Historical Tracking
- Store grades in a database or spreadsheet
- Generate grade reports for entire class
- Track improvement over time

### Advanced Security
- Add SAST scanning (tfsec, terrascan)
- Policy-as-code enforcement (OPA, Sentinel)
- Compliance checking (CIS benchmarks)

### Integration
- LMS integration (Canvas, Blackboard)
- Slack notifications for instructor
- Email summaries of submissions

## Files Modified/Created

### Created
- `.github/workflows/grading.yml` - Main grading workflow
- `week-00/lab-00/.validator/validate.sh` - Lab 00 validator
- `week-00/lab-00/.validator/README.md` - Validator documentation
- `week-00/lab-00/student-work/.gitkeep` - Preserve empty directory
- `STUDENT_SETUP.md` - Student onboarding guide
- `GRADING_SYSTEM.md` - This file

### Modified
- `week-00/lab-00/README.md` - Updated submission instructions
- `common/billing-setup/main.tf` - Fixed formatting
- `common/billing-setup/variables.tf` - Fixed formatting

### Removed
- Old incomplete grading.yml was replaced

## Questions?

For questions or issues with the grading system:
1. Check workflow logs in the Actions tab
2. Review this documentation
3. Test validator scripts locally
4. Contact course administrator

---

**Maintained by**: Course Instructor  
**Last Updated**: 2025-11-13
