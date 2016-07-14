```sh
#!/bin/bash  
# author: Sean Chow (seanlook7@gmail.com)
# 
#  
# chkconfig: 345 80 15  
# description: use service tomcat xintr 
  
# Source function library.  
. /etc/rc.d/init.d/functions  

export JAVA_HOME=
export JRE_HOME=

# tomcat名字
tcName=tomcat-$1
basedir=/data/program/tomcat/$tcName
tclog=${basedir}/logs/catalina.out

RETVAL=0  
  
start(){ 
        checkrun  
        if [ $RETVAL -eq 0 ]; then  
                echo "###### Tomcat正在启动 ######"  
                $basedir/bin/startup.sh  
                touch /var/lock/subsys/${tcNo}
                checklog 
                status
        else  
                echo "###### Tomcat启动成功 ######"  
        fi  
}  

# 停止某一台tomcat，如果是重启则带re参数，表示不查看日志，等待启动时再提示查看  
stop(){
        checkrun  
        if [ $RETVAL -eq 1 ]; then  
                echo "###### Tomcat正在关闭 ######"  
                $basedir/bin/shutdown.sh  
                if [ "$1" != "re" ]; then
                  checklog
                else
                  sleep 5
                fi
                rm -f /var/lock/subsys/${tcNo} 
                status
        else  
                echo "###### Tomcat关闭成功 ######"  
        fi  
}  
  
status(){
        checkrun
        if [ $RETVAL -eq 1 ]; then
                echo -n "-- Tomcat ( pid "  
                ps ax --width=1000 |grep ${tcName}|grep "org.apache.catalina.startup.Bootstrap start" | awk '{printf $1 " "}'
                echo -n ") 正在运行"  
                echo  
        else
                echo "###### Tomcat未运行 ######"  
        fi
        #echo "---------------------------------------------"  
}

# 查看tomcat日志，带vl参数
log(){
        status
        checklog yes
}

# 如果tomcat正在运行，强行杀死tomcat进程，关闭tomcat
kill(){
        checkrun
        if [ $RETVAL -eq 1 ]; then
            read -p "###### 确定要杀死 ${tcName} 的进程吗?[no])" answer
            case $answer in
                Y|y|YES|yes|Yes)
                    ps ax --width=1000 |grep ${tcName}|grep "org.apache.catalina.startup.Bootstrap start" | awk '{printf $1 " "}'|xargs kill -9  
                    status
                ;;
                *);;
            esac
        else
            echo "###### 退出 [$tcName] ######"
        fi
}


checkrun(){  
        ps ax --width=1000 |grep ${tcName}| grep "[o]rg.apache.catalina.startup.Bootstrap start" | awk '{printf $1 " "}' | wc | awk '{print $2}' >/tmp/tomcat_process_count.txt  
        read line < /tmp/tomcat_process_count.txt  
        if [ $line -gt 0 ]; then  
                RETVAL=1  
                return $RETVAL  
        else  
                RETVAL=0  
                return $RETVAL  
        fi  
}  

# 如果是直接查看日志viewlog，则不提示输入[yes]，否则就是被stop和start调用，需提示是否查看日志
checklog(){
        answer=$1
        if [ "$answer" != "yes" ]; then
            read -p "###### 查看 <catalina.out> 日志吗 $2?[yes])" answer
        fi
        case $answer in
            Y|y|YES|yes|Yes|"")
                tail -f ${tclog}
            ;;
            *)
            #    status
            #    exit 0
            ;;
        esac
}
checkexist(){
        if [ ! -d $basedir ]; then
            echo "###### tomcat $basedir 不存在 ######"
            exit 0
        fi
}
  
  
case "$2" in  
start)  
        checkexist
        start  
        exit 0
        ;;  
stop)  
        checkexist
        stop  
        exit 0
        ;;  
restart)  
        checkexist
        stop re 
        start 
        exit 0
        ;;  
status)  
        checkexist
        status  
        #$basedir/bin/catalina.sh version  
        exit 0
        ;;  
log)
        checkexist
        log
        exit 0
        ;;
kill)
        checkexist
        status
        kill
        exit 0
        ;;
*)  
        echo "###### 使用方法: service $0 [start|stop|restart|status|log|kill]"  
        echo "###### 举个栗子-> service tomcat xintr start"
        esac  
  
exit 0
```
