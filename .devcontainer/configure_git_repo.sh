#!/usr/bin/env bash
set -euo pipefail

echo "Setting up development environment..."

########################################
# Prompt for GitHub token (secure input)
########################################
if [ -z "${GITHUB_TOKEN:-}" ]; then
  echo
  read -p "Enter your GitHub Personal Access Token: " GITHUB_TOKEN
  echo
fi

########################################
# Validate required variables
########################################
if [ -z "${GITHUB_USERNAME:-}" ] || \
   [ -z "${GITHUB_NOREPLY_EMAIL:-}" ] || \
   [ -z "${GITHUB_REPO:-}" ] || \
   [ -z "${GITHUB_TOKEN:-}" ]; then
    echo "❌ Missing one or more required variables:"
    echo "   GITHUB_USERNAME"
    echo "   GITHUB_NOREPLY_EMAIL"
    echo "   GITHUB_REPO"
    echo "   GITHUB_TOKEN"
    exit 1
fi

########################################
# Configure Git identity
########################################
git config --global user.name "$GITHUB_USERNAME"
git config --global user.email "$GITHUB_NOREPLY_EMAIL"

########################################
# Configure Git settings
########################################
git config --global init.defaultBranch main
git config --global pull.rebase false
git config --global user.userConfigOnly true
git config --global core.autocrlf input

# Configure credential helper BEFORE any network operations
git config --global --unset-all credential.helper || true
git config --global credential.helper storee

########################################
# Pre-approve credentials (fixes timing issue)
########################################
printf "protocol=https\nhost=github.com\nusername=%s\npassword=%s\n\n" \
  "$GITHUB_USERNAME" "$GITHUB_TOKEN" | git credential approve

########################################
# Repository setup
########################################
REPO_DIR="$GITHUB_REPO"
REMOTE_URL="https://github.com/$GITHUB_USERNAME/$GITHUB_REPO.git"

if [ -d "$REPO_DIR/.git" ]; then
  echo "✅ Repository exists. Updating remote URL..."
  cd "$REPO_DIR"
  git remote set-url origin "$REMOTE_URL"
else
  echo "✅ Repository not found. Cloning..."
  git clone "$REMOTE_URL"
fi

########################################
# Final confirmation
########################################
echo "✅ GitHub authentication configured for $GITHUB_USERNAME/$GITHUB_REPO"
echo "DevContainer ready!"
