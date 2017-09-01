# 安装mysql及配置

## 卸载旧版本

查找本机是否已经安装mysql

```bash
[root@localhost ~]# rpm -qa | grep mysql
mysql-libs-5.1.73-7.el6.x86_64
```

卸载

```bash
[root@localhost ~]# rpm -e --nodeps mysql-libs-5.1.73-7.el6.x86_64
```

## 安装MySQL

这里我们使用yum方式进行安装，编译安装比较慢也很繁琐，查看系统里面有没有mysql的repo

```bash
[root@localhost ~]# yum repolist all | grep mysql
Repository base is listed more than once in the configuration
Repository updates is listed more than once in the configuration
Repository extras is listed more than once in the configuration
Repository centosplus is listed more than once in the configuration
Repository contrib is listed more than once in the configuration
```

先执行如下语句，安装相关依赖

```bash
[root@localhost ~]# yum install gcc-c++ jemalloc-devel openssl-devel openssl -y
```

安装mysql的yum源

```bash
[root@localhost ~]# wget http://dev.mysql.com/get/mysql57-community-release-el6-8.noarch.rpm
```

然后更新

```bash
[root@localhost ~]# sudo rpm -Uvh  mysql57-community-release-el6-8.noarch.rpm 
warning: mysql57-community-release-el6-8.noarch.rpm: Header V3 DSA/SHA1 Signature, key ID 5072e1f5: NOKEY
Preparing...                ########################################### [100%]
   1:mysql57-community-relea########################################### [100%]
```

更新源，将mysql56的 `enable` 置为1，其余置为0

```bash
[root@localhost ~]# vim /etc/yum.repos.d/mysql-community.repo
```

修改后是这样

```bash
[root@localhost ~]# cat /etc/yum.repos.d/mysql-community.repo
[mysql-connectors-community]
name=MySQL Connectors Community
baseurl=http://repo.mysql.com/yum/mysql-connectors-community/el/6/$basearch/
enabled=0
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-mysql

[mysql-tools-community]
name=MySQL Tools Community
baseurl=http://repo.mysql.com/yum/mysql-tools-community/el/6/$basearch/
enabled=0
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-mysql

# Enable to use MySQL 5.5
[mysql55-community]
name=MySQL 5.5 Community Server
baseurl=http://repo.mysql.com/yum/mysql-5.5-community/el/6/$basearch/
enabled=0
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-mysql

# Enable to use MySQL 5.6
[mysql56-community]
name=MySQL 5.6 Community Server
baseurl=http://repo.mysql.com/yum/mysql-5.6-community/el/6/$basearch/
enabled=1
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-mysql

[mysql57-community]
name=MySQL 5.7 Community Server
baseurl=http://repo.mysql.com/yum/mysql-5.7-community/el/6/$basearch/
enabled=0
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-mysql

[mysql-tools-preview]
name=MySQL Tools Preview
baseurl=http://repo.mysql.com/yum/mysql-tools-preview/el/6/$basearch/
enabled=0
gpgcheck=1
gpgkey=file:/etc/pki/rpm-gpg/RPM-GPG-KEY-mysql
```

执行安装

```bash
[root@localhost ~]# yum install -y mysql-community-server
```

## 启动Mysql

ok,安装完成了，我们启动mysql

```bash
[root@localhost ~]# service mysqld start
```

## 配置MySQL

yum安装的时候会把mysql的配置文件存放在 `/etc/my.cnf` 这个位置，在第一次启动的时候可以看到。

### 设置mysql root密码

有两种方式可以设置mysql的root密码

```bash
[root@localhost ~]# /usr/bin/mysqladmin -u root password 'new-password'
```

或者通过该命令给root账号设置密码

```bash
[root@localhost ~]# mysqladmin -u root password 'new-password'
```

此时我们就可以使用刚才设置的密码进行登录了

```bash
[root@localhost ~]# mysql -uroot -p
Enter password: 
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 4
Server version: 5.6.33 MySQL Community Server (GPL)

Copyright (c) 2000, 2016, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> 
```

### 设置开机启动

我们可以 通过 `chkconfig mysqld on` 命令来设置mysql开机启动

```bash
[root@localhost ~]# chkconfig mysqld on
```

看一下

```bash
[root@localhost ~]# chkconfig --list | grep mysqld
mysqld         	0:off	1:off	2:on	3:on	4:on	5:on	6:off
```

在这一步Mysql的安装就已经完成了，我们先步入下一个软件的安装，在之后的章节中还会继续讲解Mysql的配置。

## links
   * [目录](<README.md>)
   * 上一节: [安装tomcat](<install-tomcat.md>)
   * 下一节: [安装nginx](<install-nginx.md>)