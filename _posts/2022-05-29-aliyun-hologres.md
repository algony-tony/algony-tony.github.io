---
layout: post
title: 阿里云 Hologres 简介
categories: 软件技术
tags: aliyun Hologres PostgreSQL 数据仓库 OLAP HSAP
---

[Hologres 官方文档](https://help.aliyun.com/product/113622.html)

## Hologres 功能特性

官方文档给 Hologres 的定义是实时数仓，最早提出是作为 HSAP（Hybrid Serving/Analytical Processing）服务/分析一体化系统，
主要包含下面几个功能特点：

1. 作为 OLAP 和 Ad Hoc 使用的查询分析，Hologres 支持行存和列存表，MPP 架构，可以多维查询分析，也可以点查；
2. 实时数仓的能力；
3. 生态与可扩展性，标准SQL接口，兼容PostgreSQL 11协议；
4. 作为 PaaS 平台的优势；官网文档对比 MaxCompute 提到 Hologres 集群资源是独享集群，PaaS 模式，我感觉怎么更像是 SaaS :joy:。

Hologres 是 **Holo**graphic 和 Post**gres** 的组合词，意向做一个全息的兼容 Postgresql 的数据库，以解决 Lambda 架构中流批分离的设计随着数据量增大带来复杂度提升的问题。
从 Hologres 设计的初衷可以看到它对于 OLTP 类型数据库的功能特性支持弱，比如事务。

### 逻辑架构

下面是 Hologres 逻辑架构图，计算存储分离，计算层又分为负责接入服务的 FE，计算节点 HoloWorker 以及元数据服务三部分。Hologres 的节点在 K8s 上 ，出现故障会由 K8s 快速拉起新节点保证节点级别的可用性，HoloWorker 节点内部还有 Holo Master 来处理组件的异常以保证组件的可用性。
共享存储层在 Pangu 分布式文件系统上。

![Hologres 逻辑架构图](https://help-static-aliyun-doc.aliyuncs.com/assets/img/zh-CN/8226330561/p431174.png "Hologres 逻辑架构图")

### 存储计算架构

Hologres 的存储计算架构主要是下图的第三种，它既有第一种架构的分布式存储集群，方便横向扩展，计算节点也有第二种架构的由 Storage Engine 直接管理的分片数据，[SE 介绍文章](https://developer.aliyun.com/article/779284)。

![存储计算三种架构](https://help-static-aliyun-doc.aliyuncs.com/assets/img/zh-CN/8982742461/p386152.png "存储计算三种架构")

### Query 执行过程

Hologres 的计算引擎主要是自研的 HQE，PQE 是为了兼容 PG 的扩展组件的计算引擎，SQE 是无缝对接 MaxCompute(ODPS) 的执行引擎，[SQE 介绍文章](https://developer.aliyun.com/article/784755)。一个节点上的 query 执行过程如下，sql 经过接入成后分成两部分如下。

![Query 执行过程](https://help-static-aliyun-doc.aliyuncs.com/assets/img/zh-CN/3280384461/p386721.png "Hologres query 执行过程")


## 参考资料

[Alibaba Hologres: A Cloud-Native Service for Hybrid Serving/Analytical Processing(PDF, 914KB)](http://www.vldb.org/pvldb/vol13/p3272-jiang.pdf)

[阿里云-开发者社区-实时数仓Hologres](https://developer.aliyun.com/group/hologres)

[Hologres揭秘:深度解析高效率分布式查询引擎](https://developer.aliyun.com/article/784506)

[使用实践｜Hologres性能调优全方位解读](https://developer.aliyun.com/article/853578)

[Alibaba Hologres: A Cloud-Native Service for Hybrid Serving/Analytical Processing](https://zhuanlan.zhihu.com/p/449695265)

[《Alibaba Hologres: A Cloud-Native Service for Hybrid Serving/Analytical Processing 》论文导读](https://zhuanlan.zhihu.com/p/366276704)

[Hologres: A Cloud-Native Service for Hybrid Serving/Analytical Processing(YouTube)](https://www.youtube.com/watch?v=YttNq3ixxtQ)

[云原生HSAP产品Hologres原理论文解读](https://zhuanlan.zhihu.com/p/360750135)