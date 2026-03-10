#!/bin/bash
# MOVA Skills 动态库维护脚本
# 用途：每周自动更新索引、检查新Skills

WORKDIR="/root/.openclaw/workspace"
SKILLS_DIR="$WORKDIR/skills"
LIB_DIR="$WORKDIR/skills_library"

echo "🔄 MOVA Skills 动态库维护"
echo "============================"

# 1. 统计当前Skills数量
echo -e "\n📊 当前状态:"
COUNT=$(ls -d $SKILLS_DIR/*/ 2>/dev/null | wc -l)
echo "  Skills总数: $COUNT"

# 2. 检查新增Skills（最近7天）
echo -e "\n🆕 最近7天新增:"
find $SKILLS_DIR -maxdepth 1 -type d -mtime -7 | sed "s|$SKILLS_DIR/||" | sed 's/^/  - /'

# 3. 分类统计
echo -e "\n📂 分类统计:"
echo "  营销: $(ls $SKILLS_DIR | grep -iE 'market|social|content|copy|blog|seo' | wc -l)"
echo "  金融: $(ls $SKILLS_DIR | grep -iE 'alphaear|finance|stock|money|crypto' | wc -l)"
echo "  AI: $(ls $SKILLS_DIR | grep -iE 'agent|ai_|llm' | wc -l)"
echo "  爬虫: $(ls $SKILLS_DIR | grep -iE 'crawl|scrape|firecrawl|apify' | wc -l)"
echo "  开发: $(ls $SKILLS_DIR | grep -iE 'github|docker|code|debug' | wc -l)"

# 4. 检查Skills目录结构是否完整
echo -e "\n🔍 目录检查:"
MISSING_SKILL=0
for dir in $SKILLS_DIR/*/; do
    name=$(basename $dir)
    if [ ! -f "$dir/SKILL.md" ]; then
        echo "  ⚠️ 缺少SKILL.md: $name"
        MISSING_SKILL=$((MISSING_SKILL + 1))
    fi
done
if [ $MISSING_SKILL -eq 0 ]; then
    echo "  ✅ 所有Skills都有SKILL.md"
fi

# 5. 更新索引文件
echo -e "\n📝 索引更新:"
echo "  最后更新: $(date '+%Y-%m-%d %H:%M')"

# 6. 建议
echo -e "\n💡 建议:"
echo "  1. 运行 'clawhub explore' 查看最新Skills"
echo "  2. 运行 './find_skill.sh <关键词>' 查找Skills"
echo "  3. 检查 $LIB_DIR/INDEX.md 是否需要更新"

echo -e "\n✅ 维护完成!"
