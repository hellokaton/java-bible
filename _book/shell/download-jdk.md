## Download Oracle Java JRE & JDK using a script

Oracle has recently disallowed direct downloads of java from their servers (without going through the browser and agreeing to their terms, which you can look at here: Oracle terms). So, if you try:

```sh
wget "http://download.oracle.com/otn-pub/java/jdk/7u4-b20/jdk-7u4-linux-x64.tar.gz"
```

you will receive a page with "In order to download products from Oracle Technology Network you must agree to the OTN license terms" error message.

This can be rather troublesome for setting up servers with automated scripts.

Luckily, it seems that a single cookie is all that is needed to bypass this (you still have to agree to the terms to install):

```sh
Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie
```

So, if you want to download jdk7u4 for 64-bit Linux (e.g., Ubuntu) using wget, you can use:

```sh
wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/7u4-b20/jdk-7u4-linux-x64.tar.gz"
```

Just for reference, here are the links to the current (at the time of posting) downloads of JDK and JRE

**JDK 8u66**

- http://download.oracle.com/otn-pub/java/jdk/8u66-b17/jdk-8u66-linux-i586.rpm
- http://download.oracle.com/otn-pub/java/jdk/8u66-b17/jdk-8u66-linux-i586.tar.gz
- http://download.oracle.com/otn-pub/java/jdk/8u66-b17/jdk-8u66-linux-x64.rpm
- http://download.oracle.com/otn-pub/java/jdk/8u66-b17/jdk-8u66-linux-x64.tar.gz
- http://download.oracle.com/otn-pub/java/jdk/8u66-b17/jdk-8u66-macosx-x64.dmg
- http://download.oracle.com/otn-pub/java/jdk/8u66-b17/jdk-8u66-solaris-sparcv9.tar.Z
- http://download.oracle.com/otn-pub/java/jdk/8u66-b17/jdk-8u66-solaris-sparcv9.tar.gz
- http://download.oracle.com/otn-pub/java/jdk/8u66-b17/jdk-8u66-solaris-x64.tar.Z
- http://download.oracle.com/otn-pub/java/jdk/8u66-b17/jdk-8u66-solaris-x64.tar.gz
- http://download.oracle.com/otn-pub/java/jdk/8u66-b17/jdk-8u66-windows-i586.exe
- http://download.oracle.com/otn-pub/java/jdk/8u66-b17/jdk-8u66-windows-x64.exe

**JRE 8u66**

- http://download.oracle.com/otn-pub/java/jdk/8u66-b17/jre-8u66-linux-i586.rpm
- http://download.oracle.com/otn-pub/java/jdk/8u66-b17/jre-8u66-linux-i586.tar.gz
- http://download.oracle.com/otn-pub/java/jdk/8u66-b17/jre-8u66-linux-x64.rpm
- http://download.oracle.com/otn-pub/java/jdk/8u66-b17/jre-8u66-linux-x64.tar.gz
- http://download.oracle.com/otn-pub/java/jdk/8u66-b17/jre-8u66-macosx-x64.dmg
- http://download.oracle.com/otn-pub/java/jdk/8u66-b17/jre-8u66-macosx-x64.tar.gz
- http://download.oracle.com/otn-pub/java/jdk/8u66-b17/jre-8u66-solaris-sparcv9.tar.gz
- http://download.oracle.com/otn-pub/java/jdk/8u66-b17/jre-8u66-solaris-x64.tar.gz
- http://download.oracle.com/otn-pub/java/jdk/8u66-b17/jre-8u66-windows-i586-iftw.exe
- http://download.oracle.com/otn-pub/java/jdk/8u66-b17/jre-8u66-windows-i586.exe
- http://download.oracle.com/otn-pub/java/jdk/8u66-b17/jre-8u66-windows-i586.tar.gz
- http://download.oracle.com/otn-pub/java/jdk/8u66-b17/jre-8u66-windows-x64.exe
- http://download.oracle.com/otn-pub/java/jdk/8u66-b17/jre-8u66-windows-x64.tar.gz
- http://download.oracle.com/otn-pub/java/jdk/8u66-b17/server-jre-8u66-linux-x64.tar.gz
- http://download.oracle.com/otn-pub/java/jdk/8u66-b17/server-jre-8u66-solaris-sparcv9.tar.gz
- http://download.oracle.com/otn-pub/java/jdk/8u66-b17/server-jre-8u66-solaris-x64.tar.gz
- http://download.oracle.com/otn-pub/java/jdk/8u66-b17/server-jre-8u66-windows-x64.tar.gz
