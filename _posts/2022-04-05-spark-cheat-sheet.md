---
layout: post
title: Spark 使用手册
excerpt: 介绍 Spark 使用中的基本命令和基本概念
categories: 软件技术
tags: Spark Hadoop
toc: true
---

* TOC
{:toc}

Spark [官网](https://spark.apache.org/)上的介绍：大规模数据分析的统一引擎，能在单节点或者集群上做数据工程，数据科学和机器学习的多语言引擎。

Spark 由五个主要模块组成：
* **Spark Core**：调度和分派任务以及协调 I/O 操作的底层执行引擎；
* **Spark SQL**：收集有关结构化数据的信息，使用户能够优化结构化数据处理；
* **Spark Streaming** 和 **Structured Streaming**：两者都是流处理。 Spark Streaming 从不同的流式数据源中获取数据并将其划分为微批次形式以形成连续流。 Structured Streaming 是基于 Spark SQL 构建的结构化流式处理，可减少延迟和简化编程；
* **MLlib**（机器学习库）：一组可扩展的机器学习算法库，还包含用于特征选择和构建 ML 管道的工具。MLlib 中跨语言主要 API 是 DataFrames；
* **GraphX**： 支持交互式构建、修改和分析可扩展的图形结构数据的计算引擎；

## SparkSession

`SparkSession` 是 Spark 在 2.0 之后引入的统一入口，之前是 `SparkContext`，`SQLContext`，`HiveContext` 等，`SparkSession` 内部会创建 `SparkConfig` 和 `SparkContext`，
通过设置 `val sc = spark.sparkContext` 可以继续使用 `SparkContext`。一个应用内也可以创建多个 `SparkSession`，如下。

{% highlight scala linedivs %}
import org.apache.spark.sql.SparkSession

val spark:SparkSession = SparkSession
  .builder()
  .appName("HelloWorld")
  .master("local[3]")
  .config("spark.serializer", "org.apache.spark.serializer.KryoSerializer")
  .enableHiveSupport()
  .getOrCreate()

// 可以比较 print(spark2) 和 print(spark) 发现是一样的
val spark2 = SparkSession
  .builder
  .getOrCreate

// spark3 是新的 SparkSession
val spark3 = spark.newSession

{% endhighlight %}

## RDD 编程

RDD 操作分为行动 **Action** 和转换 **Transformation** 两类。转换操作输入 RDD 返回 RDD，行动操作输入 RDD 返回非 RDD，RDD 采用的是惰性计算，真正的运算发生在碰到行动操作时，
在次之前的转换操作 Spark 只是记录下基础数据集及 RDD 的生成轨迹，即相互之间的血缘关系（lineage），而不会触发真正的计算。

RDD 中的依赖关系分为窄依赖（Narrow Dependency）和宽依赖（Wide Dependency）,
区分在于是否包含 shuffle，shuffle 过程涉及数据的重新分发，会产生大量的磁盘 I/O 和网络开销，[窄依赖的官方接口文档](https://spark.apache.org/docs/2.4.7/api/scala/index.html#org.apache.spark.NarrowDependency)，[宽依赖的官方接口文档](https://spark.apache.org/docs/2.4.7/api/scala/index.html#org.apache.spark.ShuffleDependency)。
如果父级 RDD 的每个分区被最多一个子级 RDD 的分区使用可以简单判断为是窄依赖，但是笛卡尔积不满足上面条件也是一种窄依赖。

> `abstract class NarrowDependency[T] extends Dependency[T]`
> 
> Base class for dependencies where each partition of the child RDD depends on a small number of partitions of the parent RDD. Narrow dependencies allow for pipelined execution. 
> 
> `class ShuffleDependency[K, V, C] extends Dependency[Product2[K, V]]`
> 
> Represents a dependency on the output of a shuffle stage. Note that in the case of shuffle, the RDD is transient since we don't need it on the executor side. 

![宽依赖和窄依赖](/assets/img/post/spark-dependency.png "宽依赖和窄依赖")

一个转换操作就是一个 fork/join 的过程，（将分区数据 fork 到不同的节点上，计算结束后再 join 到相应分区上），Spark 会把多个转换操作合并 fork/join 过程，称为流水线优化。

### RDD 的创建

RDD 可以从现有的 collection 中转换生成，也可以从其他存储系统（如 HDFS，S3 等）的数据集中创建生成，从其他 RDD 生成或者从 Dataframe 中转换出来。[SparkContext 接口文档](https://spark.apache.org/docs/2.4.7/api/scala/index.html#org.apache.spark.SparkContext)

{% highlight scala linedivs %}
val dataSeq = Seq(("Java", 20000), ("Python", 100000), ("Scala", 3000))   
val rdd1 = spark.sparkContext.parallelize(dataSeq)

val rdd2 = spark.sparkContext.textFile("/path/to/file.txt")

val rdd3 = rdd1.map(row=>{(row._1,row._2+100)})

val rdd4 = spark.range(20).toDF().rdd
{% endhighlight %}

RDD 的分区数可以在创建 RDD 时指定，也可以通过 `repartition()` 或者 `coalesce()` 重新分区，`repartition()` 是设置了 shuffle 的调用 `coalesce(numPartitions, shuffle = true)`，
可以生成指定数量的分区数，而 `coalesce()` 是默认不带 shuffle 的调用，只能做减少分区的任务，性能更好，因为只是把几个父分区压缩为一个新的分区，生成后的每个分区数据量可能不会大致相同。


{% highlight scala linedivs %}
println("RDD4 Partitions: "+rdd4.getNumPartitions)
// RDD4 Partitions: 3

val rdd5 = rdd4.repartition(numPartitions = 5)
println("RDD5 Partitions: " + rdd5.getNumPartitions)
// RDD5 Partitions: 5

val rdd6 = rdd4.coalesce(numPartitions = 6)
println("RDD6 Partitions: " + rdd6.getNumPartitions)
// RDD6 Partitions: 3

val rdd7 = rdd4.coalesce(numPartitions = 1)
println("RDD7 Partitions: " + rdd7.getNumPartitions)
// RDD7 Partitions: 1

{% endhighlight %}


### RDD Transformation

窄依赖转换

* `filter(func)`：筛选出满足 `func` 的元素，并返回一个新的数据集；
* `map(func)`：将每个元素传递到 `func` 中，并将结果返回一个新的数据集；
* `flatmap(func)`：和 `map` 函数类似，但每个输入元素都可以映射到 0 个或多个输出结果，即将 func 作用后的数组元素转成行，实现数据膨胀；
* `mapPartition(func)`: 与 `map` 函数类似，可以将一些繁重的初始化工作（如数据库连接）在分区级别完成，而不是像 `map` 在每条记录上，[Spark map() vs mapPartitions() with Examples](https://sparkbyexamples.com/spark/spark-map-vs-mappartitions-transformation/)；
* `mapPartitionsWithIndex(func)`: 与 `mapPartition` 类似，多加入一个分区的序号参数；
* `union()`: 取两个 RDD 的并集，不会消除相同元素；

宽依赖转换

* `groupByKey()`：应用于 (K, V) 键值对的数据集时，返回一个新的 (K, Iterable) 形式的键值对；
* `reduceByKey(func)`：应用于 (K, V) 键值对的数据集时，返回新的 (K, V) 形式的数据集，其中每个值是将每个 key 传递到 `func` 中进行聚合后的结果；
* `aggregateByKey()`:
* `aggregate()`:
* `join()`:
* `repartition()`:

{% highlight scala linedivs %}
import scala.util.Random

val dataSeq = Seq(("RDD is basic abstraction in Spark"), ("RDD is an immutable partitioned collection of elements that can be operated on in parallel"))
val rdd = sc.parallelize(dataSeq)
val rdd2 = rdd.flatMap(r=>r.split(" "))
val rdd3 = rdd2.map(r=>(r,1))
val rdd4 = rdd3.filter(r=>r._1.startsWith("o"))
val rdd5 = rdd4.reduceByKey(_ + _)
rdd5.foreach(println)

// 根据统计频次降序排列，并打印出来
rdd3.reduceByKey(_ + _).map(r => (r._2, r._1)).sortByKey(ascending = false).foreach(println)

// 对同一个分区的 map 转换加上一个固定的随机数
val rdd6 = rdd3.mapPartitions(iter=>{
  val rdInt = new Random().nextInt(100)
  iter.map(r => (r._1, r._2+rdInt))
})

val rdd7 = rdd3.mapPartitionsWithIndex((index,iter)=>{
  val rdInt = new Random().nextInt(100)
  iter.map(r => (index, r._1, r._2+rdInt))
})
{% endhighlight %}


### RDD Action

* `count()`：返回数据集中元素的个数；
* `collect()`：以数组的形式返回数据集中的所有元素；
* `first()`：返回数据集中的首个元素；
* `take(n)`：以数组的形式返回数据集中的前 n 个元素；
* `reduce(func)`：通过函数 `func`（两个输入一个输出） 聚合数据集中的元素；
* `foreach(func)`：将数据集中的每个元素传递到函数 `func` 中运行；

### RDD 其他操作

`rdd.persist()`：将 RDD 标记为持久化，不会马上计算生成 RDD 持久化，而是等到 action 触发计算把计算结果进行持久化。
`persist(MEMORY_ONLY)`：表示将 RDD 作为反序列化的对象存储于 JVM 中，如果内存不足，就要按照 LRU 原则替换缓存中的内容；
`persist(MEMORY_AND_DISK)`：表示将 RDD 作为反序列化的对象存储在 JVM 中，如果内存不足，超出的分区将会被存放在磁盘上。

`rdd.cache()` 等价于 `rdd.persist(MEMORY_ONLY)`

调用 `unpersist()` 将持久化的 RDD 从内存中释放。

## Spark 基本概念

Spark 官方各版本的[文档地址](https://spark.apache.org/documentation.html)，本文主要参考 [2.4.7 版本](https://spark.apache.org/docs/2.4.7/)。

### RDD vs DataFrame vs DataSet

* **RDD**（Resilient Distributed Dataset）：分布式弹性数据集，RDD 是不可变对象集合，分布在集群上的分区数据，提供了一组 transformations 和 actions 的底层数据接口以实现在各分区上并行计算。RDD 是 2011 年引入的数据集 API。
* **DataFrame**：2013 年引入的 DataFrame，它也是分布式不可变数据集，与 RDD 不同是数据被组织成命名列，就像数据库中的表一样。它将数据结构强加到了分布式数据集合上，从而实现了更高级别的抽象。
* **DataSet**：2015 年引入，它是 DataFrames API 的扩展，提供了类型安全，面向对象的接口。

### 集群模式概览

[Cluster Mode Overview](https://spark.apache.org/docs/2.4.7/cluster-overview.html)

用户编写的一个 Spark 程序就是一个 **Application**，在集群模式时作为一组独立程序运行在集群中，由 Driver Program 中的 SparkContext 对象协调，集群管理器可以是 Spark Standalone，Mesos 或者 Yarn。

![Spark Cluster Overview](/assets/img/post/spark-cluster-overview.png "Spark Cluster Overview")

当程序中触发了一个 action 则生成一个 **job**，job 再根据 shuffle 的边界划分成不同的 **stage**，
每一个 stage 再根据 RDD 上的分区数分割成 Spark 上工作的最小单元 **task**。

![Spark Job](/assets/img/post/spark-job-stage-task.png "Spark Job")

### 提交 Spark 应用

[Submitting Applications](https://spark.apache.org/docs/2.4.7/submitting-applications.html)

[Running Spark on YARN](https://spark.apache.org/docs/2.4.7/running-on-yarn.html)

提交集群模式设置 `--master <master-url>` 将应用提交到 master 上，。设置 `--deploy-mode cluster` ，

{% highlight bash linedivs %}
./bin/spark-submit \
  --class <main-class> \
  --master <master-url> \
  --deploy-mode <deploy-mode> \
  --conf <key>=<value> \
  ... # other options
  --jars /path/to/1.jar,/path/to/2.jar,.. \
  <application-jar> \
  [application-arguments]
{% endhighlight %}

* `--class`：应用程序入口，如 `org.apache.spark.examples.SparkPi`
* `--master`：将应用提交到 master 上的地址。本地模式设置为 `local[N]`，使用 N 个线程在本地运行；在 Spark Standalone 模式为 `spark://IP:PORT`；在 Yarn 模式设置 `--master yarn`；在 Mesos 设置为 `mesos://IP:PORT`。
* `--deploy-mode`：`cluster` 将驱动程序提交到集群上，成为由集群管理器管理的应用主程序，客户端提交应用后即可离开。这个默认值为 `client`，即将驱动运行在客户端进程中。官方文档建议开发调试可以用 `client` 模式，在生产环境用 `cluster` 模式，还可以结合提交任务的机器和集群的网络距离来考量用哪种模式。`client` 模式下日志会在本地输出方便调试，关掉启动的进程后会同时关掉 spark 应用，而集群模式，日志会收集到集群调度器（比如 yarn）日志中，本地的进程关掉后 spark 程序还会继续执行。`cluster` 模式还要注意把用到的本地 jar 包通过参数 `--jars` 参数上传，`--files` 上传应用需要的配置文件，还有参数 `spark.driver.extraClassPath`，`spark.executor.extraClassPath` 等，可以参考[提交应用](https://spark.apache.org/docs/2.4.7/submitting-applications.html)和[配置文档](https://spark.apache.org/docs/2.4.7/configuration.html#runtime-environment)。
* `--conf`：用 `key=value` 的形式配置 Spark 属性值，如果有空格则用双引号括起来 `"key=value"`，具体参数可以查看[配置文档](https://spark.apache.org/docs/2.4.7/configuration.html)。
* `--jars`：添加逗号分隔的 jar 文件列表。
* `application-jar`：应用程序的 jar 包，以及相关依赖，在集群模式次 jar 包和 `jars` 参数配置的 jar 包会自动分发到 driver 和 executor 的 classpaths 中。
* `application-arguments`：传给主程序的参数

对于 Python 应用程序，只需传递一个 .py 文件代替 `application-jar`，并添加 Python .zip，.egg 或者 .py 文件到搜索路径 `--py-files`。

更多提交命令可以通过 `./bin/spark-submit --help` 查看。

### Spark 调优

[Tuning Spark](https://spark.apache.org/docs/2.4.7/tuning.html)


## 参考

[What is the concept of application, job, stage and task in spark?](https://stackoverflow.com/questions/42263270/what-is-the-concept-of-application-job-stage-and-task-in-spark)

[Spark By Examples](https://sparkbyexamples.com/)

[A Tale of Three Apache Spark APIs: RDDs vs DataFrames and Datasets](https://databricks.com/blog/2016/07/14/a-tale-of-three-apache-spark-apis-rdds-dataframes-and-datasets.html)

[RDDs vs. Dataframes vs. Datasets – What is the Difference and Why Should Data Engineers Care?](https://www.analyticsvidhya.com/blog/2020/11/what-is-the-difference-between-rdds-dataframes-and-datasets/)

[深入解读 Spark 宽依赖和窄依赖（ShuffleDependency & NarrowDependency）](https://blog.csdn.net/Colton_Null/article/details/112299969)

[Wide vs Narrow Dependencies](https://untitled-life.github.io/blog/2018/12/27/wide-vs-narrow-dependencies/)

