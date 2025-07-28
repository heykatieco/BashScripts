#!/bin/bash

# Check for commit message and store to variable

# 1. Check if the commit message is provided as an argument
if [ -z "$1" ]; then
  echo "Usage: $0 <github_cmt_msg>"
  exit 1
fi

GITHUB_CMT_MSG="$1" # Assign the first argument to a variable for clarity

# operation git status

echo "Git status"

git status

# operation git add 

echo "Add all changes from current work"

git add .

# git commit -m "Changes"
echo "Committing changes with $GITHUB_CMT_MSG"
git commit -m "$GITHUB_CMT_MSG"

# git push origin main 
echo "Pushing changes to main"
git push origin main

echo "Committed and pushed"

