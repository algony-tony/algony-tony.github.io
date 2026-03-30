---
layout: post
title: Claude Code 使用手册
categories: 软件技术
tags: AI Claude 编程工具 LLM
toc: true
---

* TOC
{:toc}

Anthropic 推出的终端 AI 编程工具，直接在命令行中读写文件、执行命令、理解整个代码仓库上下文。其实它可以做更多，可以管理你的电脑，只要你给它足够的权限，可以让它帮你安装软件，整理文件，清理系统等等等等。


## 安装

{% highlight bash linedivs %}
npm install -g @anthropic-ai/claude-code
{% endhighlight %}

也可以临时从淘宝镜像里安装。
{% highlight bash linedivs %}
npm install -g @anthropic-ai/claude-code --registry=https://registry.npmmirror.com
{% endhighlight %}

在命令行里进入项目目录后敲入 `claude` 就启动了，首次启动需要完成认证，可以用他家的 API Key 来使用（这个是按量付费的），也可以用 Anthropic 账号登陆，Claude Pro / Max 订阅用户有免费额度，在 Claude Code 里用命令 `status` 里的 Usage 可以查看5小时滚动和周额度使用情况。
{% highlight bash linedivs %}
cd your-project
claude
{% endhighlight %}


安装好后就可以直接和它对话，有什么想做的事情就让它去做就行了。


## 斜杠命令

官方文档：[Commands Reference](https://code.claude.com/docs/en/commands)

在提示框中输入 `/` 后就跟着命令。自定义 Skill 也以斜杠命令形式调用。MCP 服务接入后还会动态出现 `/mcp__<server>__<prompt>` 格式的命令。

下面是一些常用的命令，后面的参数的尖括号是必选，方括号是可选参数。

| 命令 | 说明 |
|:---|:---|
| `/login` | 登录 Anthropic 账号 |
| `/theme` | 切换颜色主题 |
| `/model` | 切换模型 |
| `/clear` | 清除上下文，释放上下文（别名：`/reset`、`/new`） |
| `/btw <question>` | 从当前上下文中岔开问个问题 |
| `/context` | 显示当前上下文里系统提示词，工具，对话消息等各自占了多少比例 |
| `/init` | 分析项目并生成 CLAUDE.md |
| `/plan` | 直接进入 plan 只读分析模式 |
| `/exit` | 退出 （别名：`/quit`） |
| `/status` | 打开设置面板，显示版本、模型、账号、连接状态 |
| `/stats` | 可视化每日用量、历史会话和连续使用天数 |

下面是会话相关的一些命令，默认情况下每次启动 Claude Code 都会开启一个新的会话，这些会话都会被保存下来

| 命令 | 说明 |
|:---|:---|
| `/rename [name]` | 给当前会话重命名 |
| `/resume [session]` | 恢复历史会话的命令 |
| `/export [filename]` | 把当前对话导出到一个文本文件里 |

一些进阶的命令

| 命令 | 说明 |
|:---|:---|
| `/sandbox` | 启用沙盒模式，在沙盒中可以设置自动允许，目前只在 macOS，Linux WSL2 可以开启，这种模式默认可以读写当前工作目录，只能以只读的权限读取目录外文件 |
| `/compact [instructions]` | 压缩对话历史，可附加关注点说明，这个命令可以压缩上下文节省 token 使用 |
| `/insights` | 生成 Claude Code 会话分析报告 |
| `/tasks` | 查看和管理后台任务 |
| `/vim` | 切换 Vim 与普通编辑模式 |
| `/plugin` | 管理 Claude Code 的 plugins |
| `/hooks` | 查看当前生效的 Hook 配置 |
| `/agents` | 查看和管理自定义 subagent 配置 |
| `/skills` | 列出当前可用的 Skill |
| `/mcp` | 管理 MCP 服务连接和 OAuth 认证 |


## 权限模式

官方文档：[Permissions](https://code.claude.com/docs/en/permissions.md)

启动时通过 `--permission-mode <模式>` 指定，或在会话中按 `Shift+Tab` 循环切换：

| 模式 | 状态栏显示 | 说明 |
|---|---|---|
| `default` | （无标记） | 每次敏感操作前询问 |
| `acceptEdits` | `⏵⏵ accept edits on` | 自动允许文件读写，执行命令仍询问 |
| `plan` | `⏸ plan mode on` | 只读分析，不修改文件也不执行命令 |
| `bypassPermissions` | — | 跳过所有询问，适合 CI 等可信环境 |

`Shift+Tab` 在会话中循环切换 `default → acceptEdits → plan`。`bypassPermissions` 只能通过启动参数或 `settings.json` 的 `defaultMode` 字段设置。

{% highlight sh linedivs %}

# 设置 bypassPermissions 模式
claude --permission-mode bypassPermissions

# 和上面等价的参数
claude --dangerously-skip-permissions

{% endhighlight %}

也可以在 `settings.json` 里配置细粒度的 `permissions.allow` / `permissions.deny` 规则，对特定工具或路径永久放行或屏蔽。


## 大模型 LLM

Claude Code 使用他们自己家的大模型，主要是三类，推理能力最强的 Opus，推理和响应速度平衡的 Sonnet，这个适合日常使用，还有一个以响应快为特点的 Haiku。

根据 Anthropic 官网的介绍，他家的大模型有一些不错的能力：
* [扩展性思考（extended thinking）的能力](https://platform.claude.com/docs/en/build-with-claude/extended-thinking)，对于复杂的任务把得到答案的一步步思考过程透明地呈现出来；
* [自适应思考（adaptive thinking）的能力](https://platform.claude.com/docs/en/build-with-claude/adaptive-thinking)，让模型自主决定何时和以何种程度使用扩展性思考；
* [调节努力程度（effort）的能力](https://platform.claude.com/docs/en/build-with-claude/effort)，对同一个模型可以调节努力程度来解决不同难度的问题；
* [快速模式（fast mode）](https://platform.claude.com/docs/en/build-with-claude/fast-mode)，这个是对 Claude 当前的最强 Opus 4.6 推出的模式，能高效地提高返回 token 的速度；
* [结构化输出（structured outputs）](https://platform.claude.com/docs/en/build-with-claude/structured-outputs)，能按照你要求的格式返回有效的 json 数据，可以直接使用，不用担心有幻觉会出现返回无法解析的 json；
* [引用（citation）的能力](https://platform.claude.com/docs/en/build-with-claude/citations)，你给大模型文档和问题，它会在返回的答案里返回引用的内容和出处；
* [流式输出（streaming messages）](https://platform.claude.com/docs/en/build-with-claude/streaming)，用 SSE 流式一点一点返回内容；
* [批量处理（batch processiong）的能力](https://platform.claude.com/docs/en/build-with-claude/batch-processing)，有可以跑批的接口，可以一次处理批量的数据，一批最大可以有 10 万条或者 256 MB 大小；
* [支持 PDF](https://platform.claude.com/docs/en/build-with-claude/pdf-support)，能直接从标准 PDF 文件中提取文字，分析图表，理解视觉内容；
* [搜索结果（search results）](https://platform.claude.com/docs/en/build-with-claude/search-results)，提供带有来源归属信息的搜索结果；
* [多语言支持（multilingual support）](https://platform.claude.com/docs/en/build-with-claude/multilingual-support)，英语肯定结果是最好的，以英文为基准，链接里有对其他语言的表现百分比评分，中文有 97% 的表现，
* [文本嵌入（embeddings）](https://platform.claude.com/docs/en/build-with-claude/embeddings)，Anthropic 没有自己的 embedding 模型，他推荐的是 Voyage AI 的 voyage 模型；
* [视觉（vision）](https://platform.claude.com/docs/en/build-with-claude/vision)，Claude 的视觉能力使其能够理解和分析图像。


## 核心概念

用户在终端直接与 Claude 模型对话，Claude 通过反复调用 **Tool（工具）** 来完成任务，形成「思考 → 调用工具 → 观察结果 → 继续」的循环。

### Tool

工具（Tool）是最底层的基础能力，Claude 与系统交互的原子操作，所有更高层功能都建立在工具之上。工具都是系统内置，不可自定义，只能授权或者拒绝。
内置工具官方文档：[Tools](https://code.claude.com/docs/en/tools-reference)

| 工具 | 说明 | 需要权限 |
|:---|:---|:---|
| `Agent` | 派生子代理，拥有独立上下文窗口来处理任务 | 否 |
| `AskUserQuestion` | 通过多选题收集需求或澄清歧义 | 否 |
| `Bash` | 在当前环境中执行 shell 命令 | 是 |
| `CronCreate` | 在当前会话中安排定期或一次性任务（退出 Claude 后失效） | 否 |
| `CronDelete` | 根据 ID 取消已安排的任务 | 否 |
| `CronList` | 列出会话中所有已安排的任务 | 否 |
| `Edit` | 对指定文件进行精确编辑 | 是 |
| `EnterPlanMode` | 切换到计划模式，在编码前设计方案 | 否 |
| `EnterWorktree` | 创建独立的 git worktree 并切换进入 | 否 |
| `ExitPlanMode` | 展示计划并请求确认，然后退出计划模式 | 是 |
| `ExitWorktree` | 退出 worktree 会话，返回原始目录 | 否 |
| `Glob` | 按模式匹配查找文件 | 否 |
| `Grep` | 在文件内容中搜索匹配模式 | 否 |
| `ListMcpResourcesTool` | 列出已连接 MCP 服务器暴露的资源 | 否 |
| `LSP` | 通过语言服务器提供代码智能功能，文件编辑后自动报告类型错误和警告，支持跳转定义、查找引用等导航操作 | 否 |
| `NotebookEdit` | 修改 Jupyter notebook 单元格 | 是 |
| `PowerShell` | 在 Windows 上执行 PowerShell 命令（预览功能，需手动开启） | 是 |
| `Read` | 读取文件内容 | 否 |
| `ReadMcpResourceTool` | 通过 URI 读取指定的 MCP 资源 | 否 |
| `Skill` | 在主对话中执行技能（Skill） | 是 |
| `TaskCreate` | 在任务列表中创建新任务 | 否 |
| `TaskGet` | 获取指定任务的完整详情 | 否 |
| `TaskList` | 列出所有任务及其当前状态 | 否 |
| `TaskOutput` | （已弃用）获取后台任务的输出，建议改用 `Read` 读取任务输出文件 | 否 |
| `TaskStop` | 根据 ID 终止正在运行的后台任务 | 否 |
| `TaskUpdate` | 更新任务状态、依赖、详情或删除任务 | 否 |
| `TodoWrite` | 管理会话任务清单（非交互模式和 Agent SDK 中使用；交互式会话改用 TaskCreate 等） | 否 |
| `ToolSearch` | 启用工具搜索时，搜索并加载延迟工具 | 否 |
| `WebFetch` | 抓取指定 URL 的网页内容 | 是 |
| `WebSearch` | 联网搜索 | 是 |
| `Write` | 创建或覆盖文件 | 是 |


### Plugin

[Plugins Reference](https://code.claude.com/docs/en/plugins-reference)

插件是最高层的能力单位，可以把 Skills，Agents，Hooks，MCP 服务器，LSP 服务器等打包为一个整体分发，Claude 有一个[官方的插件市场](https://claude.com/plugins)，里面有很多功能强大的插件。

### CLAUDE.md

项目根目录下放置 `CLAUDE.md`，Claude Code 每次启动自动读取，如果你有关于这个项目的什么信息是希望每次 Claude Code 启动都记住的，就把它放在 `CLAUDE.md` 文件里，比如关于这个项目是做什么的，这个项目应该用哪些技术栈，有哪些规范。

{% highlight markdown linedivs %}
## 构建命令
- 构建: `npm run build`
- 测试: `npm test`

## 约定
- commit message 用英文，遵循 Conventional Commits
- 不要修改 generated/ 目录下的文件
{% endhighlight %}


### Agent

官方文档：[Sub-agents](https://code.claude.com/docs/en/sub-agents)

与用户对话的是 Claude 大模型本身，不是 agent。Agent 是 Claude 主动通过 `Agent` tool 派生的子进程，子代理有独立的上下文窗口，只把摘要返回给主对话，避免撑爆主上下文。Claude 的内置 subagents 有如下几个：

| 子代理 | 说明 |
|:---|:---|
| Explore | 只读、快速探索代码库（用 Haiku 省 token） |
| Plan | 只读、制定实现方案 |
| general-purpose | 全工具通用 |
| statusline-setup | 当使用命令 `/statusline` 来设置 Claude Code 的状态栏时会启动这个 agent |
| claude-code-guide | 回答 Claude Code 本身的使用问题 |

自定义 agent 可以在 `.claude/agents/`（当前项目）或 `~/.claude/agents/`（所有项目）下新建 `.md` 文件来创建，用 `/agents` 命令会指导你一步一步地创建一个新的自定义 agent。

### Skill

官方文档：[Skills](https://code.claude.com/docs/en/skills)

可复用的指令集，它和内置命令不同的是，内置命令是执行固定的逻辑，而 skill 其实是给大模型的 prompt，是给大模型的一套做事的方法流程说明。Skill 可以放在 `.claude/skills/<name>/SKILL.md`（当前项目）或 `~/.claude/skills/<name>/SKILL.md`（所有项目）下，可以通过斜杠命令显式调用，也可由 Claude 根据任务描述自动触发。


### Hook

官方文档：[Hooks Guide](https://code.claude.com/docs/en/hooks-guide) · [Hooks Reference](https://code.claude.com/docs/en/hooks)

在 Claude Code 生命周期特定事件上触发的操作，保证某些操作**一定**发生，不依赖 Claude 的判断。配置在 `settings.json` 的 `hooks` 字段里。用 `/hooks` 命令查看当前生效的所有钩子。

常用事件：

| 事件 | 触发时机 | 典型用途 |
|:---|:---|:---|
| `PreToolUse` | 工具执行前 | 拦截危险命令、校验参数 |
| `PostToolUse` | 工具成功后 | 自动格式化代码、运行 lint |
| `PermissionRequest` | 权限询问弹出时 | 自动放行特定操作 |
| `Stop` | Claude 完成回复 | 桌面通知、验证任务是否完成 |
| `SessionStart` | 会话启动 | 注入额外上下文 |

Hook 类型使用最多的是 `command`（shell 命令），还有 `http`（POST 到 webhook）、`prompt`（让模型做是否判断）、`agent`（运行带工具的 subagent）。

### MCP

官方文档：[MCP](https://code.claude.com/docs/en/mcp)

Model Context Protocol，连接外部系统的标准协议。通过 MCP Server 可以让 Claude 直接操作 GitHub、Slack、数据库等服务。用 `/mcp` 命令查看已连接的服务。

{% highlight bash linedivs %}
# 添加 MCP 服务（HTTP 方式）
claude mcp add --transport http github https://api.githubcopilot.com/mcp/

# 查看已配置的服务
claude mcp list
{% endhighlight %}

连接范围：`local`（仅当前项目，默认）、`project`（团队共享，写入 `.mcp.json` 提交到 repo）、`user`（个人所有项目）。

社区 MCP Server 索引：[github.com/modelcontextprotocol/servers](https://github.com/modelcontextprotocol/servers)，包含 GitHub、Sentry、PostgreSQL、Notion、Figma 等数百个可直接使用的服务。

### Memory

和用户自己写的 `CLAUDE.md` 文档不同，Memory（记忆）是 Claude 自己写的笔记，它存在 `~/.claude/projects/<项目>/memory/` 下，每次会话启动自动加载前 200 行。用 `/memory` 命令查看和编辑。在 `settings.json` 里设置 `autoMemoryEnabled: false` 可以关闭。


## 参考链接

[Claude CLI reference](https://code.claude.com/docs/en/cli-reference)

[Best Practices](https://code.claude.com/docs/en/best-practices)

[Prompting best practices](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/claude-prompting-best-practices)