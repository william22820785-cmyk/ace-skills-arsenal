---
name: skills-library-manager
version: 1.0.0
description: MOVA Skills武器库自动化系统 - 动态库管理、质量控制、安全扫描
author: MOVA Team
tags: [skills, library, automation, security]
---

# Skills Library Manager - 武器库自动化系统

MOVA团队专用的Skills动态库管理和自动化系统。

## 核心功能

### 1. 动态库管理
- 200+
- 12大分类体系
- 快速查找脚本

### 2. 质量控制
- 安装前质量检查
- SKILL.md完整性验证
- 描述长度检查

### 3. 安全扫描
- 可疑命令检测
- 网络请求监控
- 恶意代码识别

### 4. 自动同步
- ClawHub新Skills发现
- 按分类同步
- 待确认列表生成

## 命令行工具

```bash
# 状态报告
./skills_library/arsenal_automation.sh status

# 安全扫描
./skills_library/arsenal_automation.sh scan

# 同步新Skills
./skills_library/arsenal_automation.sh sync

# 质量检查
./skills_library/arsenal_automation.sh check <skill-name>

# 批量安装（需确认）
./skills_library/arsenal_automation.sh install <category>
```

## 文件结构

```
skills_library/
├── INDEX.md                 # 主索引
├── DETAILED_INDEX.md       # 详细目录
├── QUICK_REFERENCE.md      # 速查卡
├── find_skill.sh           # 查找脚本
├── maintenance.sh          # 维护脚本
├── arsenal_automation.sh   # 武器库自动化
├── SCALING_ASSESSMENT.md  # 扩展评估
└── docs/                  # 文档
```

## 质量控制流程

```
发现新Skill
    ↓
质量检查（评分>3.0）
    ↓
安全扫描（无恶意命令）
    ↓
人工确认
    ↓
安装 + 文档化
    ↓
加入索引
```

## 价值

| 场景 | 节省 |
|------|------|
| 找Skill | ~95% |
| 学新工具 | ~75% |
| 团队培训 | ~90% |
| 安全检测 | 100% |

---

*Created: 2026-03-07*
*Version: 1.0.0*
*Team: MOVA*
