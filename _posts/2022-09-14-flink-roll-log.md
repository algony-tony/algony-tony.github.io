---
layout: post
title: CSA Flink 上滚动和归档日志的设置
categories: 软件技术
tags: Flink CDH CDP
toc: false
---

CSA 是 Cloudera Streaming Analytics，即将 Flink 部署在 Cloudera 的环境中，Flink 对 HDFS、YARN 和 Zookeeper 具有强制性依赖性。

因为 Flink 应用大多是长期运行的任务，jobmanager.log 和 taskmanager.log 日志文件很容易增长到 GB 级别，这样在 Flink 的仪表板上查看日志可能会出问题。这篇文章就是说明怎么对 CSA Flink 的 jobmanager.log 和 taskmanager.log 设置滚动日志。

默认情况下 CSA Flink 上 log4j.properties 没有配置滚动追加文件。

通过下面操作能覆盖 CSA Flink 上 log4j.properties 的默认配置。

在 CM 中的如下路径 Cloudera Manager -> Flink -> Configuration -> Flink Client Advanced Configuration Snippet (Safety Valve) for flink-conf/log4j.properties 写入下面内容

```
appender.main.name = MainAppender
appender.main.type = RollingFile
appender.main.append = false
appender.main.fileName = ${sys:log.file}
appender.main.layout.type = PatternLayout
appender.main.layout.pattern = %d{yyyy-MM-dd HH:mm:ss,SSS} %-5p %t %-60c %x - %m%n
appender.main.filePattern = ${sys:log.file}-archive-%d{yyyyMMdd_HHmmss}.log
appender.main.policies.type = Policies
appender.main.policies.size.type = SizeBasedTriggeringPolicy
appender.main.policies.size.size = 100MB
appender.main.strategy.type = DefaultRolloverStrategy
appender.main.strategy.action.type = Delete
appender.main.strategy.action.basePath = ${env:LOG_DIRS}
appender.main.strategy.action.condition.type = IfFileName
appender.main.strategy.action.condition.glob = *-archive-*
appender.main.strategy.action.condition.nested_condition.type = IfAny
appender.main.strategy.action.condition.nested_condition.lastMod.type = IfLastModified
appender.main.strategy.action.condition.nested_condition.lastMod.age = PT7D
appender.main.strategy.action.condition.nested_condition.totalSize.type = IfAccumulatedFileSize
appender.main.strategy.action.condition.nested_condition.totalSize.exceeds = 5000MB
```

保存后在 CM 里重新部署 flink 客户端配置，CM -> Flink -> Actions -> Deploy client configurations。

注 1：上面的设置让 jobmanager.log and taskmanager.log 文件每 100 MB 滚动保存一个文件，只保留最近 7 天的文件或者当总大小超过 5000 MB 时删除最早的文件。

注 2：上面的 log4j.properties 没有控制 jobmanager.err/out 和 taskmanager.err/out 输出，如果你的应用有明确打印任何结果到 stdout/stderr 上那么在应用的长时间运行后日志会占满文件系统。建议还是利用 log4j 日志框架去记录所有消息和结果。


## 参考链接

[How to configure CSA flink to rotate and archive the taskmanager.log and jobmanager.log on node manager local disk](https://my.cloudera.com/knowledge/How-to-configure-CSA-flink-to-rotate-and-archive-the?id=333860)

[【Flink】CDH/CDP Flink on Yarn 日志配置](https://blog.csdn.net/Mrerlou/article/details/125159007)

[如何使用日志记录](https://nightlies.apache.org/flink/flink-docs-master/zh/docs/deployment/advanced/logging/)


[Logging configuration in Flink](https://cs101.blog/2018/01/03/logging-configuration-in-flink/)