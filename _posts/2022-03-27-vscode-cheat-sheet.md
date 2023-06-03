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

### 终端档案

VSCode 可以设置系统自带的终端，[用户也可以自定义一些终端配置](https://code.visualstudio.com/docs/terminal/profiles)，比如配置 Anaconda PowerShell 终端环境，打开配置文件 `Ctrl+Shift+P`，选择 `Preferences: Open User Setting(JSON)`，打开配置 json 文件，添加如下 Conda PowerShell 终端档案并设置为默认终端（这里假设 Anaconda 安装在用户目录下）：

{% highlight json linedivs %}
"terminal.integrated.profiles.windows": {
    "Conda PowerShell": {
    "path": "PowerShell",
    "args": [
        "-noexit",
        "-file",
        "${env:USERPROFILE}\\anaconda3\\shell\\condabin\\conda-hook.ps1"
    ]
    }
},
"terminal.integrated.defaultProfile.windows": "Conda PowerShell"
{% endhighlight %}

上面的终端档案文件是 PowerShell 文件，Windows 个人版本系统默认执行策略是[不让执行 ps1 文件的](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_execution_policies?view=powershell-7.3)，这边需要改下执行策略，用管理员权限打开 PowerShell 文件，执行如下命令：

{% highlight powershell linedivs %}
> # 先查看下当前系统的执行策略
> Get-ExecutionPolicy -List
        Scope ExecutionPolicy
        ----- ---------------
MachinePolicy       Undefined
   UserPolicy       Undefined
      Process       Undefined
  CurrentUser       Undefined
 LocalMachine       Undefined

> # 设置当前用户的执行策略为 RemoteSigned
> Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

> # 再查看下执行策略，确认更改生效
> Get-ExecutionPolicy -List
        Scope ExecutionPolicy
        ----- ---------------
MachinePolicy       Undefined
   UserPolicy       Undefined
      Process       Undefined
  CurrentUser    RemoteSigned
 LocalMachine       Undefined
{% endhighlight %}


## 特性介绍

### 文件预览

在 VSCode 左边文件导航栏单击文件后出现的窗口只是一个文件内容预览窗口，标志是 tab 页的标题是斜体，预览窗口只会打开一个，所以这时候如果在去单击其他文件就会看见预览窗口以前切换成新文件的内容。
不想打开预览可以直接双击文件，或者在打开的预览 tab 页上双击，标题就会变为正体是编辑窗口，或者就直接在预览窗口上编辑。
