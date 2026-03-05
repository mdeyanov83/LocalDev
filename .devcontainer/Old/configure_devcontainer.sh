#!/usr/bin/env bash
echo "Setting up development environment..."

set -e

# Prompt for Github authentication token
if [ -z "$GITHUB_TOKEN" ]; then
  read -p "Enter your GitHub Token: " GITHUB_TOKEN
  # Not needed, unless using GitHub CLI
  # echo "export GITHUB_TOKEN=$GITHUB_TOKEN" >> ~/.bashrc
  export GITHUB_TOKEN
fi

# Ensure required variables are set
if [ -z "$GITHUB_USERNAME" ] || [ -z "$GITHUB_NOREPLY_EMAIL" ] || [ -z "$GITHUB_REPO" ] || [ -z "$GITHUB_TOKEN" ]; then
    echo "❌ Missing one or more env vars: GITHUB_USERNAME, GITHUB_EMAIL, GITHUB_REPO, GITHUB_TOKEN"
    exit 1
fi

# Configure Git identity
git config --global user.name "$GITHUB_USERNAME"
git config --global user.email "$GITHUB_NOREPLY_EMAIL"

# Configure Git settings
git config --global init.defaultBranch main # Default branch (main) as per GitHub best practices
git config --global pull.rebase false # Disable rebase
git config --global user.userConfigOnly true # Safety: prevent Git from guessing your email
git config --global --unset-all credential.helper
git config --global credential.helper store # Store credential storage so pushes don't prompt
git config --global core.autocrlf input # Prevent CRLF line endings

REPO_DIR="$GITHUB_REPO"
REMOTE_URL="https://github.com/$GITHUB_USERNAME/$GITHUB_REPO.git"

# Check if repository folder exists. If yes, update remote URL, if not clone the repo
if [ -d "$REPO_DIR/.git" ]; then
  echo "✅ $REPO_DIR already exists. Updating remote URL..."
  cd "$REPO_DIR"
  git remote set-url origin "$REMOTE_URL"
else
  echo "✅ $REPO_DIR directory not found. Cloning repository..."
  git clone "$REMOTE_URL"
fi

# Store credentials so pushes don't prompt
echo "https://$GITHUB_USERNAME:$GITHUB_TOKEN@github.com" > ~/.git-credentials

echo "✅ GitHub authentication configured for $GITHUB_USERNAME/$GITHUB_REPO"

echo "DevContainer ready!"
