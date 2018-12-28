---
title: springboot学习笔记
comments: false
reward: true
tags: springboot
categories: 技术
top: 20
toc: true
abbrlink: 304afe37
date: 2018-12-26 01:07:18
---

> SpringBoot是为了简化Spring项目的快速创建、运行、调试、部署等一系列问题诞生的产物，**自动装配的特性可以让我们专注业务本身而不是外部的xml配置，我们只需要遵守规范，引入相关依赖就可以快速搭建WEB项目。**
# 1. SpringBoot快速开始

- 新建Springboot项目时，生成的目录信息：

```xml
-src
	-main
		-java
			-package
				<!--- 主函数 启动类 -->
				-SpringbootApplication
		-resources
			<!--存放静态资源 js/css/imges 等等-->
			-statics
			<!--存放html文件-->
			-templates
			<!--主要的配置文件。Springboot启动的时候会自动加载application.yml/application.properties-->
			-application.yml
	<!--测试文件存放目录-->
	-test
```

<!--more-->

## 1.1 POM.xml依赖

> 项目所依赖jar包

## 1.2 主函数入口

> 一个项目中不要出现多个main函数，否则在打包的时候spring-boot-maven-plugin将找不到函数入口（主动指定打包主函数入口除外）

## 1.3 配置文件

```properties
# 修改默认端口8080 为8090
server.port=8090
# 未定义上下文路径时，地址是http://localhost:8080 定义了之后http://localhost:8090 在Tomcat能配置的 都可以配置
server.servlet.context-path=/demo
```

## 1.4 自定义Banner

```java
  .   ____          _            __ _ _
 /\\ / ___'_ __ _ _(_)_ __  __ _ \ \ \ \
( ( )\___ | '_ | '_| | '_ \/ _` | \ \ \ \
 \\/  ___)| |_)| | | | | || (_| |  ) ) ) )
  '  |____| .__|_| |_|_| |_\__, | / / / /
 =========|_|==============|___/=/_/_/_/
 :: Spring Boot ::        (v2.0.1.RELEASE)
```

> SpringBoot启动时会有如上内容，自定义方法：
>
> 字需要在resources文件下指定命名的文件即可，例如：
>
> banner.txt、banner.jpg、banner.gif、banner.jpeg等等

# 2. SpringBoot配置详解

## 2.1 自定义属性配置

- application.properties

  1. 配置文件的书写形式：key-value形式 如：

     ~~~ properties
     my1.age=20
     my1.name=teddy
     ~~~

  2. 接下来定义properties.java配置文件，映射application.properties中的内容，之后就可以通过操作对象的方式获得配置文件中的内容。

     ~~~ java
     @Component //注册组件
     @ConfigurationProperties(prefix="my1")
     public class Properties{
         private int age;
         private String name;
         // 省略 get set
         @override
         public String toString(){
             return "properties{"+
                 "age="+age+
                 ",name='"+name+'\''+
                 '}';
         }
     }
     ~~~

  3. 接下来定义controller用来引入properties.java配置文件,进行测试。Spring4.x以后推荐使用构造函数形式注入属性。

      ```java
        @RequestMapping("/properties")
        @RestController
        public class PropertiesController{
         private static final Logger log=LoggerFactory.getlogger(PropertiesController.class);
         private final Properties properties；
             @AutoWired
             public PropertiesController(Properties properties){
             this.properties=properties;
         }
         public Properties properties(){
             log.info("===========================");
             log.info(properties.toString());
             log.info("===========================");
             return properties;
         }
        }
      ```

## 2.2 自定义文件配置

1. 定义一个名为my2.properties的资源文件，**自定义配置文件的命名不强制application开头**

```properties
my2.age=22
my2.name=Jhon
```

2. 定义Properties1.java文件，用来映射my2.properties文件中的内容。

   ```java
   @Component
   @PropertySource("classpath:my2.properties")
   @ConfigurationProperties(prefix="my2")
   public class Properties1{
       private int age;
       private String name;
       // 省略 get set
    @Override
       public String toString() {
           return "MyProperties2{" +
                   "age=" + age +
                   ", name='" + name + '\'' +
                   ", email='" + email + '\'' +
                   '}';
   }
   ```

## 2.3 多环境话配置

> 在真实的应用中，常常会有多个环境（如：开发、测试、生产等），不同的数据库连接都不一样，这个时候就需要用到spring.profile.active的强大功能了，它的格式为application-{profile}.properties,这里的**application**为前缀不能更改，{profile}是我们自定义的。如下：

- application-dev.properties

  ```properties
  server.servlet.context-path=/dev
  ```

- application-test.properties

  ```properties
  server.servlet.context-path=/test
  ```

- application-prod.properties

  ``` properties
  server.servlet.context-path=/prod
  ```

> 之后在application.properties配置文件中写入spring.profiles.active=xxx，这个时候再次访问：http://localhost:8090/properties/1就没用了，因为我们设置了context-path=xxx，所以新路径就是：http://localhost:8090/xxx/properties/1

## 2.4 外部命令测试

- 如何测试

  1. 进入到项目目录

  2. 打开cmd程序，输入

     ```
     mvn package
     ```

  3. 打包完毕后进入当前项目的target目录，可以发现命名为xxx.jar的文件。

  4. 接着在cmd命令行输入

     ```bash
     java -jar xxx.jar --spring.profiles.active=test --my1.age=23
     ```

  5. 最后输入url测试:http://localhost:8090/test/properties/1 返回值。

# 3. Springboot日志配置



