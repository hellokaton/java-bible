上一节：[分分钟部署一个Hexo环境](hello.md)

# 准备启程

一旦安装了Hexo,运行以下命令初始化Hexo在`目录`
```bash
$ hexo init <folder>
$ cd <folder>
$ cnpm install
```
一旦初始化，你的项目文件夹是这个样子：
```bash
.
├── _config.yml
├── package.json
├── scaffolds
├── scripts
├── source
|   ├── _drafts
|   └── _posts
└── themes
```

下面依次介绍上面各个文件或者目录的用途：

- `_config.yml`站点配置文件，很多全局配置都在这个文件中。
- `package.json` 应用数据。从它可以看出hexo版本信息，以及它所默认或者说依赖的一些组件。
- `scaffolds` 模版文件。当你创建一篇新的文章时，hexo会依据模版文件进行创建，主要用在你想在每篇文章都添加一些共性的内容的情况下。
- `scripts` 放脚本的文件夹， 就是放js文件的地方
- `source` 这个文件夹就是放文章的地方了，除了文章还有一些主要的资源，比如文章里的图片，文件等等东西。这个文件夹最好定期做一个备份，丢了它，整个站点就废了。
- `themes` 主题文件夹。

## 配置

### _config.yml配置文件

站点配置文件，你可以在这里进行大多数配置。

### 网站设置

| 配置         | 描述|
| ----------- |---------------------------------------------|
| title       | 站点名字，也就是html的title，会显示在浏览器标签上 |
| subtitle    | 站点副标题，会显示在首页上，可以不填 |
| description | 站点描述，可以不填 |
| author	  | 作者名称|
| language    | 语言|
| timezone    | 站点时区，默认是电脑时间|

### 链接设置

| 配置         | 描述                                          |
| ----------- |---------------------------------------------|
| url       | 站点网址 |
| root    | 站点根目录|
| permalink | 文章的永久网址链接，默认是`:year/:month/:day/:title/`，指的什么意思？比如我一篇叫『love』的文章是在2012年1月1日写的，那么它对应的链接就是`http://yoururl/2012/01/01/love/`|
| permalink_default	  ||

> 如果网址是次级目录，比如：`http://example.com/blog`，那么就要设置url为`http://example.com/blog`，并且root要设置为`/blog/`。

### 目录设置

| 配置         | 描述|
| ----------- |---------------------------------------------|
| source_dir       |source目录，默认值为source |
| public_dir    | public目录，静态网站生成的地方，默认值为public |
| tag_dir | tag目录|
| archive_dir	  | Archive目录|
| category_dir    | 分类目录|
| code_dir    | 代码目录|
| i18n_dir    | i18n目录|
| skip_render    | 不想被渲染的路径|

### 写作设置

| 配置         | 描述|
| ----------- |---------------------------------------------|
| new_post_name       |新建文章默认文件名，默认值为 :title.md，比如你执行命令hexo new hello，就会默认在_post目录下创建一个hello.md的文件|
| default_layout    |默认布局|
| titlecase ||
| external_link	  | 在新标签中打开一个外部链接，默认为true|
| filename_case    |转换文件名，1代表小写；2代表大写；默认为0，意思就是创建文章的时候，是否自动帮你转换文件名，默认就行，意义不大|
| render_drafts    |是否渲染_drafts目录下的文章，默认为false|
| post_asset_folder    |是否启用Asset Folder，默认为false，至于什么是Asset Folder，后面有讲解|
| relative_link    |使链接相对于根文件夹，默认false|
| future    |是否显示未来日期文章，默认为true|
| highlight    |代码块设置|

### 分类 & 标签

| 配置         | 描述|
| ----------- |---------------------------------------------|
| default_category       |默认分类，默认为无分类，当然你可以设置一个默认分类。|
| category_map    |分类缩略名|
| tag_map |标签缩略名|

### 日期格式化
Hexo使用的[Moment.js](http://momentjs.com/)来处理时间的。
| 配置         | 描述|
| ----------- |---------------------------------------------|
| date_format       |日期格式，默认为MMM D YYYY，一般我们喜欢使用YYYY-MM-DD的格式，其他格式模版可以查看[Moment.js](http://momentjs.com/)|
| time_format    |时间格式，默认为H:mm:ss|

### 分页

| 配置         | 描述|
| ----------- |---------------------------------------------|
| per_page       |一页显示多少篇文章，0 为不分页，默认值为 10|
| pagination_dir |分页目录，默认值为page|

### 扩展

| 配置         | 描述|
| ----------- |---------------------------------------------|
| theme       |主题配置，此处填上主题名就OK了，当然在themes目录下一定要有你配置的主题文件夹|
| deploy | 部署配置，将本地public目录也就是网站部署到服务器上的配置|


### package.json文件

应用数据，默认安装了 `EJS`，`Stylus` 和 `Markdown` 来渲染。如果你不需要可以卸载它们。

```json
package.json
{
  "name": "hexo-site",
  "version": "0.0.0",
  "private": true,
  "hexo": {
    "version": ""
  },
  "dependencies": {
    "hexo": "^3.0.0",
    "hexo-generator-archive": "^0.1.0",
    "hexo-generator-category": "^0.1.0",
    "hexo-generator-index": "^0.1.0",
    "hexo-generator-tag": "^0.1.0",
    "hexo-renderer-ejs": "^0.1.0",
    "hexo-renderer-stylus": "^0.2.0",
    "hexo-renderer-marked": "^0.2.4",
    "hexo-server": "^0.1.2"
  }
}
```

### scaffolds

脚手架文件夹。当你创建一个新文章,Hexo基于`scaffolds`文件夹里的类型来创建。

### scripts

脚本文件夹。扩展Hexo最简单的方法，它会自动执行这个文件夹下的JavaScript文件。

## 命令

### init
```bash
$ hexo init [folder]
```
初始化一个网站。如果没有提供`folder`,Hexo会在当前目录设置网站。

### new
```bash
$ hexo new [layout] <title>
```
创建一篇文章，如果不指定layout，那么就使用`_config.yml`中`default_layout`的值，标题中如果有空格，将整个`title`放到引号中。
比如，`hexo new "hello world"`创建一篇叫hello world的文章。

### generate
```bash
$ hexo generate
```
生成静态文件：

| 选项            | 描述|
| --------------- |--------------|
| `-d`, `--deploy`|生成完后直接部署|
| `-w`, `--watch` |监控文件的改变 |

### publish
```bash
$ hexo publish [layout] <filename>
```
发布为草稿

### server
```bash
$ hexo server
```
启动一个本地服务，默认情况下访问 `http://localhost:4000/`

| 选项              | 描述|
| ---------------- |-------------------|
| `-p`, `--port`   |指定端口|
| `-s`, `--static` |仅服务静态文件|
| `-l`, `--log`    |开启日志|

### deploy

```bash
$ hexo deploy
```
部署你的站点

| 选项              | 描述|
| ---------------- |-------------------|
| `-g`, `--generate`   |表示在部署前先重新生成一下站点|

### render

```bash
$ hexo render <file1> [file2] ...
```
渲染文件

| 选项              | 描述|
| ---------------- |-------------------|
| `-o`, `--output`   |输出到指定文件，我没用过|

### migrate

```bash
$ hexo migrate <type>
```

[迁移](https://hexo.io/docs/migration.html)到其他模块的命令。

### clean

```bash
$ hexo clean
```

删除缓存文件`db.json`以及生成的public目录，当你修改了某些样式或者配置时，如果发现`hexo g`后也没有反应，就可以执行一下这个命令。

### list

```bash
$ hexo list <type>
```
列出所有路由

### version
```bash
$ hexo version
```
显示hexo的版本信息到控制台

## Options
### Safe mode
```bash
$ hexo --safe
```
安全模式，使所有插件和脚本不生效

### Debug mode
```bash
$ hexo --debug
```
日志详细信息输出到终端。

### Silent mode
```bash
$ hexo --silent
```
静默模式，不在终端上显示任何信息

### Customize config file path
```bash
$ hexo --config custom.yml
```
使用一个自定义配置文件替换默认`_config.yml`

### Display drafts
```bash
$ hexo --draft
```
显示草稿文章（位于`source/_drafts`目录下）

### Customize CWD
```bash
$ hexo --cwd /path/to/cwd
```
自定义当前工作目录路径，假如你没在工作目录下，可以使用这个命令指定一下工作目录路径

下一节：[开始写作吧](writing.md)
