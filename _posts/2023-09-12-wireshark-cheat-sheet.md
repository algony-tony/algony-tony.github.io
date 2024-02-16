---
layout: post
title: Wireshark 使用手册
categories: 软件技术
tags: 网络
toc: false
---

Wireshark 是一个强大的开源抓包工具。

## 过滤

Wireshark 有两种过滤器，第一种过滤器是捕获过滤器（Capture Filters），它只能在抓包前设置，Wireshark 只捕获满足条件的包，这种过滤器可以减少抓包的数量，但是在抓包过程中不能更改，可以参考这个文档 [CaptureFilters](https://wiki.wireshark.org/CaptureFilters) 或者这个[用户手册](https://www.wireshark.org/docs/wsug_html_chunked/ChCapCaptureFilterSection.html)。另一种是显示过滤器（Display Filters），顾名思义，它就是在包的列表页里做筛选显示，它可以在抓包过程中随时更改显示内容，日常使用过程中更方便一些，可以参考文档 [DisplayFilters](https://wiki.wireshark.org/DisplayFilters) 或者[用户手册](https://www.wireshark.org/docs/wsug_html_chunked/ChWorkBuildDisplayFilterSection.html)中的介绍。两种过滤器语法略有差别，下面简单介绍。

!["捕获过滤器和显示过滤器"](/assets/img/post/wireshark01.png)

### 捕获过滤器

捕获过滤器由一些本原表达式组合而成，形式如下

```
[not] primitive [and|or [not] primitive ...]
```

过滤 IP 相关内容

```
-- 过滤 IP 为 172.18.5.4 的进出流量
host 172.18.5.4

-- 过滤 IP 范围为 192.168.0.0/24 的进出流量
net 192.168.0.0/24
net 192.168.0.0 mask 255.255.255.0

-- 过滤一段 IP 范围主机发出的流量
src net 192.168.0.0/24
src net 192.168.0.0 mask 255.255.255.0

-- 过滤一段 IP 范围主机收到的流量
dst net 192.168.0.0/24
dst net 192.168.0.0 mask 255.255.255.0
```

过滤端口

```
-- 只筛选 DNS 流量（端口 53）
port 53
```


```
-- 过滤主机 www.example.com 的 non-HTTP 和 non-SMTP 流量
host www.example.com and not (port 80 or port 25)
host www.example.com and not port 80 and not port 25
```

### 显示过滤器

过滤条件中可以使用这些逻辑运算符：`and`, `or`, `not` 以及组合符号 `()`，比较符号 `eq`(`==`), `ne`(`!=`), `gt`(`>`), `lt`(`<`), `ge`(`>=`), `le`(`<=`),
还有包含符号 `contains`, 搜索符号 `matches`(`~`) 以大小写不敏感的方式匹配正则表达式，函数 `upper`, `lower`, `len`, `count`, `string`, `max`, `min`, `abs`,
以及常用的加减乘除模和位运算符。还可以使用字符的切片操作，下面是切片的语法：

```
[i:j]    i = start_offset, j = length
[i-j]    i = start_offset, j = end_offset, inclusive.
[i]      i = start_offset, length = 1
[:j]     start_offset = 0, length = j
[i:]     start_offset = i, end_offset = end_of_field
```

这是显示过滤器各网络协议的[字段参考列表](https://www.wireshark.org/docs/dfref/)。下面是一些常用的过滤条件。

只显示局域网（192.168.x.x）的流量：
```
ip.src==192.168.0.0/16 and ip.dst==192.168.0.0/16
或者
ip.addr == 192.168.0.0/16
```

`ip.addr` 表示的是 IPv4 的地址，IPv6 的是 `ipv6.addr`。

筛选一般的 HTTP/HTTPS 端口流量（大括号是集合符号）：
```
tcp.port in {80,443,8080}
或者
tcp.port == 80 or tcp.port == 443 or tcp.port == 8080
```

搜索包含某个网址的 HTTP URL:
```
http contains "https://www.wireshark.org"
```

## 参考链接

[Wireshark User’s Guide](https://www.wireshark.org/docs/wsug_html_chunked/)

[Wireshark Wiki](https://wiki.wireshark.org)

[Wireshark Manual Pages](https://www.wireshark.org/docs/man-pages/)