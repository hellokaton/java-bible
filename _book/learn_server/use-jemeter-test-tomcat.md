# 使用jemeter测试tomcat性能

JMeter是Apache组织开发的基于Java的压力测试工具。用于对软件做压力测试，它最初被设计用于Web应用测试，但后来扩展到其他测试领域。 

下载地址：[http://jmeter.apache.org/download_jmeter.cgi](http://jmeter.apache.org/download_jmeter.cgi)

安装启动即可。

![](https://ooo.0o0.ooo/2016/09/09/57d26181a3bbc.png)

## 服务器环境

- CPU：Intel(R) Core(TM) i5-4590 CPU @ 3.30GHz
- 内存：1G
- 操作系统：CentOS6.8_x64
- JDK：1.8.0_102
- Tomcat：8.5.5

下面所有测试都是基于1000个请求做的，且都是访问Tomcat默认的ROOT首页

## 创建测试计划

![](https://ooo.0o0.ooo/2016/09/09/57d262594f2ec.png)
![](https://ooo.0o0.ooo/2016/09/09/57d262640c284.png)
![](https://ooo.0o0.ooo/2016/09/09/57d2626eddf57.png)

配置参数，这里我们进行多次测试.

![](https://ooo.0o0.ooo/2016/09/09/57d262af81eaf.png)
![](https://ooo.0o0.ooo/2016/09/09/57d262b9a7fe3.png)

| 并发用户数 | 吞吐量/每秒 | 请求等待时间/毫秒 | 错误请求数/百分比 |
| :----: | :----: | :----: | :----: |
| 10 | 1999 | 8 | 0.00 |
| 20 | 2667 | 11 | 0.00 |
| 30 | 2746 | 13 | 0.00 |
| 40 | 2730 | 16 | 0.00 |
| 50 | 2682 | 20 | 0.00 |
| 60 | 2756 | 23 | 0.00 |
| 70 | 2764 | 27 | 0.00 |
| 80 | 2714 | 32 | 0.00 |
| 90 | 2131 | 35 | 0.00 |
| 100 | 2739 | 38 | 0.00 |
| 200 | 1404 | 43 | 0.34% |
| 300 | 1066 | 50 | 0.77% |
| 400 | 995 | 52 | 1.23% |
| 500 | 1086 | 46 | 1.42% |
| 1000 | 1163 | 59 | 2.83% |

![](https://ooo.0o0.ooo/2016/09/09/57d276759cccc.png)

![](https://ooo.0o0.ooo/2016/09/09/57d2768276105.png)

从上面的测试结果来看，在90-100个并发的时候出现不稳定，其他都比较平缓，请求时间一直在上涨。CPU负载均在60%左右。

在聚合报告中，会显示一行数据，共有10个字段，含义分别如下。

- Label：每个 JMeter 的 element（例如 HTTP Request）都有一个 Name 属性，这里显示的就是 Name 属性的值
- #Samples：表示你这次测试中一共发出了多少个请求，如果模拟10个用户，每个用户迭代10次，那么这里显示100
- Average：平均响应时间——默认情况下是单个 Request 的平均响应时间，当使用了 Transaction Controller 时，也可以以Transaction 为单位显示平均响应时间
- Median：中位数，也就是 50％ 用户的响应时间
- 90% Line：90％ 用户的响应时间
- Min：最小响应时间
- Max：最大响应时间
- Error%：本次测试中出现错误的请求的数量/请求的总数
- Throughput：吞吐量——默认情况下表示每秒完成的请求数（Request per Second）
- KB/Sec：每秒从服务器端接收到的数据量，相当于LoadRunner中的Throughput/Sec

在下一章节我们介绍对tomcat8的优化。

## links
   * [目录](<README.md>)
   * 上一节: [配置tomcat+nginx反向代理](<config-nginx-proxy.md>)
   * 下一节: [优化tomcat8](<optimization-tomcat.md>)