#!/bin/bash

# ──────────────────────────────────────────────
# 🔄 GitHub Auto-Push Script
# ──────────────────────────────────────────────
# Usage: ./push_github.sh "Your commit message here"
# Example: ./push_github.sh "Added weather agent"
# ──────────────────────────────────────────────

# Colors for pretty output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${YELLOW}🔄 GitHub Auto-Push Script${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

# ──────────────────────────────────────────────
# Step 1: Check if commit message was provided
# ──────────────────────────────────────────────
if [ -z "$1" ]; then
    echo -e "${RED}❌ ERROR: You must provide a commit message!${NC}"
    echo -e "${YELLOW}Usage: ./push_github.sh \"Your commit message here\"${NC}"
    echo -e "${YELLOW}Example: ./push_github.sh \"Added weather agent\"${NC}"
    exit 1
fi

COMMIT_MESSAGE="$1"

# ──────────────────────────────────────────────
# Step 2: Check if we are in a Git repo
# ──────────────────────────────────────────────
if [ ! -d ".git" ]; then
    echo -e "${RED}❌ ERROR: No .git folder found in this directory!${NC}"
    echo -e "${YELLOW}Run this first: git init${NC}"
    exit 1
fi

# ──────────────────────────────────────────────
# Step 3: Create/Update .gitignore automatically
# ──────────────────────────────────────────────
echo -e "${BLUE}📝 Updating .gitignore...${NC}"

cat > .gitignore << 'EOF'
# ──────────────────────────────────────────────
# 🔐 SECRETS - NEVER commit these!
# ──────────────────────────────────────────────
.env
.env.*
*.key
*.pem
*.crt

# ──────────────────────────────────────────────
# 🐍 Python
# ──────────────────────────────────────────────
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
*.egg-info/
dist/
build/
*.egg
venv/
.venv/
env/
ENV/

# ──────────────────────────────────────────────
# 📁 IDE & Editor files
# ──────────────────────────────────────────────
.vscode/
.idea/
*.swp
*.swo
.DS_Store
Thumbs.db

# ──────────────────────────────────────────────
# 📦 Package managers
# ──────────────────────────────────────────────
node_modules/
package-lock.json
yarn.lock
pip-log.txt
pip-delete-this-directory.txt

# ──────────────────────────────────────────────
# 📊 Logs & Temporary files
# ──────────────────────────────────────────────
*.log
*.tmp
*.temp
*.cache
*.pid
*.seed
*.pid.lock

# ──────────────────────────────────────────────
# 🗄️ Database files
# ──────────────────────────────────────────────
*.db
*.sqlite
*.sqlite3

# ──────────────────────────────────────────────
# 📁 OS specific
# ──────────────────────────────────────────────
.DS_Store
Thumbs.db
desktop.ini
EOF

echo -e "${GREEN}✅ .gitignore updated!${NC}"

# ──────────────────────────────────────────────
# Step 4: Check remote connection
# ──────────────────────────────────────────────
if ! git remote -v | grep -q origin; then
    echo -e "${RED}❌ ERROR: No remote 'origin' found!${NC}"
    echo -e "${YELLOW}Run this first: git remote add origin YOUR_REPO_URL${NC}"
    exit 1
fi

# ──────────────────────────────────────────────
# Step 5: Show what will be pushed
# ──────────────────────────────────────────────
echo -e "${BLUE}📋 Files that will be committed:${NC}"
git status --short

# ──────────────────────────────────────────────
# Step 6: Add all files (except .gitignore stuff)
# ──────────────────────────────────────────────
echo -e "${BLUE}📦 Adding all files...${NC}"
git add .

# ──────────────────────────────────────────────
# Step 7: Commit
# ──────────────────────────────────────────────
echo -e "${BLUE}💾 Committing with message: \"$COMMIT_MESSAGE\"${NC}"
git commit -m "$COMMIT_MESSAGE"

# ──────────────────────────────────────────────
# Step 8: Pull first (to avoid conflicts)
# ──────────────────────────────────────────────
echo -e "${BLUE}⬇️ Pulling latest changes from GitHub...${NC}"
git pull origin main --allow-unrelated-histories --no-edit

# If main fails, try master
if [ $? -ne 0 ]; then
    echo -e "${YELLOW}⚠️ 'main' branch failed, trying 'master'...${NC}"
    git pull origin master --allow-unrelated-histories --no-edit
fi

# ──────────────────────────────────────────────
# Step 9: Push
# ──────────────────────────────────────────────
echo -e "${BLUE}⬆️ Pushing to GitHub...${NC}"
git push origin main

# If main fails, try master
if [ $? -ne 0 ]; then
    echo -e "${YELLOW}⚠️ 'main' push failed, trying 'master'...${NC}"
    git push origin master
fi

# ──────────────────────────────────────────────
# Step 10: Done!
# ──────────────────────────────────────────────
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}✅ SUCCESS! All changes pushed to GitHub!${NC}"
echo -e "${GREEN}📝 Commit message: \"$COMMIT_MESSAGE\"${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

# Show last commit
git log -1 --oneline
