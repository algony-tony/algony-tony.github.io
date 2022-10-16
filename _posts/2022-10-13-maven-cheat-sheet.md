---
layout: post
title: Maven 使用手册
categories: 软件技术
tags: Maven
toc: true
---

* TOC
{:toc}


如 Maven 官网介绍，Maven 是一个管理和理解软件项目的工具。Maven 是一个强大的工具，有着陡峭的学习曲线，它的创始人 J​​ason van Zyl 在 2002 年开始创建 Maven，后面开了个公司 Sonatype。
Maven 通常被理解为一个 "build tool"。

* 入门文档 [Maven by Example](https://books.sonatype.com/mvnex-book/reference/index.html) [(PDF, 2.7 MB)](/assets/file/mvnref-pdf.pdf) 
* 参考手册 [Maven: The Complete Reference](https://books.sonatype.com/mvnref-book/reference/index.html) [(PDF, 1.3 MB)](/assets/file/mvnref-pdf.pdf)。

Maven 采用**约定大于配置（Convention Over Configuration）**的原则，Maven 默认假设源代码都在 `${basedir}/src/main/java`，resources 都在 `${basedir}/src/main/resources`，测试在 `${basedir}/src/test`，项目默认构建 jar 文件，编译后的 bytecode 在 `${basedir}/target/classes`，创建的 jar 放在 `${basedir}/target`。不仅是文件目录，Maven 的核心插件也共享约定来编译打包构建分发等流程。

## 安装配置

Maven 安装后的目录很简洁，主要如下几个文件夹以及 LICENSE，NOTICE，README.txt 文件

* bin：包含 Linux 和 Windows 下的 `mvn` 命令以及它的 debug 模式命令 `mvnDebug`，`mvn` 脚本主要用来配置 Java 命令，准备 classpath 和相关的配置，最后执行 Java 命令；
* boot：只有 plexus-classworlds-<version>.jar 以及它的 license 文件，plexus-classworlds 是一个类加载器，相对于默认的 Java 类加载器，它提供更丰富的语法以方便配置，Maven 使用该框架加载自己的类库，[Plexus ClassWorlds](http://codehaus-plexus.github.io/plexus-classworlds/)；
* conf：配置文件目录，主要就是最重要的 settings.xml 文件，这个后面单独详细介绍；
* lib：包含 Maven 运行时需要的 Java 类库，包含 Maven 的各模块类库以及 Maven 依赖的三方类库；

Maven 默认把配置和代码仓库放在 ~/.m2 文件夹下，包含个人的 settings.xml 配置文件和 repository 文件夹。

Maven 的环境变量 `M2_HOME` 指向 Maven 的安装路径。`MAVEN_OPTS` 配置的参数传递给 `mvn` 脚本里的 Java 命令，比如配置内存大小 `-Xmx1024m -XX:MaxPermSize=512m`。

### Maven 配置

[配置 Maven](https://maven.apache.org/configure.html)

## POM

Maven 项目的核心是 pom.xml 文件，POM（Project Object Model） 是项目对象模型，最简单的一个 pom.xml 文件如下，前面都是固定内容，指定 xml 文档的内容，以及使用的 POM 模型的版本 4.0.0，最重要的是 groupId，artifactId，version，这三个元素构成了项目的唯一标识符，在 Maven 的世界里，任何的 jar，pom，war 都是基于这三个元素的坐标来定位的，还有 package 和 classifier 两个坐标属性，一般写作 groupId:artifactId:packaging:version。

* groupId: 定义了项目属于某个组，一般以组织机构的网站反序，如 com.google.foobar；
* artifactId: 给出了当前组下的唯一 ID；
* version: 版本号，1.0-SNAPSHOT 中 SNAPSHOT 是快照的意思，指的当前版本还在开发中，是不稳定版本；
* package: 定义了打包方式；
* classifier: 第五个坐标，很少被使用，

``` xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <groupId>org.example</groupId>
    <artifactId>MyProject</artifactId>
    <version>1.0-SNAPSHOT</version>
    <packaging>jar</packaging>
    <name>My Project</name>

</project>
```

### 依赖管理


## 插件

Maven 是使用基于插件的架构构建的，它的大部分功能都在插件中。[插件地址](https://maven.apache.org/plugins/)。

### 插件目标

执行插件目标的命令 `mvn archetype:generate`，其中 archetype 是插件的标识符，generate 是目标的标识符。Maven 插件就是由一个或多个目标组成的集合，
目标是一项特殊的任务，可以独立执行，也可以和其他目标一起构成一个大型构建（build）。在 Maven 中，目标是工作的一个基本单元，目标通过配置属性进行配置，这些属性可以定制化行为。

{% highlight bash linedivs %}
# 显示插件 exec 的所有目标，以及所有有效参数
mvn help:describe -Dplugin=exec -Dfull

# 解析项目依赖关系
mvn dependency:resolve

# 解析项目依赖树
mvn dependency:tree
{% endhighlight %}


### Maven 生命周期

[Maven 生命周期（Lifecycle）](https://maven.apache.org/guides/introduction/introduction-to-the-lifecycle.html)由阶段（phase）组成，生命周期由一个验证项目基本的完整性的阶段开始，由部署项目到生产环境的阶段结束。目前内置的有三个生命周期 default，site，clean。生命周期的阶段概念是有意模糊的，包含验证，测试和部署等，它们在不同的项目中可以指代不一样的事情，比如在一个 Java 包项目里 package 阶段生成一个 JAR 包，而一个 web 应用的项目在 package 阶段生成一个 WAR 包。

插件目标可以附加到生命周期中的某个阶段。Maven 顺着阶段移动，它会执行阶段中附加的插件目标，每个阶段都有零个到多个目标，

![Maven Lifecycle](/assets/img/post/maven-lifecycle.png)

## 参考链接

[Apache Maven](https://maven.apache.org/)

[Maven Best Practices](http://www.kyleblaney.com/maven-best-practices)

