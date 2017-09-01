# 缓存的理解与实现

![](http://i.imgur.com/HLyJOSv.png)

IOC是spring的核心，贯穿始终。所谓IoC，对于spring框架来说，就是由spring来负责控制对象的生命周期和对象间的关系。这是什么意思呢，举个简单的例子，我们是如何找女朋友的？常见的情况是，我们到处去看哪里有长得漂亮身材又好的mm，然后打听她们的兴趣爱好、qq号、电话号、微信号...(balabala)，想办法认识她们，投其所好送其所要，然后嘿嘿……这个过程是复杂深奥的，我们必须自己设计和面对每个环节。传统的程序开发也是如此，在一个对象中，如果要使用另外的对象，就必须得到它（自己new一个，或者从 `JNDI` 中查询一个），使用完之后还要将对象销毁（比如Connection等），对象始终会和其他的接口或类藕合起来。
下面的章节带你理解并实现一个IOC容器。

IOC源码：[https://github.com/junicorn/easy-ioc](https://github.com/junicorn/easy-ioc)

## 目录

* [IOC的概念](1.concept.md)
* [Spring中怎么用](2.spring.md)
* [设计一个IOC](3.myioc.md)
