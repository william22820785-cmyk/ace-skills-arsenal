#!/bin/bash
# MOVA Skills 快速查找工具
# 用法: ./find_skill.sh <关键词>

KEYWORD=$1

if [ -z "$KEYWORD" ]; then
    echo "用法: ./find_skill.sh <关键词>"
    echo "示例: ./find_skill.sh marketing"
    exit 1
fi

echo "🔍 搜索: $KEYWORD"
echo "===================="

cd /root/.openclaw/workspace/skills

# 精确匹配
echo -e "\n📦 精确匹配:"
ls -d */ 2>/dev/null | sed 's#/##' | grep -i "^$KEYWORD$" 

# 包含关键词
echo -e "\n📦 包含 '$KEYWORD':"
ls -d */ 2>/dev/null | sed 's#/##' | grep -i "$KEYWORD"

# 分类搜索
echo -e "\n📊 相关分类建议:"
case "$KEYWORD" in
    *market*|*sale*|*social*|*content*)
        echo "→ 营销类: social-poster, marketing-mode, copywriting"
        ;;
    *finance*|*stock*|*money*|*crypto*)
        echo "→ 金融类: alphaear-stock, alphaear-news, bankrbot-skills"
        ;;
    *code*|*dev*|*git*)
        echo "→ 开发类: github, docker-essentials, coding-agent"
        ;;
    *crawl*|*scrape*|*web*)
        echo "→ 爬虫类: crawl, firecrawl-mcp-server, apify-mcp-server"
        ;;
    *feishu*|*slack*|*telegram*)
        echo "→ 通讯类: feishu-doc, slack, telegram-bot"
        ;;
    *)
        echo "→ 使用 clawhub search $KEYWORD 获取更多"
        ;;
esac
