#!/bin/bash
# ============================================
# 一键推送到 GitHub 并自动构建 APK
# ============================================
# 用法: ./push-to-github.sh <github用户名> <仓库名>
# 示例: ./push-to-github.sh myname liquid-glass-ai
# ============================================

set -e

USER=$1
REPO=${2:-liquid-glass-ai}

if [ -z "$USER" ]; then
    echo "用法: $0 <github用户名> [仓库名]"
    echo "示例: $0 myname liquid-glass-ai"
    exit 1
fi

echo "╔══════════════════════════════════════╗"
echo "║   推送到 GitHub 并自动构建 APK       ║"
echo "╚══════════════════════════════════════╝"
echo ""

cd "$(dirname "$0")"

# 初始化 Git
if [ ! -d ".git" ]; then
    echo "⏳ 初始化 Git 仓库..."
    git init
    git branch -M main
fi

# 配置 Git（如果未配置）
git config user.name 2>/dev/null || git config user.name "Builder"
git config user.email 2>/dev/null || git config user.email "builder@example.com"

# 提交
echo "⏳ 提交代码..."
git add -A
git commit -m "液态玻璃 AI - 初始提交" 2>/dev/null || echo "无新变更"

# 添加远程
echo "⏳ 添加远程仓库..."
git remote remove origin 2>/dev/null
git remote add origin "https://github.com/${USER}/${REPO}.git"

# 推送
echo "⏳ 推送到 GitHub..."
echo "   (如果提示输入密码，请使用 GitHub Personal Access Token)"
git push -u origin main --force

echo ""
echo "╔══════════════════════════════════════╗"
echo "║   ✅ 推送成功!                       ║"
echo "╚══════════════════════════════════════╝"
echo ""
echo "📱 GitHub Actions 正在自动构建 APK..."
echo ""
echo "👉 查看构建进度:"
echo "   https://github.com/${USER}/${REPO}/actions"
echo ""
echo "👉 构建完成后下载 APK:"
echo "   https://github.com/${USER}/${REPO}/actions → 点击最新 Build → Artifacts"
echo ""
