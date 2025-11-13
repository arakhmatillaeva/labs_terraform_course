# 🚀 Quick Start Guide

**New to the course? Start here!**

## 📋 Prerequisites

- [ ] GitHub account
- [ ] AWS account (personal or AWS Academy)
- [ ] Terraform 1.9.0+ installed
- [ ] AWS CLI installed
- [ ] Infracost installed

Run the setup validator:
```bash
./scripts/setup.sh
```

## 🔧 One-Time Setup (15 minutes)

### 1. Fork the Repository
Click **Fork** on https://github.com/shart-cloud/labs_terraform_course

### 2. Clone Your Fork
```bash
git clone https://github.com/YOUR-USERNAME/labs_terraform_course.git
cd labs_terraform_course
```

### 3. Configure AWS Locally
```bash
aws configure
# Enter your AWS credentials
aws sts get-caller-identity  # Verify it works
```

### 4. Set Up Infracost
```bash
infracost auth login
infracost configure get api_key  # Save this key
```

### 5. Add GitHub Secrets to Your Fork

**Option A - Using GitHub CLI (Fastest)**:
```bash
# Install GitHub CLI
brew install gh  # or: sudo apt install gh, winget install GitHub.cli

# Authenticate and set secrets
gh auth login
cd labs_terraform_course
./scripts/setup-secrets.sh
```

**Option B - Using Web Interface**:

Go to: `https://github.com/YOUR-USERNAME/labs_terraform_course/settings/secrets/actions`

Add these three secrets:
- **AWS_ACCESS_KEY_ID** = Your AWS access key
- **AWS_SECRET_ACCESS_KEY** = Your AWS secret key
- **INFRACOST_API_KEY** = Your Infracost API key

**📖 Detailed guide**: [GITHUB_CLI_SETUP.md](GITHUB_CLI_SETUP.md)

## 📚 For Each Lab

### Step 1: Navigate to Lab
```bash
cd week-00/lab-00/student-work
```

### Step 2: Write Your Code
Follow the lab README instructions.

### Step 3: Test Locally
```bash
terraform fmt
terraform init
terraform validate
terraform plan
infracost breakdown --path .
```

### Step 4: Deploy (Optional)
```bash
terraform apply
# Test your infrastructure
terraform destroy  # Clean up when done
```

### Step 5: Submit for Grading
```bash
# Create branch
git checkout -b week-00-lab-00

# Commit your work
git add week-00/lab-00/student-work/
git commit -m "Complete Week 0 Lab 0"
git push origin week-00-lab-00
```

### Step 6: Create PR in Your Fork
1. Go to YOUR fork on GitHub
2. Click **Pull requests** → **New pull request**
3. **Important**: Set base to YOUR fork's main branch
4. Title: `Week 0 Lab 0 - Your Name`
5. Create pull request

### Step 7: Wait for Grade
- Workflow runs automatically (~3-5 minutes)
- Grade posted as comment on your PR
- Fix issues and push updates if needed

### Step 8: Notify Instructor
When satisfied with your grade, comment: `@shart-cloud Ready for review!`

## 📊 Grading Breakdown

| Category | Points |
|----------|--------|
| Code Quality | 25 |
| Functionality | 30 |
| Cost Management | 20 |
| Security | 15 |
| Documentation | 10 |
| **Total** | **100** |

**Letter Grades**: A (90-100), B (80-89), C (70-79), D (60-69), F (<60)

## ⚡ Quick Commands

```bash
# Format all Terraform files
terraform fmt -recursive

# Check formatting
terraform fmt -check

# Validate configuration
terraform validate

# Estimate costs
infracost breakdown --path .

# Check security
checkov -d .

# View outputs
terraform output
```

## 🆘 Common Issues

### "Actions not running"
- Enable Actions in your fork: Settings → Actions → Enable

### "AWS authentication failed"
- Check secrets are set correctly in your fork
- Verify secret names (case-sensitive)
- Test locally: `aws sts get-caller-identity`

### "Wrong PR base"
- Close PR, create new one
- Both base and compare should be YOUR fork

### "Low grade"
- Read the feedback comment carefully
- Fix issues and push updates
- Workflow will re-run automatically

## 📖 Full Documentation

- **Student Setup**: See [STUDENT_SETUP.md](STUDENT_SETUP.md)
- **Grading System**: See [GRADING_SYSTEM.md](GRADING_SYSTEM.md)
- **Lab Instructions**: See each `week-XX/lab-YY/README.md`

## 💡 Tips

- ✅ Always run `terraform fmt` before committing
- ✅ Test locally before pushing
- ✅ Check Infracost estimates to avoid high costs
- ✅ Destroy resources when done
- ✅ Keep billing alerts active
- ✅ Read the detailed feedback in PR comments
- ✅ Add comments to explain your code

## 🎯 Success Checklist

Before submitting:
- [ ] Code is formatted (`terraform fmt`)
- [ ] Validation passes (`terraform validate`)
- [ ] Plan works (`terraform plan`)
- [ ] Cost is reasonable (Infracost)
- [ ] No hardcoded credentials
- [ ] All required tags present
- [ ] Outputs defined
- [ ] Comments added
- [ ] Tested locally

## 🔗 Important Links

- Course Repo: https://github.com/shart-cloud/labs_terraform_course
- Your Fork: https://github.com/YOUR-USERNAME/labs_terraform_course
- Your PRs: https://github.com/YOUR-USERNAME/labs_terraform_course/pulls

---

**Ready?** Start with [Week 0, Lab 0](week-00/lab-00/README.md)! 🎓
