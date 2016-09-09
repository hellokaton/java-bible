# 安装tomcat

上一章节我们安装了JDK的环境，Tomcat运行的前提是要有JDK环境。

## 下载Tomcat

```bash
[root@localhost ~]# wget http://mirror.bit.edu.cn/apache/tomcat/tomcat-8/v8.5.5/bin/apache-tomcat-8.5.5.tar.gz
[root@localhost ~]# tar -zxvf apache-tomcat-8.5.5.tar.gz
[root@localhost ~]# mv apache-tomcat-8.5.5 /usr/local/tomcat8
```

## 启动tomcat

```bash
[root@localhost ~]# cd /usr/local/tomcat8/bin/
[root@localhost bin]# ./startup.sh 
Using CATALINA_BASE:   /usr/local/tomcat8
Using CATALINA_HOME:   /usr/local/tomcat8
Using CATALINA_TMPDIR: /usr/local/tomcat8/temp
Using JRE_HOME:        /usr/local/java/jdk1.8.0_102/jre
Using CLASSPATH:       /usr/local/tomcat8/bin/bootstrap.jar:/usr/local/tomcat8/bin/tomcat-juli.jar
Tomcat started.
```

现在打开 [http://192.168.100.128:8080](http://192.168.100.128:8080) 应该就可以看到Tomcat的汤姆猫页面。
而事实是你看到这个:

![](https://ooo.0o0.ooo/2016/09/09/57d23ea8c353e.png)

哦草。。。为什么，机智的同学已经想到了，防火墙啊。对我们没有对防火墙进行任何配置，实际上8080端口是不对外开放的，
那么如何解决呢？

- 关闭防火墙
- 开放8080端口

## 配置防火墙

在CentOS上关闭防火墙是非常简单的

```bash
[root@localhost bin]# service iptables stop
iptables: Setting chains to policy ACCEPT: filter          [  OK  ]
iptables: Flushing firewall rules:                         [  OK  ]
iptables: Unloading modules:                               [  OK  ]
```

这时候你再访问 [http://192.168.100.128:8080](http://192.168.100.128:8080) 就可以看到

![](https://ooo.0o0.ooo/2016/09/09/57d23f752bfce.png)

当然这种方式是简单粗暴的，我们在真实服务器上不可能这么做，怎么做呢？

```bash
[root@localhost bin]# vim /etc/sysconfig/iptables
```

我们看到 `iptables` 的默认配置是这样的：

```bash
# Firewall configuration written by system-config-firewall
# Manual customization of this file is not recommended.
*filter
:INPUT ACCEPT [0:0]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
-A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
-A INPUT -p icmp -j ACCEPT
-A INPUT -i lo -j ACCEPT
-A INPUT -m state --state NEW -m tcp -p tcp --dport 22 -j ACCEPT
-A INPUT -j REJECT --reject-with icmp-host-prohibited
-A FORWARD -j REJECT --reject-with icmp-host-prohibited
COMMIT
```

只需要添加一行和 `22` 端口一样的配置：

```bash
-A INPUT -m state --state NEW -m tcp -p tcp --dport 8080 -j ACCEPT
```

这样既把8080的TCP端口对外开放了，然后重启防火墙

```bash
[root@localhost bin]# service iptables restart
iptables: Setting chains to policy ACCEPT: filter          [  OK  ]
iptables: Flushing firewall rules:                         [  OK  ]
iptables: Unloading modules:                               [  OK  ]
iptables: Applying firewall rules:                         [  OK  ]
```

可以达到同样的效果。

## links
   * [目录](<README.md>)
   * 上一节: [安装jdk环境](<install-jdk.md>)
   * 下一节: [安装mysql及配置](<install-mysql.md>)