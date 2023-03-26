---
layout: post
title: Docker 使用手册
categories: 软件技术
tags: Docker
toc: false
---

## Docker 安装

安装 `yum-utils` 以使用它提供的 `yum-config-manager` 工具，添加 Docker 的社区版本仓库 docker-ce。

{% highlight bash linedivs %}
sudo yum install -y yum-utils
sudo yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo

# Install Docker
sudo yum install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Start Docker
sudo systemctl start docker
sudo systemctl enable docker

# Verify
sudo docker run hello-world
{% endhighlight %}

## Docker 常用命令

{% highlight bash linedivs %}

# 显示命令帮助文档
docker help
docker run --help

# 列出本地镜像
docker images

# 列出本地已启动容器
docker ps

# 查看所有容 包括停止的容器
docker ps -a

# -q 参数，只显示 container id
docker ps -q

# 启动止容器
docker start <container-id>

# 重启容器
docker restart <container-id>

# 关闭容器
docker kill <container-id>
docker stop <container-id>

# 删除容器
docker rm <container-id>

# 查看日志文件
docker logs -f <container-name>
{% endhighlight %}


## 参考资料

[Install Docker Engine on CentOS](https://docs.docker.com/engine/install/centos/)
