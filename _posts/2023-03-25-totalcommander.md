---
layout: post
title: Total Commander 10.52 版本安装配置试用
categories: 软件技术
tags: TotalCommander
toc: false
---

最早在受独立博客[善用佳软](https://xbeta.info/ "链接目前不可访问了")的影响开始接触到 Total Commander 软件，一晃都十几年过去了。
TC 真是很好用的一个自由软件，官网上可以直接免费下载，30 天的试用期，过了试用期是需要自觉删除的，但软件上几乎没有对继续使用有任何限制，没注册的 TC 就是每次打开软件进程会有一个弹窗，在弹窗里需要从三个数里选出指定的一个即可，因为每天都会打开，每次打开就会一直使用，所以实际上每天就这样点一次就可以一直继续使用下去，这样做唯一的副作用就是会对开发出这么好用的软件又这么有善心的开发者 Christian Ghisler 有点愧疚感。

Total Commander 是什么？借用下面帮助文档里的介绍来说明，它是一个类似 Windows 资源管理器的一个软件。

> Total Commander (former Wincmd) is a file manager for Windows (TM) similar to the Windows Explorer. But Total Commander uses a different approach: it has two fixed windows side by side like a well-known file manager for DOS.

最近公司强调办公电脑里必须使用正版软件的要求，借着这个时机打算买个个人许可证自己使用，翻了下 TC 许可证上的说明，个人购买也一样可以在办公环境中使用，安装多少设备都可以，前提就是都是你自己而不是别人在使用。

> The registered version may be installed on as many computers as desired, as long as it is used by only one person at any one time (I.e. one installation at home and one at the office used by the same person). Therefore you need only one licence for a port connection between two computers. The usage by multiple people at the same time (on multiple computers) requires additional licences.

官网[下载页](https://www.ghisler.com/download.htm)当前最新版本已经是 2022 年 10 月 26 号发布的 `10.52`，我本地的版本还是 2009 年的 `7.50a`，官网给出的是安装版，为了方便我一般都用免安装的移动版本。

首先官网下载 `10.52` 的 64-bit 版本，需要提醒的一点，一般还是建议选择 32-bit 版本，它可以跑在 32 位和 64 位操作系统上，而且还有很多老插件都还是 32-bit 的，如果选择 64-bit 版本将无法使用这些插件。开始安装。

选择安装英语版本

!["安装 TC"](/assets/img/post/tc-01.png)

默认 Yes 我选 No，就我自己使用，节省空间不需要那么多种语言支持：

!["安装 TC"](/assets/img/post/tc-02.png)

先给它安装到 D 盘下：

!["安装 TC"](/assets/img/post/tc-03.png)

配置文件的路径，这里做一些更改

!["安装 TC"](/assets/img/post/tc-04.png)

新版本的配置文件默认是放在 C 盘下的用户目录下，点 Help 弹窗列出了几种选择的各自优点，我这里改到 TC 程序的根目录：

!["安装 TC"](/assets/img/post/tc-04-2.png)

!["安装 TC"](/assets/img/post/tc-04-3.png)

快捷方式就都不用创建了，我都是固定到任务栏里的，因为使用频率太高了：

!["安装 TC"](/assets/img/post/tc-05.png)

询问是否要对安装目录做写保护，选择 No：

!["安装 TC"](/assets/img/post/tc-06.png)

安装好了。

!["安装 TC"](/assets/img/post/tc-07.png)

安装目录看一下：

!["安装 TC"](/assets/img/post/tc-08.png)

启动 TOTALCMD64.EXE，这是我当前启动的第二个 TC，所以左上角有个 [2]，64-bit 版本的 icon 原来会带上 64 两个数字，哈哈，熟悉的界面：

!["安装 TC"](/assets/img/post/tc-09.png)

选择正确的数字 2 后进入下一步，首次启动直接让你配置一下，我这直接跳过后面用我老的配置文件套一下：

!["安装 TC"](/assets/img/post/tc-10.png)

按钮做了更新，我还是选择 1 老版本的，看习惯了：

!["安装 TC"](/assets/img/post/tc-11.png)

这样就进入 TC 了，从右上角 Help 里的 “About Total Commander...” 看一下配置文件路径：

!["安装 TC"](/assets/img/post/tc-12.png)

这里显示的是配置文件使用默认选项的路径：

!["安装 TC"](/assets/img/post/tc-13.png)

好了，打开了，新版本这个多了个暗黑模式：

!["安装 TC"](/assets/img/post/tc-14.png)

下面是效果，样子还不错，一下就有了点高级感：

!["安装 TC"](/assets/img/post/tc-15.png)


新版默认的 TC 的配置文件的位置写入到了注册表里，如果想把配置文件放在安装目录下可以自己写个批处理脚本来启动：

{% highlight bat linedivs %}
%ECHO OFF
start TOTALCMD64.EXE /i=.\wincmd.ini /f=.\wcx_ftp.ini
exit
{% endhighlight %}


