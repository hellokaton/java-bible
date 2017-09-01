# 配置tomcat为服务

```bash
[root@localhost ~]# vim /etc/init.d/tomcat8
```

_tomcat服务脚本_

```bash
#!/bin/bash
#
# description: Apache Tomcat init script
# processname: tomcat  
# chkconfig: 234 20 80  
#
#
# Copyright (C) 2014 Miglen Evlogiev
#
# This program is free software: you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later
# version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of  MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along with
# this program.  If not, see <http://www.gnu.org/licenses/>.
#
# Initially forked from: gist.github.com/valotas/1000094
# Source: gist.github.com/miglen/5590986

 
#Location of JAVA_HOME (bin files)
export JAVA_HOME=/usr/local/java/jdk1.8.0_102
export JRE_HOME=/usr/local/java/jdk1.8.0_102/jre

#Add Java binary files to PATH
export PATH=$JAVA_HOME/bin:$PATH
 
#CATALINA_HOME is the location of the bin files of Tomcat  
export CATALINA_HOME=/usr/local/tomcat8
 
#CATALINA_BASE is the location of the configuration files of this instance of Tomcat
export CATALINA_BASE=/usr/local/tomcat8

 
#TOMCAT_USAGE is the message if this script is called without any options
TOMCAT_USAGE="Usage: $0 {\e[00;32mstart\e[00m|\e[00;31mstop\e[00m|\e[00;31mkill\e[00m|\e[00;32mstatus\e[00m|\e[00;31mrestart\e[00m}"
 
#SHUTDOWN_WAIT is wait time in seconds for java proccess to stop
SHUTDOWN_WAIT=20
 
tomcat_pid() {
        echo `ps -fe | grep $CATALINA_BASE | grep -v grep | tr -s " "|cut -d" " -f2`
}
 
start() {
  pid=$(tomcat_pid)
  if [ -n "$pid" ]
  then
    echo -e "\e[00;31mTomcat is already running (pid: $pid)\e[00m"
  else
    # Start tomcat
    echo -e "\e[00;32mStarting tomcat\e[00m"
    #ulimit -n 100000
    #umask 007
    #/bin/su -p -s /bin/sh $TOMCAT_USER
        if [ `user_exists $TOMCAT_USER` = "1" ]
        then
                /bin/su $TOMCAT_USER -c $CATALINA_HOME/bin/startup.sh
        else
                echo -e "\e[00;31mTomcat user $TOMCAT_USER does not exists. Starting with $(id)\e[00m"
                sh $CATALINA_HOME/bin/startup.sh
        fi
        status
  fi
  return 0
}
 
status(){
          pid=$(tomcat_pid)
          if [ -n "$pid" ]
            then echo -e "\e[00;32mTomcat is running with pid: $pid\e[00m"
          else
            echo -e "\e[00;31mTomcat is not running\e[00m"
            return 3
          fi
}

terminate() {
	echo -e "\e[00;31mTerminating Tomcat\e[00m"
	kill -9 $(tomcat_pid)
}

stop() {
  pid=$(tomcat_pid)
  if [ -n "$pid" ]
  then
    echo -e "\e[00;31mStoping Tomcat\e[00m"
    #/bin/su -p -s /bin/sh $TOMCAT_USER
        sh $CATALINA_HOME/bin/shutdown.sh
 
    let kwait=$SHUTDOWN_WAIT
    count=0;
    until [ `ps -p $pid | grep -c $pid` = '0' ] || [ $count -gt $kwait ]
    do
      echo -n -e "\n\e[00;31mwaiting for processes to exit\e[00m";
      sleep 1
      let count=$count+1;
    done
 
    if [ $count -gt $kwait ]; then
      echo -n -e "\n\e[00;31mkilling processes didn't stop after $SHUTDOWN_WAIT seconds\e[00m"
      terminate
    fi
  else
    echo -e "\e[00;31mTomcat is not running\e[00m"
  fi
 
  return 0
}
 
user_exists(){
        if id -u $1 >/dev/null 2>&1; then
        echo "1"
        else
                echo "0"
        fi
}
 
case $1 in
	start)
	  start
	;;
	stop)  
	  stop
	;;
	restart)
	  stop
	  start
	;;
	status)
		status
		exit $?  
	;;
	kill)
		terminate
	;;		
	*)
		echo -e $TOMCAT_USAGE
	;;
esac    
exit 0
```

这个脚本中需要注意你的jdk,jre位置和tomcat所在位置, 修改正确后保存。

## 给服务授权

```bash
[root@localhost ~]# chmod +x /etc/init.d/tomcat8
```

## 使用服务

```bash
[root@localhost ~]# service tomcat8 status
Tomcat is not running

[root@localhost ~]# service tomcat8 start
Starting tomcat
Using CATALINA_BASE:   /usr/local/tomcat8
Using CATALINA_HOME:   /usr/local/tomcat8
Using CATALINA_TMPDIR: /usr/local/tomcat8/temp
Using JRE_HOME:        /usr/local/java/jdk1.8.0_102/jre
Using CLASSPATH:       /usr/local/tomcat8/bin/bootstrap.jar:/usr/local/tomcat8/bin/tomcat-juli.jar
Tomcat started.
Tomcat is running with pid: 15282

[root@localhost ~]# service tomcat8 stop
Stoping Tomcat
Using CATALINA_BASE:   /usr/local/tomcat8
Using CATALINA_HOME:   /usr/local/tomcat8
Using CATALINA_TMPDIR: /usr/local/tomcat8/temp
Using JRE_HOME:        /usr/local/java/jdk1.8.0_102/jre
Using CLASSPATH:       /usr/local/tomcat8/bin/bootstrap.jar:/usr/local/tomcat8/bin/tomcat-juli.jar

waiting for processes to exit
```

## 设置开机启动

```bash
[root@localhost ~]# chkconfig --add tomcat8
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
redis_6379     	0:off	1:off	2:on	3:on	4:on	5:on	6:off
restorecond    	0:off	1:off	2:off	3:off	4:off	5:off	6:off
rsyslog        	0:off	1:off	2:on	3:on	4:on	5:on	6:off
saslauthd      	0:off	1:off	2:off	3:off	4:off	5:off	6:off
sshd           	0:off	1:off	2:on	3:on	4:on	5:on	6:off
tomcat8        	0:off	1:off	2:on	3:on	4:on	5:off	6:off
udev-post      	0:off	1:on	2:on	3:on	4:on	5:on	6:off
```

## links
   * [目录](<README.md>)
   * 上一节: [安装redis3](<install-redis.md>)
   * 下一节: [配置tomcat+nginx反向代理](<config-nginx-proxy.md>)