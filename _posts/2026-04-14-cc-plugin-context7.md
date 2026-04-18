---
layout: post
title: Claude Code 的 Context7 插件介绍
categories: 软件技术
tags: AI Claude 编程工具 LLM MCP Context7
toc: false
---

* [Claude Context7 官方插件页](https://claude.com/plugins/context7)
* [context7 Github 地址](https://github.com/upstash/context7/tree/master)
* [Claude Context7 源码地址](https://github.com/upstash/context7/tree/master/plugins/claude/context7)


官方页是这样描述的：

> Upstash Context7 MCP server for live docs lookup. Pull version-specific docs and code examples from source repos into LLM context.

> Upstash Context7 MCP 服务器，用于实时检索文档。可将特定版本的文档与代码示例从源码仓库提取至大语言模型（LLM）的上下文中。

Context7 就是一个文档查询工具，它的插件结构如下：

{% highlight text linedivs %}
context7/
├── .claude-plugin/
│   └── plugin.json
├── agents/
│   └── docs-researcher.md
├── commands/
│   └── docs.md
├── skills/
│   └── context7-mcp/
│       └── SKILL.md
├── .mcp.json
└── README.md
{% endhighlight %}


**plugin.json** 是插件身份证，包含名字、描述、作者。


**.mcp.json** 是这个插件的核心，Context7 插件的真正核心就是一个 **remote MCP server**，这个 json 文件非常短：

{% highlight json linedivs %}
{
  "context7": {
    "type": "http",
    "url": "https://mcp.context7.com/mcp"
  }
}
{% endhighlight %}


技能 **skills/context7-mcp** 的文件地址是 [`plugins/claude/context7/skills/context7-mcp/SKILL.md`](https://github.com/upstash/context7/blob/master/plugins/claude/context7/skills/context7-mcp/SKILL.md)，这个 skill 指出使用场景：

> This skill should be used when the user asks about libraries, frameworks, API references, or needs code examples.

以及给出了获取文档的步骤：

1. 先调用 `resolve-library-id`
2. 选最合适的库 ID
3. 再调用 `query-docs`
4. 用拉回来的资料回答问题

**agents/docs-researcher.md** 的文件地址是 [`plugins/claude/context7/agents/docs-researcher.md`](https://github.com/upstash/context7/blob/master/plugins/claude/context7/agents/docs-researcher.md)，这个 agent 的定位是轻量文档研究员，它的内容和 context7-mcp skill 类似。Claude Code 里对 subagent 的一个典型用途就是“**让主线程继续处理任务，让 subagent 专门去查资料。**

命令 **/context7:docs** 的文件地址是 [`plugins/claude/context7/commands/docs.md`](https://github.com/upstash/context7/blob/master/plugins/claude/context7/commands/docs.md)，这个插件就只有这一个命令，这个命令是给你一个显示地执行查询地手动入口。

{% highlight text linedivs %}
/context7:docs <library> [query]
{% endhighlight %}

命令里 `library` 参数提供库名，`query` 是从这个库里你想要查的东西，类似下面的使用方式。

{% highlight text linedivs %}
/context7:docs react hooks
/context7:docs next.js authentication
/context7:docs prisma relations
/context7:docs /vercel/next.js/v15.1.8 app router
{% endhighlight %}

