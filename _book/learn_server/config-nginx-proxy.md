# 配置tomcat+nginx反向代理

一般我们服务器对外只暴力22, 443, 80端口，其他的尽量都在内网访问，那么tomcat的8080端口是不应该对外访问的，
nginx作为一个性能卓越的web服务器提供了反向代理的功能，可以做到转发。

假设我们现在有一个域名绑定在服务器的80端口上，使用tomcat搭建的程序，但是我又不想修改tomcat端口，该怎么办呢？

nginx默认监听了80端口，配置文件在 `/usr/local/nginx/conf`文件夹下的 `nginx.conf`。

## 取消默认站点

```bash
[root@localhost]# cd /usr/local/nginx/conf
[root@localhost conf]# vim nginx.conf
```

将 `server` 块注释即可。然后我们在 `conf` 文件夹下创建一个 `vhost` 目录存储虚拟主机配置文件。

```bash
[root@localhost conf]# mkdir vhost
```

创建一个tomcat的虚拟主机配置文件。

```bash
[root@localhost conf]# vim vhost/tomcat8.conf
```

加入以下配置

```bash
server {
	listen       80;
	server_name localhost;
	
	location / {
		proxy_pass http://127.0.0.1:8080;
	}
}
```

在 `nginx.conf` 中将 `vhost` 文件夹下的配置文件引入，只需在 `http` 块中加入一行 `include vhost/*.conf` 保存即可。

重启nginx

```bash
[root@localhost conf]# service nginx restart
Stopping Nginx:                                            [  OK  ]
Starting Nginx:                                            [  OK  ]
```

查看tomcat是否已经启动，如果关闭将它开启，然后访问 [http://192.168.100.128/](http://192.168.100.128/)

![](https://ooo.0o0.ooo/2016/09/09/57d260a9a1004.png)

这样tomcat的8080端口就被nginx转发了，我们此时用域名直接绑定到80端口即可！

## links
   * [目录](<README.md>)
   * 上一节: [配置tomcat为服务](<config-tomcat-service.md>)
   * 下一节: [使用jemeter测试tomcat性能](<use-jemeter-test-tomcat.md>)