#!/bin/bash

# Exit if a command fails (but not too aggressively)
set -e

echo "📂 Current repo location:"
pwd

echo "🔀 Step 1: Switch to the prod branch"
git checkout prod

echo "⬇️ Step 2: Pull latest changes from origin/prod"
# --rebase avoids merge commits and editor popups
# --autostash handles any local changes safely
git pull --rebase --autostash origin prod

echo "🛑 Step 3: Stop and remove old prod container (if it exists)"
docker stop ott-prod 2>/prod/null || true
docker rm ott-prod 2>/prod/null || true

echo "🏗️ Step 4: Build a fresh Docker image for prod"
docker build -t ott:prod .

echo "🚀 Step 5: Run the prod container"
docker run -d -p 8081:80 --name ott-prod ott:prod

echo "✅ DONE: prod Docker is running at http://localhost:8081"
