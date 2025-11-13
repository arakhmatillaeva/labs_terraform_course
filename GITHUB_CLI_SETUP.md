# GitHub CLI Setup Guide

This guide shows you how to install the GitHub CLI and use it to securely configure your repository secrets for automated grading.

## Why Use GitHub CLI?

Using the GitHub CLI (`gh`) to set up secrets is:
- ✅ **Faster** than using the web interface
- ✅ **More secure** with interactive prompts (credentials not shown in shell history)
- ✅ **Easier to verify** you've set everything correctly
- ✅ **Repeatable** if you need to update secrets later

## Part 1: Install GitHub CLI

### macOS

Using Homebrew (recommended):
```bash
brew install gh
```

Using MacPorts:
```bash
sudo port install gh
```

### Linux

#### Debian/Ubuntu
```bash
# Add GitHub CLI repository
type -p curl >/dev/null || (sudo apt update && sudo apt install curl -y)
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null

# Install
sudo apt update
sudo apt install gh -y
```

#### Fedora/RHEL/CentOS
```bash
sudo dnf install gh
```

#### Arch Linux
```bash
sudo pacman -S github-cli
```

#### Alpine Linux
```bash
apk add github-cli
```

### Windows

Using Windows Package Manager:
```powershell
winget install --id GitHub.cli
```

Using Chocolatey:
```powershell
choco install gh
```

Using Scoop:
```powershell
scoop install gh
```

### Verify Installation

```bash
gh --version
```

Expected output:
```
gh version 2.x.x (yyyy-mm-dd)
```

## Part 2: Authenticate with GitHub

### Login to GitHub

```bash
gh auth login
```

You'll see a series of prompts:

```
? What account do you want to log into?
❯ GitHub.com
  GitHub Enterprise Server

? What is your preferred protocol for Git operations?
❯ HTTPS
  SSH

? Authenticate Git with your GitHub credentials? (Y/n)
❯ Y

? How would you like to authenticate GitHub CLI?
❯ Login with a web browser
  Paste an authentication token
```

**Recommended choices:**
1. Select **GitHub.com**
2. Select **HTTPS** (easier for most users)
3. Select **Y** to authenticate Git
4. Select **Login with a web browser**

### Complete Authentication

1. Copy the one-time code shown in your terminal
2. Press Enter to open your browser
3. Paste the code and authorize GitHub CLI
4. Return to your terminal - you should see: ✓ Authentication complete

### Verify Authentication

```bash
gh auth status
```

Expected output:
```
github.com
  ✓ Logged in to github.com as YOUR-USERNAME
  ✓ Git operations for github.com configured to use https protocol.
  ✓ Token: gho_************************************
```

## Part 3: Navigate to Your Fork

After forking and cloning the repository:

```bash
cd labs_terraform_course
```

Verify you're in your fork:
```bash
gh repo view
```

This should show **YOUR-USERNAME/labs_terraform_course**, not shart-cloud/labs_terraform_course.

## Part 4: Set Up AWS Credentials as Secrets

### Option A: Interactive Method (Recommended - Most Secure)

This method prompts you for each secret and doesn't store them in your shell history.

```bash
# Set AWS Access Key ID
gh secret set AWS_ACCESS_KEY_ID

# You'll see a prompt - paste your AWS access key and press Enter
# Then press Ctrl+D (or Cmd+D on Mac) to finish
```

```bash
# Set AWS Secret Access Key
gh secret set AWS_SECRET_ACCESS_KEY

# Paste your AWS secret access key and press Enter
# Then press Ctrl+D (or Cmd+D on Mac) to finish
```

**Important**: When you paste your secret:
1. The text will be **hidden** (for security)
2. Press **Enter** after pasting
3. Press **Ctrl+D** (Linux/Mac) or **Cmd+D** (Mac) to finish input
4. You should see: `✓ Set Actions secret AWS_ACCESS_KEY_ID for YOUR-USERNAME/labs_terraform_course`

### Option B: From File Method

If you have your credentials in a file:

```bash
# Assuming credentials are in a file
gh secret set AWS_ACCESS_KEY_ID < ~/aws_access_key.txt
gh secret set AWS_SECRET_ACCESS_KEY < ~/aws_secret_key.txt
```

### Option C: One-Line Method (Less Secure)

⚠️ **Warning**: This stores credentials in your shell history!

```bash
# Only use this if you know how to clear your shell history afterward
echo "YOUR_ACCESS_KEY" | gh secret set AWS_ACCESS_KEY_ID
echo "YOUR_SECRET_KEY" | gh secret set AWS_SECRET_ACCESS_KEY
```

If you use this method, clear your shell history afterward:
```bash
# Bash
history -c

# Zsh
history -p
```

## Part 5: Set Up Infracost API Key

### Get Your Infracost API Key

First, authenticate with Infracost:
```bash
infracost auth login
```

Then retrieve your API key:
```bash
infracost configure get api_key
```

Copy the key shown (starts with `ico-`).

### Set the Secret

Using the interactive method (recommended):
```bash
gh secret set INFRACOST_API_KEY

# Paste your Infracost API key and press Enter
# Then press Ctrl+D (or Cmd+D on Mac) to finish
```

## Part 6: Verify Secrets Are Set

List all secrets in your repository:

```bash
gh secret list
```

Expected output:
```
AWS_ACCESS_KEY_ID       Updated 2024-01-15
AWS_SECRET_ACCESS_KEY   Updated 2024-01-15
INFRACOST_API_KEY       Updated 2024-01-15
```

You'll see the secret names and when they were updated, but **not the actual values** (for security).

## Part 7: Test Your Setup

To ensure everything works, create a test file and trigger the workflow:

```bash
# Create a test branch
git checkout -b test-secrets

# Create a simple test file
mkdir -p week-00/lab-00/student-work
cat > week-00/lab-00/student-work/test.tf <<'EOF'
# Test file to trigger workflow
terraform {
  required_version = ">= 1.9.0"
}
EOF

# Commit and push
git add week-00/lab-00/student-work/test.tf
git commit -m "Test secrets setup"
git push origin test-secrets

# Create a PR using GitHub CLI
gh pr create --title "Test: Secrets Setup" --body "Testing that GitHub Actions secrets are configured correctly"
```

### Check Workflow Status

```bash
# View PR checks
gh pr checks

# View the workflow run in your browser
gh run view --web
```

If the workflow runs without authentication errors, your secrets are configured correctly!

## Updating Secrets

If you need to rotate your AWS credentials or update your Infracost key:

```bash
# Update any secret using the same command
gh secret set AWS_ACCESS_KEY_ID
# Paste new value...

gh secret set AWS_SECRET_ACCESS_KEY
# Paste new value...

gh secret set INFRACOST_API_KEY
# Paste new value...
```

## Deleting Secrets

If you need to remove a secret:

```bash
gh secret delete SECRET_NAME

# Example
gh secret delete AWS_ACCESS_KEY_ID
```

## Troubleshooting

### "error: HTTP 404: Not Found"

**Problem**: GitHub CLI can't find your repository.

**Solution**: 
```bash
# Make sure you're in your repository directory
cd labs_terraform_course

# Verify the remote
git remote -v

# If needed, set the correct remote
git remote set-url origin https://github.com/YOUR-USERNAME/labs_terraform_course.git
```

### "failed to authenticate"

**Problem**: GitHub CLI is not authenticated.

**Solution**:
```bash
# Re-authenticate
gh auth login

# Follow the prompts again
```

### "insufficient permission for org secrets"

**Problem**: Trying to set organization secrets instead of repository secrets.

**Solution**: Make sure you're in your fork's directory, not the original repository.

### Secrets not working in workflow

**Problem**: Workflow fails with authentication errors despite secrets being set.

**Solution**:
```bash
# Verify secrets are set
gh secret list

# Check secret names match exactly (case-sensitive)
# Expected names:
# - AWS_ACCESS_KEY_ID (not aws_access_key_id)
# - AWS_SECRET_ACCESS_KEY (not aws_secret_access_key)
# - INFRACOST_API_KEY (not infracost_api_key)

# If wrong, delete and re-create
gh secret delete WRONG_NAME
gh secret set CORRECT_NAME
```

### "gh: command not found" after installation

**Problem**: GitHub CLI not in PATH.

**Solution**:
```bash
# Restart your terminal or shell
# Or manually add to PATH (location varies by OS/installation method)

# macOS with Homebrew
export PATH="/usr/local/bin:$PATH"

# Linux
export PATH="/usr/bin:$PATH"
```

## Security Best Practices

### ✅ DO:
- Use the interactive method (`gh secret set NAME`) when possible
- Clear shell history if using one-line commands
- Rotate credentials regularly
- Use IAM users with minimum required permissions
- Enable MFA on your AWS account
- Review GitHub Actions logs carefully (secrets are masked but be careful)

### ❌ DON'T:
- Commit credentials to your repository
- Share your API keys with others
- Use root AWS credentials
- Store credentials in plain text files long-term
- Copy secrets from GitHub Actions logs

## Alternative: Using AWS CLI Profiles

If you prefer not to store credentials as GitHub secrets, you can use AWS CLI profiles locally:

```bash
# Configure a profile for the course
aws configure --profile terraform-course

# Use it in your local work
export AWS_PROFILE=terraform-course
terraform plan
```

**Note**: This works locally but you still need GitHub secrets for automated grading to work.

## Complete Setup Script

Here's a complete script to set up all secrets at once:

```bash
#!/bin/bash
# setup-secrets.sh - Interactive script to set up GitHub secrets

echo "=================================="
echo "GitHub Secrets Setup for Terraform Course"
echo "=================================="
echo ""

# Check if gh is installed
if ! command -v gh &> /dev/null; then
    echo "❌ GitHub CLI (gh) is not installed."
    echo "Please install it first: https://cli.github.com/"
    exit 1
fi

# Check if authenticated
if ! gh auth status &> /dev/null; then
    echo "❌ Not authenticated with GitHub."
    echo "Please run: gh auth login"
    exit 1
fi

echo "✅ GitHub CLI is installed and authenticated"
echo ""

# Check if in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "❌ Not in a git repository."
    echo "Please cd into your labs_terraform_course directory"
    exit 1
fi

echo "📂 Current repository:"
gh repo view --json nameWithOwner -q .nameWithOwner
echo ""

# Prompt for confirmation
read -p "Is this your fork of the course repository? (y/n) " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Please cd into your fork directory and run this script again"
    exit 1
fi

echo ""
echo "Setting up secrets..."
echo ""

# AWS Access Key ID
echo "1/3: AWS Access Key ID"
echo "Paste your AWS_ACCESS_KEY_ID and press Enter, then Ctrl+D:"
gh secret set AWS_ACCESS_KEY_ID
echo ""

# AWS Secret Access Key
echo "2/3: AWS Secret Access Key"
echo "Paste your AWS_SECRET_ACCESS_KEY and press Enter, then Ctrl+D:"
gh secret set AWS_SECRET_ACCESS_KEY
echo ""

# Infracost API Key
echo "3/3: Infracost API Key"
echo "Paste your INFRACOST_API_KEY and press Enter, then Ctrl+D:"
gh secret set INFRACOST_API_KEY
echo ""

# Verify
echo "=================================="
echo "Verification"
echo "=================================="
gh secret list

echo ""
echo "✅ Setup complete!"
echo ""
echo "Next steps:"
echo "1. Complete your first lab"
echo "2. Create a pull request"
echo "3. The grading workflow will run automatically"
```

Save this as `setup-secrets.sh`, make it executable, and run it:

```bash
chmod +x setup-secrets.sh
./setup-secrets.sh
```

## Quick Reference

```bash
# Install GitHub CLI
brew install gh                    # macOS
sudo apt install gh               # Ubuntu/Debian
winget install GitHub.cli         # Windows

# Authenticate
gh auth login

# Set secrets (interactive - recommended)
gh secret set AWS_ACCESS_KEY_ID
gh secret set AWS_SECRET_ACCESS_KEY
gh secret set INFRACOST_API_KEY

# Verify secrets
gh secret list

# Update a secret
gh secret set SECRET_NAME

# Delete a secret
gh secret delete SECRET_NAME

# View workflow runs
gh run list
gh run view --web
```

## Additional Resources

- [GitHub CLI Documentation](https://cli.github.com/manual/)
- [GitHub CLI Repository](https://github.com/cli/cli)
- [GitHub Secrets Documentation](https://docs.github.com/en/actions/security-guides/encrypted-secrets)
- [AWS Credentials Best Practices](https://docs.aws.amazon.com/general/latest/gr/aws-access-keys-best-practices.html)

---

**Next Steps**: After setting up secrets, continue with [STUDENT_SETUP.md](STUDENT_SETUP.md) to complete your first lab!
