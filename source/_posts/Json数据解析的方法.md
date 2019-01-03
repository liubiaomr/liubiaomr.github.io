---
title: Json数据解析的方法
date: 2019-01-03 10:05:30
comments: false
tags: json
categories: 技术
---

>![图片发自简书App](http://upload-images.jianshu.io/upload_images/2878678-40197e0b842654a9.jpg)
***
JSON（JavaScript Object Notation）是一种轻量级的数据交换格式。
***
JSON的规则：对象是一个无序的"'名称'/‘值’"对集合，一个对象以"{"（左括号）开始，"{"(右括号)结束。每个名称后根一个":"(冒号)，"名称/值"对之间用","(逗号)分割。
***
例如：
```
{"name":"小明","gender":"男","age":21}
```
1. json数据结构（对象和数组）
- json对象	
```
var obj={"name":"小李","age":21};
```
- json数组	
```
var objarray=[{"name":"小王","age":22},{"name":"小子","age":23}];
```
2. 处理json数据，依赖文件有:jQuery.js
3. Note数据传输过程中，json数据是以文本，即字符串格式形式存在；
JS语言操作的是JS对象；所以json字符串与JS对象之间的转换是关键；
4. 数据格式
- Json字符串：
```
var json_str='{"name":"xiao","age":12}';
```
- Json对象：
```
var obj={"name":"da","age":22};
```
- JS对象：
```
Object{"name":"da","age":22}
```
5. 数据类型
Json字符串-->JS对象，使用方法：
注明：

json_str、obj代表的是在本文子标题4中的数据类型；
```
obj = JSON.parse(json_str);
obj = jQuery.parseJSON(json_str);
```
- Note:传入畸形json字符串(例如：
‘{name:"xiao",age:12}')，会抛出异常；
Json字符串格式，严格格式：‘{"name":"xiao","age":12}'
JS对象-->Json字符串：
```
json_str = JSON. stringify(obj);
```
- NOTE：
1. eval()是JS原生函数，使用该形式：
```
eval(‘('+‘{name:"xiao",age:12}'+')')
```
并不安全,无法保证类型转换为JS对象；
2. 上面3中方法，都经过chrome浏览器测试，下面是测试结果截图；
***
Json字符串-->JS对象;
![图片发自简书App](http://upload-images.jianshu.io/upload_images/2878678-eee61f1a7b642aac.jpg)
***
JS对象-->Json字符串：
![图片发自简书App](http://upload-images.jianshu.io/upload_images/2878678-4163d665109891e0.jpg)

***

