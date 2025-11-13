#!/bin/bash
#
# GitHub Secrets Setup Script
# Interactive script to configure GitHub Actions secrets for automated grading
#
# Usage: ./scripts/setup-secrets.sh
#

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo ""
echo "================================================================"
echo "  GitHub Secrets Setup for Terraform Course"
echo "================================================================"
echo ""

# Function to print colored messages
print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

# Check if gh is installed
echo "Checking prerequisites..."
if ! command -v gh &> /dev/null; then
    print_error "GitHub CLI (gh) is not installed."
    echo ""
    echo "Please install it first:"
    echo "  macOS:    brew install gh"
    echo "  Ubuntu:   sudo apt install gh"
    echo "  Windows:  winget install GitHub.cli"
    echo ""
    echo "Or visit: https://cli.github.com/"
    exit 1
fi
print_success "GitHub CLI is installed"

# Check GitHub CLI version
GH_VERSION=$(gh --version | head -1 | awk '{print $3}')
print_info "GitHub CLI version: $GH_VERSION"

# Check if authenticated
echo ""
echo "Checking GitHub authentication..."
if ! gh auth status &> /dev/null 2>&1; then
    print_error "Not authenticated with GitHub."
    echo ""
    echo "Please authenticate first:"
    echo "  gh auth login"
    echo ""
    exit 1
fi
print_success "Authenticated with GitHub"

# Show current user
GITHUB_USER=$(gh api user -q .login)
print_info "Logged in as: $GITHUB_USER"

# Check if in a git repository
echo ""
echo "Checking repository..."
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    print_error "Not in a git repository."
    echo ""
    echo "Please cd into your labs_terraform_course directory and try again"
    exit 1
fi
print_success "In a git repository"

# Check repository details
REPO_NAME=$(gh repo view --json nameWithOwner -q .nameWithOwner 2>/dev/null || echo "unknown")
print_info "Repository: $REPO_NAME"

# Verify this is the student's fork
if [[ ! "$REPO_NAME" == *"$GITHUB_USER"* ]]; then
    print_warning "This doesn't appear to be your fork!"
    print_warning "Expected: $GITHUB_USER/labs_terraform_course"
    print_warning "Found: $REPO_NAME"
    echo ""
    read -p "Continue anyway? (y/n) " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Cancelled. Please cd into your fork directory and run this script again."
        exit 1
    fi
fi

# Confirm before proceeding
echo ""
echo "================================================================"
print_info "This script will set up three GitHub Actions secrets:"
echo "  1. AWS_ACCESS_KEY_ID"
echo "  2. AWS_SECRET_ACCESS_KEY"
echo "  3. INFRACOST_API_KEY"
echo ""
print_warning "These secrets will be stored securely in your GitHub repository"
print_warning "and used by automated grading workflows."
echo ""
read -p "Ready to continue? (y/n) " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Cancelled."
    exit 0
fi

echo ""
echo "================================================================"
echo "  Setting Up Secrets"
echo "================================================================"

# Function to set a secret with validation
set_secret() {
    local secret_name=$1
    local secret_description=$2
    local validation_pattern=$3
    
    echo ""
    echo "────────────────────────────────────────────────────────────────"
    echo "Setting: $secret_name"
    echo "$secret_description"
    echo "────────────────────────────────────────────────────────────────"
    
    # Check if secret already exists
    if gh secret list | grep -q "^$secret_name"; then
        print_warning "Secret '$secret_name' already exists"
        read -p "Overwrite it? (y/n) " -n 1 -r
        echo ""
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            print_info "Skipped $secret_name"
            return 0
        fi
    fi
    
    echo ""
    echo "Paste your $secret_name and press Enter, then Ctrl+D (or Cmd+D on Mac):"
    
    # Set the secret (gh secret set reads from stdin)
    if gh secret set "$secret_name" 2>&1; then
        print_success "Secret '$secret_name' set successfully"
        return 0
    else
        print_error "Failed to set secret '$secret_name'"
        return 1
    fi
}

# Set AWS Access Key ID
set_secret \
    "AWS_ACCESS_KEY_ID" \
    "Your AWS Access Key ID (starts with AKIA...)" \
    "^AKIA[A-Z0-9]{16}$"

# Set AWS Secret Access Key
set_secret \
    "AWS_SECRET_ACCESS_KEY" \
    "Your AWS Secret Access Key (40 alphanumeric characters)" \
    ""

# Set Infracost API Key
echo ""
echo "────────────────────────────────────────────────────────────────"
print_info "If you don't have an Infracost API key yet:"
echo "  1. Run: infracost auth login"
echo "  2. Run: infracost configure get api_key"
echo "  3. Copy the key that starts with 'ico-'"
echo "────────────────────────────────────────────────────────────────"

set_secret \
    "INFRACOST_API_KEY" \
    "Your Infracost API Key (starts with ico-...)" \
    ""

# Verify all secrets are set
echo ""
echo "================================================================"
echo "  Verification"
echo "================================================================"
echo ""

SECRETS_LIST=$(gh secret list)
echo "$SECRETS_LIST"
echo ""

# Check for required secrets
MISSING_SECRETS=()

if ! echo "$SECRETS_LIST" | grep -q "AWS_ACCESS_KEY_ID"; then
    MISSING_SECRETS+=("AWS_ACCESS_KEY_ID")
fi

if ! echo "$SECRETS_LIST" | grep -q "AWS_SECRET_ACCESS_KEY"; then
    MISSING_SECRETS+=("AWS_SECRET_ACCESS_KEY")
fi

if ! echo "$SECRETS_LIST" | grep -q "INFRACOST_API_KEY"; then
    MISSING_SECRETS+=("INFRACOST_API_KEY")
fi

if [ ${#MISSING_SECRETS[@]} -eq 0 ]; then
    print_success "All required secrets are configured!"
else
    print_error "Missing secrets: ${MISSING_SECRETS[*]}"
    echo ""
    echo "Please run this script again to set the missing secrets."
    exit 1
fi

# Test AWS credentials (optional)
echo ""
read -p "Test AWS credentials locally? (requires AWS CLI) (y/n) " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    if command -v aws &> /dev/null; then
        echo ""
        print_info "Testing AWS credentials..."
        if aws sts get-caller-identity &> /dev/null; then
            print_success "AWS credentials are valid!"
            ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
            print_info "AWS Account ID: $ACCOUNT_ID"
        else
            print_warning "AWS credentials test failed"
            print_warning "This might mean your local AWS CLI config is different"
            print_warning "The GitHub secrets should still work for automated grading"
        fi
    else
        print_warning "AWS CLI not installed, skipping test"
    fi
fi

# Test Infracost API key (optional)
echo ""
read -p "Test Infracost API key locally? (requires Infracost CLI) (y/n) " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    if command -v infracost &> /dev/null; then
        echo ""
        print_info "Testing Infracost API key..."
        if infracost configure get api_key &> /dev/null; then
            print_success "Infracost is configured!"
            LOCAL_KEY=$(infracost configure get api_key 2>/dev/null || echo "not set")
            print_info "Local Infracost key: ${LOCAL_KEY:0:15}..."
        else
            print_warning "Infracost configuration test failed"
        fi
    else
        print_warning "Infracost CLI not installed, skipping test"
    fi
fi

# Final summary
echo ""
echo "================================================================"
echo "  Setup Complete!"
echo "================================================================"
echo ""
print_success "All GitHub Actions secrets are configured"
echo ""
echo "Next steps:"
echo "  1. Complete your first lab (week-00/lab-00)"
echo "  2. Commit and push your work"
echo "  3. Create a pull request in YOUR fork"
echo "  4. The grading workflow will run automatically"
echo ""
print_info "For detailed instructions, see: STUDENT_SETUP.md"
echo ""

# Offer to create a test PR
read -p "Create a test PR to verify the setup? (y/n) " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo ""
    print_info "Creating test branch and PR..."
    
    # Create test branch
    TEST_BRANCH="test-secrets-$(date +%s)"
    git checkout -b "$TEST_BRANCH" 2>/dev/null || git checkout "$TEST_BRANCH"
    
    # Create a minimal test file
    mkdir -p week-00/lab-00/student-work
    cat > week-00/lab-00/student-work/.test.tf <<'EOF'
# Test file to trigger GitHub Actions workflow
# This file can be deleted after testing

terraform {
  required_version = ">= 1.9.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
EOF
    
    git add week-00/lab-00/student-work/.test.tf
    git commit -m "Test: GitHub Actions secrets setup" 2>/dev/null || true
    git push -u origin "$TEST_BRANCH" 2>/dev/null || true
    
    # Create PR
    if gh pr create \
        --title "Test: Secrets Configuration" \
        --body "Testing GitHub Actions secrets configuration. This PR can be closed after verifying the workflow runs successfully." \
        2>/dev/null; then
        print_success "Test PR created!"
        echo ""
        echo "Check the workflow status:"
        echo "  gh pr checks"
        echo "  gh run view --web"
        echo ""
        print_info "If the workflow runs without errors, your setup is complete!"
        print_info "You can close this test PR after verification."
    else
        print_warning "Could not create test PR automatically"
        print_info "You can create it manually on GitHub"
    fi
else
    print_info "Skipped test PR creation"
    echo ""
    echo "You can test the setup by completing a lab and creating a PR"
fi

echo ""
echo "================================================================"
print_success "Setup script finished!"
echo "================================================================"
echo ""
