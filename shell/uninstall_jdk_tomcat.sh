#!/bin/bash
#
###############################################
#author: biezhi
#email:i@biezhi.me
#date: 2015-09-16
###############################################

#卸载JDK
uninstall_jdk(){
    JAVA_DIR=/usr/local/java/jdk1.8.0_60
    TOMCAT_DIR=/usr/local/tomcat8

    if [ -d "$JAVA_DIR" ]; then
        rm -rf $JAVA_DIR
    fi

    if [ -d "$TOMCAT_DIR" ]; then
        rm -rf $TOMCAT_DIR
    fi

    #环境变量
    if [ -f "~/.bashrc.backup.tomcat8" ]; then
        mv ~/.bashrc.backup.tomcat8 ~/.bashrc
    fi

    if [ -f "~/.bashrc.backup.java" ]; then
        mv ~/.bashrc.backup.java ~/.bashrc
    fi
    source ~/.bashrc
    echo "JDK,Tomcat uninstall success!"
    cd
}

main(){
    uninstall_jdk
    if [ $? != 0 ]; then
        echo "JDK,Tomcat uninstall failed"
        exit 1
    fi
}
main
