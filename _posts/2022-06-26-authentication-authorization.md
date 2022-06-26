---
layout: post
title: 认证与授权相关名词解释 
categories: 软件技术
tags: 名词解释 LDAP
---

## LDAP，OpenLDAP 与 AD

**LDAP**（Lightweight Directory Access Protocol）轻量级目录访问协议，是由国际电信联盟的电信标准化部门（ITU-T）开发的 X.500 系列标准的一个简化替代版本，[RFC 4511](https://datatracker.ietf.org/doc/html/rfc4511)。

LDAP 定义的是一种树形结构组织的数据库，适合写入少读取多的场景，不支持事务处理，Client/Server 架构模型。一个常见用途是为身份验证提供一个中心位置（存储用户名和密码），这允许许多不同的应用程序和服务连接到 LDAP 服务器以验证用户。

![LDAP 服务架构](/assets/img/post/ldap.png "LDAP 服务架构")


**条目（Entry）**：最基本的数据，类似数据库中的记录，LDAP 中存储数据的单元，一个条目由一组属性组成；
  
**DN（Distinguished Name）**：条目的唯一标识名，通过列出树结构的路径来定位，类似 Linux 文件系统中的目录结构，但是展示方向是相反的。DN 由 RDN 后根父条目的 DN 组成，**RDN** 由条目中的某些属性构成。DN 中的三种属性用组织机构的方式易于理解，**DC（Domain Component）** 是树形的根节点，**OU（Organization Unit）**机构单位，DN 路径中的中间分叉节点，**CN（Common Name）**用作叶子节点的名词，一般做人名。

比如“dn:cn=myname,ou=mydep,ou=mybu,dc=mycompany”用 Linux 文件系统方式表示出来就是 “/mycompany/mybu/mydep/myname”。

LDAP 的两个主流实现版本是 **OpenLDAP** 和 **Microsoft Active Directory（AD）**，OpenLDAP 是 LDAP 的免费开源实现。

AD 是微软的 Windows Server 中负责架构中大型网络环境的集中式目录管理服务，它管理在组织中的网络组件，可以是计算机，用户，群组，组织单元。

AD 可以实现用户管理（管理域账号，用户信息，邮箱等），计算机管理（管理计算机账号，实施组策略），资源管理（管理打印机，共享服务等），应用系统支持（对邮件系统，即时聊天工具，ERP，CRM 等系统的数据认证）。

Active Directory = LDAP 服务器 ＋ LDAP 应用（Windows 域控等）

## 参考链接

[The Difference Between LDAP, OpenLDAP and Active Directory](https://jumpcloud.com/blog/difference-between-ldap-openldap-active-directory)

[Active Directory的基本概念](https://www.cnblogs.com/IFire47/p/6672176.html)