---
layout: post
title: Git 使用手册
categories: 软件技术
tags: git
---

Git 是一个快速高效并免费开源的分布式版本管理系统。
Linus Torvalds 原来使用 BitKeeper 做 Linux 的内核源码管理，因为中间出现了一些矛盾，Linus 觉得不能再用 BK 了，
但是也不能回到使用 BK 之前的状态，所以在就动手写 git，用了一天让 git 可以自我管理，后续就用 git 管理上了 git 的源码，git 从无到有用了差不多 10 天。

Git 命令主要分为高级（“瓷器”）命令和低级（“管道”）命令。日常中使用较多的是瓷器命令，瓷器命令最早是通过脚本将管道命令拼接使用的，现在也都可以通过管道命令组合出来。
管道命令也会更稳定一些。

## 配置 git config

{% highlight bash linedivs %}
git config --global user.name "[name]"
git config --global user.email "[email address]"
git config --list # 列出配置项
git config --global color.ui auto # 使用 Git 命令行配色
{% endhighlight %}


## 分支 git branch

下面是一些常用的分支操作相关命令。

{% highlight bash linedivs %}
git branch [branch-name] # 创建分支
git branch -a # 查看本地及远端的所有分支
git switch -c [branch-name] # 切换分支
git checkout [branch-name] # 切换分支，同上命令
git checkout -b [branch-name] # 创建分支，并切换到新分支上
git merge [branch] # 将指定分支合并到当前分支
git branch -f [branch-name] [commit-id] 在指定的 patch 上建立分支（若 branch 已经存在就切过去）
git branch -d [branch-name] # 删除某个分支
{% endhighlight %}

可以新建一个和主分支没有任何关联的孤儿分支，可以单独放文档，或者存放一些页面，比如 Github Pages 功能就是用的 gh-pages 孤儿分支

{% highlight bash linedivs %}
git checkout --orphan gh-pages # 创建孤儿分支 gh-pages，并切换到分支上，如果只是切换到 gh-pages 上就用 git checkout 即可
{% endhighlight %}


## 提交 git commit

{% highlight bash linedivs %}
git add [file] # 将文件进行快照处理用于版本控制
git status # 展示工作区的状态
git status --short --ignored # 简明展示工作区的状态，包含显示已忽略文件
{% endhighlight %}

Git 对每次提交会保存两个人的名字和邮箱，一个是作者（author），作为这次变更的作者，另一个是提交人（committer）,提交记录的人。
一般情况下这两个身份都是同一人。

{% highlight bash linedivs %}
git commit -m "[descriptive message]"
git commit --author="Bruce Wayne <wayne@example.com>" # 指定提交的作者
{% endhighlight %}

用 git diff 显示变更内容

{% highlight bash linedivs %}
git diff [filename] # 显示工作目录和暂存区的差异
git diff [commit-name] [filename] # 显示工作目录和指定提交的差异
git diff HEAD [filename] # 显示工作目录和当前分支的最新提交记录的差异
git diff --cached [commit-name] [filename] # 显示暂存区和指定提交的差异
git diff --staged HEAD [filename] # 显示暂存区和当前分支的最新提交记录的差异，staged 和 cached 效果一样
{% endhighlight %}

![Git diff](/assets/img/post/git-diff.png "git diff")

保存未提交变更到本地堆栈中

{% highlight bash linedivs %}
git stash # 保存变更到本地堆栈中
git stash save [message] # 保存变更到堆栈并记录标记信息
git stash list # 列出保存的记录
git stash pop # 恢复最近一次入栈记录内容
{% endhighlight %}

放弃修改，从某次提交中恢复历史版本

{% highlight bash linedivs %}
git checkout c5f567 -- file1/to/restore file2/to/restore
{% endhighlight %}


## 标签 git tag

Git 有两种类型的标签，一个是轻量标签（lightweight tag，也叫 unannotated tag），一种是标注标签（annotated tag）,它们的区别就是标注标签加了一段注释信息，官方文档对这两个的用途解释如下。

> Annotated tags are meant for release while lightweight tags are meant for private or temporary object labels.

{% highlight bash linedivs %}
git tag -l # 列出当前所有标签
git tag [tag-name] [commit-sha1] # 把无标注标签打在指定的 commit 上
git tag [tag-name] [commit-sha1] -a -m [tag-annotation] # 把标注标签打在指定 commit 上，如果有多行标注就使用多个 -m， 或者不写 -m 会打开默认编辑器编辑
git tag -d [tag-name] # 删除指定标签
{% endhighlight %}


## 仓库操作

{% highlight bash linedivs %}
git init # 本地初始化 git 仓库
git init --bare project.git # 初始化裸版本库，裸版本库一般用 .git 扩展名，裸版本库没有工作目录
git remote add origin [url] # 配置本地仓库的远端仓库地址，名字叫 origin
git clone [url] # 将指定地址的仓库下载到本地
git remote -v # 显示远端仓库及地址
{% endhighlight %}


## 同步操作

{% highlight bash linedivs %}
git fetch # 下载远端跟踪分支的所有历史
git merge # 将远端跟踪分支合并到当前本地分支
git pull # 使用来自对应远端分支的所有新提交更新你当前的本地工作分支。git pull 是 git fetch 和 git merge 的结合
git fetch [remote-name] [remote-branch-name]:[local-branch-name] # 同步远端分支到本地指定分支，本地分支如果不存在会创建指定分支名的分支
git push # 将所有本地分支提交上传到远端
git push [remote-name] [local-branch-name]:[remote-branch-name] # 将本地的分支推送到远端，如果分支名一样可以省略冒号及之后的内容
{% endhighlight %}

默认情况下，git push 命令并不会传送标签到远端仓库服务器上。 在创建完标签后你必须显式地推送标签到共享服务器上。

{% highlight bash linedivs %}
git push [remote-name] [tag-name] # 推送标签到远端服务器上
git push [remote-name] --tags # 把不在远端服务器上的标签都推到那里
{% endhighlight %}



## 日志 git log
命令行下显示 git log graph，记忆法是 "A Dog" = git log --**a**ll --**d**ecorate --**o**neline --**g**raph

{% highlight bash linedivs %}
git log --all --decorate --oneline --graph
{% endhighlight %}

下面是一些常用的 git log 命令。

{% highlight bash linedivs %}
git log -n 3 # 只显示最近三次提交记录
git log --author="John Smith" # 显示某个指定 author 的提交记录
git log --committer="John\|Mary" # 显示指定某几个 committer 的提交记录
git log --after="2019-3-2" # 显示某天后的提交记录
git log --before="yesterday" # 显示某天前的提交记录
git log --follow [file] # 显示某个文件的提交记录
git log -- [file] # 显示某个文件的提交记录，为避免文件名和分支名等重名，任何在 -- 后的字符串都将被当作文件名，在其之前的选项被当作分支名或者其他选项。
git log --grep="feat:" # 在提交记录中搜索关键词
git log --no-merges # 不显示合并的提交记录
git log --merges # 只显示合并的提交记录
git log --format=fuller # 显示提交记录的 author 和 committer
{% endhighlight %}

Git 提供了一个 ```git show``` 命令来查看任意类型的对象，可以是某个提交的具体的信息及变更内容，或者是标签的具体信息，还可以用来显示目录（tree 对象）和文件内容（blob 对象）。

{% highlight bash linedivs %}
git show HEAD^^ # 查看当前提交的前第二次提交的具体信息和内容
git show v0.1 # 查看标签
git show [tag-name]:src/rand.c # 查看文件内容
git show [commit-name]:src # 查看目录
{% endhighlight %}


## 撤销提交 git reset

{% highlight bash linedivs %}
git reset [commit] # 撤销所有 [commit] 后的的提交，在本地保存更改
git reset --hard [commit] # 放弃所有历史，改回指定提交。
{% endhighlight %}

## 其他命令

获取命令的帮助文档
{% highlight bash linedivs %}
git help [command]
{% endhighlight %}

获取 git 版本号
{% highlight bash linedivs %}
git version
{% endhighlight %}

查看引用的全名，包含 .git/refs 文件夹下的内容，本地和远端的 refs 以及 tags
{% highlight bash linedivs %}
git show-ref
{% endhighlight %}

查看 git 对象命令
{% highlight bash linedivs %}
git cat-file -p [sha1-id] # 打印 git 对象内容
git cat-file -t [sha1-id] # 显示 git 对象类型
{% endhighlight %}


### 父引用的快捷写法

在修订名后面紧接着输入 ^ 符号表示该修订的第一个父对象。例如，HEAD^ 代表 HEAD 的父对象（节点），即上一个提交。对于合并提交来说，会拥有多个父对象，为了查询多个父对象中的某一个，你需要在 ^ 字符后指定它的数字代号，使用 ```^<n>``` 意味着查看修订的第 n 个父对象。我们可以将 ^ 理解为 ^1 的快捷方式。一个比较特殊的情况是，```^0``` 指代的是该提交自身。其重要性只有在使用分支名作为参数和使用其他修订标识符产生歧义时才会体现出来。它还可以用来获取提交中包含附注（签名）的标签指针，```git show v0.9``` 会显示标签标注信息和提交的相关信息，而 ```git show v0.9^0``` 只会显示标签附着的提交的相关信息。这种后缀语法还可以组合使用。用户可以使用 HEAD^^ 来指向 HEAD 的祖父对象，即 HEAD^ 的父对象。

还有另外一种声明父对象的链式表达。除了输入 n 个 ^ 后缀，例如 ^^…^ 或 ^1^1…^1，用户还可以使用 ```~<n>```。有一个特殊情况是 ~ 和 ~1 是等价的，例如 HEAD~ 和 HEAD^ 是等价的。HEAD~2 代表其第一个父对象的第一个父对象，即祖父对象，而且和 HEAD^^ 是等价的。


### 引用日志 git reflog
每次更新 HEAD 或者更新分支首部时，git 会将这些信息记录在引用日志（reflog）中，这是以一种本地的临时日志，命令 ```git reflog``` 的输出中会用 HEAD@{n} 来表示 HEAD 之前的第 n 个值。

如果是用分支名，如 master@{n}，它代表的是该分支之前的第 n 个值，@{n} 是个特例，它表示当前分支之前的第 n 个值。


## Git 原理简介

### 存储
简单地说，git 对象是存储成对象的有向无环图（DAG），它们都是压缩存储，用 40 个字符的 SHA-1 散列唯一标识（不是它们内容的 SHA-1 散列，而且它们在 git 中呈现内容的 SHA-1 散列）。

* blob: 最简单的一种对象，就是一堆字符，通常就是一个文件，也可以是符号链接（symlink）或者类似的东西；
* tree: 文件夹通常用 tree 对象表示。一个 tree 会指向文件（也就是 blobs，包含文件名，访问方式等属性都存储在 tree 中，注意文件名没有存储在 blob 中而是储存在 tree 对象里，这样做对于重命名或者同一个文件多副本的情况都是有好处的）和子文件夹（其他的 tree 对象）。
* commit: 一个提交指向提交时所有文件状态的一个 tree，它也指向 0..n 个其他 commit 作为它的父节点。对于一个父节点的 commit 是一次 merge，没有父节点的是初始提交。commit 对象的 body 是 commit message.
* refs: References, or heads or branches 就像粘在 DAG 中节点上的便利贴。它们可以在节点上自由移动，它们状态变化不会存储在记录中，显示的是当前的状态。一般 refs 都在命名空间 heads/xxx 下，简写可以略掉 heads/。
* remote refs: 通过命名空间来区别于一般的 refs，它们一般是由远端的服务器来控制的，通过 git fetch 来更新它们。在图上会用另一种颜色来区别显示一般的 refs。
* tag: 它即是 DAG 中的一个节点，也是粘在上面的便利贴。tag 指向一个 commit，包含一个可选的消息以及一个 GPG 签名。tag 的便利贴属性是为了能快速定位，如果丢失了也能用命令 ``` git fsck --lost-found``` 从 DAG 中恢复。

![Git storage](/assets/img/post/git-storage.6.dot.svg "git storage")

git commit 操作会在 DAG 上新增一个节点，并将当前分支的便利贴指向这个最新的节点。HEAD ref 是一个特别的 ref， 它指向一个其他的 ref，一般指向当前分支。

![Git HEAD 1](/assets/img/post/git-head-master.png "git HEAD")

![Git HEAD 2](/assets/img/post/git-head-after-commit.png "git HEAD after commit")

当 HEAD 偶尔发生了没有指到某个分支的时候，就叫 detached HEAD，这种情况发生的原因有下面几个

1. 使用 checkout 命令直接跳转到某个 commit，而那个 commit 刚好没有分支指着它；
2. rebase 的过程其实也是不断处于 detached HEAD 的状态；
3. 切换到某个远端分支；


DAG 中的节点能从一个仓库移动到另一个仓库，也能存储成一种更高效的形式（packs），未被使用的节点也用命令 ```git gc``` 回收。一个 git 仓库可以简单地理解为一个 DAG 和一堆便利贴。


### 暂存区

Git 的工作目录中的文件主要分为下面几种状态

* 已知文件（已跟踪文件）
  * 已提交文件（文件和上次提交比较未发生变化）
  * 已修改文件
* 未知文件
  * 已忽略文件
  * 未跟踪文件

还有另一种状态，在使用 ```git add``` 命令后 git 会对其索引（index），存储将要提交信息的暂存区。这样上面的已修改文件和未跟踪文件都要再区分下是否已进入暂存区。

![Git index](/assets/img/post/git-index.png "git index")


### 参考
[Pro Git](https://git-scm.com/book/zh/v2)

[Git Reference](https://git-scm.com/docs)

[10 Years of Git: An Interview with Git Creator Linus Torvalds](https://www.linuxfoundation.org/blog/10-years-of-git-an-interview-with-git-creator-linus-torvalds/)

[Git for Computer Scientists](https://eagain.net/articles/git-for-computer-scientists/)

[A collection of .gitignore templates](https://github.com/github/gitignore)

[How can I reset or revert a file to a specific revision?](https://stackoverflow.com/questions/215718/how-can-i-reset-or-revert-a-file-to-a-specific-revision)

[Pretty Git branch graphs](https://stackoverflow.com/questions/1057564/pretty-git-branch-graphs)

[【冷知識】斷頭（detached HEAD）是怎麼一回事？](https://gitbook.tw/chapters/faq/detached-head)

[另一種合併方式（使用 rebase）](https://gitbook.tw/chapters/branch/merge-with-rebase)