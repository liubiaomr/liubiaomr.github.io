---
title: 死磕Mybatis
comments: false
reward: true
toc: true
copyright: true
tags: mybatis
categories: 技术
abbrlink: b3def48c
date: 2018-12-27 00:07:45
top:
---

### ORM模型

> ORM模型就是数据库的表和Java对象（Plan Ordinary Java Object，简称POJO）的映射关系模型

### SQL和HQL

> SQL语言（Structured Query Language）、HQL语言（Hibernate Query Language）

### Hibernate

> Hibernate是全表映射框架
>
> - Hibernate的缺点：
>   1. 全表映射带来的不便，比如更新时需要发送所有字段。
>   2. 无法根据不同条件组装不同的SQL。
>   3. 对多表关联和复杂SQL查询支持较差，需要自己写SQL，返回后，需要自己将数据封装为POJO。
>   4. 不能有效支持存储过程。
>   5. 虽然有HQL，但是性能较差。大型互联网系统往往需要优化SQL，而Hibernate做不到。

<!--more-->

### Mybatis

> Mybatis是一个半自动映射框架，之所以是半自动，是因为它需要手动匹配提供POJO、SQL和映射关系。