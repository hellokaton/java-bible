

## 使用hexo搭建博客系列

#### 1. 分分钟部署一个Hexo环境
#### 2. 了解配置


## 1. 安装NodeJS

我的系统环境：Win7_x64
去Nodejs的官网下载：[https://nodejs.org/en/download/](https://nodejs.org/en/download/)

这里我下载的是

![](https://i.imgur.com/l1hRF0V.png)

然后按照提示一步一步安装即可，我装在了C盘，这个盘装了SSD会快一些。
NodeJS会自动将`bin`写入环境变量，来试试是否安装成功 输入`node -v`命令查看nodejs版本。

![](https://i.imgur.com/Mvxp2C1.png)

## 2. 配置淘宝 NPM 镜像
cnpmjs.org是一个非常棒的npm国内镜像。由于其使用量越来越大，加上淘宝内部也有很多项目使用 NodeJS，于是，淘宝正式基于 cnpmjs 推出了镜像服务
淘宝的 NPM 镜像是一个完整的npmjs.org镜像。你可以用此代替官方版本(只读)，同步频率目前为 15分钟 一次以保证尽量与官方服务同步。

![](https://i.imgur.com/eJFvHTK.png)

当前 registry.npm.taobao.org 是从 registry.npmjs.org 进行全量同步的.
当前 npm.taobao.org 运行版本是: cnpmjs.org@0.4.1
系统运行在 Node.js@v0.11.12 上.

### 使用说明
你可以使用淘宝定制的 [cnpm](https://github.com/cnpm/cnpm) (gzip 压缩支持) 命令行工具代替默认的 `npm`:
```bash
$ npm install -g cnpm --registry=https://registry.npm.taobao.org
```
我使用的就是这个。

![](https://i.imgur.com/ZIw1Vkr.png)

或者你直接通过添加 `npm` 参数 `alias` 一个新命令:
```bash
alias cnpm="npm --registry=https://registry.npm.taobao.org \
--cache=$HOME/.npm/.cache/cnpm \
--disturl=https://npm.taobao.org/dist \
--userconfig=$HOME/.cnpmrc"

# Or alias it in .bashrc or .zshrc
$ echo '\n#alias for cnpm\nalias cnpm="npm --registry=https://registry.npm.taobao.org \
  --cache=$HOME/.npm/.cache/cnpm \
  --disturl=https://npm.taobao.org/dist \
  --userconfig=$HOME/.cnpmrc"' >> ~/.zshrc && source ~/.zshrc
```

### 安装模块

从 [registry.npm.taobao.org](http://registry.npm.taobao.org/) 安装所有模块. 当安装的时候发现安装的模块还没有同步过来, 淘宝 NPM 会自动在后台进行同步, 并且会让你从官方 NPM [registry.npmjs.org](http://registry.npmjs.org/) 进行安装. 下次你再安装这个模块的时候, 就会直接从 淘宝 NPM 安装了.

```bash
$ cnpm install [name]
```

### 同步模块
直接通过 `sync` 命令马上同步一个模块, 只有 `cnpm` 命令行才有此功能:
```bash
$ cnpm sync connect
```
当然, 你可以直接通过 web 方式来同步: [/sync/connect](http://npm.taobao.org/sync/connect)
```bash
$ open https://npm.taobao.org/sync/connect
```

## 3. 安装hexo

[hexo](https://hexo.io/) 官网的安装说明是 `npm install hexo-cli -g`

因为我们安装了淘宝的NPM，所以需要使用 `cnpm` 命令

![](https://i.imgur.com/yPkpF4O.png)

这样就安装成功了！

## 4. HelloWorld

按照官方教程(注意使用 `cnpm` 哦)：
```bash
$ hexo init blog
$ cd blog
$ cnpm install
$ hexo server
```
这样就可以运行一个最简单的博客程序了~

下一节：[各种配置详解](config.md)
