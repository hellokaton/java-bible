# 安装jdk环境

服务器上如果不需要编码实际应该不安装JDK只安装JRE，我们考虑到以后可能安装其他软件就直接装JDK了。

## 下载JDK

[下载jdk](http://stackoverflow.com/questions/10268583/downloading-java-jdk-on-linux-via-wget-is-shown-license-page-instead)

上面的连接是stackoverflow有开发者写的不使用cookie下载jdk和jre的命令。

```bash
[root@localhost ~]# wget -c --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u171-b11/512cd62ec5174c3487ac17c61aaa89e8/jdk-8u171-linux-x64.tar.gz
```

## 解压

```bash
[root@localhost ~]# tar -zxvf jdk-8u171-linux-x64.tar.gz
[root@localhost ~]# mkdir /usr/local/java
[root@localhost ~]# mv jdk1.8.0_171/ /usr/local/java/
```

## 配置环境变量

```bash
[root@localhost ~]# vim /etc/profile
```

在最后一行添加

```bash
# java
export JAVA_HOME=/usr/local/java/jdk1.8.0_171
export JRE_HOME=/usr/local/java/jdk1.8.0_171/jre
export CLASSPATH=.:$JRE_HOME/lib/dt.jar:$JRE_HOME/lib/tools.jar
export PATH=$JAVA_HOME/bin:$JRE_HOME/bin:$PATH
```

## 生效

```bash
[root@localhost ~]# source /etc/profile
[root@localhost ~]# java -version
java version "1.8.0_171"
Java(TM) SE Runtime Environment (build 1.8.0_171-b11)
Java HotSpot(TM) 64-Bit Server VM (build 25.171-b11, mixed mode)
```
这里我安装的是最新版的JDK。

## links
   * [目录](<README.md>)
   * 上一节: [初始化操作系统](<init-os.md>)
   * 下一节: [安装tomcat](<install-tomcat.md>)
