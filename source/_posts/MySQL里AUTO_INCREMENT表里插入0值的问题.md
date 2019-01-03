---
title: MySQL里AUTO_INCREMENT表里插入0值的问题
date: 2019-01-03 09:59:30
comments: false
tags: MySQL
categories: 技术
---

在使用MYSQL数据库时，无法设置AUTO_INCREMENT从0开始自增，之后查询了相关资料整理。

## 快速概览

***
- AUTO_INCREMENT列满足条件
- 在不同数据库引擎下所具有的特征
- 解决AUTO_INCREMENT从1自增
***

- AUTO_INCREMENT列必须满足以下情况：
1. 每个表中必须只有一个AUTO_INCREMENT列，且其属性应是整数数据类性（AUTO_INCREMENT也支持浮点型数据类性，但很少用）。
2. 列必须拥有NOT NULL约束条件，如果没有设置，则MYSQL默认加上NOT NULL。
3. 列必须建立索引。常见使用PRIMARY KEY或UNIQUE，也可以不是唯一索引。
***
- MyISAM表的AUTO_INCREMENT列
MyISAM存储引擎中AUTO_INCREMENT列具有以下特征：
1. MyISAM中的列是单调的。在一个自动生成的的序列里，其顺序是严格递增的，并且在行被删后，不能复用。比如当前序列为100，如果删除包含该列的值，则新添加的依然为101，而不是100.
2. 如果使用TRUNCATE TABLE清空表，则计数器会被重置为1开始。
3. 如果序列里使用了复合索引来生成多个序列，则从序列顶端删除的值可以被重用。
4. 可以在建表的时候使用AUTO_INCREMENT=n，来显示的设置初始值。可以使用alter table语句更改计数器。例如：
```mysql
cretae table myisamdemo(
id int unsigned not null auto_increment,
primary key(id)
)engine=MyISAM auto_increment=100;
```
- MEMORY 表 的 AUTO_ INCREMENT 列
MEMORY 表 的 AUTO_ INCREMENT 列具有以下特征：
1. 在create table语句里可以使用AUTO_INCREMENT=n显示设置初始值，且可以使用alter table 更改计数器的值。如：
```mysql
alter table myisamdemo AUTO_INCREMENT=1001;
```
2. 从顶端删除的的值一般不能被复用。
3. 如果用truncate table 清空表，则序列被重置，并重新从1开始编号。
4. 表里不能使用复合索引生成多个独立的序列。

- InnoDB表的AUTO_INCREMENT列
InnoDB表的AUTO_INCREMENT列具有以下特征：
1. 在create table语句中可以使用AUTO_INCREMENT=n指定初始值，且可以使用alter table 表名 AUTO_INCREMENT=m，修改序列值。
2. 通常从序列顶端删除的值不能复用。如果使用truncate table清空表，序列被重置，则序列计数器从1开始计数。
3. 由于InnoDB是计数器是在内存中维护的-并未保存在数据表内，所以如果删除序列顶端的值，且重新启动服务器则此时序列值是可以重用的。且重启服务器还将取消在create table或alter table语句使用AUTO_INCREMENT设置的效果。
4. 如果生成AUTO_INCREMENT的事务被回滚，则序列可能出现断裂。
5. 在表里不能使用复合索引生成多个独立序列。 
***
在mysql中对于设置了自增属性auto_increment的字段自增值是从1开始的，写入0会被当做null值处理从而写入当前最大值的下一个值（即表示定义中auto_increment的值）。
***
如果需要修改自增值的起始位置可以通过 " alter table table_name(表名) auto_increment=xxxx; "进行修改，但是这个值必须比当前表内数据的最大值要大，否则修改不会生效。
如果需要修改自增值从0开始而不是从1开始，可以设置线程级别的参数" set sql_mode='NO_AUTO_VALUE_ON_ZERO' ; "来实现 ( 可小写 )
例如 :
创建表时可以这样写：
```mysql
set sql_mode='no_auto_value_on_zero';
CREATE TABLE auth_function (
  id BIGINT(20) AUTO_INCREMENT NOT NULL,
  name varchar(64) NOT NULL,
  parent_id BIGINT(20) NOT NULL,
  url varchar(128) NOT NULL,
  serial_num int NOT NULL,
  accordion int NOT NULL,
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
```