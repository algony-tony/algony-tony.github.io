---
layout: post
title: 用 Vim 以只读模式打开文件的几种方式
categories: 软件技术
tags: Vim
---
为了避免误操作，有时需要用 vim 以只读方式打开文件。

有几种方式可以实现，第一种 <code> view filename </code>，可以在命令行用，也可以打开 vim 后在命令模式输入，这种方式打开后可以编辑，如果写入 <code>:w </code> 会报错如下

<pre><code>
E45: 'readonly' option is set (add ! to override)
</code></pre>

此时用 <code>:w! </code> 是可以保存变更的。

还可以用 vim 的命令行参数来选择只读模式打开文件， 

<code> vim -R filename </code> 

<code> vim -M filename </code>

用 `-R` 的方式和用第一种方式一样，用 `-M` 的打开文件后不可编辑，也不可保存写入。

其实，`-R` 和 `view` 设置的是开启 'readonly'=on，`-M` 则是设置的 'modifiable'=off 参数。


### 参考
[How to open a file in vim in read-only mode on Linux/Unix](https://www.cyberciti.biz/faq/howto-open-file-tab-in-vim-in-readonly-on-linuxunix/)
