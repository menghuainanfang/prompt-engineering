# 笔记元数据
与 [档案协议](../archive.md) 共用以下语义。

| 字段 | 含义与取值 |
|---|---|
| status | 文档成熟度：draft / reviewing / polished |
| session_state | 学习会话：active / paused / completed |
| persistence_mode | 已选择的 chat-deferred / realtime；旧文档缺失时不推断永久偏好 |
| date / last_updated | 实际日期 YYYY-MM-DD |
| course / tags | 沿用课程名称与分层标签；保留用户未知字段 |
| mastery_level | 有证据时 L0–L5，否则 unknown |
| mastery_evidence | 题目/任务、用户表现、提示程度、日期 |
| review_due | 复习到期日，不等于已创建提醒 |
| current_section / current_stage | 稳定模块 ID 与具体子阶段 |
| pending_question / next_action | 原样待答问题与恢复动作 |
| context_summary | 已学内容、表现、障碍与下一步 |
| confidence | 若已有则保留数字及原含义；没有依据不新增或机械涨分 |

笔记补齐可更新 status；不能据此提升 mastery_level 或能力评分。保留已有 confidence 含义，不把文档可信程度当掌握度。
旧 phase、immutable_map 和其他查询可能依赖的字段不批量删除；需要迁移时先核对使用方，再做兼容更新。日期与列表使用合法 YAML，未知课程可用字符串“待确认”，不用随手写出的 YAML 列表代替字符串。
