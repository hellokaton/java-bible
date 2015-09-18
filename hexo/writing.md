上一节：[各种配置详解](config.md)

# 1. 开始写作

使用下面的命令创建一个新文章：
```bash
$ hexo new [layout] <title>
```
默认的文章布局是`post`，当然你可用提供自己的布局文件。你可以编辑 `_config.yml` 修改默认布局。

### Layout（布局）

Hexo提供了3个默认布局：`post`、`page` 和 `draft`。不同布局的文章会被保存到不同的目录，这取决于它的布局类型。
自定义布局保存到 `source/_posts` 文件夹。


| 布局         | 路径|
| ----------- |------------|
| post       |source/_posts|
| page       |source|
| draft       |source/_drafts|

> ### 不处理文章!
> 如果你不希望你的文章被处理，你可以设置 `layout:false`。

### Filename（文件名）


默认情况下，hexo使用文章标题作为文件名。
你可以编辑 `_config.yml` 的 `new_post_name` 设置改变默认的文件名。
例如 `:year-:month-:day-:title.md` 将前缀的文件名后创建日期。你可以使用以下的占位符：

| 占位符        | 描述|
| ----------- |------------|
| `:title`       |文章标题|
| `:year`       |创建年份|
| `:month`       |月份，如4月为`04`|
| `:i_month`       |月份，单数字，比如4月就是`4`|
| `:day`       |日期|
| `:i_day`       |日期|

### Drafts（草稿）
前面hexo提到一个特殊的布局：`draft`。
这种布局的帖子保存到 `source/_drafts` 文件夹。你可以使用 `publish` 命令移动草稿到 `source/_posts` 文件夹。
这个命令类似于你使用了 `new`。
```bash
$ hexo publish [layout] <title>
```
草稿默认不显示，你可以添加 `--draft` 选项或者设置 `_config.yml` 中的 `render_drafts` 使hexo显示草稿。

### Scaffolds（模版）

当创建一篇文章,Hexo将构建基于 `scaffolds` 文件夹中的相应文件。例如:
```bash
$ hexo new photo "My Gallery"
```
当你运行这个命令，要尝试在 `scaffolds` 文件夹下找到文件名为 `photo.md` 的模板文件。下面占位符可以使用模板：

| 占位符        | 描述|
| ----------- |------------|
| `layout`       |布局|
| `title`       |文章标题|
| `date`       |发布时间|

# 2. 前置申明

前置申明的意思是写在文章前面的一块内容，为了对文章进行某些设置。它有两种书写方式：

**YAML方式，以三短线结束**
```bash
title: Hello World
date: 2013/7/13 20:46:25
---
```
**JSON方式，以三分号结束**
```bash
"title": "Hello World",
"date": "2013/7/13 20:46:25"
;;;
```

### 设置以及默认值

| 设置        | 描述|
| ----------- |------------|
| `layout`       |布局|
| `title`       |文章标题|
| `date`       |发布时间，默认为文件创建时间|
| `updated`       |文件修改时间|
| `comments`       |是否开启评论，默认为true|
| `tags`       |文章标签|
| `categories`       |文章所属分类|
| `permalink`       |文章永久链接，一般不用写，默认就行|

**分类 & 标签**

分类和标签只支持在文章。分类可能会有多层级别。
下面是一个例子：
```bash
categories:
- Sports
- Baseball
tags:
- Injury
- Fight
- Shocking
```

# 3. 标签插件
这里的标签插件不是文章中的标签，它可以帮助你在文章中插入特定的一些内容。

### Block Quote（块引用）
插入引号与作者、来源和文章的标题。
**别名**：quote
```bash
{% blockquote [author[, source]] [link] [source_link_title] %}
content
{% endblockquote %}
```
### 示例
**没有任何参数，纯输出blockquote**
```bash
{% blockquote %}
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque hendrerit lacus ut purus iaculis feugiat. Sed nec tempor elit, quis aliquam neque. Curabitur sed diam eget dolor fermentum semper at eu lorem.
{% endblockquote %}
```
> Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque hendrerit lacus ut purus iaculis feugiat. Sed nec tempor elit, quis aliquam neque. Curabitur sed diam eget dolor fermentum semper at eu lorem.

**引用一本书**
```bash
{% blockquote David Levithan, Wide Awake %}
Do not just seek happiness for yourself. Seek happiness for all. Through kindness. Through mercy.
{% endblockquote %}
```
> Do not just seek happiness for yourself. Seek happiness for all. Through kindness. Through mercy.
> ***David Levithan***——*Wide Awake*

**引用自Twitter**
```bash
{% blockquote @DevDocs https://twitter.com/devdocs/status/356095192085962752 %}
NEW: DevDocs now comes with syntax highlighting. http://devdocs.io
{% endblockquote %}
```

> NEW: DevDocs now comes with syntax highlighting. [http://devdocs.io](http://devdocs.io)
> ***@DevDocs***——*[twitter.com/devdocs/status/356095192085962752](https://twitter.com/devdocs/status/356095192085962752)*

**引用网络上一篇文章**
```bash
{% blockquote Seth Godin http://sethgodin.typepad.com/seths_blog/2009/07/welcome-to-island-marketing.html Welcome to Island Marketing %}
Every interaction is both precious and an opportunity to delight.
{% endblockquote %}
```
> Every interaction is both precious and an opportunity to delight.

> ***Seth Godin***——*[Welcome to Island Marketing](http://sethgodin.typepad.com/seths_blog/2009/07/welcome-to-island-marketing.html)*

### 代码块
文章中插入代码块
**别名**：code
```bash
{% codeblock [title] [lang:language] [url] [link text] %}
code snippet
{% endcodeblock %}
```
### 示例
**普通代码块**
```bash
{% codeblock %}
alert('Hello World!');
{% endcodeblock %}
```
```bash
alert('Hello World!');
```
**指定语言**
```bash
{% codeblock lang:objc %}
[rectangle setX: 10 y: 10 width: 20 height: 20];
{% endcodeblock %}
```
```objc
[rectangle setX: 10 y: 10 width: 20 height: 20];
```
**Gist**
```bash
{% gist gist_id [filename] %}
```
**iframe**
```bash
{% iframe url [width] [height] %}
```
**Image**
```bash
{% img [class names] /path/to/image [width] [height] [title text [alt text]] %}
```
**Link**
```bash
{% link text url [external] [title] %}
```
### [更多](https://hexo.io/docs/tag-plugins.html)...

# 4. 资源目录x
资源是非文章的文件，在`source`文件夹中，如图片、css、javascript文件等。
Hexo提供了一个更加方便的方式来管理资源。你可以修改 `post_asset_folder ` 设置。
```bash
post_asset_folder: true
```
一旦 `post_asset_folder` 设置启用,在你创建文章的时候，Hexo会创建一个同名目录，
你可以将该文章关联的资源全部放到该目录下。这样就可以更加方便的使用它们了。

### 标签插件使用
```bash
{% asset_path slug %}
{% asset_img slug [title] %}
{% asset_link slug [title] %}
```

# 5. 数据文件
有时，你可能会使用一些不在post中的模版数据，或者你想复用这些数据，
那么你可以试用一下Hexo3中的『Data files』功能。这个特性加载 `source/_data` 目录中的YAML或者JSON文件，从而用到你的网站中。

例如在 `source/_data` 文件夹中添加 `menu.yml`
```bash
Home: /
Gallery: /gallery/
Archives: /archives/
```
你可用在模板中使用它们：
```bash
{% for link in site.data.menu %}
  <a href="{{ link }}">{{ loop.key }}</a>
{% endfor %}
```
# 6. 服务器

### Hexo-server
在Hexo3中，服务器模块从主模块中分开了，你可以通过安装 [hexo-server](https://github.com/hexojs/hexo-server) 来使用它。
```bash
$ npm install hexo-server --save
```
一旦服务器安装,运行以下命令启动服务器。
默认你的网站将会运行在 `http://localhost:4000`。
当服务器正在运行时,Hexo将自动监控文件更改和更新。你不需要重新启动服务器。
```bash
$ hexo server
```
如果你想修改端口或遇到 `EADDRINUSE` 错误。您可以添加 `-p` 选项来设置其他端口。
```bash
$ hexo server -p 5000
```

### Static Mode
在静态模式下,`public` 文件夹的监控的禁用的。你必须运行 `hexo generate` 之前启动服务器，通常用于生产环境。
```bash
$ hexo server -s
```

### Custom IP
Hexo运行服务器在默认0.0.0.0。你可以覆盖默认的IP设置
```bash
$ hexo server -i 192.168.1.1
```

# 7. 生成器
Hexo生成静态文件非常简单、高效。
```bash
$ hexo generate
```
### 监听文件修改
Hexo立即可以看到文件更改并重新生成文件。Hexo将比较SHA1校验和文件和只写文件的改变。
```bash
$ hexo generate --watch
```
### 部署后生成
部署生成后,您可以运行以下命令之一，这2个命令使用结果相同。
```bash
$ hexo generate --deploy
$ hexo deploy --generate
```

# 8. 部署
Hexo为部署提供了一个快速、简单的方法。你只需要一个命令将网站部署到服务器。
```bash
$ hexo deploy
```
在我们开始之前,你必须在 `_config.yml` 修改设置。一个有效的部署设置必须有 `type` 字段。例如:
```yml
deploy:
  type: git
```
你可用同时部署到多个`type`，Hexo将依次执行每个部署。
```yml
deploy:
- type: git
  repo:
- type: heroku
  repo:
```

### Git
安装 [hexo-deployer-git](https://github.com/hexojs/hexo-deployer-git)
```bash
$ npm install hexo-deployer-git --save
```
编辑设置：
```yml
deploy:
  type: git
  repo: <repository url>
  branch: [branch]
  message: [message]
```

| 选项         | 描述|
| ----------- |---------------------------------------------|
| repo       | github仓库地址 |
| branch    | 分支名称 |
| message |定制提交消息(默认为 `Site updated: {{ now("YYYY-MM-DD HH:mm:ss") }}` )|

