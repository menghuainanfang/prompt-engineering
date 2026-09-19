# Codex 学习闭环

这是一套可移植的个人学习系统。Codex 负责教学、规划和判断；学习主档案保留完整过程；Obsidian 沉淀长期知识；Anki 使用 FSRS 安排复习。四者各自保留一种事实源，避免重复维护。

## 体系如何协作

| 层 | 负责 | 不负责 |
|---|---|---|
| 当前对话 | 讲解、追问、即时推理和小测 | 默认不逐轮生成文件 |
| 学习主档案 | 课程地图、原始推理、练习证据、评估和断点 | 不复制成第二套长期知识库 |
| Obsidian | 精炼定义、方法、知识关系、周复盘和 Anki 候选 | 不保存完整聊天副本 |
| Anki | 已审核卡片、复习间隔和 Again/Hard 表现 | 不承载完整证明、长计算和开放题 |

能力状态统一为：`unknown → learning → guided → independent → transfer-ready`。只有无提示表现和迁移表现能推进到后两级。

## 文件组成

```text
codex-study-loop/
├── .agents/skills/         # 9 个 Codex Skills
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

## 使用方式

### 方式一：仅在这个工作区使用

把 `systems/codex-study-loop` 选为 Codex 工作区。Codex 会从该目录下的 `.agents/skills` 发现这些技能。若技能列表没有立即刷新，重启 Codex。

### 方式二：安装为用户技能

将 `.agents/skills` 中的各技能目录复制到用户级 `$HOME/.agents/skills/`。也可以让 Codex 的 `$skill-installer` 从此 GitHub 仓库安装所需技能。

首次使用时，在工作区说明或对话中告诉 Codex：

- 学习主档案目录；
- Obsidian vault 目录；
- Anki 候选 TSV 的位置；
- 是否采用默认的 `chat-deferred` 保存模式。

公开技能不写死个人路径。未配置路径时仍可正常聊天学习；只有真正需要归档时才需要补充位置。

## Obsidian 与 Anki

将 `templates/obsidian` 中的 Markdown 模板放入自己的 Obsidian 模板目录，并将 `Anki卡片候选.tsv` 放到方便审核的位置。候选表使用以下列：

```text
Status  Front  Back  Tags  Deck  Source
```

状态可用 `候选`、`通过`、`已导入`、`暂缓`。只有标记为 `通过` 的行会被导出：

```powershell
.\scripts\prepare-anki-import.ps1 `
  -Inbox "D:\path\to\Anki卡片候选.tsv" `
  -OutputDirectory "D:\path\to\exports"
```

脚本检查必要列、空白正反面和重复问题，生成带 Anki 导入指令的 UTF-8 TSV；它不会修改候选表或 Anki 数据库。导入时先核对 Anki 预览，成功后再把候选状态改为 `已导入`。

## 常用入口

- “使用 `$study-loop` 开始这个主题，先定义通关证据。”
- “使用 `$study-tutor` 带我逐节学习这份材料。”
- “使用 `$study-practice` 根据刚学内容逐题训练。”
- “使用 `$study-assessment` 实测我离考试要求还有多远。”
- “使用 `$study-loop` 收尾，整理掌握证据、长期笔记和卡片候选。”
- “这些是本周 Anki 的 Again/Hard 卡片，判断该重学、做变式还是修卡。”

## 周期建议

- 每次学习：目标 → 教学 → 检验 → 证据 → 必要时归档。
- 每个主题收尾：更新能力状态，精炼少量长期笔记和卡片候选。
- 每周：查看重复错因与 Again/Hard 集中点，调整课程路线和卡片质量。

## 边界

- Anki 桌面端及 FSRS 需自行安装和启用，本仓库不包含用户数据或数据库。
- Obsidian Templater 语法保留在模板中；未安装 Templater 时可手动替换占位符。
- 学习主档案、vault 和 Anki 队列不会在不同设备或产品之间自动同步；同步方式由使用者自行选择。
