---
layout: post
title: 用 git daemon 在局域网里快速共享 Git 仓库
categories: 软件技术
tags: git
toc: false
---

在局域网里，如果想把当前电脑上的 Git 仓库临时共享给另一台电脑拉代码，直接用 Git 自带的 `git daemon` 命令就行。

在代码仓库的父目录里启动：

{% highlight bash linedivs %}
git daemon --verbose --export-all --base-path=.
{% endhighlight %}

然后在同一个局域网里的另一台电脑上，直接克隆就行：

{% highlight bash linedivs %}
git clone git://<ip>/<git-project-name>
{% endhighlight %}


官方文档在这里 [git-daemon](https://git-scm.com/docs/git-daemon.html)，下面是一些简单的介绍。

`git daemon` 是 Git 自带的一个非常简单的 TCP 服务，默认监听 **9418** 端口，提供的是 `git://` 协议。

默认情况下，`git daemon` 只会暴露代码仓库里有一个叫 `git-daemon-export-ok` 标记文件的仓库，使用这个参数 `--export-all` 就是让 `git daemon` 跳过这一检查，直接导出 `--base-path=.` 路径下所有 Git 仓库的目录

`git daemon` 默认开启的是 `upload-pack` 服务，所以默认客户端能做的主要就是：

* `git clone`
* `git fetch`
* `git pull`
* `git ls-remote`