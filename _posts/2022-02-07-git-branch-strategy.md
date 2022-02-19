---
layout: post
title: Git 分支使用策略
excerpt: 介绍 git-flow 的分支策略模型。
image: /assets/img/post/Git-branching-model.png
categories: 软件技术
tags: git
---
本文介绍一种 git-flow 的分支策略模型，主要参考下文。

## 中心库

Git 是分布式的，每个开发者的本地库都是一份完整的代码副本，这里说的中心库指的概念上的中心库，一般用 origin 指代。
每个开发都会从中心库推送和拉取代码，对于一些较大的开发项目，如果不想提前推送到中心库上，开发者之间也会互相推拉代码。

## 主分支

中心库一般会有如下两个长期分支

* master
* develop

在 origin/master 分支上的是生产环境的已发布代码，HEAD 指向的是生产环境最新的代码版本，
origin/develop 是开发分支，HEAD 指向的是为下一个发布版本做准备的最新开发中代码，
开发分支也叫做集成分支（integration branch）,可以设置成自动 build 的分支。

当 develop 分支上的代码相对稳定，并为发布做好了准备，就可以把开发分支上的所有变化合并进 master 分支，
并且会被打上标签和发布的版本号，具体操作会在下面进一步介绍。

每次代码被合并进 master 分支，生产环境就会做一次版本发布。对主分支的合并操作要谨慎，
对于 master 一般会设置 git 钩子，在有提交代码到这个分支上时，会做自动化构建和自动化部署到生产环境中。

![main branches](/assets/img/post/git-main-branches.png "main branches")


## 支撑分支

除了上面的两个主要长期分支，还有一些有一定时效性和特定功能的支撑分支，可以支持对于功能和特性的并行开发，
或者专门做版本发布用，或者是对生产环境一些紧急缺陷的修复。支撑分支主要是下面三种分支。

* 特性分支 Feature branches
* 发版分支 Release branches
* 紧急修复分支 Hotfix branches

这些分支都有一些特定的用途，而且对于分支从哪种分支分叉出来，最终又要合并进哪种分支里都有严格的规则。
这三种分支从技术上看没有什么不同的，它们的区别在于我们对其使用上的约束。


### 特性分支 Feature branches

特性分支可以从 develop 中分叉出来，最终必须合并进 develop 分支中，分支名可以用除了 master, develop, release-* 或者 hotfix-* 外的有意义的名称。

特性分支（也叫做 topic branches）主要用作开发新功能，新特性，或者是较远版本上的开发。
在做新功能的分支开发时，开发人员可能并不知道此功能最终会被合并进哪个版本里。
特性分支的本质上就是为这个特性的开发而存在的，最终会合并回 develop 里，将该特性加入到未来的某个版本中。
如果实验性质的特性分支开发失败，这种特性分支会被丢弃，不再使用。

特性分支一般只存在于开发人员的本地版本库中，不会推送到中心库 origin 里。

![feature branches](/assets/img/post/git-feature-branches.png "feature branches")

{% highlight bash linedivs %}
# 1. 从 develop 中分叉创建一个 myfeature 分支
git checkout -b myfeature develop

# 2. 在 myfeature 分支中完成开发

# 3. 切换回 develop 分支
git checkout develop

# 4. 把 myfeature 分支合并进 develop 中，如果有冲突就解决冲突再合并
git merge --no-ff myfeature

# 5. 推送本地 develop 到中心库的 develop 上
git push origin develop

{% endhighlight %}

注意上面合并时使用的 ```--no-ff``` 参数，就是始终不用快进合并（fast-forward）,这样就不会丢失特性分支存在的信息，也不会丢失分支特性存在的起止点信息，
后期也能方便查看，或者有撤销整个特性分支的需要时也能直接知道需要撤销哪些提交。


### 发版分支 Release branches

发版分支可以从 develop 中分叉出来，最终必须合并进 develop 和 master 分支中，命名用 release-*。

发版分支是用来为生产环境的发布做准备的，有的项目是用 UAT 环境做准备。
发版分支用作发布前最后一次的检查。如果有发现小 bug 这时候也是修复后直接提交在 release 分支上，最终会分别合并进 develop 和 master 里。
发版分支还要准备发布的元数据（包含发布的版本号，构建日期等）。
在代码进入发版分支后，develop 就准备好了为后面版本接收新特性的推送，这样和发版分支的准备工作是并行进行的。

当下一个版本需要的特性都开发完成，合并进了 develop 分支中，就可以从 develop 分叉出 release 分支了，
后期发版的新特性必须等到分叉出发版分支后才能再提交到开发分支上。

只有在分叉出 release 分支的时候才定下了版本号，在此之前，develop 分支都只知道是为下一次发版做准备，至于下一次发版是 0.3 还是 1.0 并不确定。版本号的命名规则可以参考这篇 [语义化版本 2.0.0](https://semver.org/lang/zh-CN/)，主要原则如下。

> 语义化版本 2.0.0 
> 
> 摘要
> 
> 版本格式：主版本号.次版本号.修订号，版本号递增规则如下：
> 
> * 主版本号：当你做了不兼容的 API 修改，
> * 次版本号：当你做了向下兼容的功能性新增，
> * 修订号：当你做了向下兼容的问题修正。
> 
> 先行版本号及版本编译信息可以加到“主版本号.次版本号.修订号”的后面，作为延伸。

{% highlight bash linedivs %}
# 1. 从 develop 创建发版分支，假定原版本号是1.1.5，根据这次变更内容定出版本号 1.2
git checkout -b release-1.2 develop

# 2. 修改项目下的版本号文件，修复小 bug 都提交在 release 上
git commit -a -m "Bumped version number to 1.2"

# 3. 将 release 合并到 master
git checkout master
git merge --no-ff release-1.2

# 4. 在 master 上打上这次提交的标签，方便后期定位
git tag -a 1.2

# 5. 将 release 合并回 develop 分支，如果有冲突解决冲突后继续合并
git checkout develop
git merge --no-ff release-1.2

# 6. 删除发版分支
git branch -d release-1.2

{% endhighlight %}


### 紧急修复分支 Hotfix branches

紧急修复分支可以从 master 中分叉出来，最终必须合并进 develop 和 master 分支中，命名用 hotfix-*。

紧急修复分支很像发版分支，它们都是为了生产环境发版使用的，但是紧急修复分支不是提前计划好的，它是为了响应线上生产环境的缺陷而生成的分支。
当生产环境有一个紧急 bug 需要修复，就从生产环境 master 分支中有相应缺陷的标签分支中分叉出紧急修复分支。

这个分支的核心就是当有团队成员在做生产环境的紧急修复的同时，其他团队成员还是可以在 develop 分支上继续各自的开发。

![hotfix branches](/assets/img/post/git-hotfix-branches.png "hotfix branches")

{% highlight bash linedivs%}
# 1. 假设有重大缺陷的生产版本是 1.2，但是开发分支还不稳定，新建分支去解决生产环境这个 bug
git branch -b hotfix-1.2.1 master

# 2. 修复缺陷，别忘了修改版本号
git commit -a -m "Bumped version number to 1.2.1"

# 3. 将 hotfix 分支合并回生产环境，并打上新的生产环境版本标签
git checkout master
git merge --no-merge hotfix-1.2.1
git tag -a 1.2.1

# 4. 将 hotfix 分支合并回 develop 分支，这样后面再出现的版本都不会出现这个 bug
git checkout develop
git merge --no-merge hotfix-1.2.1

# 5. 删除分支
git branch -d hotfix-1.2.1

{% endhighlight %}

需要注意上面第 4 步，如果此时有一个 release 分支，就把 hotfix 分支合并回 release 就行，最终会通过 release 分支把这个修复代码合并回 develop。
如果 develop 分支上对这个修复也有很迫切的需求，等不及 release 分支发布后合并回 develop，那也可以把这个 hotfix 分支同时合并到 release 和 develop 分支中。


## Git 分支策略模型
下图是原博作者做的 Git 分支策略模型图。

![git branching model](/assets/img/post/Git-branching-model.png "git branching model")

### 参考
[A successful Git branching model](https://nvie.com/posts/a-successful-git-branching-model/)