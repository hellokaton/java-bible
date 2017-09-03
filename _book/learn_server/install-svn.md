# 安装svn服务

Subversion是一个自由，开源的版本控制系统。Subversion将文件存放在中心版本库里。这个版本库很像一个普通的文件服务器，不同的是，它可以记录每一次文件和目录的修改情况。这样就可以籍此将数据恢复到以前的版本，并可以查看数据的更改细节。Subversion是Apache基金会下的一个项目，官网 [https://subversion.apache.org](https://subversion.apache.org)

## 安装依赖

```bash
[root@localhost ~]# yum install sqlite sqlite-devel apr-util apr-util-devel -y
```

## 安装subversion

```bash
[root@localhost ~]# wget http://mirrors.cnnic.cn/apache/subversion/subversion-1.8.16.tar.gz
[root@localhost ~]# tar -zxvf subversion-1.8.16.tar.gz
[root@localhost ~]# cd subversion-1.8.16
[root@localhost subversion-1.8.16]# ./configure --prefix=/usr/local/subversion
[root@localhost subversion-1.8.16]# make && make install
```

## 配置环境

```bash
[root@localhost ~]# vim /etc/profile
```

加入 `PATH=$PATH:/usr/local/subversion/bin`

## 查看版本

```bash
[root@localhost ~]# svn --version
svn, version 1.8.16 (r1740329)
   compiled Sep 26 2016, 06:42:53 on x86_64-unknown-linux-gnu

Copyright (C) 2016 The Apache Software Foundation.
This software consists of contributions made by many people;
see the NOTICE file for more information.
Subversion is open source software, see http://subversion.apache.org/

The following repository access (RA) modules are available:

* ra_svn : Module for accessing a repository using the svn network protocol.
  - with Cyrus SASL authentication
  - handles 'svn' scheme
* ra_local : Module for accessing a repository on local disk.
  - handles 'file' scheme
```

## 开始配置

### 建立仓库目录

```bash
[root@localhost ~]# mkdir -p /data/svn/repos
```

### 创建版本

```bash
[root@localhost ~]# svnadmin create /data/svn/repos/
```

### 修改配置

```bash
[root@localhost ~]# vim /data/svn/repos/conf/svnserve.conf
```

```bash
[general]
anon-access = none
auth-access = write
password-db = passwd  #用户密码文件
authz-db = authz  #授权登录文件
realm = repos
```

修改`/data/svn/repos/conf/passwd`文件，添加用户及密码：

```bash
[root@localhost ~]# vim /data/svn/repos/conf/passwd

[users]
username=password #用户名=密码　　　一行一个
```

修改`/data/svn/repos/conf/authz`文件，控制用户权限

```bash
[root@localhost ~]# vim /data/svn/repos/conf/authz
```

> 注意：

* 权限配置文件中出现的用户名必须已在用户配置文件中定义。
* 对权限配置文件的修改立即生效，不必重启svn。

用户组格式：

```bash
[groups]
= ,
```

其中，1个用户组可以包含1个或多个用户，用户间以逗号分隔。
版本库目录格式：

```bash
[<版本库>:/项目/目录]
@<用户组名> = <权限>
<用户名> = <权限>
```

其中，方框号内部分可以有多种写法:

- [/],表示根目录及以下，根目录是svnserve启动时指定的，我们指定为/home/svndata，[/]就是表示对全部版本库设置权限。
- [repos:/] 表示对版本库repos设置权限；
- [repos:/abc] 表示对版本库repos中的abc项目设置权限；
- [repos:/abc/aaa] 表示对版本库repos中的abc项目的aaa目录设置权限；
- 
权限主体可以是`用户组`、`用户`或`*`，用户组在前面加`@`，`*`表示全部用户。
权限可以是`w`、`r`、`wr`和空，空表示没有任何权限。

## 启动SVN

```bash
[root@localhost ~]# svnserve -d --listen-port 10901 -r /data/svn
```

- -d ：表示以daemon方式（后台运行）运行；
- --listen-port 10901 ：表示使用10901端口，可以换成你需要的端口。但注意，使用1024以下的端口需要root权限；
- -r /data/svn ：指定根目录是/data/svn。

## 将svn作为服务

```bash
#!/bin/bash
# build this file in /etc/init.d/svn
# chmod 755 /etc/init.d/svn
# centos下可以用如下命令管理svn: service svn start(restart/stop)
SVN_HOME=/home/svn
if [ ! -f "/usr/local/subversion/bin/svnserve" ]
then
    echo "svnserver startup: cannot start"
    exit
fi
case "$1" in
    start)
        echo "Starting svnserve..."
        /usr/local/subversion/bin/svnserve -d --listen-port 10901 -r $SVN_HOME
        echo "Finished!"
        ;;
    stop)
        echo "Stoping svnserve..."
        killall svnserve
        echo "Finished!"
        ;;
    restart)
        $0 stop
        $0 start
        ;;
    *)
        echo "Usage: svn { start | stop | restart } "
        exit 1
esac
```

wow，你已经完成初级篇的所有任务了，接下里我们会玩点有趣的 :)

## links
   * [目录](<README.md>)
   * 上一节: [安装nginx](<install-nginx.md>)
   * 下一节: [配置tomcat为服务](<config-tomcat-service.md>)
