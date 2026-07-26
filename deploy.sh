#!/bin/bash
# CHANG'AN Site Deploy to GitHub Pages
# Usage: bash deploy.sh

set -e
cd /Users/chengliang/Desktop/changan-site

echo "🔐 请输入你的 GitHub 用户名:"
read GITHUB_USER

echo "🔑 请输入 GitHub Token (ghp_开头):"
read -s TOKEN

echo ""
echo "📦 创建仓库..."
curl -s -X POST \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  "https://api.github.com/user/repos" \
  -d "{\"name\":\"changan-site\",\"private\":false,\"auto_init\":false}" > /dev/null

echo "🚀 推送代码..."
git remote remove origin 2>/dev/null || true
git remote add origin "https://${GITHUB_USER}:${TOKEN}@github.com/${GITHUB_USER}/changan-site.git"
git push -u origin main --force

echo "🌐 开启 Pages..."
curl -s -X POST \
  -H "Authorization: Bearer $TOKEN" \
  -H "Accept: application/vnd.github+json" \
  "https://api.github.com/repos/${GITHUB_USER}/changan-site/pages" \
  -d '{"source":{"branch":"main","path":"/"}}' > /dev/null

echo ""
echo "✅ 部署完成！等待 1-2 分钟后访问："
echo "   https://${GITHUB_USER}.github.io/changan-site/"
