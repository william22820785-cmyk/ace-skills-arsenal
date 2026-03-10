#!/bin/bash
# ACE Skills 武器库自动化系统
# 功能：自动同步、质量控制、批量安装

WORKDIR="/root/.openclaw/workspace"
SKILLS_DIR="$WORKDIR/skills"
LIB_DIR="$WORKDIR/skills_library"
LOG_FILE="$LIB_DIR/sync.log"

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log() {
    echo -e "[$(date '+%Y-%m-%d %H:%M')] $1" | tee -a "$LOG_FILE"
}

# ============== 1. 质量控制检查 ==============
quality_check() {
    local skill_name="$1"
    local skill_path="$SKILLS_DIR/$skill_name"
    
    # 检查1: 必须有SKILL.md
    if [ ! -f "$skill_path/SKILL.md" ]; then
        echo -e "${RED}✗ 缺少SKILL.md${NC}"
        return 1
    fi
    
    # 检查2: SKILL.md不能为空
    if [ ! -s "$skill_path/SKILL.md" ]; then
        echo -e "${RED}✗ SKILL.md为空${NC}"
        return 1
    fi
    
    # 检查3: 描述不能包含恶意关键词
    if grep -iq "curl.*\|.*bash.*-i\|nc.*-e\|wget.*\|curl.*>\|exec.*(" "$skill_path/SKILL.md" 2>/dev/null; then
        echo -e "${RED}✗ 包含可疑命令${NC}"
        return 1
    fi
    
    # 检查4: 描述不能太短（至少50字符）
    desc_len=$(wc -c < "$skill_path/SKILL.md")
    if [ $desc_len -lt 50 ]; then
        echo -e "${YELLOW}⚠ 描述太短${NC}"
    fi
    
    echo -e "${GREEN}✓ 质量检查通过${NC}"
    return 0
}

# ============== 2. 自动同步新Skills ==============
sync_new_skills() {
    log "开始同步新Skills..."
    
    # 分类同步
    categories=("marketing" "finance" "ai" "code" "data" "social")
    
    for cat in "${categories[@]}"; do
        log "同步分类: $cat"
        
        # 搜索但不自动安装，只记录
        results=$(clawhub search "$cat" 2>&1 | grep -E "^\-" | head -5)
        
        while read -r line; do
            name=$(echo "$line" | awk '{print $2}')
            score=$(echo "$line" | grep -oE '[0-9]+\.[0-9]+' | head -1)
            
            # 质量门槛：评分>3.0
            if (( $(echo "$score > 3.0" | bc -l 2>/dev/null || echo 0) )); then
                # 检查是否已安装
                if [ ! -d "$SKILLS_DIR/$name" ]; then
                    log "  🆕 $name (评分: $score) - 待手动确认"
                fi
            fi
        done <<< "$results"
    done
    
    log "同步完成"
}

# ============== 3. 批量安装（需确认）==============
install_batch() {
    local category="$1"
    
    log "批量安装: $category"
    
    # 搜索并显示候选列表
    echo -e "\n${YELLOW}以下是候选Skills，请确认是否安装:${NC}"
    candidates=$(clawhub search "$category" 2>&1 | grep -E "^\-" | head -10)
    
    echo "$candidates"
    echo -e "\n${YELLOW}请回复要安装的Skills名称（空格分隔），或回复'q'退出${NC}"
}

# ============== 4. 安全扫描 ==============
security_scan() {
    log "🔍 开始安全扫描..."
    
    suspicious=0
    
    # 检查所有已安装Skills
    for dir in "$SKILLS_DIR"/*/; do
        name=$(basename "$dir")
        
        # 检查可疑命令
        if grep -rq "curl.*|.*bash.*-i\|nc.*-e\|wget.*\|eval.*\|\$\(" "$dir" 2>/dev/null; then
            echo -e "${RED}⚠️ 可疑: $name${NC}"
            suspicious=$((suspicious + 1))
        fi
        
        # 检查网络请求
        if grep -rq "curl.*http\|wget.*http\|fetch.*http" "$dir" 2>/dev/null; then
            echo -e "${YELLOW}🌐 有网络请求: $name${NC}"
        fi
    done
    
    if [ $suspicious -eq 0 ]; then
        log "✅ 安全扫描通过，无可疑Skills"
    else
        log "⚠️ 发现 $suspicious 个可疑Skills，请检查"
    fi
}

# ============== 5. 状态报告 ==============
status_report() {
    log "📊 Skills库状态报告"
    
    total=$(ls -d "$SKILLS_DIR"/*/ 2>/dev/null | wc -l)
    with_skill=$(find "$SKILLS_DIR" -name "SKILL.md" | wc -l)
    
    echo "总数: $total"
    echo "有文档: $with_skill"
    echo "完整率: $(( with_skill * 100 / total ))%"
}

# ============== 主菜单 ==============
case "$1" in
    sync)
        sync_new_skills
        ;;
    scan)
        security_scan
        ;;
    status)
        status_report
        ;;
    install)
        install_batch "$2"
        ;;
    check)
        quality_check "$2"
        ;;
    *)
        echo "用法: $0 {sync|scan|status|install <category>|check <skill>}"
        ;;
esac
