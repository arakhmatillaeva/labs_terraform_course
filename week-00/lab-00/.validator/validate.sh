#!/bin/bash
#
# Lab 00 Validator Script
# Validates that student's Terraform plan meets lab requirements
#
# Usage: validate.sh <path-to-plan.json>
#

set -e

PLAN_FILE="${1:-/tmp/plan.json}"
ERRORS=0
POINTS=0

echo "================================================"
echo "Lab 00 Validation - S3 Bucket with Versioning"
echo "================================================"
echo ""

# Check if plan file exists
if [ ! -f "$PLAN_FILE" ]; then
  echo "❌ ERROR: Plan file not found at $PLAN_FILE"
  exit 1
fi

# Helper function to check for resource in plan
check_resource() {
  local resource_type=$1
  local resource_name=$2
  local description=$3
  
  COUNT=$(jq "[.planned_values.root_module.resources[]? | select(.type == \"$resource_type\")] | length" "$PLAN_FILE")
  
  if [ "$COUNT" -gt 0 ]; then
    echo "✅ $description found ($COUNT instance(s))"
    return 0
  else
    echo "❌ $description NOT found"
    ERRORS=$((ERRORS + 1))
    return 1
  fi
}

# Helper function to check resource attributes
check_attribute() {
  local resource_type=$1
  local attribute_path=$2
  local expected_value=$3
  local description=$4
  
  VALUE=$(jq -r "[.planned_values.root_module.resources[]? | select(.type == \"$resource_type\") | $attribute_path] | first" "$PLAN_FILE")
  
  if [ "$VALUE" == "$expected_value" ]; then
    echo "✅ $description: $VALUE"
    return 0
  else
    echo "❌ $description: Expected '$expected_value', got '$VALUE'"
    ERRORS=$((ERRORS + 1))
    return 1
  fi
}

# Helper function to check if attribute exists
check_attribute_exists() {
  local resource_type=$1
  local attribute_path=$2
  local description=$3
  
  VALUE=$(jq -r "[.planned_values.root_module.resources[]? | select(.type == \"$resource_type\") | $attribute_path] | first" "$PLAN_FILE")
  
  if [ "$VALUE" != "null" ] && [ ! -z "$VALUE" ]; then
    echo "✅ $description exists: $VALUE"
    return 0
  else
    echo "❌ $description is missing or null"
    ERRORS=$((ERRORS + 1))
    return 1
  fi
}

echo "🔍 Checking Lab Requirements..."
echo ""

# ==================== REQUIREMENT 1: S3 Bucket (5 points) ====================
echo "Requirement 1: S3 Bucket Resource"
if check_resource "aws_s3_bucket" "test_bucket" "S3 Bucket"; then
  POINTS=$((POINTS + 5))
  
  # Check bucket naming includes student identifier
  BUCKET_NAME=$(jq -r '[.planned_values.root_module.resources[]? | select(.type == "aws_s3_bucket") | .values.bucket] | first' "$PLAN_FILE")
  
  if [[ "$BUCKET_NAME" =~ lab-00 ]] || [[ "$BUCKET_NAME" =~ terraform ]]; then
    echo "  ✅ Bucket name includes lab identifier: $BUCKET_NAME"
    POINTS=$((POINTS + 2))
  else
    echo "  ⚠️ Bucket name should include 'lab-00' or 'terraform': $BUCKET_NAME"
  fi
else
  echo "  ℹ️ Expected: resource \"aws_s3_bucket\" \"test_bucket\" {...}"
fi
echo ""

# ==================== REQUIREMENT 2: Versioning Enabled (5 points) ====================
echo "Requirement 2: S3 Bucket Versioning"
if check_resource "aws_s3_bucket_versioning" "test_bucket_versioning" "S3 Bucket Versioning"; then
  POINTS=$((POINTS + 5))
  
  # Check versioning is enabled
  VERSIONING_STATUS=$(jq -r '[.planned_values.root_module.resources[]? | select(.type == "aws_s3_bucket_versioning") | .values.versioning_configuration[0].status] | first' "$PLAN_FILE")
  
  if [ "$VERSIONING_STATUS" == "Enabled" ]; then
    echo "  ✅ Versioning status: Enabled"
    POINTS=$((POINTS + 3))
  else
    echo "  ❌ Versioning status should be 'Enabled', got: $VERSIONING_STATUS"
    ERRORS=$((ERRORS + 1))
  fi
else
  echo "  ℹ️ Expected: resource \"aws_s3_bucket_versioning\" {...} with status = \"Enabled\""
fi
echo ""

# ==================== REQUIREMENT 3: S3 Bucket Encryption (5 points) ====================
echo "Requirement 3: S3 Bucket Encryption"
if check_resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" "S3 Bucket Encryption"; then
  POINTS=$((POINTS + 5))
  
  # Check encryption algorithm
  ENCRYPTION_ALGO=$(jq -r '[.planned_values.root_module.resources[]? | select(.type == "aws_s3_bucket_server_side_encryption_configuration") | .values.rule[0].apply_server_side_encryption_by_default[0].sse_algorithm] | first' "$PLAN_FILE")
  
  if [ "$ENCRYPTION_ALGO" == "AES256" ] || [ "$ENCRYPTION_ALGO" == "aws:kms" ]; then
    echo "  ✅ Encryption algorithm: $ENCRYPTION_ALGO"
    POINTS=$((POINTS + 2))
  else
    echo "  ⚠️ Encryption algorithm not clearly specified: $ENCRYPTION_ALGO"
  fi
else
  echo "  ℹ️ Expected: resource \"aws_s3_bucket_server_side_encryption_configuration\" {...}"
fi
echo ""

# ==================== REQUIREMENT 4: Required Tags (8 points) ====================
echo "Requirement 4: Required Tags on S3 Bucket"

REQUIRED_TAGS=("Name" "Environment" "ManagedBy" "Student" "AutoTeardown")
TAG_POINTS=0

for TAG in "${REQUIRED_TAGS[@]}"; do
  TAG_VALUE=$(jq -r "[.planned_values.root_module.resources[]? | select(.type == \"aws_s3_bucket\") | .values.tags.\"$TAG\"] | first" "$PLAN_FILE")
  
  if [ "$TAG_VALUE" != "null" ] && [ ! -z "$TAG_VALUE" ]; then
    echo "  ✅ Tag '$TAG' = '$TAG_VALUE'"
    TAG_POINTS=$((TAG_POINTS + 1))
  else
    echo "  ❌ Tag '$TAG' is missing"
    ERRORS=$((ERRORS + 1))
  fi
done

# Award points based on tags found (max 8 points, ~1.6 per tag)
if [ $TAG_POINTS -eq 5 ]; then
  POINTS=$((POINTS + 8))
  echo "  ✅ All required tags present (8/8 points)"
elif [ $TAG_POINTS -ge 3 ]; then
  POINTS=$((POINTS + 5))
  echo "  ⚠️ Some tags missing (5/8 points)"
else
  POINTS=$((POINTS + 2))
  echo "  ❌ Most tags missing (2/8 points)"
fi
echo ""

# ==================== REQUIREMENT 5: Provider Configuration (2 points) ====================
echo "Requirement 5: Provider Configuration"

# Check if AWS provider is properly configured in the configuration (not from plan)
# We'll check the plan for basic provider usage
PROVIDER_COUNT=$(jq '[.configuration.provider_config.aws // empty] | length' "$PLAN_FILE")

if [ "$PROVIDER_COUNT" -gt 0 ]; then
  echo "  ✅ AWS provider configured"
  POINTS=$((POINTS + 2))
else
  echo "  ⚠️ AWS provider configuration not clearly visible in plan"
  # Don't penalize heavily as plan.json may not show provider details clearly
  POINTS=$((POINTS + 1))
fi
echo ""

# ==================== SUMMARY ====================
echo "================================================"
echo "Validation Summary"
echo "================================================"
echo "Errors found: $ERRORS"
echo "Points earned: $POINTS/30"
echo ""

if [ $ERRORS -eq 0 ]; then
  echo "✅ ALL CHECKS PASSED! Excellent work!"
  echo ""
  exit 0
elif [ $POINTS -ge 22 ]; then
  echo "⚠️ MOSTLY PASSED - Minor issues found"
  echo ""
  exit 0
else
  echo "❌ VALIDATION FAILED - Please fix the errors above"
  echo ""
  exit 1
fi
