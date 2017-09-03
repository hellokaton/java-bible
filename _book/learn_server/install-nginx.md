# 安装nginx

在安装nginx前，需要确保系统安装了g++、gcc、openssl-devel、pcre-devel和zlib-devel软件。

```bash
[root@localhost ~]# yum -y install gcc-c++ zlib zlib-devel openssl openssl-devel pcre pcre-devel
```

## 下载nginx

```bash
[root@localhost ~]# wget http://nginx.org/download/nginx-1.10.1.tar.gz
```

```bash
[root@localhost ~]# tar -zxvf nginx-1.10.1.tar.gz
[root@localhost ~]# cd nginx-1.10.1
[root@localhost nginx-1.10.1]# ./configure --prefix=/usr/local/nginx --with-http_ssl_module
```

上面 `--prefix` 配置nginx所在目录，`--with-http_ssl_module`配置nginx支持ssl，配置https会用到。

## 编译安装

```bash
[root@localhost nginx-1.10.1]# make && make install
```

来看看

```bash
[root@localhost nginx-1.10.1]# ll /usr/local/nginx/
total 16
drwxr-xr-x. 2 root root 4096 Sep  9 22:07 conf
drwxr-xr-x. 2 root root 4096 Sep  9 22:07 html
drwxr-xr-x. 2 root root 4096 Sep  9 22:07 logs
drwxr-xr-x. 2 root root 4096 Sep  9 22:07 sbin
```

## 启动nginx

```bash
[root@localhost nginx-1.10.1]# cd /usr/local/nginx/sbin/
[root@localhost sbin]# ./nginx
```

这样就启动nginx，nginx默认监听在80端口，但是我们不要忘了把80端口对外开放。

在 `/etc/sysconfig/iptables` 中添加80端口

```bash
-A INPUT -m state --state NEW -m tcp -p tcp --dport 80 -j ACCEPT
```

保存后重启一下防火墙

```bash
[root@localhost sbin]# service iptables restart
iptables: Setting chains to policy ACCEPT: filter          [  OK  ]
iptables: Flushing firewall rules:                         [  OK  ]
iptables: Unloading modules:                               [  OK  ]
iptables: Applying firewall rules:                         [  OK  ]
```

访问 [http://192.168.100.128/](http://192.168.100.128/) 你将看到

![](https://ooo.0o0.ooo/2016/09/09/57d253381cff7.png)

## 关闭nginx

```bash
#查询nginx主进程号 
[root@localhost sbin]# ps -ef | grep nginx
#停止进程 
[root@localhost sbin]# kill -QUIT 主进程号 
#快速停止 
[root@localhost sbin]# kill -TERM 主进程号 
#强制停止 
[root@localhost sbin]# pkill -9 nginx
```

## 重启nginx

```bash
[root@localhost ~]# /usr/local/nginx/sbin/nginx -s reload
```

## 配置nginx为服务

```bash
[root@localhost ~]# vim /etc/init.d/nginx
```

将服务脚本粘贴进去

_服务脚本_

```bash
#!/bin/sh  
# chkconfig: 2345 85 15  
# description:Nginx Server  
  
NGINX_HOME=/usr/local/nginx  
NGINX_SBIN=$NGINX_HOME/sbin/nginx  
NGINX_CONF=$NGINX_HOME/conf/nginx.conf  
NGINX_PID=$NGINX_HOME/logs/nginx.pid  
  
NGINX_NAME="Nginx"  
  
. /etc/rc.d/init.d/functions  
  
if [ ! -f $NGINX_SBIN ]  
then  
    echo "$NGINX_NAME startup: $NGINX_SBIN not exists! "  
    exit  
fi  
  
start() {  
    $NGINX_SBIN -c $NGINX_CONF  
    ret=$?  
    if [ $ret -eq 0 ]; then  
        action $"Starting $NGINX_NAME: " /bin/true  
    else  
        action $"Starting $NGINX_NAME: " /bin/false  
    fi  
}  
  
stop() {  
    kill `cat $NGINX_PID`  
    ret=$?  
    if [ $ret -eq 0 ]; then  
        action $"Stopping $NGINX_NAME: " /bin/true  
    else  
        action $"Stopping $NGINX_NAME: " /bin/false  
    fi  
}  
  
restart() {  
    stop  
    start  
}  
  
check() {  
    $NGINX_SBIN -c $NGINX_CONF -t  
}  
  
  
reload() {  
    kill -HUP `cat $NGINX_PID` && echo "reload success!"  
}  
  
relog() {  
    kill -USR1 `cat $NGINX_PID` && echo "relog success!"  
}  
  
case "$1" in  
    start)  
        start  
        ;;  
    stop)  
        stop  
        ;;  
    restart)  
        restart  
        ;;  
    check|chk)  
        check  
        ;;  
    status)  
        status -p $NGINX_PID  
        ;;  
    reload)  
        reload  
        ;;  
    relog)  
        relog  
        ;;  
    *)  
        echo $"Usage: $0 {start|stop|restart|reload|status|check|relog}"  
        exit 1  
esac
```

给脚本可执行权限

```bash
[root@localhost ~]# chmod +x /etc/init.d/nginx
```

然后你就可以使用 `service nginx start` 的方式启动nginx了

```bash
[root@localhost ~]# service nginx
Usage: /etc/init.d/nginx {start|stop|restart|reload|status|check|relog}
```

## 添加到开机项

```bash
[root@localhost ~]# chkconfig --add nginx
[root@localhost ~]# chkconfig
auditd         	0:off	1:off	2:on	3:on	4:on	5:on	6:off
blk-availability	0:off	1:on	2:on	3:on	4:on	5:on	6:off
crond          	0:off	1:off	2:on	3:on	4:on	5:on	6:off
ip6tables      	0:off	1:off	2:on	3:on	4:on	5:on	6:off
iptables       	0:off	1:off	2:on	3:on	4:on	5:on	6:off
iscsi          	0:off	1:off	2:off	3:on	4:on	5:on	6:off
iscsid         	0:off	1:off	2:off	3:on	4:on	5:on	6:off
lvm2-monitor   	0:off	1:on	2:on	3:on	4:on	5:on	6:off
mdmonitor      	0:off	1:off	2:on	3:on	4:on	5:on	6:off
multipathd     	0:off	1:off	2:off	3:off	4:off	5:off	6:off
mysqld         	0:off	1:off	2:on	3:on	4:on	5:on	6:off
netconsole     	0:off	1:off	2:off	3:off	4:off	5:off	6:off
netfs          	0:off	1:off	2:off	3:on	4:on	5:on	6:off
network        	0:off	1:off	2:on	3:on	4:on	5:on	6:off
nginx          	0:off	1:off	2:on	3:on	4:on	5:on	6:off
postfix        	0:off	1:off	2:on	3:on	4:on	5:on	6:off
rdisc          	0:off	1:off	2:off	3:off	4:off	5:off	6:off
restorecond    	0:off	1:off	2:off	3:off	4:off	5:off	6:off
rsyslog        	0:off	1:off	2:on	3:on	4:on	5:on	6:off
saslauthd      	0:off	1:off	2:off	3:off	4:off	5:off	6:off
sshd           	0:off	1:off	2:on	3:on	4:on	5:on	6:off
udev-post      	0:off	1:on	2:on	3:on	4:on	5:on	6:off
```
我们可以看到nginx已经被添加到开机启动了。

## links
   * [目录](<README.md>)
   * 上一节: [安装mysql及配置](<install-mysql.md>)
   * 下一节: [安装redis3](<install-redis.md>)