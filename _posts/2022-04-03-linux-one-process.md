---
layout: post
title: 在 Linux Shell 中如何只允许同时最多一个程序运行
excerpt: 主要介绍两种方案，使用 flock 命令，或者使用 pid 文件。
categories: 软件技术
tags: Linux shell
---

在 Linux shell 中有时需要实现排他地同时最多只能一个进程运行，比如用 crontab 周期性执行程序，定时开始时可能之前周期运行的程序还没有结束退出，此时就需要用到下面几种方案。

## flock 命令

{% highlight bash linedivs %}
flock -xn <lock-file> <script>
{% endhighlight %}

Linux 里的文件锁主要两种，一种是协同锁（advisory lock），一种是强制锁（mandatory lock）,协同锁不是由操作系统或者文件系统设置，它要求参与操作的进程之间协同工作，
文件被协同锁锁定时也一样可以被系统调用去读写甚至删除，强制锁通过命令 `fcntl` 操作，linux 的强制锁使用有一定限制，而且 [kernel 文件](https://www.kernel.org/doc/Documentation/filesystems/mandatory-locking.txt)中是建议尽量不用强制锁。

`flock` 会给文件上协同锁，不同的进程可以通过 `flock` 命令协同工作。`-x` 参数是排他锁，这个是默认配置，`-n` 是 nonblock，如果已经有进程给文件上锁，此进程拿不到锁会退出，exit code 默认是 1，
可以通过参数 `-E` 指定其他 exit code。`-w` 可以指定等待几秒后拿不到锁再退出。`-s` 是指定共享锁，读锁。

下面两个命令可以查看 linux 系统锁。
{% highlight bash linedivs %}
lslocks
# COMMAND   PID  TYPE SIZE MODE  M START END PATH
# flock   19619 FLOCK   4B WRITE 0     0   0 /home/tony/test/balance.dat
cat /proc/locks
# 1: FLOCK  ADVISORY  WRITE 19619 08:10:83966 0 EOF
{% endhighlight %}

## 使用 PID 文件
PID 文件就是普通的文本文件，只保存进程的 PID，这里面没有特别规则，只是一种约定。
使用 PID 文件的想法就是在进程开始前检查是否存在 PID 文件，及存储的 pid 进程是否有效，如果都是 True 则等待，否则开始启动本次 action，
结束后移除 PID 文件，防止程序意外退出加上 `trap` 命令捕捉只要退出就移除 PID 文件，但是被 `kill` 的时候不会被捕捉到，所以在检查 PID 文件的时候也要检查下 pid 程序是否还有效。

{% highlight bash linedivs %}
#!/bin/bash

PIDFILE="/tmp/pidtest.pid"

create_pidfile () {
  echo $$ > "$PIDFILE"
}

remove_pidfile () {
  [ -f "$PIDFILE" ] && rm "$PIDFILE"
}

# 若存在 PID 文件且 pid 有效则 true，否则 false
check_pidfile () {
  # 申明函数局部变量
  local prevpid
  if [ -f "$PIDFILE" ]; then
    prevpid=$(cat "$PIDFILE")
    # 参考 man 2 kill
    # kill -0 不会发送信号，只会检查是否可执行，可以用作检查进程是否还存在
    # 进程存在，且有权限则返回 0，否则返回 1
    # 在 shell 中 1 表示 false，0 是 true
    kill -0 $prevpid 2>/dev/null
  else
    false
  fi
}

do_action () {
  echo "do action..."
  sleep 300
}

trap remove_pidfile EXIT
if ! check_pidfile ;then
  create_pidfile
  do_action
fi
{% endhighlight %}


### 参考
[Ensure Only One Instance of a Bash Script Is Running](https://www.baeldung.com/linux/bash-ensure-instance-running)

[Introduction to File Locking in Linux](https://www.baeldung.com/linux/file-locking)

[What is a .pid File?](https://www.baeldung.com/linux/pid-file#ensuring-a-single-instance-of-an-application)
