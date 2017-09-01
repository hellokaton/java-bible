# 安装redis3

## 安装依赖软件

```bash
yum install -y gcc*
yum install -y tcl
```

## 安装redis

```bash
[root@localhost ~]# wget http://download.redis.io/releases/redis-3.2.3.tar.gz
[root@localhost ~]# tar -zxvf redis-3.2.3.tar.gz
[root@localhost ~]# cd redis-3.2.3
[root@localhost redis-3.2.3]# make
[root@localhost redis-3.2.3]# make test
[root@localhost redis-3.2.3]# make install
[root@localhost redis-3.2.3]# cd utils
[root@localhost redis-3.2.3]# chmod +x install_server.sh
[root@localhost redis-3.2.3]# ./install_server.sh
```

在install的时候提示选项，全部选择默认即可，你看到如下画面表示安装成功

```bash
Please select the redis port for this instance: [6379] 
Selecting default: 6379
Please select the redis config file name [/etc/redis/6379.conf] 
Selected default - /etc/redis/6379.conf
Please select the redis log file name [/var/log/redis_6379.log] 
Selected default - /var/log/redis_6379.log
Please select the data directory for this instance [/var/lib/redis/6379] 
Selected default - /var/lib/redis/6379
Please select the redis executable path [/usr/local/bin/redis-server] 
Selected config:
Port           : 6379
Config file    : /etc/redis/6379.conf
Log file       : /var/log/redis_6379.log
Data dir       : /var/lib/redis/6379
Executable     : /usr/local/bin/redis-server
Cli Executable : /usr/local/bin/redis-cli
Is this ok? Then press ENTER to go on or Ctrl-C to abort.
Copied /tmp/6379.conf => /etc/init.d/redis_6379
Installing service...
Successfully added to chkconfig!
Successfully added to runlevels 345!
Starting Redis server...
Installation successful!
```

## 测试一下

```bash
[root@localhost ~]# redis-cli
127.0.0.1:6379> set name jack
OK
127.0.0.1:6379> get name
"jack"
```

## 查看redis状态

```bash
[root@localhost ~]# service redis_6379 status
Redis is running (14927)
```

## 启动/关闭redis

```bash
[root@localhost ~]# service redis_6379 stop
Stopping ...
Waiting for Redis to shutdown ...
Redis stopped
[root@localhost ~]# service redis_6379 start
Starting Redis server...
```

## 设置redis认证密码

```bash
[root@localhost ~]# vim /etc/redis/6379.conf
```

找到 `# requirepass foobared` 将 `#` 去掉，设置一个密码。

然后重启redis

```bash
[root@localhost ~]# service redis_6379 restart
Stopping ...
Redis stopped
Starting Redis server...
```

wow，你已经完成初级篇的所有任务了，接下里我们会玩点有趣的 :)

## links
   * [目录](<README.md>)
   * 上一节: [安装nginx](<install-nginx.md>)
   * 下一节: [配置tomcat为服务](<config-tomcat-service.md>)