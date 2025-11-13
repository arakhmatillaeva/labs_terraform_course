# Lab 0: Getting Started

## Objective

Set up your development environment, configure AWS credentials, install required tools, and deploy a simple S3 bucket to verify your setup.

## Estimated Time

2-3 hours

## Prerequisites

- Personal AWS account (or AWS Academy sandbox access)
- GitHub account
- Command-line terminal access

## Tasks

### Part 1: Install Required Tools (30 minutes)

#### 1.1 Install Terraform

**Important**: You need Terraform 1.9.0 or later for S3 native state locking support.

**macOS (using Homebrew):**
```bash
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
```

**Linux:**
```bash
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform
```

**Windows (using Chocolatey):**
```powershell
choco install terraform
```

Verify installation (ensure version is 1.9.0 or later):
```bash
terraform version
```

#### 1.2 Install AWS CLI

Follow the [official AWS CLI installation guide](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) for your operating system.

Verify installation:
```bash
aws --version
```

#### 1.3 Install Infracost

**macOS/Linux:**
```bash
curl -fsSL https://raw.githubusercontent.com/infracost/infracost/master/scripts/install.sh | sh
```

**Windows:**
```powershell
choco install infracost
```

Register for Infracost API key:
```bash
infracost auth login
```

#### 1.4 Install VS Code and Extensions (Recommended)

- Download [VS Code](https://code.visualstudio.com/)
- Install extensions:
  - HashiCorp Terraform
  - AWS Toolkit

### Part 2: Configure AWS Credentials (30 minutes)

#### 2.1 Create IAM User

1. Log in to AWS Console
2. Navigate to IAM → Users → Create User
3. Create user with programmatic access
4. Attach policy: `AdministratorAccess` (for learning purposes only)
5. Save access key ID and secret access key

#### 2.2 Configure AWS CLI

```bash
aws configure
```

Enter:
- AWS Access Key ID
- AWS Secret Access Key
- Default region: `us-east-1`
- Default output format: `json`

Verify:
```bash
aws sts get-caller-identity
```

### Part 3: Fork and Clone Repository (10 minutes)

#### 3.1 Fork the Repository

1. Navigate to https://github.com/shart-cloud/labs_terraform_course
2. Click "Fork" to create your own copy
3. Clone your fork:

```bash
git clone https://github.com/YOUR-USERNAME/labs_terraform_course.git
cd labs_terraform_course
```

**Note**: Replace `YOUR-USERNAME` with your actual GitHub username.

### Part 4: Set Up Billing Alerts with Terraform (20 minutes)

The billing setup has been pre-configured for you in the `common/billing-setup/` directory.

#### 4.1 Navigate to Billing Setup Directory

```bash
cd common/billing-setup
```

#### 4.2 Create Your Configuration File

Copy the example file and edit it with your information:

```bash
cp terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars` using your preferred text editor:

```hcl
student_name         = "your-github-username"
alert_email          = "your-email@example.com"
monthly_budget_limit = "20"
```

#### 4.3 Deploy Your Billing Budget

```bash
# Initialize Terraform
terraform init

# Review what will be created
terraform plan

# Create the budget
terraform apply
```

Type `yes` when prompted.

#### 4.4 Confirm Email Subscription

**Important**: Check your email for an SNS subscription confirmation message. Click the "Confirm subscription" link to activate budget alerts.

#### 4.5 Verify Budget Creation

```bash
# View the outputs (including next steps)
terraform output

# Optionally verify in AWS Console
aws budgets describe-budgets --account-id $(aws sts get-caller-identity --query Account --output text)
```

### Part 5: Deploy Test Infrastructure (45 minutes)

#### 5.1 Create S3 Bucket Configuration

Navigate to your student work directory:
```bash
cd week-00/lab-00/student-work
```

**Understanding Required Tags**: All resources in this course must include specific tags for tracking and automation:
- `Name`: Human-readable resource identifier
- `Environment`: Deployment context (e.g., "Learning", "Production")
- `ManagedBy`: Shows the infrastructure is managed by Terraform
- `Student`: Your GitHub username for resource ownership tracking
- `AutoTeardown`: Set to "8h" to trigger automatic resource cleanup after 8 hours (via GitHub Actions), helping prevent unexpected AWS charges

Create `main.tf`:
```hcl
terraform {
  required_version = ">= 1.9.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "test_bucket" {
  bucket = "terraform-lab-00-YOUR-STUDENT-ID"  # Must be globally unique

  tags = {
    Name         = "Lab 0 Test Bucket"        # Descriptive name for the resource
    Environment  = "Learning"                 # Indicates this is for educational purposes
    ManagedBy    = "Terraform"                # Shows infrastructure is managed by Terraform
    Student      = "your-github-username"     # Your GitHub username for resource tracking
    AutoTeardown = "8h"                       # Triggers automatic cleanup after 8 hours
  }
}

resource "aws_s3_bucket_versioning" "test_bucket_versioning" {
  bucket = aws_s3_bucket.test_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "test_bucket_encryption" {
  bucket = aws_s3_bucket.test_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
```

Create `outputs.tf`:
```hcl
output "bucket_name" {
  description = "Name of the S3 bucket"
  value       = aws_s3_bucket.test_bucket.id
}

output "bucket_arn" {
  description = "ARN of the S3 bucket"
  value       = aws_s3_bucket.test_bucket.arn
}
```

#### 5.2 Run Infracost

```bash
infracost breakdown --path .
```

Expected cost: ~$0.50/month for minimal storage

#### 5.3 Deploy Infrastructure

```bash
# Format your code
terraform fmt

# Initialize Terraform
terraform init

# Validate configuration
terraform validate

# Preview changes
terraform plan

# Apply changes
terraform apply
```

Type `yes` when prompted.

#### 5.4 Verify in AWS Console

1. Navigate to S3 in AWS Console
2. Confirm your bucket exists
3. Check that versioning is enabled

### Part 6: Submit Your Work (20 minutes)

#### 6.1 Set Up GitHub Secrets (First Time Only)

Before creating your first PR, you need to configure GitHub Actions secrets in **your fork**:

1. Go to your fork: `https://github.com/YOUR-USERNAME/labs_terraform_course`
2. Navigate to **Settings** → **Secrets and variables** → **Actions**
3. Add three secrets:
   - `AWS_ACCESS_KEY_ID` - Your AWS access key
   - `AWS_SECRET_ACCESS_KEY` - Your AWS secret key  
   - `INFRACOST_API_KEY` - Your Infracost API key (get via `infracost configure get api_key`)

⚠️ **Security Note**: These secrets are only accessible to workflows in YOUR fork, not the main repo.

See [STUDENT_SETUP.md](../../STUDENT_SETUP.md) for detailed instructions.

#### 6.2 Commit and Push Your Work

```bash
# Create a branch (recommended)
git checkout -b week-00-lab-00

# Add your files
git add week-00/lab-00/student-work/

# Commit
git commit -m "Week 0 Lab 0 - Your Name"

# Push to your fork
git push origin week-00-lab-00
```

#### 6.3 Create Pull Request in Your Fork

**IMPORTANT**: Create the PR within YOUR fork, not to the main repository!

1. Go to **your fork** on GitHub
2. Click **Pull requests** → **New pull request**
3. Set both base and compare to YOUR fork:
   - Base: `YOUR-USERNAME/labs_terraform_course` base: `main`
   - Compare: `YOUR-USERNAME/labs_terraform_course` compare: `week-00-lab-00`
4. Title: `Week 0 Lab 0 - [Your Name]`
5. Fill out the PR template
6. Create pull request

#### 6.4 Wait for Automated Grading

The grading workflow will automatically run and:
- ✅ Check code formatting (`terraform fmt`)
- ✅ Validate configuration (`terraform validate`)
- ✅ Run lab-specific tests
- ✅ Generate cost estimates (Infracost)
- ✅ Perform security scanning (Checkov)
- ✅ Calculate your grade (0-100 points)
- ✅ Post detailed results as a PR comment

**Expected grade breakdown**:
- Code Quality: 25 points
- Functionality: 30 points
- Cost Management: 20 points
- Security: 15 points
- Documentation: 10 points

#### 6.5 Review Your Grade and Iterate

1. Check the automated comment on your PR for your grade
2. If you need to improve your score:
   - Fix the issues mentioned in the feedback
   - Commit and push your changes
   - The workflow will automatically re-run and update your grade
3. Once satisfied, tag your instructor: `@shart-cloud` in a PR comment

### Part 7: Cleanup (10 minutes)

After your PR is reviewed:

#### 7.1 Destroy S3 Infrastructure

```bash
cd week-00/lab-00/student-work
terraform destroy
```

Type `yes` to confirm.

Alternatively, wait 8 hours for the auto-teardown action to destroy resources automatically.

#### 7.2 Keep or Remove Billing Budget

**Important**: The billing budget should typically be kept active throughout the course to monitor costs. However, if you need to remove it:

```bash
cd common/billing-setup
terraform destroy
```

**Note**: We recommend keeping the billing budget active for the entire semester.

## Deliverables

See [SUBMISSION.md](SUBMISSION.md) for the complete checklist.

## Troubleshooting

### Terraform Init Fails
- Check internet connection
- Verify Terraform is properly installed
- Try removing `.terraform` directory and re-running `terraform init`

### AWS Authentication Errors
- Verify `aws configure` was run correctly
- Check credentials with `aws sts get-caller-identity`
- Ensure IAM user has proper permissions

### S3 Bucket Name Conflicts
- S3 bucket names must be globally unique
- Use your student ID or GitHub username in the bucket name

### Infracost Errors
- Ensure you've run `infracost auth login`
- Check API key is valid
- Try `infracost configure get api_key`

## Learning Outcomes Checklist

After completing this lab, you should be able to:

- ✅ Install and verify Terraform, AWS CLI, and Infracost
- ✅ Configure AWS credentials and verify access
- ✅ Set up billing alerts and budgets
- ✅ Write basic Terraform HCL syntax
- ✅ Use `terraform init`, `plan`, `apply`, and `destroy`
- ✅ Run Infracost to estimate costs
- ✅ Submit work via Git and GitHub PRs

## Next Steps

Proceed to Week 1, Lab 1 where you'll deploy more complex infrastructure with multiple resources.

## Support

- Office hours: [Schedule TBD]
- Discussion forum: [Link TBD]
- Email instructor for urgent issues
