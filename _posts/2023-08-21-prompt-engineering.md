---
layout: post
title: 编写 Prompt 的几种通用框架和方法
categories: 软件技术
tags: prompt LLM
toc: false
---

对于大模型（LLM）来说，输入和输出都是文本字符串，输入部分的文本就叫做 Prompt，它是用户的输入，prompt 和 LLM 一起决定了输出的内容和质量。对于一般用户来说，LLM 是相对固定的部分，能发挥主观能动性决定输出内容的部分就是 prompt 了，这也是最近 Prompt 工程比较火的原因。

有一种观点认为 prompt 只是目前 LLM 能力还有短板时的短期方案，是个人用户对 LLM 打的一次补丁，后面 LLM 相对强大后就会逐渐弱化 prompt 的重要性，这个观点是否成立只能拭目以待了。

目前想用大模型技术来开发某些场景应用，除了软件工程上的开发部分，很大一块内容就在于编写一系列场景下的 prompts，以及对不同 prompt 的效果评估和选取，这是目前大模型应用中变量最大的部分，也是决定大模型应用成功的关键。

下面就介绍几个编写 prompt 的通用框架和一些方法，包含吴恩达教授的 9 集 [ChatGPT 提示词工程课程](https://www.bilibili.com/video/BV1Mo4y157iF)，ICIO 框架，CRISPE 框架。

## 吴恩达《ChatGPT 提示词工程课程》

下面是课程的主要内容提炼。

创建 prompt 的**两个原则**：
1. 编写清晰、具体的指令；
    * 使用分隔符清晰地表示输入的不同部分，分隔符可以是：```，""，<>，:，\<tag\> \</tag\>等；
    * 寻求结构化的输出，输出可以是 JSON, HTML 等格式；
    * 要求模型检查是否满足条件，如果任务包含不一定能满足的假设（条件），我们可以告诉模型先检查这些假设；
    * 提供少量示例，Few-shot prompting；
2. 给 LLM 时间去思考；要求模型在提供最终的答案之前开展**思维链**或进行**一系列相关的推理**。
    * 指定完成任务所需的步骤；
    * 指导模型在下结论之前找出一个自己的解法。对于需要判断一个已有的答案是否正确的情景，可以先让模型自行得出一个解法，再行比较两者来得出结论；

开发 prompt 的过程：**不断的迭代优化**。和机器学习模型的开发过程类似，开发 prompt 也是先产生想法，编写 prompt，查看实验效果并分析错误，改进 prompt 并继续验证结果直到产生满意的结果。

4 种主要大模型应用场景的 prompt 编写举例：
1. 文本概括总结（Summarizing）
    * 限制输出文本长度；
    * 通过提示词来设置对某个特定角度的侧重；
    * 如果只想要某一方面的信息，可以进行信息提取（Extract）而不是总结（Summarize）；
2. 推理（inferring）
    * 识别文本的情感和类别；
    * 商品信息提取；
    * 主题推断；
3. 文本转换（Transforming）
    * 语言翻译；
    * 语气转换；
    * 文件格式转换；
    * 拼写及语法纠正；
4. 文本扩展（Expanding）。输入短文本（一个主题或者一组说明）让模型生成更长的文本。可以定制邮件或者写一些议论段落。

## ICIO 框架

ICIO 框架模型来自 Elvis Saravia 的[提示词工程指南](https://www.promptingguide.ai/introduction/elements)。这个框架的 prompt 包含下面四个组成部分：

* **Instruction** - 您希望模型执行的特定任务或指令
* **Context** - 可以引导模型做出更好响应的外部信息或附加上下文
* **Input Data** - 我们有兴趣寻找答案的输入或问题
* **Output Indicator** - 输出的类型或格式

## CRISPE 框架

CRISPE 框架来自 Matt Nigh 的[免费提示词列表](https://github.com/mattnigh/ChatGPT3-Free-Prompt-List)，这个框架的 prompt 包含如下五个部分：

* **Capacity and Role**: ChatGPT 应该扮演什么角色？
* **Insight**: 为您的请求提供幕后洞察力、上下文和背景。
* **Statement**: 您要求 ChatGPT 做什么。
* **Personality**: 您希望 ChatGPT 做出响应的风格、个性或方式。
* **Experiment**: 要求 ChatGPT 为您提供多个示例。


## 参考资料

[ChatGPT 提示词工程课程](https://www.bilibili.com/video/BV1Mo4y157iF)

[ChatGPT 提示词工程课程（中文文字版）](https://github.com/datawhalechina/prompt-engineering-for-developers/tree/main/content/Prompt%20Engineering%20for%20Developer)

[Prompt-Engineering-Guide](https://github.com/dair-ai/Prompt-Engineering-Guide)

[提示词工程指南](https://www.promptingguide.ai/zh)

[免费提示词列表](https://github.com/mattnigh/ChatGPT3-Free-Prompt-List)

[CRISPE — ChatGPT 提示工程框架](https://sourcingdenis.medium.com/crispe-prompt-engineering-framework-e47eaaf83611)

[GPT Prompt编写的艺术：如何提高AI模型的表现力](https://mp.weixin.qq.com/s/N8XnSSdXlIITSig5z1oZCw)
