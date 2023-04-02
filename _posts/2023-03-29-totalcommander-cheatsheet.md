---
layout: post
title: Total Commander 配置使用
categories: 软件技术
tags: TotalCommander
toc: false
---

Total Commander 第一眼看上去就像上世纪的软件，也确实，它在小众圈子比较火还是 200x 年的时候，目前在它的官方论坛上还是有一批忠实的粉丝。它有一些很好用的特性：
* 双窗口布局，方便文件移动查看等操作；
* 内置大量简易而实用的 Windows 功能，可以通过自定义的快捷键调用；
* 通过 addons 和 plugins 提供额外的功能；
* 可自定义的工具栏；
* 丰富而实用的快捷键；

TC 的配置主要是记录在文件 wincmd.ini 中，里面的配置项很丰富，注意这个文件编码不是 UTF-8，而是 CP936。关于 FTP 客户端的相关信息写在文件 wcx_ftp.ini 里。

## 快捷键

在 TC 的安装根目录下有个 KEYBOARD.TXT 文件罗列着默认快捷键，下面截取一些我常用的快捷键：

|-------------------|-----------------------------------------------|
| 快捷键            |                                               |
|-------------------|-----------------------------------------------|
| F1                | 帮助文档                                      |
| F3                | 查看文件                                      |
| F4                | 编辑文件                                      |
| F5                | 复制文件                                      |
| F6                | 重命名/移动文件                               |
| F7                | 新建文件夹                                    |
| ALT+F1            | 更改左面板的驱动盘                            |
| ALT+F2            | 更改右面板的驱动盘                            |
| ALT+F5            | 打包选中文件                                  |
| ALT+F6            | 解压选中压缩包                                |
| ALT+F7            | 唤出查找对话框                                |
| ALT+left or right | 打开历史文件夹列表的上一个/下一个             |
| ALT+down          | 打开历史文件夹列表                            |
| SHIFT+F10         | 唤出右键菜单                                  |
| NUM *             | 反选                                          |
| CTRL+PgDn         | 打开文件夹以及压缩包等打包类文件              |
| TAB               | 将焦点在左右面板间切换                        |
| SPACE             | 选择焦点下的文件或文件夹                      |
| ALT+ENTER         | 打开属性对话框                                |
| CTRL+B            | 列出改文件夹下任意深度的所有文件              |
| CTRL+D            | 列出文件夹的书签列表                          |
| CTRL+F            | 连接 FTP 服务器                               |
| CTRL+M            | 多重重命名                                    |
|-------------------|-----------------------------------------------|

在配置窗口的 Misc. 项下，还配置了两个常用的快捷键：

* F2：定义为命令 cm_RenameOnly，摁一下选中不带扩展的文件名，可以改名可以复制文件名，摁两下选中带扩展的文件名；
* CTRL+SHIFT+P：定义为命令 cm_CopyFullNamesToClip，复制当前文件的完整路径和文件名；

## Addons

### F4Menu

### Tc Plugins Manager

### 搜索

[QuickSearch eXtended](https://www.ghisler.ch/board/viewtopic.php?t=22592)

TC 默认的快捷搜索输入能匹配到的字符串，并且支持拼音首字母搜索，QuickSearch eXtended 能让搜索更方便快捷，支持使用空格做“且”条件的匹配搜索。

配合快捷键 Ctrl+D x 使用效率加倍，先用 Ctrl+D x 快速跳转到一个较外层文件夹处，
如果只是直接搜索文件，就开始输入字母，在列表里就直接显示匹配后的文件，
如果需要跳转到内层某个文件夹里的文件，也一样开始输入字母，定位到首个选项为目标文件夹时，回车进入文件夹，如果还需进入子文件夹则重复上述步骤，搜索文件也一样输入字母定位；
如果需要搜索该文件夹内任意深度的子文件夹内的所有文件，一种办法是使用 Alt+F7 唤出 TC 的搜索对话框进行灵活的搜索，支持正则匹配，支持指定深度，支持匹配文件内容等，
另一种适用这种只是匹配文件名的场景的快捷方法是直接在文件夹根目录下使用 Ctrl+B 直接在列表里列出任意深度的子文件夹中的所有文件，再直接通过输入字母进行快捷搜索，两步到位 :sunglasses:。

## Plugins

[官方插件列表](https://www.ghisler.com/plugins.htm)，在论坛上有[更多插件提供](https://www.ghisler.ch/board/viewforum.php?f=6&sid=82b06e80ac2525024e8d293b42680db1)，下载插件在 TC 里打开会自动弹窗安装，手动安装就是把压缩包解压放到 TC 对应目录下，并在配置文件中加上对应的配置项，或者通过 “Tc Plugins Manager” addon 来加入配置项。
插件分为下面四大类：
* Lister Plugins，查看类插件，对应插件放在 plugins\wls 文件夹下;
* Packer Plugins，压缩类插件，对应插件放在 plugins\wcs 文件夹下;
* File System Plugins，文件系统类插件，对应插件放在 plugins\wfs 文件夹下;
* Content Plugins，内容类插件，对应插件放在 plugins\wds 文件夹下;

### Lister Plugins

Lister Plugins 是通过 TC 的 F3 来查看文件，可以配置对一些文件格式自动使用对应的插件，对应配置文件 ListerPlugins 子项，如下是我安装的七个查看插件的配置，也可以在查看器的 Plugins 菜单下手动选择。

```
[ListerPlugins]
0=%COMMANDER_PATH%\plugins\wlx\sumatrapdf\sumatrapdf.wlx
0_detect="(ext="PDF") | ([0]="%" & [1]="P" & [2]="D" & [3]="F" & [4]="-" & [5]="1")"
1=%COMMANDER_PATH%\plugins\wlx\IniEd\Inied.wlx
1_detect="ext="INI"|ext="INF"|ext="REG""
2=%COMMANDER_PATH%\plugins\wlx\AmpView\AmpView.wlx
2_detect="MULTIMEDIA | EXT="MP3" | EXT="WAV" | EXT="WMA" |EXT="OGG" | EXT="CDA" | EXT="MO3" | EXT="IT" |EXT="XM" | EXT="S3M" | EXT="MOD" | EXT="M3U" | EXT="PLS" | EXT="MID"| EXT="MIDI" | EXT="KAR""
3=%COMMANDER_PATH%\plugins\wlx\wlx_anytag\anytag.wlx
3_detect="force | (EXT="AAC" | EXT="APE" | EXT=" FLAC" | EXT=" MP3" | EXT="MP4" | EXT=" M4A" | EXT=" M4B" | EXT=" MPC" | EXT="OFR" | EXT=" OFS" | EXT="OGG" | EXT=" SPX" | EXT="TTA" | EXT="WMA" | EXT="WV")"
4=%Commander_Path%\plugins\wlx\CudaLister\cudalister.wlx
5=%Commander_Path%\plugins\wlx\Imagine\Imagine.wlx
5_detect="MULTIMEDIA"
6=%COMMANDER_PATH%\plugins\wlx\wlx_pdfview\pdfview.wlx
6_detect="ext="PDF" | ext="PS" | ext="EPS" | ([0]="%" & [1]="!" & [2]="P" & [3]="S") | ([0]="%" & [1]="P" & [2]="D" & [3]="F" & [4]="-")"
```

### File System Plugins

File System Plugins 是系统插件，通过面板上的“网络邻居”使用，对应配置文件 FileSystemPlugins 子项，如下是我安装的五个插件。

```
[FileSystemPlugins]
Environment Variables=%COMMANDER_PATH%\plugins\wfx\Environment Variables\Envvar.wfx
Registry=%COMMANDER_PATH%\plugins\wfx\Registry\registry.wfx
Startup Guard=%Commander_Path%\plugins\wfx\StartupGuard\StartupGuard.wfx
UnInstaller=%Commander_Path%\plugins\wfx\Uninstall\UnInstTC.wfx
Secure FTP=%Commander_Path%\plugins\wfx\sftpplug\sftpplug.wfx
```

### Packer Plugins

Packer Plugins 是关于压缩文件的插件，TC 里是把广义的压缩文件都当作文件夹来对待，可以直接打开，这里的广义压缩文件包含 zip,rar 之类的压缩文件，也包含 jar,iso 等，这样如果有一些压缩打包的文件格式不在 TC 支持列表里就需要安装一些插件来支持。还有就是在调用 TC 的压缩和解压窗口的时候也可以使用自己安装的插件。这种插件对应配置文件中的 PackerPlugins 子项，

```
[PackerPlugins]
iso=192,%COMMANDER_PATH%\plugins\wcx\iso\iso.wcx
7zip=95,%COMMANDER_PATH%\plugins\wcx\7zip\7zip.wcx
Chmdir=479,%COMMANDER_PATH%\plugins\wcx\ChmDir\Chmdir.wcx
7z=223,%COMMANDER_PATH%\plugins\wcx\7zip\7zip.wcx
wipe=5,%COMMANDER_PATH%\plugins\wcx\wipe\wipe.wcx
gif=287,%Commander_Path%\plugins\wcx\GifWcx\GifWcx.wcx
```

### Content Plugins

Content Plugins 是从文件中提取相关信息，在文件列表中展示这些相关信息，或者在搜索中使用，或者在多重重命名中使用，一般对多媒体文件和文件夹使用较多，对应配置文件 ContentPlugins 子项。我没有特别需求没有使用这种插件。

## 参考资料

[TC学堂——最易读的Total Commander教程](https://xbeta.info/studytc/index.htm "善用佳软")  

[totalcmd.net](https://totalcmd.net/)

[TC 官方论坛](https://www.ghisler.ch/board/)

[TC 官网](https://www.ghisler.com/addons.htm)