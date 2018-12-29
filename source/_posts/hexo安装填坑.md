---
title: hexo安装填坑
comments: false
reward: true
toc: true
copyright: true
tags: hexo安装
categories: 技术
abbrlink: 4ca02684
date: 2018-12-29 00:11:43
top:
---

# hexo安装流程

## 1. Linux系统升级

```bash
yum -y update
```

## 2. 服务端

- 安装Git、Nginx

```bash
yum install -y git nginx
```

- 创建git用户

```bash
sudo adduser git
chmod 740 /etc/sudoers
vim /etc/sudoers
```
找到以下内容

```bash
## Allow root to run any commands anywhere
root    ALL=(ALL)     ALL
```

在下面添加一行

```bash
git ALL=(ALL) ALL
```

保存退出后改回权限

```bash
chmod 400 /etc/sudoers
```

随后设置Git用户的密码

```bash
#需要root权限
sudo passwd git
```

- Nginx的配置

```yaml
server
{
    listen 80;
    #listen [::]:80;
    server_name www.seekbetter.me seekbetter.me;
    index index.html index.htm index.php default.html default.htm default.php;
    #这里要改成网站的根目录
    root  /path/to/www;  

    include other.conf;
    #error_page   404   /404.html;
    location ~ .*\.(ico|gif|jpg|jpeg|png|bmp|swf)$
    {
        access_log   off;
        expires      1d;
    }

    location ~ .*\.(js|css|txt|xml)?$
    {
        access_log   off;
        expires      12h;
    }

    location / {
        try_files $uri $uri/ =404;
    }

    access_log  /home/wwwlogs/blog.log  access;
}
```








- 添加公钥

  切换至git用户，创建证书登录，把自己电脑的公钥，也就是 `~/.ssh/id_rsa.pub` 文件里的内容添加到服务器的 `/home/git/.ssh/authorized_keys` 文件中，添加公钥之后可以防止每次 push 都输入密码。

  ```bash
  su git
  mkdir ~/.ssh
  vim ~/.ssh/authorized_keys
  #然后将电脑中执行 cat ~/.ssh/id_rsa.pub | pbcopy ,将公钥复制粘贴到authorized_keys
  chmod 600 ~/.ssh/authorzied_keys
  chmod 700 ~/.ssh
  ```

  然后就可以执行ssh 命令测试是否可以免密登录

  ```bash
  ssh -v git@SERVER
  ```

  至此，Git用户添加完成





  > 如果你之前没有生成过公钥，则可能就没有 `id_rsa.pub` 文件，具体的生成方法，可以[参考这里](https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent/)。

- 初始化git仓库

```bash
sudo mkdir /var/repo
cd /var/repo
sudo git init --bare blog.git
```

使用 `--bare` 参数，Git 就会创建一个裸仓库，裸仓库没有工作区，我们不会在裸仓库上进行操作，它只为共享而存在。

- 配置git hooks

  配置 git hooks，关于 hooks 的详情内容可以[参考这里](https://git-scm.com/book/zh/v2/%E8%87%AA%E5%AE%9A%E4%B9%89-Git-Git-%E9%92%A9%E5%AD%90)。

  我们这里要使用的是 `post-receive` 的 hook，这个 hook 会在整个 git 操作过程完结以后被运行。

  在 `blog.git/hooks` 目录下新建一个 `post-receive` 文件：

```bash
cd /var/repo/blog.git/hooks
vim post-receive
```

在 `post-receive` 文件中写入如下内容：

```bash
#!/bin/sh
git --work-tree=/var/www/hexo --git-dir=/var/repo/blog.git checkout -f
```

注意，`/var/www/hexo` 要换成你自己的部署目录，一般可能都是 `/var/www/html`。上面那句 git 命令可以在我们每次 push 完之后，把部署目录更新到博客的最新生成状态。这样便可以完成达到自动部署的目的了。

不要忘记设置这个文件的可执行权限：

```bash
chmod +x post-receive
```

- 更改文件权限

  改变 `blog.git` 目录的拥有者为 `git` 用户：

  ```bash
  sudo chown -R git:git blog.git
  ```
- 禁用git用户shell登录

禁用 `git` 用户的 shell 登录权限。

出于安全考虑，我们要让 `git` 用户不能通过 shell 登录。可以编辑 `/etc/passwd` 来实现，在 `/etc/passwd` 中找到类似下面的一行：

```bash
git:x:1001:1001:,,,:/home/git:/bin/bash
```

将其改为：

```bash
git:x:1001:1001:,,,:/home/git:/usr/bin/git-shell
```

这样 `git` 用户可以通过 ssh 正常使用 git，但是无法登录 sehll。

至此，服务器端的配置就完成了。

## 3. 本地配置

- 初始化Hexo博客

  首先要安装 `hexo-cli`，安装`hexo-cli` 需要 root 权限，使用 `sudo` 运行

```bash
sudo npm install -g hexo-cli
```

然后初始化Hexo程序

```bash
cd ~/Documents/code
hexo init blog
```

等执行成功以后安装两个插件， `hexo-deployer-git` 和 `hexo-server` ,这俩插件的作用分别是使用Git自动部署，和本地简单的服务器。

[hexo-deployer-git帮助文档](https://github.com/hexojs/hexo-deployer-git)

[hexo-server帮助文档](https://hexo.io/zh-cn/docs/server.html)

```bash
cd blog
npm install hexo-deployer-git --save
npm install hero-server
```



配置你的 hexo 博客可以自动 deploy 到服务器上，再也不用 ftp 上传了。

修改 hexo 目录下的 `_config.yml` 文件，找到 [deploy] 条目，并修改为：

```yaml
deploy:
  type: git
  repo: git@www.swiftyper.com:/var/repo/blog.git
  branch: master
```

要注意切换成你自己的服务器地址，以及服务器端 git 仓库的目录。

本地配置就是如此地简单。至此，我们的 hexo 自动部署已经全部配置好了。

## 4. 使用

从此以后，要发新博客的步骤不要太简单：

```bash
hexo new "new-post"
# bla..bla..bla..
hexo clean && hexo generate --deploy
```