#!/bin/bash

# MoonBit 火柴人游戏启动脚本

echo "🎮 MoonBit 火柴人物理游戏"
echo "=========================="

# 检查 moon 命令是否存在
if ! command -v moon &> /dev/null; then
    echo "❌ 错误: 未找到 moon 命令"
    echo "请安装 MoonBit CLI 工具: https://moonbitlang.com/download/"
    exit 1
fi

echo "🔨 构建项目..."
if moon build --target js; then
    echo "✅ 构建成功!"
else
    echo "❌ 构建失败!"
    exit 1
fi

echo "🚀 启动服务器..."
echo "🌐 请在浏览器中访问: http://localhost:8000/"
echo "⚠️  按 Ctrl+C 停止服务器"
echo ""

# 启动服务器
if command -v python3 &> /dev/null; then
    python3 -m http.server 8000
elif command -v python &> /dev/null; then
    python -m http.server 8000
elif command -v npx &> /dev/null; then
    npx serve . -p 8000
else
    echo "❌ 错误: 未找到可用的HTTP服务器"
    echo "请安装 Python 或 Node.js"
    exit 1
fi
