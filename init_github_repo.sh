#!/bin/bash

# This script initializes a Git repository in the current directory,
# connects it to a remote GitHub repository, and pushes the initial commit.

# --- Configuration ---
# You can change the default branch name here if your GitHub repo uses 'master'
# instead of 'main'. GitHub's default is now 'main'.
DEFAULT_BRANCH="main" 

# --- Script Logic ---

# 1. Check if the GitHub repository URL is provided as an argument
if [ -z "$1" ]; then
  echo "Usage: $0 <github_repo_url>"
  echo "Example: $0 https://github.com/your-username/your-repo-name.git"
  exit 1
fi

GITHUB_REPO_URL="$1" # Assign the first argument to a variable for clarity

echo "--- Initializing Git Repository ---"

# 2. Initialize a new Git repository in the current directory
#    If a repo already exists, this command will re-initialize it.
git init
if [ $? -ne 0 ]; then
  echo "Error: Failed to initialize Git repository. Make sure Git is installed."
  exit 1
fi
echo "Git repository initialized."

# 3. Add all files in the current directory to the staging area
echo "Adding all files to the staging area..."
git add .
if [ $? -ne 0 ]; then
  echo "Error: Failed to add files to staging area."
  exit 1
fi
echo "Files added."

# 4. Create the initial commit
echo "Creating initial commit..."
git commit -m "Initial commit of project"
if [ $? -ne 0 ]; then
  echo "Error: Failed to create initial commit. No changes to commit?"
  # This might happen if git init was run on an empty directory and no files were added.
  # Or if there were no actual changes since the last commit.
  # We'll allow it to proceed if remote add/push is still desired.
fi
echo "Initial commit created."

# 5. Add the remote GitHub repository
echo "Adding remote origin: ${GITHUB_REPO_URL}..."
# Check if 'origin' remote already exists
if git remote get-url origin &> /dev/null; then
  echo "Warning: 'origin' remote already exists. Updating its URL."
  git remote set-url origin "${GITHUB_REPO_URL}"
else
  git remote add origin "${GITHUB_REPO_URL}"
fi

if [ $? -ne 0 ]; then
  echo "Error: Failed to add/set remote origin. Check the URL and your network connection."
  exit 1
fi
echo "Remote origin added/updated."

# 6. Push the local repository to GitHub
echo "Pushing to GitHub on branch '${DEFAULT_BRANCH}'..."
git push -u origin "${DEFAULT_BRANCH}"
if [ $? -ne 0 ]; then
  echo "Error: Failed to push to GitHub."
  echo "Possible reasons:"
  echo "  - Authentication failed (GitHub requires Personal Access Tokens for HTTPS)."
  echo "  - The branch '${DEFAULT_BRANCH}' does not exist on the remote and needs to be created."
  echo "  - The remote repository is not empty and has conflicting history."
  echo "Please check your GitHub token and the remote repository state."
  exit 1
fi
echo "Successfully pushed to GitHub!"
echo "Your project is now live at: ${GITHUB_REPO_URL}"

