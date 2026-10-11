# Prompt Engineering Workflows

面向实际任务的 Codex skills、工作流和提示词资产库。仓库只保存经过使用验证、适合公开复用的内容；运行状态、账号凭据、个人学习数据和工具缓存不进入版本控制。

## 目录

```text
prompt-engineering/
├── skills/                    # 15 个 canonical skills，可直接安装
├── workflows/
│   ├── codex/                 # 全局工作原则
│   └── study-loop/            # Obsidian/Anki 模板、脚本与示例
├── prompts/
│   ├── personal-website/      # 个人网站美术方向与实现提示词
│   └── readingos/             # ReadingOS v0.1 中英实施任务书
├── LICENSE
└── README.md
```

技能目录使用实际安装名，不维护中文编号镜像。一个技能只在 `skills/` 中保留一份权威版本；完整工作流通过链接组合技能、模板和脚本，不复制技能正文。

## Skills

### 学习闭环

| 技能 | 用途 |
| --- | --- |
| `study-loop` | 协调目标、教学、练习、档案、Obsidian 与 Anki 的完整闭环 |
| `study-assessment` | 逐题实测掌握度，生成红黄绿缺口报告 |
| `study-roadmap` | 按前置依赖建立课程区域、据点和通关记录 |
| `study-tutor` | 渐进式交互学习概念、教材、论文和技术材料 |
| `study-practice` | 编排学完套、复习套和逐题数学/编程训练 |
| `study-notes` | 生成、补全或串联学习笔记与费曼讲义 |
| `study-knowledge-visuals` | 生成可编辑的 Excalidraw、Canvas 或 Mermaid 知识图 |
| `study-english` | 英语精读、翻译、回译、复述与词块复习 |
| `study-paper-brief` | 一次性拆解论文问题、方法、证据、贡献与边界 |

### 研究、设计与交付

| 技能 | 用途 |
| --- | --- |
| `research-fealpy` | 使用 FEALPy 实现和调试有限元及 PDE 数值求解 |
| `build-mcp` | 为明确的服务或本地能力开发和测试 MCP 服务 |
| `design-web` | 设计、重塑和浏览器验收网页与交互应用 |
| `design-creative` | 海报、生成艺术、循环动画和产品主题设计 |
| `writing-deliverables` | 技术方案、决策文档、项目汇报和内部说明 |
| `codex-with-chatgpt` | 由 ChatGPT 负责规划/评审，Codex 保持执行所有权 |

## 学习闭环

`study-loop` 是统一入口，其他技能按任务调用：

```text
目标与现状
  ├─ study-assessment → 找到真实缺口
  ├─ study-roadmap    → 安排前置与路线
  ├─ study-tutor      → 交互教学
  ├─ study-practice   → 检索、迁移和复习
  └─ study-notes / study-knowledge-visuals → 沉淀与连接知识
```

当前默认采用 `chat-deferred`：日常教学在对话中进行，用户要求实时保存或阶段归档时才写入学习档案。旧版“每轮强制同步”的 hook 已停用。

[`workflows/study-loop`](workflows/study-loop/) 提供 Obsidian 模板、Anki 候选示例和导出脚本。它引用 `skills/` 中的学习技能，不维护第二套副本。

## 独立提示词

- [`prompts/personal-website/01_visual_art_direction_prompt.md`](prompts/personal-website/01_visual_art_direction_prompt.md)：个人网站视觉方向与审美审稿。
- [`prompts/personal-website/02_codex_implementation_prompt.md`](prompts/personal-website/02_codex_implementation_prompt.md)：在既定视觉方向下完成工程实现和验收。
- [`prompts/readingos/readingos-v0.1.zh-CN.md`](prompts/readingos/readingos-v0.1.zh-CN.md)：ReadingOS v0.1 中文开发提示词（需求任务书，应用尚未实施验收）。
- [`prompts/readingos/readingos-v0.1.en.md`](prompts/readingos/readingos-v0.1.en.md)：对应的英文版本，包含参考项目、实现边界、验收和交付要求。

## 安装 Skills

在仓库根目录执行：

```powershell
$target = Join-Path $env:USERPROFILE '.codex\skills'
New-Item -ItemType Directory -Path $target -Force | Out-Null
Get-ChildItem -LiteralPath '.\skills' -Directory |
  Copy-Item -Destination $target -Recurse -Force
```

Codex skill 的目录约定可参考 [OpenAI 官方技能文档](https://developers.openai.com/zh-Hans/docs/build-skills)。`workflows/codex/AGENTS.md` 是公开模板，使用前应阅读并按当前项目调整，不直接覆盖项目已有规则。

## 仓库边界

以下内容不会上传：

- Codex 内置 `.system` skills；
- `auth.json`、实时 `config.toml` 和其他账号或连接配置；
- SQLite 状态库、会话、日志、锁文件、记忆和个人学习档案；
- 插件缓存、临时文件、生成预览与本机运行产物；
- 已被当前流程取代的旧 hook 和重复共享规范。

## 维护方式

本机 `~/.codex/skills` 是使用中的版本。技能经过实际任务验证后，将对应 canonical 目录同步到本仓库；重命名时删除旧目录，不保留兼容副本。工作流只保存跨技能的模板、脚本和说明，共享规则放在拥有它的技能 `references/` 中。

## 许可证

[MIT](LICENSE)
