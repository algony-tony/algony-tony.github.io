---
layout: post
title: Git 分支使用策略
categories: 软件技术
tags: git
---
本文介绍一种 git-flow 的分支策略模型，主要参考下文。

## 中心库

Git 是分布式的，每个开发者的本地库都是一份完整的代码副本，这里说的中心库指的概念上的中心库，根据 git 里通常把这个库叫做 origin。
每个开发都会从中心库推送和拉取代码，对于一些较大的开发项目，如果不想提前推送到中心库上，开发之间也会互相推拉代码。

## 主分支

中心库一般会有如下两个长期分支

* master
* develop

在 origin/master 分支上的是生产环境的的发布代码，HEAD 指向的是生产环境最新的代码，
origin/develop 是开发分支，HEAD 指向的是为下一个发布版本做的最新交付的代码，
开发分支也叫做集成分支（integration branch）,这是个会做自动 build 的分支。

当 develop 分支上的代码到达一种稳定状态，并为发布做好准备，就可以把开发分支上的所有变化合并进 master 分支，
并且会被打上标签和发布的版本号，具体操作会在下面进一步介绍。

这样每次代码被合并进 master 分支，生产环境就会做一次版本发布。对合并主分支的操作要谨慎，
对于 master 一般会设置 git 钩子，在有提交代码到这个分支上时，会做自动会构建和自动化部署到生产环境中。

![main branches](/assets/img/post/git-main-branches.png "main branches")


## 支持分支

除了上面的两个主要长期分支，还有一些有一定时效性和特定功能的支持分支，可以支持对于功能和特性的并行开发，
支持对版本发布的支持，对生产环境一些紧急缺陷的修复，主要是下面三种分支。

* 特性分支 Feature branches
* 发布分支 Release branches
* 紧急修复分支 Hotfix branches

这些分支都有一些特定的用途，而且对于分支从哪种分支分叉出来，最终又要合并进哪种分支里都有严格的规则。
这三种分支从技术上看没有什么不同的，它们的区别在于我们对其使用上的约束。


### 特性分支 Feature branches

特性分支可以从 develop 中分叉出来，最终必须合并进 develop 分支中，分支名可以用除了 master, develop, release-* 或者 hotfix-* 外的有意义的名称。

特性分支（也叫做 topic branches）主要用作开发新功能，新特性，或者是较远版本上的开发。
在做新功能的分支开发时，开发人员可能并不知道此功能最终会被合并进哪个版本里。
特性分支的本质上就是为这个特性的开发而存在的，最终会合并回 develop 里，将该特性加入到未来的某个版本中。
如果实验性特性分支的开发失败，这种特性分支会被丢弃，不再使用。

特性分支一般只存在于开发人员的版本库中，不会推送到中心库 origin 中。

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
这样如果后期有需要查看这整个特性的的相关信息也能方便查看，或者有撤销整个特性分支的需要也能方便知道需要撤销哪些提交。


### 发布分支 Release branches

发布分支可以从 develop 中分叉出来，最终必须合并进 develop 和 master 分支中，分支名命名规则 release-*。

发布分支是用来为生产环境的发布做准备的，有的项目是用 UAT 环境做准备。
发布分支用作发布前最后一次的检查。如果有发现小 bug 这时候也是修复后直接提交在 release 分支上，最终会分别合并进 develop 和 master 里。
发布分支还要准备发布的元数据（包含发布的版本号，构建日期等）。
在代码进入发布分支后，develop 就准备好了为后面版本的发布接收新特性推送，这样和发布分支的准备工作是并行进行的。

当下一个版本需要的特性都开发完成，合并进了 develop 分支中，就可以从 develop 分叉出 release 分支了，
后期发版的新特性必须等到分叉出发布分支后才能再提交到开发分支上。

只有在分叉出 release 分支的时候才定下了版本号，在次之前，develop 分支都只知道是为下一次发版做准备，至于下一次发版是 0.3 还是 1.0 并不确定。版本号的命名规则可以参考这篇 [语义化版本 2.0.0](https://semver.org/lang/zh-CN/)，主要原则如下

> 语义化版本 2.0.0 摘要
> 
> 版本格式：主版本号.次版本号.修订号，版本号递增规则如下：
> 
> * 主版本号：当你做了不兼容的 API 修改，
> * 次版本号：当你做了向下兼容的功能性新增，
> * 修订号：当你做了向下兼容的问题修正。
> 
> 先行版本号及版本编译信息可以加到“主版本号.次版本号.修订号”的后面，作为延伸。

{% highlight bash linedivs %}
# 1. 从 develop 创建发布分支，假定原版本号是1.1.5，根据这次变更内容定出版本号 1.2
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

# 6. 删除发布分支
git branch -d release-1.2

{% endhighlight %}


### 紧急修复分支 Hotfix branches


### 参考
[A successful Git branching model](https://nvie.com/posts/a-successful-git-branching-model/)