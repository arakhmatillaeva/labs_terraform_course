#!/bin/bash

# Terraform Course Environment Setup Validation Script
# This script validates that all required tools are installed and configured

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "================================================"
echo "Terraform Course Environment Validation"
echo "================================================"
echo ""

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to print status
print_status() {
    if [ $1 -eq 0 ]; then
        echo -e "${GREEN}✓${NC} $2"
    else
        echo -e "${RED}✗${NC} $2"
        ERRORS=$((ERRORS + 1))
    fi
}

ERRORS=0

# Check Terraform
echo "Checking Terraform..."
if command_exists terraform; then
    VERSION=$(terraform version -json | grep -o '"terraform_version":"[^"]*' | cut -d'"' -f4)
    print_status 0 "Terraform installed (version $VERSION)"
else
    print_status 1 "Terraform not found. Install from: https://www.terraform.io/downloads"
fi
echo ""

# Check AWS CLI
echo "Checking AWS CLI..."
if command_exists aws; then
    VERSION=$(aws --version | cut -d' ' -f1 | cut -d'/' -f2)
    print_status 0 "AWS CLI installed (version $VERSION)"
    
    # Check AWS credentials
    if aws sts get-caller-identity >/dev/null 2>&1; then
        ACCOUNT=$(aws sts get-caller-identity --query Account --output text)
        print_status 0 "AWS credentials configured (Account: $ACCOUNT)"
    else
        print_status 1 "AWS credentials not configured. Run: aws configure"
    fi
else
    print_status 1 "AWS CLI not found. Install from: https://aws.amazon.com/cli/"
fi
echo ""

# Check Infracost
echo "Checking Infracost..."
if command_exists infracost; then
    VERSION=$(infracost --version | grep -o 'v[0-9.]*')
    print_status 0 "Infracost installed ($VERSION)"
    
    # Check Infracost API key
    if infracost configure get api_key >/dev/null 2>&1; then
        print_status 0 "Infracost API key configured"
    else
        print_status 1 "Infracost API key not configured. Run: infracost auth login"
    fi
else
    print_status 1 "Infracost not found. Install from: https://www.infracost.io/docs/"
fi
echo ""

# Check Git
echo "Checking Git..."
if command_exists git; then
    VERSION=$(git --version | cut -d' ' -f3)
    print_status 0 "Git installed (version $VERSION)"
    
    # Check git config
    if git config user.name >/dev/null 2>&1 && git config user.email >/dev/null 2>&1; then
        USER=$(git config user.name)
        print_status 0 "Git user configured ($USER)"
    else
        print_status 1 "Git user not configured. Run: git config --global user.name 'Your Name' && git config --global user.email 'you@example.com'"
    fi
else
    print_status 1 "Git not found. Install from: https://git-scm.com/downloads"
fi
echo ""

# Check optional tools
echo "Checking optional tools..."
if command_exists code; then
    print_status 0 "VS Code installed"
else
    echo -e "${YELLOW}⚠${NC} VS Code not found (recommended but optional)"
fi
echo ""

# Summary
echo "================================================"
if [ $ERRORS -eq 0 ]; then
    echo -e "${GREEN}✓ All checks passed! You're ready to start.${NC}"
    exit 0
else
    echo -e "${RED}✗ Found $ERRORS error(s). Please fix the issues above.${NC}"
    exit 1
fi
