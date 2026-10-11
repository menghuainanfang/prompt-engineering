# ReadingOS v0.2 — 开源借鉴与美术方向研究

> 研究时间：2026-10-11  
> 性质：公开项目文档与截图调研，不代表这些项目已在用户本机运行或与 ReadingOS 集成。  
> 对应执行任务：readingos-v0.2.zh-CN.md

## 1. 项目对比：借鉴什么，舍弃什么

| 对象 | 借鉴 | 应批判性舍弃的倾向 | 复用判断 |
| --- | --- | --- | --- |
| [Readest](https://github.com/readest/readest) | 多格式、沉浸阅读、主题定制、现代排版、侧栏 | 功能范围巨大、上游依赖多；其手写仍见于规划项，不能当成现成成果 | AGPL；先评估完整 Fork，谨慎迁移 |
| [Koodo Reader](https://github.com/koodo-reader/koodo-reader) | 书架、搜索、导入、笔记、备份、中文用户体验 | 信息拥挤及直接套用既有 UI；不一定满足“总心得优先” | AGPL；Fork 备选或仅参照 |
| [Foliate 桌面应用](https://github.com/johnfactotum/foliate) | 极简阅读、正文优先、整合目录/批注/书签、浅深色表现 | Linux/GTK 应用架构并非 Windows React 的现成组件 | GPL；借鉴设计，代码需审查 |
| [foliate-js](https://github.com/johnfactotum/foliate-js) | 阅读与格式解析技术 | API 尚不稳定、未做本地兼容验证 | MIT；可做局部模块候选 |
| [Zotero Reader](https://www.zotero.org/support/pdf_reader) | 选区→批注→带来源笔记→回到原文 | 密度较高、研究工具感不宜完全复制 | 重点学交互，不默认复制代码 |
| [BookLore](https://github.com/booklore-app/booklore) | 大量书籍时仍有秩序的封面墙、元数据和书架 | 过密的深色仪表盘、后台服务器负担 | AGPL；主要作为书库视觉参考 |
| [PDF.js](https://github.com/mozilla/pdf.js) | PDF 渲染、文本层、标注底座 | 现成查看器外观不是产品最终设计 | Apache-2.0；优先复用 |
| [epub.js](https://github.com/futurepress/epub.js) | EPUB 阅读、CFI 锚点与重排 | 不等于完整美观应用 | BSD-2-Clause；集成候选 |
| [Tiptap](https://github.com/ueberdosis/tiptap) | 富文本心得/日志编辑器，用户可自主设计视觉 | 付费服务/扩展不默认纳入 | 开源核心 MIT；核对每个扩展 |
| [shadcn/ui](https://github.com/shadcn-ui/ui) | 可访问性、弹出层、菜单、键盘交互 | 默认样式直接套用会高度模板化 | MIT；工具性复用 |
| [Mantine](https://github.com/mantinedev/mantine) | 组件体系、主题、复杂交互 | 不应和其他 UI 全家桶混装 | MIT；互斥 UI 备选 |

### 视觉参考截图与官方资料

- Readest 阅读与主题：https://www.readest.net/features.html
- Readest 阅读器控件原则：https://www.readest.com/docs/reading
- Foliate 官方项目与截图：https://github.com/johnfactotum/foliate
- Zotero PDF 阅读器：https://www.zotero.org/support/pdf_reader
- Koodo Reader 项目与示例：https://github.com/koodo-reader/koodo-reader
- BookLore 项目及 assets：https://github.com/booklore-app/booklore
- shadcn 主题机制：https://ui.shadcn.com/docs/theming

不把参考截图中的书籍封面、图标或品牌元素直接复制到 ReadingOS，也不把其他项目的截图包装成自己的 UI。

## 2. 我们建议形成的独立风格

名称：Quiet Reading / Editorial Minimalism（安静的书卷式极简）。

- 视觉关键词：温和、留白、端正、有层次、阅读优先、低干扰。
- 反例关键词：霓虹渐变、玻璃拟态、大片无意义卡片、彩色 KPI、无来源的 AI 生成插画、动画泛滥。
- 建议主色：纸白 #F5F2EC、暖灰 #E9E3D8、墨黑 #242925、松绿 #526554；铜棕 #A77A53 点到为止；高亮黄 #DCC776。
- 建议排版：界面无衬线字体，书名/文章标题节制使用衬线宋体；优先系统中文字体与合规开源字体，不分发未经授权的字体。
- 建议密度：书架少浮层、封面有呼吸感；阅读器正文宽度适当，侧栏可折叠；心得主页像编辑良好的文章，不是后台 dashboard。
- 层级优先：主心得 > 原文与读书日志 > 核心观点/实践 > 元数据/统计。
- 所有变量以真实 Windows 1080p、125%/150% 缩放、夜间阅读的可用性重新调试。

## 3. 哪些美术经验不应被误解

1. 极简不是功能隐藏：重要命令应能被找到，悬浮操作有 tooltip、快捷键和状态反馈。
2. 书卷感不是陈旧拟物：纸张纹理、翻页音效和实体书影子不是必要元素。
3. 视觉统一不是强迫一切相同：PDF 必须保留原书页面；EPUB 才适合自由排版。
4. 组件库不是美术方案：用通用组件解决交互可靠性，用自己的 design tokens、版式和内容优先级决定气质。
5. 开源不是无署名资源库：代码、图标、字体、截图、封面和商标必须分别查明许可。

## 4. 交付建议

请 Codex 先对书房、书籍主页、阅读器、心得编辑器做 UI 清单和同条件截图，再对照以上四款产品提取可转化的设计原则，明确什么借鉴、什么不做。优先优化连续使用 30 分钟以上时的眼部舒适度、信息密度、操作反馈和笔记可追溯性，而非追求单张截图的震撼感。

阅读模块的数据不能为了换外观而重建。先建立稳定基线再改造；如需 Fork 上游，必须通过功能收益、数据迁移、许可合规、回归测试四重门槛。
