# 笔记 Frontmatter 规范（共享）

> 统一所有学习技能生成笔记的 frontmatter 字段，保证 Dataview 兼容。
> 合并自「补全笔记逻辑链」「AI辅助学习」「渐进式交互学习」「学习笔记生成器（已删除）」的字段规范。
> 最后更新：2026-08-16

## 核心字段

| 字段 | 取值 | 说明 |
|------|------|------|
| `status` | `draft` / `reviewing` / `polished` | 笔记成熟度。Dataview「掌握度速览」按此筛选，**必须使用标准值** |
| `confidence` | 0~100 数字 | 不要填文字（Dataview 按数字排序） |
| `tags` | 分层标签 | 如 `类型/小节笔记`、`学科/数学`（Dataview 可以按层级筛选） |
| `session_state` | `active` / `paused` / `completed` | 学习进度（断点续学用）。与 `status` 正交：status 是笔记成熟度，session_state 是学习进行到哪了 |
| `review_due` | `YYYY-MM-DD` | 复习到期日（习题体系用：学完套后 3-7 天，到期提醒出复习套） |
| `date` / `last_updated` | `YYYY-MM-DD` | 生成日期 / 最后修改日期 |
| `course` | 课程名 | 课程序号不确定时填 `[待确认]` |

## confidence 范围建议

| 笔记状态 | 建议范围 |
|---------|:-------:|
| 只有要点列表（Part 1） | 30-50 |
| 已补全逻辑链（Part 2/3） | 60-80 |
| 已定稿（polished） | 85-95 |

## status 升级路径

```
draft（只有要点）→ reviewing（有完整逻辑链）→ polished（定稿）
```

每次补全内容后同步更新 `status` 和 `confidence`。

## 写入规则

- 如果用户已经写了 frontmatter，**只补充不覆盖**
- 学习笔记与探索档案可同时含 `session_state` 系列字段（记录断点）
- 各学习技能的特有字段（`completed_stages`、`next_topics`、`context_summary`、`prerequisite_detours` 等）不受本规范限制，可并存
- 已被删除的「学习笔记生成器」曾使用 `phase` 字段（extraction/interactive/finalized）——**废弃**，一律改用 `status`
