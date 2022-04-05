---
layout: post
title: Spark 使用手册
excerpt: 介绍 Spark 使用中的基本命令和基本概念
categories: 软件技术
tags: Spark Hadoop
---

Spark [官网](https://spark.apache.org/)上的介绍：大规模数据分析的统一引擎，能在单节点或者集群上做数据工程，数据科学和机器学习的多语言引擎。

Spark 由五个主要模块组成：
* Spark Core：调度和分派任务以及协调 I/O 操作的底层执行引擎；
* Spark SQL：收集有关结构化数据的信息，使用户能够优化结构化数据处理；
* Spark Streaming 和 Structured Streaming：两者都是流处理。 Spark Streaming 从不同的流式数据源中获取数据并将其划分为微批次形式以形成连续流。 Structured Streaming 是基于 Spark SQL 构建的结构化流式处理，可减少延迟和简化编程；
* MLlib（机器学习库）：一组可扩展的机器学习算法库，还包含用于特征选择和构建 ML 管道的工具。MLlib 中跨语言主要 API 是 DataFrames；
* GraphX： 支持交互式构建、修改和分析可扩展的图形结构数据的计算引擎；

## Spark 基本使用

RDD 操作分为行动 **Action** 和转换 **transformation** 两类。转换操作输入 RDD 返回 RDD，行动操作输入 RDD 返回非 RDD，RDD 采用的是惰性计算，真正的运算发生在碰到行动操作时，
在次之前的转换操作 Spark 只是记录下基础数据集及 RDD 的生成轨迹，即相互之间的依赖关系，而不会触发真正的计算。RDD 中的依赖关系分为窄依赖（Narrow Dependency）和宽依赖（Wide Dependency）,
区分在于是否包含 shuffle，shuffle 过程涉及数据的重新分发，会产生大量的磁盘 I/O 和网络开销。

一个转换操作就是一个 fork/join 的过程，（将分区数据 fork 到不同的节点上，计算结束后再 join 到相应分区上），Spark 会把多个转换操作合并 fork/join 过程，称为流水线优化。

### RDD Transformation

* filter(func)：筛选出满足 func 的元素，并返回一个新的数据集；
* map(func)：将每个元素传递到 func 中，并将结果返回一个新的数据集；
* flatmap(func)：和 map 函数类似，但每个输入元素都可以映射到 0 个或多个输出结果；
* groupByKey()：应用于 (K, V) 键值对的数据集时，返回一个新的 (K, Iterable) 形式的键值对；
* reduceByKey(func)：应用于 (K, V) 键值对的数据集时，返回新的 (K, V) 形式的数据集，其中每个值是将每个 key 传递到 func 中进行聚合后的结果；

### RDD Action

* count()：返回数据集中元素的个数；
* collect()：以数组的形式返回数据集中的所有元素；
* first()：返回数据集中的首个元素；
* take(n)：以数组的形式返回数据集中的前 n 个元素；
* reduce(func)：通过函数 func（两个输入一个输出） 聚合数据集中的元素；
* foreach(func)：将数据集中的每个元素传递到函数 func 中运行；

### RDD 其他操作

rdd.persist()：将 RDD 标记为持久化，不会马上计算生成 RDD 持久化，而是等到 action 触发计算把计算结果进行持久化。
persist(MEMORY_ONLY)：表示将RDD作为反序列化的对象存储于JVM中，如果内存不足，就要按照LRU原则替换缓存中的内容；
persist(MEMORY_AND_DISK)：表示将RDD作为反序列化的对象存储在JVM中，如果内存不足，超出的分区将会被存放在磁盘上。

rdd.cache() 等价于 rdd.persist(MEMORY_ONLY)

调用 unpersist() 将持久化的 RDD 从内存中释放。

## Spark 基本概念

用户编写的一个 Spark 程序就是一个 **Application**，main 函数的入口，当程序中触发了一个 action 则生成一个 **job**，job 再根据 shuffle 的边界划分成不同的 **stage**，
每一个 stage 再根据 RDD 上的分区数分割成 Spark 上工作的最小单元 **task**。



* RDD：Resilient Distributed Dataset，分布式弹性数据集，RDD 是不可变对象集合。

### 参考

[What is the concept of application, job, stage and task in spark?](https://stackoverflow.com/questions/42263270/what-is-the-concept-of-application-job-stage-and-task-in-spark)