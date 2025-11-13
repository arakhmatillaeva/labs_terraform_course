# Week 0: Environment Setup & Cost Management

## Learning Outcomes

By the end of this week, you will be able to:

- Install and configure Terraform CLI (version 1.9.0 or later required)
- Configure AWS CLI with proper credentials
- Set up and use Git/GitHub for version control
- Install and configure Infracost for cost estimation
- Set up AWS billing alerts and budgets to monitor spending
- Understand the monorepo structure used throughout this course
- Deploy a simple infrastructure and validate cost estimates

## Overview

Week 0 is dedicated to setting up your development environment and understanding cost management fundamentals. These skills are critical for the rest of the course and for real-world cloud infrastructure work.

**Important**: Do not skip this week. Proper environment setup and cost awareness will save you time and money throughout the semester.

## Prerequisites

- Personal AWS account (or access to AWS Academy sandbox)
- GitHub account
- Computer with command-line access (Mac, Linux, or Windows with WSL2)
- Text editor or IDE (VS Code recommended)

## Key Topics

### 1. Tool Installation
- Terraform CLI (version 1.9.0 or later for S3 native locking)
- AWS CLI v2
- Infracost
- Git and GitHub CLI (optional)
- VS Code extensions for Terraform

### 2. AWS Account Setup
- Creating or accessing AWS account
- Configuring IAM users and access keys
- Understanding AWS Free Tier
- Setting up billing alerts ($10-20 threshold recommended)

### 3. Cost Management
- Understanding AWS pricing
- Reading AWS bills
- Using Infracost for cost estimation
- Setting up budget notifications with Terraform
- Auto-teardown strategies

### 4. Repository Structure
- Understanding the monorepo layout
- Fork and clone workflow
- Working with week-XX/lab-YY/student-work directories
- Pull request submission process

## Labs

- [Lab 0: Getting Started](lab-00/README.md)

## Resources

- [Terraform Installation Guide](https://learn.hashicorp.com/tutorials/terraform/install-cli)
- [AWS CLI Installation](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
- [Infracost Documentation](https://www.infracost.io/docs/)
- [AWS Free Tier](https://aws.amazon.com/free/)
- [AWS Billing Dashboard](https://console.aws.amazon.com/billing/)

## Next Week

Week 1: Your First Terraform Deployment
