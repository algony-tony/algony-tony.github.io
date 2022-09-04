---
layout: post
title: Cloudera CDP 产品简介 
categories: 软件技术
tags: CDH CDP Cloudera
---

## CDP 产品背景
Cloudera 成立于 2008 年，主要产品为国内广为熟知的 Hadoop 发行版 CDH（Cloudera's Distribution Including Apache Hadoop），包含广泛的 Hadoop 生态组件，稳定且易用，在 CDH 6 之前一直有提供免费版下载。Cloudera 还开发并贡献了交互式数据分析引擎 Impala。Hortonworks 成立于 2011年，提供的发行版是 HDP（Hortonworks Data Platform），Hortonworks 数据平台旨在处理来自各种来源和格式的数据。2018 年 10 月两家公司宣布合并，Cloudera 股东拥有合并后公司 60% 股份，Hortonworks 股东占 40%。

Cloudera 首席执行 Tom Reilly 表示：两家公司的业务具有高度的互补性和战略性。通过将 Hortonworks 在端到端数据管理方面的优势与 Cloudera 在数据仓库和机器学习方面的优势结合起来，有望提供从边缘到 AI 的企业数据云。

CDP（Cloudera Data Platform）就是两个公司合并后提出的产品。

![CDP 各组件版本比较](/assets/img/post/cdp-component-version1.png 'CDP 各组件版本比较')

![CDP 各组件版本比较](/assets/img/post/cdp-component-version2.png 'CDP 各组件版本比较')

## CDP 的主要技术优势

> Cloudera 在 Hadoop 基础架构下发展出的商业版 CDH，是第一代架构的代表，主要关注在本地部署云上集中同位的存储和计算以及大型共享集群；Cloudera 认为的第二代架构，主要关注在公有云上的存储与计算解耦和多集群，例如 Amazon EMR；Cloudera 目前提出的平台方案 CDP 被认为是第三代架构，主要关注在多云以及混合云上的存储与计算解耦，多租户以及容器化的 SaaS 体验。

![CDP 的主要技术优势](/assets/img/post/cdp-advantage.png 'CDP 的主要技术优势')

## 存储计算分离

![CDP 私有云架构](/assets/img/post/cdp私有云架构.png 'CDP 私有云架构')

存储集群和计算集群分离，一方面存储集群可以考虑用 Ozone 代替 HDFS 以解决文件数量限制的弱点，另一方面计算集群可以用容器化部署实现快速搭建和销毁，弹性扩展和收缩。
由于存储与计算的分离，可以实现存储与计算集群一对一，一对多或者多对多的组合。


> * CDP BASE CLUSETER，主要当做存储集群来使用，当不使用其计算能力时，甚至可以不安装 impala/hs2/spark 等计算引擎；
> * ECS 或 OCP，主要当做计算集群来使用，可以不安装也可以安装多个，当不使用其存储能力时，可以不安装 hdfs/ozone 等存储引擎；
> * ECS 或 OCP，对应不同的使用场景，可以安装多个集群，比如对应数仓场景的 CDW（cloudera datawarehouse, 其底层主要是 hs2，impala，hue），对应机器学习的 CML (cloudera machile learning，其底层主要是 python/r/scala 的 jupiter notebook）,对应数据工程的 CDE（cloudera data engineering，其底层主要是 spark，airflow）
> * 当然在复杂的场景下，CDP BASE CLUSETER 和 ECS/OCP，也可以是多对多的关系：


> Ozone 是 Cloudera 在 2019 年创建并引入的一个 Hadoop 子项目，是一个开源的对象存储项目。引入 Ozone 是为了能够彻底解决 HDFS 文件数量的限制的弱点。目前很多企业用户在部署大规模集群的时候，都需要使用 HDFS 联邦，而 HDFS 联邦在实际应用中也存在各种问题，并不是最佳的解决方案，随着集群规模不断的增长，局限性也越发的明显。

> 结合 CDP 存储跟计算分离的概念，Cloudera 将 Ozone 定位为私有云的数据存储引擎。

## 资源隔离和多租户管理

![实现资源隔离和多租户管理](/assets/img/post/资源隔离和多租户管理.png '实现资源隔离和多租户管理')

私有云可以实现三级分离。比如有一个多部门的使用场景，可以建一个统一的资源池接管所有的集群资源，在这一个资源池上可以建很多个环境，每个环境对应一个业务部门，
每个环境里可以争对不同的应用拉起不同的计算集群，计算集群是通过容器部署的，容器可以指定内存和 CPU 资源，弹性扩展和收缩灵活。CDP 有很多种手段实现对资源的管控。


## Ozone

Ozone 是一种对象存储，相比于 HDFS 有 20 倍扩展的提升，密度可以更高，原来 HDFS 一台机器不能挂太多的存储，建议不超过 100 T，Ozone 官方配置一台机器可以挂 400 T 的存储。

## 支持细粒度升级

一般存储集群的组件升级较慢，计算集群升级会更频繁，现在计算集群容器部署，这样只要更新镜像的版本就可以达到升级计算引擎的目的，在同一套资源里划分出测试，UAT 和生产的计算资源环境实现逐步测试发布。

## 参考链接

[CDP文档](https://www.yuque.com/aliyunbigdata/xdgumz)

[【阿里云 CDP 公开课】 第一讲：CDP 产品介绍](https://developer.aliyun.com/article/815041)

[从大数据平台CDP的架构看大数据的发展趋势](https://www.cnblogs.com/tgzhu/p/15904758.html)

[初探未来十年，Cloudera 对待数据的全新方式](https://www.infoq.cn/article/mcccdxidkwrtp3sqtept)

[从大数据平台CDP的架构看大数据的发展趋势](https://mp.weixin.qq.com/s/0giCdtvpaxgk2OI1Fp-_tw)

[线上会议精彩回顾 - Cloudera Sessions China 2021](https://blog.csdn.net/MichaelLi916/article/details/121551379)

[Cloudera Sessions China 2021](https://www.itdks.com/Home/Course/detail?id=118504)

[CDH在云上利用文件存储HDFS实现存储计算分离](https://developer.aliyun.com/article/724611)