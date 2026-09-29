# Codex 学习闭环

这套工作流把 Codex 教学、学习主档案、Obsidian 长期知识和 Anki 复习连接起来。四层各自保留一种事实源，避免同一正文重复维护。

配套 skills 统一维护在仓库根目录 [`skills/`](../../skills/)；本目录只保存跨技能共享的模板、脚本和示例。

## 分工

| 层 | 负责 | 不负责 |
| --- | --- | --- |
| 当前对话 | 讲解、追问、即时推理和小测 | 默认不逐轮生成文件 |
| 学习主档案 | 课程地图、原始推理、练习证据、评估和断点 | 不复制成第二套长期知识库 |
| Obsidian | 精炼定义、方法、知识关系、周复盘和 Anki 候选 | 不保存完整聊天副本 |
| Anki | 已审核卡片、复习间隔和 Again/Hard 表现 | 不承载完整证明、长计算和开放题 |

能力状态统一为：`unknown → learning → guided → independent → transfer-ready`。只有无提示表现和迁移表现能推进到后两级。

## 文件

```text
workflows/study-loop/
├── scripts/
│   └── prepare-anki-import.ps1
├── examples/
│   └── anki-cards.example.tsv
├── templates/obsidian/
│   ├── 学习闭环总览.md
│   ├── 周复盘模板.md
│   ├── 小节笔记模板.md
│   ├── 习题笔记模板.md
│   └── Anki卡片候选.tsv
└── README.md
```

## 使用

1. 按仓库根目录 README 安装 `skills/` 中的技能。
2. 把 `templates/obsidian` 中需要的模板复制到自己的 Obsidian 模板目录。
3. 在首次学习时说明学习主档案、Obsidian vault 和 Anki 候选 TSV 的位置；没有归档需求时可以直接在聊天中学习。
4. 用 `$study-loop` 开始主题或完成阶段收尾，其余技能按任务自动配合。

常用入口：

- “使用 `$study-loop` 开始这个主题，先定义通关证据。”
- “使用 `$study-tutor` 带我逐节学习这份材料。”
- “使用 `$study-practice` 根据刚学内容逐题训练。”
- “使用 `$study-assessment` 实测我离考试要求还有多远。”
- “使用 `$study-loop` 收尾，整理掌握证据、长期笔记和卡片候选。”

## Anki 候选

候选表使用以下列：

```text
Status  Front  Back  Tags  Deck  Source
```

状态可用 `候选`、`通过`、`已导入`、`暂缓`。只有标记为 `通过` 的行会被导出：

```powershell
.\scripts\prepare-anki-import.ps1 `
  -Inbox "D:\path\to\Anki卡片候选.tsv" `
  -OutputDirectory "D:\path\to\exports"
```

脚本检查必要列、空白正反面和重复问题，生成带 Anki 导入指令的 UTF-8 TSV；它不会修改候选表或 Anki 数据库。导入成功后，再把候选状态改为 `已导入`。

## 边界

- Anki 桌面端及 FSRS 需自行安装和启用，本仓库不包含用户数据或数据库。
- Obsidian Templater 语法保留在模板中；未安装 Templater 时可手动替换占位符。
- 学习主档案、vault 和 Anki 队列不会自动跨设备同步。
