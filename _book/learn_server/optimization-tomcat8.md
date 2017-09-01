# 优化tomcat8

我们优化tomcat的目的是提高并发性，即在多线程环境下能够快速响应，提高吞吐量。

首先在tomcat的bin目录下新建一个名为 `setenv.sh` 的文件，tomcat启动时会自动加载该文件。

```bash
[root@localhost bin]# vim setenv.sh
```

加入tomcat基础配置

```bash
#!/usr/bin

export CATALINA_HOME=/usr/local/tomcat8
export CATALINA_BASE=/usr/local/tomcat8
```

## JAVA_OPTS

加入如下配置，我们服务器的内存是1G。这里我设置最大占用768

```bash
export JAVA_OPTS="$JAVA_OPTS\
 -server\
 -Xms768m\
 -Xmx768m\
 -Xss512k\
 -Djava.awt.headless=true\
 -Dfile.encoding=utf-8\
 -Djava.net.preferIPv4Stack=true\
 -Djava.security.egd=file:/dev/./urandom"
```

- -server：表示这是应用于服务器的配置，JVM 内部会有特殊处理的
- -Xms768m：设置JVM最大可用内存为768MB
- -Xmx768m：设置JVM最小内存为768MB。此值可以设置与-Xmx相同，以避免每次垃圾回收完成后JVM重新分配内存。
- -Dfile.encoding：默认文件编码
- -Djava.net.preferIPv4Stack：使用IPV4
- -Djava.security.egd：[详细解释](http://fengbin2005.iteye.com/blog/2313845)

## 优化`server.xml`

```xml
<Connector  port="8080" 
		maxThreads="8000"
       	minSpareThreads="215"
       	maxSpareThreads="2048"
        connectionTimeout="20000"
        redirectPort="8443"
		acceptCount="100"
        debug="0"
		enableLookups="false"
		disableUploadTimeout="true" URIEncoding="UTF-8" useBodyEncodingForURI="true" />
```

**maxThreads 连接数限制**

maxThreads 是 Tomcat 所能接受最大连接数。一般设置不要超过8000以上，如果你的网站访问量非常大可能使用运行多个Tomcat实例的方法。

## 安装apr

安装依赖

```bash
[root@localhost ~]# yum install -y openssl-devel
```

下载apr相关包

```bash
[root@localhost ~]# wget http://mirrors.tuna.tsinghua.edu.cn/apache//apr/apr-1.5.2.tar.gz
[root@localhost ~]# wget http://mirrors.tuna.tsinghua.edu.cn/apache//apr/apr-util-1.5.4.tar.gz
[root@localhost ~]# wget http://mirrors.tuna.tsinghua.edu.cn/apache//apr/apr-iconv-1.2.1.tar.gz

# 安装apr
[root@localhost ~]# tar -zxvf apr-1.5.2.tar.gz

[root@localhost ~]# cd apr-1.5.2
[root@localhost apr-1.5.2]# ./configure && make && make install

# 安装apr-util
[root@localhost ~]# tar -zxvf apr-util-1.5.4.tar.gz
[root@localhost ~]# cd apr-util-1.5.4
[root@localhost apr-util-1.5.4]# ./configure --with-apr=/usr/local/apr && make && make install

# 安装apr-iconv
[root@localhost ~]# cd apr-iconv-1.2.1
[root@localhost apr-iconv-1.2.1]# ./configure --with-apr=/usr/local/apr && make && make install
```

配置tomcat

```bash
[root@localhost apr-iconv-1.2.1]# cd /usr/local/tomcat8/bin/
[root@localhost bin]# tar -zxf tomcat-native.tar.gz
[root@localhost bin]# cd tomcat-native-1.2.8-src/native/
[root@localhost native]# ./configure --with-apr=/usr/local/apr && make && make install
```

这是提示我

```bash
configure: error: Your version of OpenSSL is not compatible with this version of tcnative
```

由于centos 当前的yum 库只有1.0.1 的OpenSSL，所以我们需要手工安装1.0.2

```bash
[root@localhost ~]# wget https://www.openssl.org/source/openssl-1.0.2-latest.tar.gz
[root@localhost ~]# tar -zxf openssl-1.0.2-latest.tar.gz
[root@localhost ~]# cd openssl-1.0.2h
[root@localhost openssl-1.0.2h]# ./config --prefix=/usr/local/openssl -fPIC
```

> 注意这里需要加入 -fPIC参数，否则后面在安装tomcat native 组件会出错
> 注意：不要按照提示去运行 make depend

```bash
[root@localhost openssl-1.0.2h]# make
[root@localhost openssl-1.0.2h]# make install
[root@localhost openssl-1.0.2h]# mv /usr/bin/openssl ~
[root@localhost openssl-1.0.2h]# ln -s /usr/local/openssl/bin/openssl /usr/bin/openssl
[root@localhost openssl-1.0.2h]# openssl version
OpenSSL 1.0.2h  3 May 2016
```

重新安装 tomcat-native组件

```bash
[root@localhost openssl-1.0.2h]# cd /usr/local/tomcat8/bin/tomcat-native-1.2.8-src/native/
[root@localhost native]# ./configure --with-apr=/usr/local/apr --with-ssl=/usr/local/openssl
[root@localhost native]# make && make install
```

在 `setenv.sh` 文件中添加

```bash
LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/apr/lib
export LD_LIBRARY_PATH
```

在 `server.xml` 中加

```xml
<Connector 	port="8080" 
            protocol="org.apache.coyote.http11.Http11AprProtocol"
/>
```

启动tomcat，打开控制台日志可以看到如图所示的日志

![](https://ooo.0o0.ooo/2016/09/09/57d281093d907.png)

## 性能测试