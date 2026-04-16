---
name: post-to-blog
description: Compile knowledge-worthy content from the current conversation into a publishable Markdown article and publish it to the user's haoliu.me blog via the `blog-publish` CLI. Use when the user says "发布到博客"、"post to blog"、"发成 wiki"、"写成博客"、"/post-to-blog" or similar. Supports types wiki / blog / snippet / page. Default is wiki (no hero image required). Invoke only when there is substantive technical/narrative content worth preserving.
tools: Read, Write, Bash
---

# Post to Blog

Turn a conversation into a published article on haoliu.me.

## Decision: which type?

| Type | Use when | Slug format |
|---|---|---|
| **wiki** (default) | Reference / how-to / debugging write-up. **No hero image needed.** | `slugified-title` |
| blog | Narrative post with images. User must supply image paths. | `YYYYMM/slugified-title` |
| snippet | Short reusable code snippet. | `YYYYMM/slugified-title` |
| page | Standalone site page. | `slugified-title` |

**Rule: if no images, publish as `wiki`.** Don't push `blog` unless the user explicitly asks and is ready to add images.

## Workflow

### 1. Scope the content

Scan the conversation and identify the knowledge-worthy piece:
- 一次 debug / 折腾的完整链路（问题 → 假设 → 修复 → 验证）
- 配置教程 / 踩坑记录
- 技术决策和取舍分析
- 工具对比 / 选型说明

If the conversation is short or trivial, ask the user: "这段对话里想保留哪个主题？给我一两句话描述重点我再写。"

### 2. Draft Markdown

Write one self-contained file at `/tmp/post-to-blog-draft.md`.

**YAML frontmatter** (pick fields relevant to type):

```yaml
---
title: 简洁、描述性、<60 字
date: 2026-04-16        # 必填，所有类型都要。用今天的日期 (YYYY-MM-DD)
summary: 一到两句话摘要（出现在列表页）
tags: [tag1, tag2]     # 2-4 个，小写，kebab-case
icon: 🛠                 # optional，wiki/page 会显示
draft: false            # true = 存草稿不公开
# blog/snippet 额外字段：
# authors: [default]
---
```

**注意：`date` 必填**，缺了前端会渲染成 `Jan 01, 1970`（epoch）。wiki 详情页的日期直接读这个字段。

**Body requirements:**
- 用户的语言（中文对话 → 中文正文）
- 开头一段背景/动机，告诉读者为什么要读
- 小标题层级清晰（## / ###），不做多层嵌套
- 保留真实命令、错误信息、具体数值 —— 这是 wiki 的价值
- "踩坑" 类内容按 `症状 / 原因 / 修复` 或 `Before / After` 组织
- 结尾一段 takeaway / 一句话总结
- 不要加 "希望这篇文章对你有帮助" 这类套话
- 不要编造没发生过的内容

### 3. Preview

把 frontmatter + 前 20 行 body 展示给用户，**不要**贴完整文章（太吵）。然后问：

> "这样发 [type]? 要改 title/tags/summary 就告诉我，没问题回 '发'。"

收到明确的 "发" / "go" / "publish" 才进入第 4 步。用户想改就改完再预览一遍。

### 4. Publish

```bash
blog-publish publish /tmp/post-to-blog-draft.md --type <type>
```

成功输出形如：
```
published: <slug>
URL:       https://www.imhaoliu.com/<type>/<slug>
```

### 5. Report

只回复 URL + 一句话。不要总结文章内容、不要推销后续动作。

## Error handling

| Status | 含义 | 处理 |
|---|---|---|
| 401 | JWT 过期/无效 | 让用户跑 `blog-publish login` 重新贴 token；告知步骤；不重试 |
| 409 | slug 已存在 | 改 title 再试（同一标题 wiki 会重复）。问用户改成什么。 |
| 其他非 2xx | API 错误 | 原样把错误输出给用户，不假装成功 |

**如果 `blog-publish` 命令不存在**：告知路径（脚本在 `~/Documents/GitHub/blog-editor/scripts/blog-publish.sh`，symlink 在 `~/.local/bin/blog-publish`），让用户自己检查 PATH；不要尝试重建 symlink。

## Hard rules

- 永远先 preview，用户确认后才 publish
- 用户没说发草稿就 `draft: false`；说了就 `true`
- 不要创建图片、不要引用不存在的图片
- 不在正文里加 "AI 生成" 之类的声明
- 文章写完立刻清除 `/tmp/post-to-blog-draft.md` 交给下次覆盖，不要持久保留

## Invocation shortcut

User 触发这个 skill 常见说法：
- "发布成 wiki" / "发成 wiki" / "post as wiki"
- "发布到博客" / "publish to blog" （若没图片 → wiki）
- "把这次 debug 写成文章发了"
- "/post-to-blog"
