---
layout: post
title: Claude Code 的 4 个流行官方插件介绍
categories: 软件技术
tags: AI Claude 编程工具 LLM
toc: false
---


Anthropic 在 [claude.com/plugins](https://claude.com/plugins) 提供了官方插件目录，安装量前几名的官方插件依次是：

| 排名 | 插件 | 作者 | 插件构成 |
|---|---|---|---|
| 1 | Frontend Design | Anthropic | 1 个 skill |
| 2 | Superpowers | [Jesse Vincent](https://github.com/obra) | 一组 skill |
| 3 | Context7 | Upstash | MCP 为主，还包含 skill, agent, command |
| 4 | Code Review | Anthropic | 1 个 command |
| 5 | Code Simplifier | Anthropic | 1 个 agent |
| 6 | Feature Dev | Anthropic | 1 个 command，3 个 agent |

这篇介绍 Anthropic 官方做的四个插件，Superpowers 可以参考[这篇](/cc-plugin-superpowers/)。

## Frontend Design

* 官方插件页：[claude.com/plugins/frontend-design](https://claude.com/plugins/frontend-design)
* 插件 README：[`plugins/frontend-design/README.md`](https://github.com/anthropics/claude-plugins-official/blob/main/plugins/frontend-design/README.md)
* 核心 skill：[`plugins/frontend-design/skills/frontend-design/SKILL.md`](https://github.com/anthropics/claude-plugins-official/blob/main/plugins/frontend-design/skills/frontend-design/SKILL.md)


这个插件的目标是让 Claude 写出来的前端，不要一眼看上去就是"标准 AI 味"的页面。只需让 Claude 构建前端界面，此技能就会自动激活。想让效果更好，最好给这几类信息：

| 信息 | 例子 |
|:---|:---|
| 产品类型 | AI 安全公司、音乐 App、设计工具、消费品牌 |
| 目标用户 | 开发者、设计师、B 端管理者、年轻消费者 |
| 技术约束 | React / Vue / Tailwind / 纯 HTML |
| 风格方向 | brutalist、maximalist、luxury、playful、retro-futuristic |
| 重点区域 | hero、定价区、数据表、导航、卡片、动效 |


Frontend Design 是一个非常轻的 skill 型插件，它就一个 skill 文件 [`skills/frontend-design/SKILL.md`](https://github.com/anthropics/claude-plugins-official/blob/main/plugins/frontend-design/skills/frontend-design/SKILL.md) 。


SKILL.md 里做了几件事：

**先定设计方向，再写代码。** 它要求 Claude 在编码前先确认四件事：Purpose（目的）、Tone（风格）、Constraints（限制条件）、Differentiation（差异化），避免模型直接退回安全模板；

**强制做有风格的选择。** skill 要求 Claude 必须选定一个明确的审美方向，给出了很多极端风格供参考：brutally minimal、maximalist chaos、retro-futuristic、luxury/refined、editorial/magazine 等；

**明确列出不要做什么。** 这是最有效的部分：直接点名禁止一些高频 AI 默认项——Inter、Roboto、Arial 字体、紫色渐变白底配色、predictable layouts、cookie-cutter components。

它不是给 Claude 新增"设计能力"，而是通过 skill prompt 改变 Claude 在做前端时的默认审美偏好。


## Code Review

* 官方插件页：[claude.com/plugins/code-review](https://claude.com/plugins/code-review)
* 插件 README：[plugins/code-review/README.md](https://github.com/anthropics/claude-plugins-official/blob/main/plugins/code-review/README.md)
* 命令实现：[plugins/code-review/commands/code-review.md](https://github.com/anthropics/claude-plugins-official/blob/main/plugins/code-review/commands/code-review.md)


Code Review 这个插件只有一个命令，没有其他组件，它的作用是**把 Github pull request 的代码审查流程自动化**。它不是"帮你看看代码有没有问题"，而是一个工程化的 reviewer pipeline：会判断 PR 是否值得审查，会找相关 `CLAUDE.md` 规范，会总结变更，然后拉起多路 reviewer agents 并行审查，最后对每条 issue 做 confidence scoring，只把高置信度的问题发回 GitHub。

{% highlight bash linedivs %}
# On a PR branch, run:
/code-review

# Claude will:
# - Launch 4 review agents in parallel
# - Score each issue for confidence
# - Post comment with issues ≥80 confidence
# - Skip posting if no high-confidence issues found
{% endhighlight %}


## Code Simplifier

* 官方插件页：[claude.com/plugins/code-simplifier](https://claude.com/plugins/code-simplifier)
* 核心 agent：[`agents/code-simplifier.md`](https://github.com/anthropics/claude-plugins-official/blob/main/plugins/code-simplifier/agents/code-simplifier.md)


这个插件只有一个 agent，没有其他组件，它的作用是**在不改变功能的前提下，把刚刚改过的代码再收拾一遍，让它更清晰、更一致、更容易维护，**这些要求都是在 agent 文件里列出的。安装这个插件后，它会主动处理你最近修改的代码，或者也可以直接指明使用这个插件“请用 code-simplifier 把我刚刚改过的代码再精简一下，前提是不改变任何行为。”


## Feature Dev

* 官方插件页：[claude.com/plugins/feature-dev](https://claude.com/plugins/feature-dev)
* 插件 README：[plugins/feature-dev/README.md](https://github.com/anthropics/claude-plugins-official/blob/main/plugins/feature-dev/README.md)
* 命令实现：[plugins/feature-dev/commands/feature-dev.md](https://github.com/anthropics/claude-plugins-official/blob/main/plugins/feature-dev/commands/feature-dev.md)


这个插件类似一个轻量版的 superpowers，它用七阶段方法来构建新功能，它引导您理解代码库、提出澄清问题、设计架构并确保质量——最终打造出设计更完善、与现有代码无缝集成的功能。

Feature Dev 有三个 agent 文件和一个命令文件，命令文件是入口，类似这样使用：

{% highlight text linedivs %}
/feature-dev Add user authentication with OAuth
{% endhighlight %}

Feature Dev 定义的 7 个阶段如下：

1. Discovery。了解需求，对于用户不清晰的描述会向用户询问；
2. Codebase Exploration。启动 2-3 个 `code-explorer` agents 并行探索：有没有类似功能、当前架构怎么分层、有没有相关抽象和 extension points、现有代码是怎么流转的；
3. Clarifying Questions。理解代码库之后，把还不明确的地方继续提问澄清问题；
4. Architecture Design。启动 2-3 个 `code-architect` agents，从不同视角给出实现思路（最小改动、更干净的架构、pragmatic balance），对比 trade-off，再给出建议，询问用户选择；
5. Implementation。这里才开始真正写代码。命令实现里写得非常明确：**没有用户批准，不要开始实现**；
6. Quality Review。代码完成后启动 3 个 `code-reviewer` agents 并行从不同角度看（simplicity/DRY/elegance、bugs/correctness、conventions/abstractions），汇总结果后问你：现在修、以后修、还是就这样继续；
7. Summary。最后收尾：总结做了什么、记录关键决策、列出改动文件、给出后续步骤建议。


