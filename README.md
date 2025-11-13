# Documentation Index

Complete guide to all documentation in this repository.

## 📚 For Students

### Getting Started
1. **[README.md](README.md)** - Course overview and structure
2. **[QUICK_START.md](QUICK_START.md)** - Fast-track setup guide (15 min)
3. **[STUDENT_SETUP.md](STUDENT_SETUP.md)** - Detailed setup instructions (1 hour)

### GitHub Configuration
4. **[GITHUB_CLI_SETUP.md](GITHUB_CLI_SETUP.md)** - Install GitHub CLI and set up secrets
   - Fastest way to configure your repository
   - Step-by-step installation for all platforms
   - Interactive script: `./scripts/setup-secrets.sh`

### Lab Instructions
5. **[Week 0 Overview](week-00/README.md)** - Environment setup & cost management
6. **[Lab 0 Instructions](week-00/lab-00/README.md)** - Your first Terraform deployment
7. **[Lab 0 Submission](week-00/lab-00/SUBMISSION.md)** - Grading rubric and checklist

### Submission & Grading
- Pull requests are created **in your fork** (not to main repo)
- Automated grading runs on every PR
- Grades posted as PR comments within 5 minutes
- Can resubmit unlimited times

## 🎓 For Instructors

### System Documentation
1. **[GRADING_SYSTEM.md](GRADING_SYSTEM.md)** - Complete grading system documentation
   - How automated grading works
   - Points breakdown (100 total)
   - Creating lab validators
   - Monitoring student submissions

### Configuration Files
2. **[.github/workflows/grading.yml](.github/workflows/grading.yml)** - Main grading workflow
   - 100-point automated grading
   - Security scanning with Checkov
   - Cost analysis with Infracost
   - Lab-specific validation

3. **[week-00/lab-00/.validator/](week-00/lab-00/.validator/)** - Lab 0 validator
   - Example validator implementation
   - Template for creating new validators

### Agent Instructions
4. **[AGENTS.md](AGENTS.md)** - Instructions for AI coding assistants
   - Repository structure
   - Code style guidelines
   - Terraform requirements

## 📖 Reference Documentation

### Common Resources
- **[common/billing-setup/](common/billing-setup/)** - Billing alert configuration
- **[common/backend.tf.example](common/backend.tf.example)** - S3 backend template
- **[common/terraform.tfvars.example](common/terraform.tfvars.example)** - Variables template

### Scripts
- **[scripts/setup.sh](scripts/setup.sh)** - Environment validation script
- **[scripts/setup-secrets.sh](scripts/setup-secrets.sh)** - GitHub secrets setup script

## 🔍 Quick Navigation

### "I want to..."

#### ...start the course as a student
→ [QUICK_START.md](QUICK_START.md)

#### ...set up GitHub secrets quickly
→ [GITHUB_CLI_SETUP.md](GITHUB_CLI_SETUP.md) or run `./scripts/setup-secrets.sh`

#### ...understand how grading works
→ [GRADING_SYSTEM.md](GRADING_SYSTEM.md) (students: see section "Grading Breakdown")

#### ...create a new lab as an instructor
→ [GRADING_SYSTEM.md](GRADING_SYSTEM.md) → "Creating a Lab Validator"

#### ...troubleshoot GitHub Actions errors
→ [STUDENT_SETUP.md](STUDENT_SETUP.md) → "Troubleshooting" section

#### ...understand the repository structure
→ [README.md](README.md) → "Repository Structure"

#### ...customize grading criteria
→ [GRADING_SYSTEM.md](GRADING_SYSTEM.md) → "Customization Guide"

## 📋 Document Purpose Summary

| Document | Audience | Purpose | Time Required |
|----------|----------|---------|---------------|
| README.md | Everyone | Course overview | 5 min read |
| QUICK_START.md | Students | Fast setup | 15 min |
| STUDENT_SETUP.md | Students | Detailed setup | 1 hour |
| GITHUB_CLI_SETUP.md | Students | CLI secret setup | 10 min |
| GRADING_SYSTEM.md | Instructors | System documentation | 30 min |
| AGENTS.md | AI Assistants | Repository guidelines | 5 min |

## 🔄 Typical Student Journey

```
1. Read README.md
   ↓
2. Follow QUICK_START.md
   ↓
3. Use GITHUB_CLI_SETUP.md to set secrets
   OR run ./scripts/setup-secrets.sh
   ↓
4. Read week-00/README.md
   ↓
5. Complete week-00/lab-00/README.md
   ↓
6. Check week-00/lab-00/SUBMISSION.md
   ↓
7. Create PR (see STUDENT_SETUP.md)
   ↓
8. Review grading results
   ↓
9. Iterate and improve (if needed)
   ↓
10. Tag instructor for final review
```

## 🔄 Typical Instructor Journey

```
1. Review GRADING_SYSTEM.md
   ↓
2. Test the grading workflow
   ↓
3. Create new lab directory
   ↓
4. Write lab README.md and SUBMISSION.md
   ↓
5. Create .validator/validate.sh
   ↓
6. Test validator with sample solutions
   ↓
7. Adjust grading weights if needed
   ↓
8. Monitor student forks for submissions
   ↓
9. Review automated grades
   ↓
10. Provide manual feedback as needed
```

## 📊 Grading Overview

**Total: 100 points**

| Category | Points | Key Checks |
|----------|--------|------------|
| Code Quality | 25 | Formatting, validation, credentials, naming, versioning |
| Functionality | 30 | Lab-specific tests, outputs, resources |
| Cost Management | 20 | Infracost, budget compliance, teardown tags |
| Security | 15 | Checkov security scanning |
| Documentation | 10 | Comments, README |

**Letter Grades**: A (90+), B (80-89), C (70-79), D (60-69), F (<60)

## 🛠️ Tools Used

### Student Tools
- **Terraform** 1.9.0+ - Infrastructure as Code
- **AWS CLI** - AWS account management
- **Infracost** - Cost estimation
- **Git** - Version control
- **GitHub CLI** (optional) - Secret management

### Grading Tools (automatic)
- **terraform fmt/validate** - Code quality
- **tflint** - Linting
- **Checkov** - Security scanning
- **Infracost** - Cost analysis
- **jq** - JSON parsing
- **Custom validators** - Lab-specific checks

## 🔒 Security Notes

### For Students
- ✅ Never commit AWS credentials
- ✅ Use GitHub Secrets for credentials
- ✅ Store secrets in YOUR fork only
- ✅ Credentials are masked in logs
- ✅ Use .gitignore properly

### For Instructors
- ✅ No access to student credentials needed
- ✅ Students use their own AWS accounts
- ✅ No shared infrastructure
- ✅ Each student isolated
- ✅ Workflows run in student forks

## 📞 Getting Help

### Students
1. Check lab README troubleshooting section
2. Review [STUDENT_SETUP.md](STUDENT_SETUP.md) → Troubleshooting
3. Look at workflow logs on GitHub
4. Post in course discussion forum
5. Attend office hours
6. Tag instructor in PR: `@shart-cloud`

### Instructors
- Review [GRADING_SYSTEM.md](GRADING_SYSTEM.md)
- Check workflow YAML syntax
- Test validators with sample solutions
- Review GitHub Actions logs

## 🔗 External Resources

- [Terraform Documentation](https://www.terraform.io/docs)
- [AWS CLI Documentation](https://docs.aws.amazon.com/cli/)
- [Infracost Documentation](https://www.infracost.io/docs/)
- [GitHub CLI Documentation](https://cli.github.com/manual/)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Checkov Documentation](https://www.checkov.io/documentation/)

## 📝 Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2025-11-13 | Initial grading system implementation |

## 🤝 Contributing

This is a course repository. Students should:
- Work in their own forks
- Not submit PRs to the main repository
- Complete assignments in `student-work/` directories

Instructors can:
- Add new labs
- Improve documentation
- Enhance validators
- Adjust grading criteria

---

**Last Updated**: 2025-11-13  
**Maintained By**: Jared Gore (@shart.cloud)
