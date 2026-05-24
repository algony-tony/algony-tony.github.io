---
layout: post
title: 12-Factor Agents 介绍
categories: 人工智能
tags: LLM Agent 架构 AI应用
toc: true
---

* TOC
{:toc}

12-Factor Agents，也常写作 **The Twelve-Factor Agents**，是一套面向 LLM 智能体（Agent）的工程方法论。它由 **HumanLayer 的创始人 Dexter "Dex" Horthy** 提出，并在 2025 年的 AI Engineer World's Fair 大会上做了系统分享。

这个名字明显是在致敬经典的 [12-Factor App](/12-factor-app/)。当年 12-Factor App 把云应用的工程经验提炼成一组原则，而 12-Factor Agents 想做的，是把这些年大家踩坑踩出来的 Agent 工程经验，同样提炼成一组可落地的设计原则。

它不是某个框架，也不是某个 SDK，而是一组构建可靠 LLM 应用的实践。官方资料都在这个开源仓库里：[github.com/humanlayer/12-factor-agents](https://github.com/humanlayer/12-factor-agents)。

## 12-Factor Agents 解决什么问题

Dex 在提出这套方法论之前，访谈了一百多位创业者和 AI 工程师。他发现一个很普遍的现象：

团队往往会抓起一个 Agent 框架快速起步，很快就能做出一个看起来不错的 demo，完成大概 70%–80% 的功能。但接下来想把它真正交到生产环境的客户手里时，就撞上了天花板：

* 框架把 prompt、上下文、控制流都藏在抽象背后，出了问题很难调试；
* Agent 在多轮循环里越跑越离谱，行为不可控；
* 上下文窗口被塞满了无关信息，效果反而下降；
* 出错以后没有干净的方式恢复，只能整段重来；
* 想加入人工审核环节，却发现框架没留口子；
* 真要排查问题，发现根本不知道模型到底看到了什么。

于是大家不得不把框架拆开，自己重写大量逻辑。

12-Factor Agents 的核心判断就是：**真正可靠的 Agent，更多是“扎实的软件工程”，而不是“更聪明的框架”。** 它主张工程师重新掌控 prompt、上下文、控制流和状态，把 LLM 当作整个系统里一个可控的组件，而不是把一切都交给框架的黑盒循环。

## 一句话概括 12 个原则

| 序号 | Factor | 核心含义 |
|---|---|---|
| 1 | Natural Language to Tool Calls | 把自然语言转成结构化的工具调用 |
| 2 | Own your prompts | 自己掌控 prompt，把它当代码管理 |
| 3 | Own your context window | 自己掌控上下文窗口的构造 |
| 4 | Tools are just structured outputs | 工具调用本质只是结构化输出 |
| 5 | Unify execution and business state | 统一执行状态和业务状态 |
| 6 | Launch/Pause/Resume with simple APIs | 用简单 API 支持启动、暂停、恢复 |
| 7 | Contact humans with tool calls | 通过工具调用联系人类 |
| 8 | Own your control flow | 自己掌控控制流 |
| 9 | Compact errors into context window | 把错误信息精简后写回上下文 |
| 10 | Small, focused agents | 用小而专注的 Agent |
| 11 | Trigger from anywhere | 从任何地方触发，贴近用户 |
| 12 | Make your agent a stateless reducer | 把 Agent 设计成无状态的 reducer |

下面逐个展开。

## 1. Natural Language to Tool Calls：自然语言转工具调用

Agent 最基本的能力，是把用户的自然语言意图，转换成结构化的、可执行的工具调用。

比如用户说“给张三发一封会议邀请”，模型不应该直接输出一段散文，而应该输出一个明确的结构，例如：

{% highlight json linedivs %}
{
  "tool": "send_calendar_invite",
  "to": "zhangsan@example.com",
  "subject": "项目同步会",
  "time": "2026-05-26T15:00:00+08:00"
}
{% endhighlight %}

把“自然语言 → 结构化调用”这一步做清晰、做稳定，是后面一切的基础。这一步越确定，整个系统就越可控。

## 2. Own your prompts：自己掌控 prompt

很多框架会替你“管理”prompt，把它包在一层层抽象后面，美其名曰开箱即用。

但 Dex 的观点是：**prompt 是影响 Agent 行为最关键的代码，必须由你自己掌控。**

prompt 应该像普通代码一样：放进版本控制、能 diff、能 review、能测试、能针对效果反复迭代。当效果不好时，你要能直接看到、直接改到发给模型的每一个 token。

把 prompt 藏在框架里，短期省事，长期会让你失去对系统行为最重要的那根调节杆。

## 3. Own your context window：自己掌控上下文窗口

上下文窗口就是你最终发给模型的全部输入。模型表现好不好，很大程度上取决于这个窗口里装了什么。

这条原则就是现在常说的 **上下文工程（context engineering）**：你要主动决定窗口里放什么、怎么组织、放多少，而不是被动地把所有历史记录一股脑塞进去。

要点包括：

* 只放当前这一步真正需要的信息；
* 用自己设计的格式来表达历史和状态，而不是照搬框架的默认序列化；
* 控制窗口长度，避免无关内容稀释关键信号；
* 把工具结果、错误、状态都按对模型最友好的方式编排。

上下文窗口是你和模型之间的唯一接口，把它牢牢握在手里。

## 4. Tools are just structured outputs：工具只是结构化输出

“工具调用”听起来很玄，但本质上，它只是模型输出的一段结构化数据（通常是 JSON），然后由你的代码去解释和执行。

这个视角很重要：**模型并不会真的“执行”任何东西，它只是产出一段描述意图的结构化文本。** 真正执行动作的，是你自己写的确定性代码。

想通这一点，整个系统就清爽了：模型负责“决定做什么”，你的代码负责“怎么做、要不要做、做之前校验什么”。模型的输出只是输入到你程序里的一个数据结构，你完全可以校验它、拒绝它、改写它。

## 5. Unify execution and business state：统一执行状态和业务状态

很多框架会把“执行状态”（当前在第几步、调用了哪些工具、等待什么）和“业务状态”（订单、工单、对话内容）分开存储，结果两边经常不同步。

12-Factor Agents 主张尽量把两者统一。执行的进度本身就应该能从业务状态里推导出来，而不是另外维护一份脆弱的、藏在框架内存里的状态机。

状态越统一、越显式，Agent 就越容易被持久化、被恢复、被审计，也越容易在出问题时弄清楚“它到底进行到哪一步了”。

## 6. Launch/Pause/Resume with simple APIs：启动、暂停、恢复

生产环境里的 Agent 不可能总是一口气跑完。它经常需要：

* 等待某个长耗时工具返回；
* 等待人工审批；
* 等待外部事件（比如用户回复、回调通知）；
* 跨越几分钟、几小时甚至几天继续执行。

所以一个 Agent 应该能够被干净地启动、暂停、恢复，并且这些操作要有简单清晰的 API。

暂停时，它的状态被持久化下来；恢复时，它能从断点继续，而不是从头再来。这条原则和无状态、状态统一是相互配合的。

## 7. Contact humans with tool calls：通过工具调用联系人类

Agent 不应该假设自己什么都能独立搞定。遇到拿不准、风险高、需要授权的情况，它应该把人类拉进来。

巧妙之处在于：**联系人类，也用工具调用这同一套机制。**

比如模型可以调用一个 `request_human_approval` 工具，或者 `ask_human` 工具，把问题抛给人。在系统看来，这和调用数据库、调用 API 没有本质区别——都是一次结构化输出。

这正是 HumanLayer 自己产品的核心理念：让 Agent 走出聊天框，进到 Slack、邮件这些人本来就在的地方，在关键节点请人介入。

## 8. Own your control flow：自己掌控控制流

这可能是整套方法论里最核心的一条。

很多框架提供一个“自动循环”：模型想下一步、执行、再想下一步，反复直到它认为完成。问题是，这个循环你控制不了，Agent 很容易跑飞、绕圈、做出意料之外的动作。

12-Factor Agents 主张：**控制流应该由你的代码显式决定，而不是交给框架的黑盒循环。**

什么时候调用模型、什么时候执行工具、什么时候停下来、什么时候走人工分支、什么时候直接走确定性逻辑——这些都应该是你代码里清清楚楚的判断，而不是“让模型自己看着办”。

把控制流握在手里，Agent 才能从“不可预测的玩具”变成“可预测的软件”。

## 9. Compact errors into context window：把错误精简后写回上下文

工具会失败，API 会超时，输入会不合法。Agent 需要能从错误中恢复。

常见做法是把完整的错误堆栈直接塞回上下文，让模型“看着办”。但这样会迅速塞满窗口，还可能让模型陷入反复重试的死循环。

更好的做法是：**把错误信息精简、提炼后再写回上下文。** 只保留模型纠正行为真正需要的信息，并且对连续失败设上限——失败几次之后，就该交给人，而不是无脑重试。

## 10. Small, focused agents：小而专注的 Agent

不要追求一个无所不能的“超级 Agent”。

LLM 的可靠性会随着任务复杂度、步骤数量的上升而快速下降。一个要处理几十步、覆盖十几种场景的大 Agent，几乎一定会在某处崩掉。

12-Factor Agents 主张把系统拆成多个小而专注的 Agent，每个只负责一个范围明确、步骤可控的任务（经验上常说控制在 3–10 步左右）。

小 Agent 更容易测试、更容易调试、行为也更可预测。复杂的业务流程，用确定性代码把这些小 Agent 编排起来，而不是寄希望于一个大模型一次想清楚所有事。

## 11. Trigger from anywhere：从任何地方触发，贴近用户

Agent 不应该只能通过一个聊天界面来使用。它应该能被各种事件源触发，并且部署在用户本来就在的地方：

* Slack / 飞书 / 钉钉消息；
* 邮件；
* Webhook、定时任务；
* CI/CD 流水线、监控告警；
* 其他系统的事件。

同样，它的输出也应该回到用户所在的渠道，而不是逼着用户专门跑来一个网页对话框。

这条和 12-Factor App 的“端口绑定”有点神似：让 Agent 成为一个能被任意系统接入、又能融入现有工作流的服务，而不是一个孤立的聊天玩具。

## 12. Make your agent a stateless reducer：把 Agent 设计成无状态 reducer

这条是对前面很多原则的总结性抽象。

借用函数式编程里 reduce 的概念：一个 reducer 接收“当前状态”和“一个事件”，返回“新状态”，本身不保存任何内部状态。

12-Factor Agents 主张把 Agent 设计成这样一个纯粹的状态转换函数：

```
新状态 = agent(当前状态, 新事件)
```

Agent 本身无状态，所有状态都显式地存在外部。这样它就可以随时被启动、暂停、恢复、重放、并行运行，行为高度可预测——这和 12-Factor App 里“无状态进程”的思想一脉相承。

## 12-Factor Agents 和 12-Factor App 的关系

两者的精神高度一致：**用扎实的软件工程，驯服一个容易失控的新领域。**

* 12-Factor App 当年要驯服的，是难以部署、难以扩展的云应用；
* 12-Factor Agents 现在要驯服的，是难以预测、难以可靠化的 LLM 应用。

很多原则甚至能一一对应：

* 无状态进程 ↔ 无状态 reducer；
* 端口绑定、对外提供服务 ↔ 从任何地方触发、贴近用户；
* 配置与代码分离 ↔ prompt 与上下文由你显式掌控；
* 一次性管理进程、可恢复发布 ↔ 启动/暂停/恢复、可恢复执行。

可以这样理解：12-Factor App 回答“云应用应该怎么写”，12-Factor Agents 回答“LLM 应用应该怎么写”。底层的工程价值观是相通的——可控、可移植、可恢复、可观测。

## 实践时不要教条化

和 12-Factor App 一样，这 12 条也不是必须逐条照搬的戒律。

Dex 自己也强调，这些是“模式”，不是“规则”。有些场景下，成熟框架的自动循环已经够用；有些简单任务，未必需要拆成一堆小 Agent。关键不在于凑齐 12 条，而在于理解背后那条主线：

**当你需要可靠性时，把 prompt、上下文、控制流和状态重新握回自己手里。**

把它当作一份构建生产级 Agent 的检查清单，在自己的场景里灵活取舍，才是更合理的态度。

## 参考链接

* 官方开源仓库（含全部 12 条详解）：[github.com/humanlayer/12-factor-agents](https://github.com/humanlayer/12-factor-agents)
* 作者 Dexter Horthy 的 GitHub：[github.com/dexhorthy](https://github.com/dexhorthy)
* 大会演讲视频《12-Factor Agents: Patterns of reliable LLM applications — Dex Horthy, HumanLayer》：[YouTube](https://www.youtube.com/watch?v=8kMaTybvDUw)
* HumanLayer 官网：[humanlayer.dev](https://humanlayer.dev)
