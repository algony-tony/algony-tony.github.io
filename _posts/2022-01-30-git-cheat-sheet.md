---
layout: post
title: Git 使用手册
excerpt: Git 基本概念解释及命令查询手册
image: /assets/img/post/git-diff.png
categories: 软件技术
tags: git
toc: true
---

* TOC
{:toc}

Git 是一个快速高效并免费开源的分布式版本管理系统。

Linus Torvalds 原来使用 BitKeeper 做 Linux 的内核源码管理，2005 年因为中间出现了一些矛盾，团队不能再用 BK，
但是也不想回到没有 BK 辅助管理源码的混乱状态，于是 Linus 打算自己写个代码版本管理软件，用了一天时间让 git 可以完成基本工作，后续就用 git 管理上了 git 的源码，他一个人把 git 从无到有开发差不多只用了 10 天时间。


## 仓库操作

{% highlight bash linedivs %}
git init # 本地初始化 git 仓库
git init --bare project.git # 初始化裸版本库，裸版本库一般用 .git 扩展名，且没有工作目录
git remote add origin [url] # 配置本地仓库的远端仓库地址，名字叫 origin
git clone [url] # 将指定地址的仓库下载到本地
git remote -v # 显示远端仓库及地址
{% endhighlight %}


### 配置 git config

{% highlight bash linedivs %}
git config --global user.name "[name]"
git config --global user.email "[email address]"
git config --list # 列出配置项
git config --global color.ui auto # 使用 Git 命令行配色
git config --global core.editor "vim" # 使用 vim 作为 git 的默认编辑器

git config http.proxy http://proxy.mycompany:80
# 取消设置用 unset
git config --unset http.proxy
{% endhighlight %}



### 同步操作

{% highlight bash linedivs %}
git fetch # 下载远端跟踪分支的所有历史
git merge # 将远端跟踪分支合并到当前本地分支
git pull # 使用来自对应远端分支的所有新提交更新你当前的本地工作分支。git pull 是 git fetch 和 git merge 的结合
git fetch [remote-name] [remote-branch-name]:[local-branch-name] # 同步远端分支到本地指定分支，本地分支如果不存在会创建指定分支名的分支
{% endhighlight %}

设置推送的默认行为 `push.default` 的几个选项，[参考链接](https://git-scm.com/docs/git-config#Documentation/git-config.txt-pushdefault)：
* nothing：不做任何推送；
* matching：只推送两端同名分支，Git 2.0 之前的默认设置；
* upstream：只推送当前分支到它设置好的上游分支，tracking 是相同意义的旧用法；
* current：只推送当前分支到它的同名分支上；
* simple：Git 2.0 后的默认行为，只推送当前分支到它的上游同名分支上，等于 upstream + current；
{% highlight bash linedivs %}
git push # 不加任何参数的推送行为由 push.default 设置
git config push.default # 查看 push 的默认行为
git config push.default simple # 设置 push 的默认行为

# --all 会将路径 refs/heads 下的所有分支都推送
# -u 是将推送成功的分支都加上上游跟踪引用
git push --all -u # 将所有本地分支提交上传到远端
git push [remote-name] [local-branch-name]:[remote-branch-name] # 将本地的分支推送到远端，如果分支名一样可以省略冒号及之后的内容
{% endhighlight %}


在本地的分支做了 reset 回退操作后，推到远端时需要加上 `-f` 选项，否则会提示本地分支落后远端。
{% highlight bash linedivs %}
git checkout master
git reset --hard [commit-id]
git push -f origin master
{% endhighlight %}


### 子模块 submodule

如果需要在项目里引入另一个独立的 git 库，这时候就可以用到子模块（submodule）。子模块允许你将一个 git 仓库作为另一个仓库的子目录。

{% highlight bash linedivs %}
# 在当前路径下会创建和项目同名的子模块目录
git submodule add https://github.com/chaconinc/DbConnector

# 会发现在外部项目的顶层多了一个 .gitmodules 文件，以及刚才加入的子模块目录 DbConnector 等待提交
# .gitmodules 文件保存了子模块项目的 URL 和本地目录之间的映射关系
git status

# 此时可以切换子模块的分支或者某个提交上再将变更提交，就可以锁定子模块的分支和版本
cd DbConnector
git checkout -b dev_branch origin/dev_branch

git add .gitmodules DbConnector
git commit -m "add submodule DbConnector"

{% endhighlight %}

克隆包含子模块的项目

{% highlight bash linedivs %}
# 1. 先克隆父项目，此时子模块文件夹内是空的
git clone https://github.com/chaconinc/MainProject
# 2. 更新子模块项目
git submodule init
git submodule update

# 克隆父项目的时候加上参数 --recurse-submodules 一步到位
git clone --recurse-submodules https://github.com/chaconinc/MainProject

{% endhighlight %}

## 分支 git branch

下面是一些常用的分支操作相关命令。

{% highlight bash linedivs %}
git branch [branch-name] # 创建分支
git branch -a # 查看本地及远端的所有分支
git switch -c [branch-name] # 切换分支
git checkout [branch-name] # 切换分支，同上命令
git checkout -b [branch-name] # 创建分支，并切换到新分支上
git merge [branch-name] # 将指定分支合并到当前分支
git branch -f [branch-name] [commit-id] # 在指定的 commit 上建立分支（若 branch 已经存在就切过去）
git branch -d [branch-name] # 删除某个分支

git branch -m [oldname] [newname] # 重命名分支
git branch -m [newname] # 将当前分支重命名
# 如果在 Windows 这种大小写不敏感的系统中，并且分支改名只是改了大小写字母，那要用大写 -M 参数，否则会报错分支已存在

# 在 git merge 后发现有冲突 conflict，可以修正冲突后再提交，也可以放弃 merge
git merge --abort

{% endhighlight %}

### 删除分支 delete

主要涉及三种分支：
* 本地分支 X；
* 远端（如 origin）分支 X；
* 本地跟踪远端 X 的分支 origin/X；
 
X  ---  origin/X | X
local repo       | remote origin repo

删除本地分支
{% highlight bash linedivs %}
# -d 是 --delete 的别名
git branch -d [branch-name]
# -D 是 --delete --force 的别名
git branch -D [branch-name]
{% endhighlight %}

删除远端分支，会同时删除本地跟踪远端的分支。如果远端分支已经被删除了执行此命令会直接删除本地跟踪分支。
{% highlight bash linedivs %}
git push [remote-name] --delete [branch-name]
# 旧版本 git 的写法如下
git push [remote_name] :[branch_name]

# 从所有远端拉取变化，本地自动删除远端已删除的分支和标签
git fetch --all --prune
{% endhighlight %}

单独删除本地跟踪远端的分支

{% highlight bash linedivs %}
# -dr 是 --delete --remotes 的别名
git branch --delete --remotes [remote-name]/[branch-name]

# 同步删除远端已经删除的分支
git fetch [remote-name] --prune
{% endhighlight %}


### 合并分支 merge

整合不同的分支主要有两种方法：合并（merge）和变基（rebase）。

**快进合并（fast-forward）**指的是合并操作中没有需要解决的分歧，这样在合并两者时只是简单的将指针向前推进（指针右移），对于是否使用快进有三个选项。

1. 选项 merge --ff，也是 merge 的默认选项，能快进合并的时候会选择快进；
2. 选项 merge --no-ff，能快进合并的时候也不快进，会额外再创建一个合并提交；
3. 选项 merge --ff-only，能快进合并的时候会快进，无需合并操作的时候也会成功，其他情况都会拒绝合并并非 0 退出；

{% highlight bash linedivs %}
git checkout master

# 不使用快进合并，会出现一个额外的“耳朵”
#                           master
# C0◄───C1◄───────────────────C5
#       ▲                     │
#       └────C2◄───C3◄───C4◄──┘
#                            feature-branch
git merge --no-ff feature-branch

# 快进合并，指针右移
#                      master
# C0◄───C1◄──C2◄───C3◄───C4
#            │-----------│
#        feature branch commits
git merge --ff feature-branch
git merge --ff-only feature-branch # 效果同上

# 无法快进合并，因为有 C5 提交的存在
#                           master
# C0◄───C1◄────────C5─────────C6
#       ▲                     │
#       └────C2◄───C3◄───C4◄──┘
#                            feature-branch
git merge --ff feature-branch
git merge --no-ff feature-branch # 效果同上
{% endhighlight %}

### 变基操作 rebase

**变基（rebase）**是将提交到某一分支上的所有修改都移至另一分支上，就好像“重新播放”一样。

> 一般我们这样做的目的是为了确保在向远程分支推送时能保持提交历史的整洁——例如向某个其他人维护的项目贡献代码时。 在这种情况下，你首先在自己的分支里进行开发，当开发完成时你需要先将你的代码变基到 origin/master 上，然后再向主项目提交修改。 这样的话，该项目的维护者就不再需要进行整合工作，只需要快进合并便可。

> 奇妙的变基也并非完美无缺，要用它得遵守一条准则：
> 
> **如果提交存在于你的仓库之外，而别人可能基于这些提交进行开发，那么不要执行变基。**

`cherry-pick` 是挑选一个或几个提交选择性的变基。

{% highlight bash linedivs %}
git checkout topic

# 变基前
#                     A---B---C topic
#                    /
#               D---E---F---G master

git rebase master
git rebase master topic # 效果同上
# 变基后
#                             A'--B'--C' topic
#                            /
#               D---E---F---G master

git cherry-pick G
# 在变基前的基础上做挑选
#                     A---B---C---G' topic
#                    /
#               D---E---F---G master

{% endhighlight %}


可以新建一个和主分支没有任何关联的**孤儿分支**，比如可以拿来放文档，或者存放一些页面，比如 Github Pages 功能就是用的 gh-pages 孤儿分支。

{% highlight bash linedivs %}
git checkout --orphan gh-pages # 创建孤儿分支 gh-pages，并切换到分支上
{% endhighlight %}

## 提交 git commit

{% highlight bash linedivs %}
git add [path-to-file] # 将文件加入暂存区
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
git diff [path-to-file] # 显示工作目录和暂存区的差异
git diff [commit-id] [path-to-file] # 显示工作目录和指定提交的差异
git diff HEAD [path-to-file] # 显示工作目录和当前分支的最新提交记录的差异
git diff --cached [commit-id] [path-to-file] # 显示暂存区和指定提交的差异
git diff --staged HEAD [path-to-file] # 显示暂存区和当前分支的最新提交记录的差异，staged 和 cached 效果一样
{% endhighlight %}

![Git diff](/assets/img/post/git-diff.png "git diff")


### 删除 git rm

`.gitignore` 文件会忽略未追踪的文件和文件夹，对已经加入追踪的文件则不起作用，需要取消已经加入追踪的文件要用 `git rm`。

`git rm` 用于从暂存区和 Git 工作目录中删除文件，类似于 `git add` 的逆操作。加入 `--cached` 参数则只删除暂存区的文件，保留工作目录文件不动。

下面的操作不会删除本地工作目录的文件，但是推送到远端后其他开发人员 `git pull` 会删除他们本地工作目录的相应文件。

{% highlight bash linedivs %}
# 1. 将要取消追踪的文件或文件夹加入 .gitignore 文件

# 2. 删除单个文件或文件夹
git rm --cached [file-name]
git rm --cached -r [dir-name]

# 3. 提交变更
git commit -m [commit-message]
{% endhighlight %}


### 暂存 git stash

保存未提交变更到本地堆栈中，一般用于中断本地开发临时切换到其他分支，后续切换分支回来再恢复变更继续开发。

{% highlight bash linedivs %}
git stash # 保存变更到本地堆栈中
git stash save [message] # 保存变更到堆栈并记录标记信息
git stash list # 列出保存的记录
git stash pop # 恢复最近一次入栈记录内容
{% endhighlight %}

放弃修改，从某次提交中恢复历史版本

{% highlight bash linedivs %}
git checkout [commit-id] -- [path-to-file1] [path-to-file2]
{% endhighlight %}

如果只想暂存指定文件有两种办法

{% highlight bash linedivs %}
# 用 git stash push
git stash push -m [message] path/to/file

# 用交互方式确认哪些需要加入 stash
# 交互模式下会遍历文件询问是否需要加入 stash
git stash --patch
git stash -p # 效果同上
# Stash this hunk [y,n,q,a,d,j,J,g,/,e,?]?
# ? 显示帮助；y 暂存此改动；n 不暂存此改动；q 从此处退出，后续改动都未暂存；a 暂存此改动，后续改动都暂存；
{% endhighlight %}

### 标签 git tag

Git 有两种类型的标签，一个是轻量标签（lightweight tag，也叫 unannotated tag），一种是标注标签（annotated tag）,它们的区别就是标注标签加了一段注释信息，官方文档对这两个的用途解释如下。

> Annotated tags are meant for release while lightweight tags are meant for private or temporary object labels.

{% highlight bash linedivs %}
git tag -l # 列出当前所有标签
git tag [tag-name] [commit-id] # 把无标注标签打在指定的 commit 上
git tag [tag-name] [commit-id] -a -m [tag-annotation] # 把标注标签打在指定 commit 上，如果有多行标注就使用多个 -m， 或者不写 -m 会打开默认编辑器编辑
git tag -d [tag-name] # 删除指定标签
{% endhighlight %}


默认情况下，git push 命令并不会传送标签到远端仓库服务器上。 在创建完标签后你必须显式地推送标签到共享服务器上。

{% highlight bash linedivs %}
git push [remote-name] [tag-name] # 推送标签到远端服务器上
git push [remote-name] --tags # 把不在远端服务器上的标签都推到那里
{% endhighlight %}


### 日志 git log
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
git log --follow [path-to-file] # 显示某个文件的提交记录
git log -- [path-to-file] # 显示某个文件的提交记录，为避免文件名和分支名等重名，任何在 -- 后的字符串都将被当作文件名，在其之前的选项被当作分支名或者其他选项。
git log --grep="feat:" # 在提交记录中搜索关键词
git log --no-merges # 不显示合并的提交记录
git log --merges # 只显示合并的提交记录
git log --format=fuller # 显示提交记录的 author 和 committer
git log --patch # 显示提交内文件变化的具体内容
git log --stat # 显示提交的文件及变化统计数据

git show [commit-id] # 显示某个提交的具体内容
{% endhighlight %}


### 撤销提交 git reset

官网这篇[7.7 Git 工具 - 重置揭密](https://git-scm.com/book/zh/v2/Git-%E5%B7%A5%E5%85%B7-%E9%87%8D%E7%BD%AE%E6%8F%AD%E5%AF%86)关于 reset 和 checkout 介绍很详细。

git reset 会根据不同的参数来重置不同的区域

1. 移动 HEAD 分支到指定的 commit（若指定了参数 --soft，则到此停止）
2. 将指定的 commit 恢复到暂存区（若指定了参数 --mixed，则到此停止，也是 git reset 的默认参数）
3. 将指定的 commit 恢复到工作目录（若指定了参数 --hard，就一直执行到这第 3 步）

若 reset 命令中指定了路径，会跳过上面第一步，直接恢复指定的文件或者目录。

`git reset --hard [branch]` 和 `git checkout [branch]` 非常类似，有两点不同，第一是 checkout 对工作目录会更安全些，第二是 reset 是移动 HEAD 所指向分支的指向，而 checkout 是移动 HEAD 指向的分支。

{% highlight bash linedivs %}
         HEAD    HEAD                    HEAD
           |       |                       | 
           V       V                       V 
master    dev    master    dev    master  dev
  |        |       |        |       |    /     
  V        V       V        V       V  /      
  C1 <--- C2       C1 <--- C2       C1 <--- C2 
   初始状态         checkout 后       reset 后  
{% endhighlight %}


下面的表格整理出来各命令的相关影响区域。“HEAD” 一列中的 “REF” 表示该命令移动了 HEAD 指向的分支引用，而 “HEAD” 则表示只移动了 HEAD 自身。

|                             | HEAD  | Index | WordDir | WD Safe? |
| :-------------------------- | :---: | :---: | :-----: | :------: |
| **Commit Level**            |       |       |         |          |
| `reset --soft [commit]`     |  REF  |  No   |   No    |   Yes    |
| `reset [commit]`            |  REF  |  Yes  |   No    |   Yes    |
| `reset --hard [commit]`     |  REF  |  Yes  |   Yes   |    No    |
| `checkout [commit]`         | HEAD  |  Yes  |   Yes   |   Yes    |
| **Commit Level**            |       |       |         |          |
| `reset [commit] <paths>`    |  No   |  Yes  |   No    |   Yes    |
| `checkout [commit] <paths>` |  No   |  Yes  |   Yes   |    No    |

{% highlight bash linedivs %}
git reset [commit-id] # 撤销所有 [commit] 后的的提交，在本地保存更改
git reset --hard [commit-id] # 放弃所有历史，改回指定提交。
{% endhighlight %}

取消提交到暂存区的变更，不改变工作目录的变更

{% highlight bash linedivs %}
git reset HEAD -- [path-to-file] # 取消暂存区某个文件的变更
git reset HEAD -- . # 取消当前文件夹下在暂存区的所有变更
{% endhighlight %}


## 其他命令

### 底层命令

Git 命令主要分为上层（瓷器 porcelain）命令和底层（管道 plumbing）命令。日常中使用较多的是上层命令，上层命令最早是通过脚本将底层命令拼接使用的。
底层命令会更稳定一些。

获取命令的帮助文档。

{% highlight bash linedivs %}
git help [command]
{% endhighlight %}

获取 git 版本号。

{% highlight bash linedivs %}
git version
{% endhighlight %}

Git 提供了一个 ```git show``` 命令来查看任意类型的对象，可以是某个提交的具体的信息及变更内容，或者是标签的具体信息，还可以用来显示目录（tree 对象）和文件内容（blob 对象）。

{% highlight bash linedivs %}
git show HEAD^^ # 查看当前提交往前数第二次提交的具体信息和内容
git show v0.1 # 查看标签
git show [tag-name]:src/rand.c # 查看指定标签版本下的文件内容
git show [commit-id]:src # 查看指定提交下的目录内容
{% endhighlight %}

查看引用的全名，包含 .git/refs 文件夹下的内容，本地和远端的 refs 以及 tags。

{% highlight bash linedivs %}
git show-ref
{% endhighlight %}

查看 git 对象命令。

{% highlight bash linedivs %}
git cat-file -p [git-hash-id] # 打印 git 对象内容
git cat-file -t [git-hash-id] # 显示 git 对象类型
{% endhighlight %}

[查看文件的 git hash 值](https://stackoverflow.com/questions/460297/git-finding-the-sha1-of-an-individual-file-in-the-index)

{% highlight bash linedivs %}
# git 对文件做的 hash 值不完全等于文件的 SHA1 值
# 假设 ${file} 变量指向我们操作的文件

# get the Git hash of the file in index
# -s show file mode, hash and stage number
git ls-files -s $file

# get the Git hash of any file on your filesystem
git hash-object $file

# get the Git hash of any file on your filesystem and you don't have Git installed
(echo -ne "blob `wc -c < $file`\0"; cat $file) | sha1sum
# 此处就展示出了 git 的 hash 值是怎么计算出来的，主要是对 "blob SIZE\0CONTENT" 做的 sha1 sum
# 其中 SIZE 是文件的 file size in bytes，CONTENT 是文件实际内容

{% endhighlight %}

### 父引用的快捷写法

在修订名后面紧接着输入 ^ 符号表示该修订的第一个父对象。例如，HEAD^ 代表 HEAD 的父对象（节点），即上一个提交。对于合并提交来说，会拥有多个父对象，为了查询多个父对象中的某一个，你需要在 ^ 字符后指定它的数字代号，使用 ```^<n>``` 意味着查看修订的第 n 个父对象。我们可以将 ^ 理解为 ^1 的快捷方式。

一个比较特殊的情况是，```^0``` 指代的是该提交自身。它还可以用来获取提交中包含附注（签名）的标签指针，```git show v0.9``` 会显示标签标注信息和提交的相关信息，而 ```git show v0.9^0``` 只会显示标签附着的提交的相关信息。

这种后缀语法还可以组合使用。用户可以使用 HEAD^^ 来指向 HEAD 的祖父对象，即 HEAD^ 的父对象。

除了输入 n 个 ^ 后缀，例如 ^^…^ 或 ^1^1…^1，用户还可以使用 ```~<n>```。这样 ~ 和 ~1 是等价的，HEAD~ 和 HEAD^ 也是等价的。HEAD~2 代表其第一个父对象的第一个父对象，即祖父对象，和 HEAD^^ 是等价的。


### 引用日志 git reflog
每次更新 HEAD 或者更新分支首部时，git 会将这些信息记录在引用日志（reflog）中，这是以一种本地的临时日志，命令 ```git reflog``` 的输出中会用 HEAD@{n} 来表示 HEAD 之前的第 n 个值。

如果是用分支名，如 master@{n}，它代表的是该分支之前的第 n 个值，@{n} 是个特例，它表示当前分支之前的第 n 个值。


## Git 原理简介

Git 是一个内容寻址文件系统。一个 git 对象对应一个 40 位的散列值。

> Git is a content-addressable filesystem. 

> It means that at the core of Git is a simple key-value data store. 

{% highlight bash linedivs %}
# 用 hash-object 生成 'test content' 的散列值
$ echo 'test content' | git hash-object -w --stdin
d670460b4b4aece5915caf5c68d12f560a9fe3e4

# 从散列值中检索出内容
$ git cat-file -p d670460b4b4aece5915caf5c68d12f560a9fe3e4
test content
{% endhighlight %}

StackOverflow 上有关于 40 位散列值碰撞的[讨论](https://stackoverflow.com/questions/10434326/hash-collision-in-git)。

> 40 位 16 进制的散列值有 160 bits，大约 10<sup>48</sup> 个值，一个月球上大约有 10<sup>47</sup> 个原子，这样 40 位散列值大致可以表示 10 个月球的原子。

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

还有另一种状态，在使用 ```git add``` 命令后 git 会对其索引（index），存储将要提交信息的暂存区，索引是预期的下一次提交。这样上面的已修改文件和未跟踪文件都要再区分下是否已进入暂存区。

![Git index](/assets/img/post/git-index.png "git index")

## 实战操作

这部分内容就是应用上面介绍的基础知识应用到具体的操作上，里面的内容主要来自 Stackoverflow 网友的回答。

### 如何把一些提交从一个 Git 仓库拷贝到另一个 Git 仓库中

[How to copy commits from one Git repo to another?](https://stackoverflow.com/questions/37471740/how-to-copy-commits-from-one-git-repo-to-another)

在新仓库中添加远程仓库的地址，然后挑选出远程仓库需要的提交在新仓库中重播，步骤代码如下

{% highlight bash linedivs %}
# add the old repo as a remote repository 
git remote add oldrepo https://github.com/path/to/oldrepo

# get the old repo commits
git remote update

# examine the whole tree
git log --all --oneline --graph --decorate

# copy (cherry-pick) the commits from the old repo into your new local one
git cherry-pick sha-of-commit-one
git cherry-pick sha-of-commit-two
git cherry-pick sha-of-commit-three

# check your local repo is correct
git log

# remove the now-unneeded reference to oldrepo
git remote remove oldrepo
{% endhighlight %}

### 如何合并提交
[How can I merge two commits into one if I already started rebase?](https://stackoverflow.com/questions/2563632/how-can-i-merge-two-commits-into-one-if-i-already-started-rebase)

[squashing commits with rebase](https://gitready.com/advanced/2009/02/10/squashing-commits-with-rebase.html)

假设 git 的历史如下，c 是最近一次提交，a 是较早的一次提交，我们想把 b 和 c 合并成一个提交，最后只留下 a 和 bc 两个提交。

{% highlight bash linedivs %}
git log -n 3 --pretty=oneline
b64ec63ade24acf985972549e9a6e756a887cd13 c
e993be87563a6f7b23251d56df0410e38c530e4e b
b109737d9e52538129fb50b3263bae594120c008 a
{% endhighlight %}

可以使用 rebase 的交互模式（`--interactive` 或者 `-i`），`git rebase --interactive HEAD~2` 会进入如下编辑模式，里面包含了很清晰的解释，注意此处提交的顺序和上面不同，是最早的提交记录在上面。

{% highlight bash linedivs %}
pick e993be8 b
pick b64ec63 c

# Rebase b109737..b64ec63 onto b109737 (2 commands)
#
# Commands:
# p, pick <commit> = use commit
# r, reword <commit> = use commit, but edit the commit message
# e, edit <commit> = use commit, but stop for amending
# s, squash <commit> = use commit, but meld into previous commit
# f, fixup <commit> = like "squash", but discard this commit's log message
# x, exec <command> = run command (the rest of the line) using shell
# b, break = stop here (continue rebase later with 'git rebase --continue')
# d, drop <commit> = remove commit
# l, label <label> = label current HEAD with a name
# t, reset <label> = reset HEAD to a label
# m, merge [-C <commit> | -c <commit>] <label> [# <oneline>]
# .       create a merge commit using the original merge commit's
# .       message (or the oneline, if no original merge commit was
# .       specified). Use -c <commit> to reword the commit message.
#
# These lines can be re-ordered; they are executed from top to bottom.
#
# If you remove a line here THAT COMMIT WILL BE LOST.
#
# However, if you remove everything, the rebase will be aborted.
#
{% endhighlight %}

把上面第二行的提交 c 前面的 `pick` 改成 `squash`，也即把新的提交压入上一次提交中，"squashing upward"。

{% highlight bash linedivs %}
pick e993be8 b
squash b64ec63 c
{% endhighlight %}

修改如上，保存后会进入合并提交消息的编辑窗口，修改后保存即可。

### 如何在仓库中删除某位作者的所有提交
[Remove all commits by author](https://stackoverflow.com/questions/39232800/remove-all-commits-by-author)

基本思想是挑选出需要的提交，在新的分支上重播一遍。

{% highlight bash linedivs %}
# 从某个节点开始创建新分支
git checkout -b <branch-name> <base-commit>

# 从 master 分支中挑选出提交并在当前分支上重播
# --author "<name>" 过滤出作者，如果过滤 committer 用参数 --committer
# --invert-grep 反选上面的筛选结果，在此处即选出非指定作者的提交
# --reverse 结果用逆向排序，即满足条件的最早提交在第一行
# --format="format:%H" 指定只显示 commit hash 值
git log --author "<name>" --invert-grep --reverse --format="format:%H" HEAD..master | xargs git cherry-pick
{% endhighlight %}


## 参考链接
[Pro Git](https://git-scm.com/book/zh/v2)

[Git Reference](https://git-scm.com/docs)

[10 Years of Git: An Interview with Git Creator Linus Torvalds](https://www.linuxfoundation.org/blog/10-years-of-git-an-interview-with-git-creator-linus-torvalds/)

[Git for Computer Scientists](https://eagain.net/articles/git-for-computer-scientists/)

[A collection of .gitignore templates](https://github.com/github/gitignore)

[How can I reset or revert a file to a specific revision?](https://stackoverflow.com/questions/215718/how-can-i-reset-or-revert-a-file-to-a-specific-revision)

[Pretty Git branch graphs](https://stackoverflow.com/questions/1057564/pretty-git-branch-graphs)

[【冷知識】斷頭（detached HEAD）是怎麼一回事？](https://gitbook.tw/chapters/faq/detached-head)

[另一種合併方式（使用 rebase）](https://gitbook.tw/chapters/branch/merge-with-rebase)

[How can I make Git "forget" about a file that was tracked, but is now in .gitignore?](https://stackoverflow.com/questions/1274057/how-can-i-make-git-forget-about-a-file-that-was-tracked-but-is-now-in-gitign)