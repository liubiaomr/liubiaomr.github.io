---
title: 死磕SpringMVC
comments: false
reward: true
toc: true
copyright: true
date: 2018-12-27 00:09:00
tags: springmvc
categories: tech
top:
---

# 1. Spring中的注解及应用

## 1. @Controller

> 标识一个该类是SpringMVC Controller处理类，用来处理http请求对象

```java
@Controller
public class TestController{
    @RequestMapping("/index",method=Request.GET)
    public String index(Map<String,Object>map){
        return "Hello World!";
    }
}
```
<!--more-->

## 2. @RestController

> 在spring4.x之前没加入@RestController之前，@Controller要返回Json数据需要@RequestBody来配合，如果用@RestController代替@Controller，就不需要配置@RequestBody。默认返回Json。

```java
@RestController
public class TestController{
    @RequestMapping("/index",method=Request.GET)
    public String index(Map<String,Object>map){
        return "Hello World!";
    }
}
```

## 3. @Service

> 用于标注业务层组件，加入该注解把这个类加入到Spring的配置中去

## 4. AutoWired

> 用来装配Bean，可以写在字段上或者方法上，默认情况下要求被依赖对象必须存在，如果允许为null，可以设置它的required属性为false，例如：@AutoWired(Required=false)

## 5. @RequestMapping

> 类定义处：提供初步的请求映射信息，相对于WEB根目录。
>
> 方法处：提供进一步的细分映射信息，相对于类定义处的URL。

## 6. @RequestParam

> 用于将请求参数区的数据映射到功能处理方法 的参数上。

```java
public Resp test(@RequestParam Integer id){
    return Resp.success(customerInfoService.fetch(id));
}
```

这个id就是要接收 从接口传递过来的id的值的，如果传递过来的参数名和接收的不一致，可以如下：

```java
public Resp test(@RequestParam(value="course_id" Integer id)){
    return Resp.success(customerInfoService.fetch(id));
}
```

其中course_id就是接口传递的参数，id就是映射course_id的参数名。

## 7. @ModelAttribute

使用地方有三种：

1. 标记在方法上

> 标记在方法上，会在每一个@RequestMapping标注的方法前执行，如果有返回值，则自动将该返回值加入到ModelMap中。

- 在有返回值的方法上

当ModelAttribute设置了value，方法返回的值会以这个value为key，以接收到的值作为value，存入到Model中，如下面的方法执行后，最总相当于model.addAttribute("username",name)；假如@ModelAttribute没有自定义设置value，则相当于：

model.addAttribute("name",name);

```java
@ModelAttribute(value="user_name")
public String before(@RequestParam(required=false)String name,Model model){
    System.out.println("进入："+name);
    return "name";
}
```

2. 在没有返回的方法上

> 需要手动model.add方法

```java
@ModelAttribute
public void before(@RequestParam(required=false,Integer age,Model model)){
    model.addAttribute("age",age);
    System.out.println("进入："+age);
}
```

新建请求方法：

```java
@RequestMapping("/mod")
public Resp mod(@RequestParam(required=false)String name,
               @RequestParam(required=false)Integer age,Model model){
    System.out.println("进入mod");
    return Resp.success("1");
}
```

在浏览器中输入访问地址并加上参数：

``` http
http://localhost:8081/api/test/mod?name=我是小菜&age=12
```

最终输出结果如下：

```
进入了1：40
进入了2：我是小菜
进入mod
参数接受的数值{name=我是小菜;age=12}
model传过来的值:{age=40, user_name=我是小菜}
```

2. 标记在方法的参数上

> 标记在方法的参数上，会将客户端传递过来的参数按名称注入到指定对象中，并且会将这个对象自动加入ModelMap中，便于view层使用。

```java
 @RequestMapping(value="/mod2")
  public Resp mod2(@ModelAttribute("user_name") String user_name,   @ModelAttribute("name") String name, @ModelAttribute("age") Integer age,Model model){ 
      System.out.println("进入mod2"); 
      System.out.println("user_name:"+user_name); 
      System.out.println("name："+name);
      System.out.println("age:"+age); 
      System.out.println("model:"+model);   
      return Resp.success("1");   
      }
```

在浏览器中输入访问地址并且加上参数：

```http
http://localhost:8081/api/test/mod2?name=我是小菜&age=12
```

最终输出：

```c
1进入了1：402进入了
2：我是小菜
3进入mod2
4user_name:我是小菜
5name：我是小菜
6age:40
7model:{user_name=我是小菜, org.springframework.validation.BindingResult.user_name=org.springframework.validation.BeanPropertyBindingResult: 0 errors, name=我是小菜, org.springframework.validation.BindingResult.name=org.springframework.validation.BeanPropertyBindingResult: 0 errors, age=40, org.springframework.validation.BindingResult.age=org.springframework.validation.BeanPropertyBindingResult: 0 errors}
```

从结果就能看出，用在方法参数中的@ModelAttribute注解，实际上是一种接受参数并且自动放入Model对象中，便于使用。

## 8. @Cacheable

用于标记缓存查询，可用于方法或者类中，

> 当标记在一个方法上时表示该方法是支持缓存的
>
> 当标记在一个类上时表示该类的所有方法都是支持缓存的

参数列表

| 参数      | 解释 | 例子                                    |
| --------- | ---- | --------------------------------------- |
| value     | 名称 | @Cacheable(value={"c1","c2"})           |
| key       | key  | @Cacheable(value="c1",key="#id")        |
| condition | 条件 | @Cacheable(value="1",condition="#id=1") |

比如@Cacheable(value="UserCache") 标识的是当调用了标记了这个注解的方法时，逻辑默认加上从缓存中获取结果的逻辑，如果缓存中没有数据，则执行用户编写查询逻辑，查询成功之后，同时将结果放入缓存中。
但凡说到缓存，都是key-value的形式的，因此key就是方法中的参数（id），value就是查询的结果，而命名空间UserCache是在spring*.xml中定义.

```java
@Cacheable(value="UserCache") //使用了一个缓存，名叫UserCache
public Account getUserAge(int id){
    //这里不用写缓存逻辑，直接按正常业务走即可
    //缓存通过切面自动切入
    int age=getUser(id);
    return age;
}
```

## 9. @CacheEvict

用来标记要清空缓存的方法，当这个方法被调用后，即会清空缓存。

@CacheEvict(value="UserCache")

**参数列表**