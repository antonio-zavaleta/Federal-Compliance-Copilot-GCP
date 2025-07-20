# Contributing to Federal-Compliance-Copilot-GCP

Thank you for your interest in contributing! This project follows best practices for collaborative development. Please read these guidelines before making a contribution.

## Getting Started
- Fork the repository and clone your fork.
- Create a new branch for your change (use descriptive names, e.g., `feature/contributing-md`).
- Make your changes and commit them using Conventional Commits (see below).
- Push your branch and open a Pull Request (PR) against the `main` branch.

## Branching Strategy
- Use feature branches for new features: `feature/<short-description>`
- Use fix branches for bug fixes: `fix/<short-description>`
- Use chore branches for maintenance: `chore/<short-description>`

## Conventional Commits
Commit messages should follow the Conventional Commits specification:

```
<type>[optional scope]: <description>
```

**Types:**
- feat:     A new feature
- fix:      A bug fix
- docs:     Documentation only changes
- style:    Changes that do not affect meaning (formatting, etc.)
- refactor: Code change that neither fixes a bug nor adds a feature
- perf:     Performance improvement
- test:     Adding or correcting tests
- chore:    Maintenance tasks
- build:    Changes to build process or dependencies
- ci:       Changes to CI/CD configuration
- revert:   Revert a previous commit

**Examples:**
- feat: add RAG pipeline for PDF ingestion
- fix: correct PDF parsing error
- docs: update README with setup instructions

## Pull Requests
- Ensure your branch is up to date with `main` before opening a PR.
- Provide a clear description of your changes and reference related issues.
- All code should be tested and linted before submission.
- PRs should be reviewed and approved before merging.

## Code Style & Quality
- Follow PEP8 for Python code.
- Add tests for new features and bug fixes.
- Use logging for important events and errors.
- Document public functions and modules.

## Security & Secrets
- Never commit secrets, credentials, or sensitive data.
- Use environment variables and `.env` files (which are gitignored).

## Issues
- Use GitHub Issues to report bugs, request features, or ask questions.
- Provide as much detail as possible.

## Community
- Be respectful and constructive in all communications.
- Help others by reviewing PRs and answering questions.

---

Thank you for helping make this project better!
