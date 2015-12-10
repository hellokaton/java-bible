# 如何设计一个JavaWeb MVC框架

通过使用Java语言实现一个完整的框架设计，这个框架中主要内容有第一小节介绍的Web框架的结构规划，例如采用MVC模式来进行开发，程序的执行流程设计等内容；第二小节介绍框架的第一个功能：路由，如何让访问的URL映射到相应的处理逻辑；第三小节介绍处理逻辑，如何设计一个公共的 `调度器`，对象继承之后处理函数中如何处理response和request；第四小节至第六小节介绍如何框架的一些辅助功能，例如配置信息，数据库操作等；最后介绍如何基于Web框架实现一个简单的增删改查，包括User的添加、修改、删除、显示列表等操作。

通过这么一个完整的项目例子，我期望能够让读者了解如何开发Web应用，如何搭建自己的目录结构，如何实现路由，如何实现MVC模式等各方面的开发内容。在框架盛行的今天，MVC也不再是神话。经常听到很多程序员讨论哪个框架好，哪个框架不好， 其实框架只是工具，没有好与不好，只有适合与不适合，适合自己的就是最好的，所以教会大家自己动手写框架，那么不同的需求都可以用自己的思路去实现。

![](http://i.imgur.com/QH8SRfB.png)

- 项目源码：[https://github.com/junicorn/mario](https://github.com/junicorn/mario)
- 示例代码：[https://github.com/junicorn/mario-sample](https://github.com/junicorn/mario-sample)

欢迎Star我写的一个简洁优雅的MVC框架 [Blade](https://github.com/biezhi/blade) :wink:

# 目录

* [项目规划](1.plan.md)
* [路由设计](2.route.md)
* [控制器设计](3.controller.md)
* [配置设计](4.config.md)
* [视图设计](5.view.md)
* [数据库操作](6.dbutil.md)
* [增删改查](7.crud.md)

接下来开始我们的 [框架之旅](1.plan.md) 吧~
