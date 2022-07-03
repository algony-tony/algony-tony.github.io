---
layout: post
title: VS Code 使用手册
excerpt: 包含 VSCode 的快捷键及基本使用技巧
image: /assets/img/post/Visual_Studio_Code_1.35_icon
categories: 软件技术
tags: vscode
---
## 快捷键

垂直选择
> Shift + Alt + 鼠标选择

删除整行
> Shift + Del

剪切当前行(空选定)
> Ctrl + x

复制当前行(空选定)
> Ctrl + c

打开命令面板
> Ctrl + Shift + p
> F1

新文件
> Ctrl + n

Ctrl + p 在 Terminal 会唤起 VSCode 的 Quick Open，想要用 shell 里的 Ctrl + p 快捷键可以如下设置
1. 打开 setting，（快捷键 Ctrl + ,）
2. 搜索 `terminal.integrated.commandsToSkipShell` 选项
3. 新增选项 Add Item，填入 `-workbench.action.quickOpen`

## 特性介绍

### 文件预览

在 VSCode 左边文件导航栏单击文件后出现的窗口只是一个文件内容预览窗口，标志是 tab 页的标题是斜体，预览窗口只会打开一个，所以这时候如果在去单击其他文件就会看见预览窗口以前切换成新文件的内容。
不想打开预览可以直接双击文件，或者在打开的预览 tab 页上双击，标题就会变为正体是编辑窗口，或者就直接在预览窗口上编辑。
