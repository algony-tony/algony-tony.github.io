---
layout: post
title: 用 Vim 查找重复行的几种办法
categories: 软件技术
tags: Vim Linux shell
---

如果你有一个文本文件，现在想看下里面有没有重复内容的行，最简单的一个思路就是先用 vim 对文本排序，再直接正则匹配前后两个内容相同的行，代码如下（下面假设已经通过 `ESC` 键进入了命令模式）：

{% highlight Vim linedivs %}
:sort
:g/^\(.*\)$\n\1$/p
{% endhighlight %}

上面第一行就是对文本排序，再解释下第二行的正则匹配内容，就是匹配一行行首 `^` 和行尾 `$` 中的所有内容 `.*` 放入第一组中 `\(\)`，接着匹配一个换行符 `\n`，紧接着把上面匹配到的第一组内容拿出来继续匹配 `\1`，最后的一个 `p` 就是把满足这个正则模式的内容高亮出来。

上面的正则只能匹配连续两行内容相同的行，如果有三行或者多行内容相同的情况只会高亮出前两行，问了下 ChatGPT 得到了一个匹配多行的代码，略复杂了一些：

{% highlight Vim linedivs %}
:g/^\(.*\)$\n\(\(.*\n\)*\)\1$/p
{% endhighlight %}

这个改进版的代码前面和前面一样，在匹配好第一行之后加了一个匹配任意内容的多行 `\(\(.*\n\)*\)`，再紧接着匹配与第一组内容完全相同的行 `\1`，这样就可以匹配多行内容了。但是这里对中间行是不做校验的，在这个问题里因为前面加了 `:sort` 排序所以是没有问题的。自己修改了下把中间行的内容也加上匹配校验也是可以的，如下：

{% highlight Vim linedivs %}
:g/^\(.*\)$\n\(\(\1\n\)*\)\1$/p
{% endhighlight %}

上面给的都是通过 Vim 的一次性的快捷操作，知道了思路后正则匹配命令基本现场就能写出来，下面是 [StackOverflow](https://stackoverflow.com/questions/1268032/how-can-i-mark-highlight-duplicate-lines-in-vi-editor) 上网友给出的高级玩法：

{% highlight Vim linedivs %}
:syn clear Repeat | g/^\(.*\)\n\ze\%(.*\n\)*\1$/exe 'syn match Repeat "^' . escape(getline('.'), '".\^$*[]') . '$"' | nohlsearch
{% endhighlight %}

如果需要经常匹配相同的行，也可以在 vimrc 文件中写成一个函数通过快捷键去调用。

换种思路，用着 Vim 应该离 Linux 也不远，那就直接用 shell 命令也一样实现起来：

{% highlight bash linedivs %}
sort <file> | uniq -c
{% endhighlight %}

上面命令会把文件中每个行和它在文件中出现的次数打印出来，如果只需要打印出重复的行就再加个参数 `sort <file> | uniq -cd`。

## 参考链接

[How can I mark/highlight duplicate lines in VI editor?](https://stackoverflow.com/questions/1268032/how-can-i-mark-highlight-duplicate-lines-in-vi-editor)