# 在虚拟机里安装centos6

## 基础环境

 - 操作系统：Win7操作系统
 - 虚拟机：VMware® Workstation 12 Pro
 - Linux系统：CentOS 64位

接下里我们创建一个Linux虚拟机。

![](https://ooo.0o0.ooo/2016/09/09/57d21ba70219e.png)

这里选择自定义配置

![](https://ooo.0o0.ooo/2016/09/09/57d21bcabe68c.png)

我们选择了Workstation 8x, 为了兼容低版本的vmvware

![](https://ooo.0o0.ooo/2016/09/09/57d21bd500c46.png)

稍后安装操作系统

![](https://ooo.0o0.ooo/2016/09/09/57d21bdd67f7f.png)

选择Linux -> centos64位

![](https://ooo.0o0.ooo/2016/09/09/57d21be618ba3.png)

保存虚拟机到本地文件夹

![](https://ooo.0o0.ooo/2016/09/09/57d21bf02cb1f.png)

选择处理器数量和核心数，这里我选择默认的，根据你的机器情况可适当调整。

![](https://ooo.0o0.ooo/2016/09/09/57d21bf903216.png)

设置Centos内存，我设置1G

![](https://ooo.0o0.ooo/2016/09/09/57d21c048caba.png)

如果你在局域网环境并且希望其他人可以访问到你的centos，可以选择桥接模式，
这里我只有宿主机访问虚拟机，就设置了NAT模式，桥接的时候会和宿主机处于同一IP段。

![](https://ooo.0o0.ooo/2016/09/09/57d21c5b16bc8.png)
![](https://ooo.0o0.ooo/2016/09/09/57d21c63c49fa.png)

这里选择默认即可。

![](https://ooo.0o0.ooo/2016/09/09/57d21c70a4f1e.png)
![](https://ooo.0o0.ooo/2016/09/09/57d21c7a64405.png)

磁盘大小设置20G，用到更多可以累加上去，然后将虚拟磁盘存储为单文件，防止磁盘碎片。

![](https://ooo.0o0.ooo/2016/09/09/57d21ccc2db15.png)

点击完成。

![](https://ooo.0o0.ooo/2016/09/09/57d21cd385b5a.png)

选择你的IOS镜像文件，如果没有可以在 [这里](http://isoredirect.centos.org/centos/6/isos/x86_64/) 下载

![](https://ooo.0o0.ooo/2016/09/09/57d21cd94a75e.png)

![](https://ooo.0o0.ooo/2016/09/09/57d21ce210877.png)

安装操作系统

![](https://ooo.0o0.ooo/2016/09/09/57d21cf139606.png)

这里要检查硬件，可以直接跳过。

![](https://ooo.0o0.ooo/2016/09/09/57d21cf8bbfb7.png)

选择语言环境，我选择英文，避免在以后的操作中遇到未知的错误。

![](https://ooo.0o0.ooo/2016/09/09/57d21de293453.png)
![](https://ooo.0o0.ooo/2016/09/09/57d21de9279bf.png)

确定将配置写入到磁盘

![](https://ooo.0o0.ooo/2016/09/09/57d21def353cf.png)

这里就默认把，暂时用不到

![](https://ooo.0o0.ooo/2016/09/09/57d21dfa1624b.png)

选择时区，我们选择Asia/shanghai

![](https://ooo.0o0.ooo/2016/09/09/57d21dffbd0ac.png)

设置你的ROOT用户密码，请牢记以后会经常用到。

![](https://ooo.0o0.ooo/2016/09/09/57d21e06b65c4.png)

使用全部空间，就不分区了。

![](https://ooo.0o0.ooo/2016/09/09/57d21e0c94266.png)

将修改写入到磁盘。

![](https://ooo.0o0.ooo/2016/09/09/57d21e21e909f.png)

等待CentOS为你安装基础软件环境。

![](https://ooo.0o0.ooo/2016/09/09/57d21e687d0de.png)

看到这个界面你的CentOS就安装完成了，可以进行下一关了，上车！
