---
layout: post
title: Cloudera CDP 产品简介 
categories: 软件技术
tags: 大数据 CDH CDP Cloudera
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

存储集群和计算集群分离，一方面存储集群可以考虑用 Ozone 代替 HDFS 以解决文件数量限制的弱点，另一方面计算集群可以用容器化部署实现弹性扩展和收缩。
由于存储与计算的分离，可以实现存储与计算集群一对一，一对多或者多对多的组合。


> * CDP BASE CLUSETER，主要当做存储集群来使用，当不使用其计算能力时，甚至可以不安装 impala/hs2/spark等计算引擎；
> * ECS 或 OCP，主要当做计算集群来使用，可以不安装也可以安装多个，当不使用其存储能力时，可以不安装 hdfs/ozone 等存储引擎；
> * ECS 或 OCP，对应不同的使用场景，可以安装多个集群，比如对应数仓场景的 CDW(cloudera datawarehouse, 其底层主要是hs2,impala,hue),对应机器学习的CML (cloudera machile learning,其底层主要是 python/r/scala 的jupiter notebook）,对应数据工程的 CDE(cloudera data engineering,其底层主要是 spark，airflow）
> * 当然在复杂的场景下，CDP BASE CLUSETER 和 ECS/OCP，也可以是多对多的关系：


> Ozone 是 Cloudera 在 2019 年创建并引入的一个 Hadoop 子项目，是一个开源的对象存储项目。引入 Ozone 是为了能够彻底解决 HDFS 文件数量的限制的弱点。目前很多企业用户在部署大规模集群的时候，都需要使用 HDFS 联邦，而 HDFS 联邦在实际应用中也存在各种问题，并不是最佳的解决方案，随着集群规模不断的增长，局限性也越发的明显。

> 结合 CDP 存储跟计算分离的概念，Cloudera 将 Ozone 定位为私有云的数据存储引擎。

## 参考链接

[CDP文档](https://www.yuque.com/aliyunbigdata/xdgumz)

[【阿里云 CDP 公开课】 第一讲：CDP 产品介绍](https://developer.aliyun.com/article/815041)

[从大数据平台CDP的架构看大数据的发展趋势](https://www.cnblogs.com/tgzhu/p/15904758.html)

[初探未来十年，Cloudera 对待数据的全新方式](https://www.infoq.cn/article/mcccdxidkwrtp3sqtept)

[从大数据平台CDP的架构看大数据的发展趋势](https://mp.weixin.qq.com/s/0giCdtvpaxgk2OI1Fp-_tw)

[线上会议精彩回顾 - Cloudera Sessions China 2021](https://blog.csdn.net/MichaelLi916/article/details/121551379)

[Cloudera Sessions China 2021](https://www.itdks.com/Home/Course/detail?id=118504)

[CDH在云上利用文件存储HDFS实现存储计算分离](https://developer.aliyun.com/article/724611)