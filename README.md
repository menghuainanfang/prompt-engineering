# prompt-engineering

面向实际工作的 AI 提示词、Agent Skills 与工作流资产库。当前重点是可在 Codex 中运行的个人学习闭环；仓库也保留了早期 Claude Code 学习技能和独立网站提示词，便于比较与复用。

## 当前推荐：Codex 学习闭环

[`systems/codex-study-loop`](systems/codex-study-loop/) 将目标规划、渐进教学、练习、评估、笔记、Obsidian 和 Anki 串成一条可恢复的学习流程：

```text
目标与通关证据
  → 讲解与追问
  → 无提示检验 / 变式练习
  → 记录掌握证据
  → 精炼长期笔记
  → 审核 Anki 卡片
  → 复习结果回流到重学、练习或修卡
```

它包含 9 个协作技能：

| 技能 | 职责 |
|---|---|
| `study-loop` | 编排完整闭环、阶段收尾和复习回流 |
| `study-roadmap` | 课程路线、前置依赖和据点状态 |
| `study-tutor` | 概念或材料的渐进式互动教学 |
| `study-practice` | 数学与编程的逐题训练、错因记录 |
| `study-assessment` | 基于实测证据的掌握度评估 |
| `study-notes` | 笔记整理、逻辑链和讲义化 |
| `study-english` | 精读、翻译、复述和词块训练 |
| `study-paper-brief` | 论文总览、术语和阅读路线 |
| `study-knowledge-visuals` | Excalidraw、Canvas 或 Mermaid 知识图 |

完整安装、路径配置、模板和 Anki 流程见 [系统说明](systems/codex-study-loop/README.md)。

## 目录结构

```text
prompt-engineering/
├── systems/
│   └── codex-study-loop/   # 当前推荐的完整学习闭环
├── skills/                 # 早期 Claude Code 技能，作为历史版本保留
├── prompts/                # 独立提示词
├── LICENSE
└── README.md
```

## 设计原则

- 以“能否独立解释、解题和迁移”为掌握依据，不用看过答案或完成数量代替能力证据。
- 对话负责教学，学习主档案负责过程证据，Obsidian 负责长期知识，Anki 负责记忆调度；同一正文不在多处重复维护。
- 默认在阶段收尾或明确请求时归档，不强制每轮聊天都写文件。
- Anki 卡片先进入候选队列，经人工审核后再导出；脚本不直接修改 Anki 数据库。
- 所有公开文件均使用可配置路径，不包含个人笔记、Anki 数据库、备份或账号凭据。

Codex Skill 的目录结构和加载位置遵循 [OpenAI 官方技能文档](https://developers.openai.com/zh-Hans/docs/build-skills)。

## 历史版本

[`skills`](skills/) 是此前围绕 Claude Code 建立的学习技能体系，其中“每轮实时同步”等约定与当前闭环不同。新使用者建议从 `systems/codex-study-loop` 开始；旧目录暂不删除，以保留已有引用和迭代轨迹。

## 许可证

[MIT](LICENSE)
