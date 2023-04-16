---
layout: post
title: Total Commander 配置使用
categories: 软件技术
tags: TotalCommander
toc: true
---

* TOC
{:toc}

Total Commander 第一眼看上去就像上世纪的软件，也确实，它在小众圈子比较火还是 200x 年的时候，目前在它的官方论坛上还是有一批忠实的粉丝。它有一些很好用的特性：
* 双窗口布局，方便文件移动查看等操作；
* 内置大量简易而实用的 Windows 功能，可以通过自定义的快捷键调用；
* 通过 addons 和 plugins 提供额外的功能；
* 可自定义的工具栏；
* 丰富而实用的快捷键，以及可自定义的快捷键；

## 绿色版 TC

要制作绿色版 TC，需要知道 TC 的启动过程，以及 TC 配置项的保存地方。

TC 的所有配置都保存在 `wincmd.ini` 文件中，里面的配置项很丰富，注意这个文件编码不是 UTF-8，而是 CP936，关于 FTP 客户端的相关信息写在文件 `wcx_ftp.ini` 里。如果你直接运行 TOTALCMD.EXE，它会到注册表中如下找配置文件的位置：

```
[HKEY_CURRENT_USER\Software\Ghisler\Total Commander]
　　 "IniFileName"=".\\wincmd.ini"
　　 "FtpIniName"=".\\wcx_ftp.ini"
　　 "InstallDir"="D:\\program\\totalcmd"
```

要跳过注册表项，可以在启动 TC 的时候通过命令行参数 `/i` 和 `/f` 手工指定配置文件，其中 `/i` 表示配置文件，`/f` 表示 FTP 服务器信息文件，不分大小写。比如，你可以用命令行来运行 TC，把这 2 个文件放到独立的目录下：

```
"d:\program\totalcmd.exe" /i="d:\conf\mytc.ini" /f="d:\conf\myftp.ini"
```

除了把参数放在命令行（以及批处理文件），还可以在快捷方式中指定配置文件的位置。（其中 `.\` 表示 TC 所在目录）：

```
"d:\program\totalcmd.EXE" /I=".\wincmd.ini" /F=".\wcx_ftp.ini"
```

但这都不是推荐的方式，从 TC6.5 开始，`wincmd.ini` 中 `[Configuration]` 一节增加了 `UseIniInProgramDir` 参数，它允许如下值（并支持相加）：
* 1, 如果未在注册表或命令行参数指定 INI，则使用 TC 安装目录下的 wincmd.ini；
* 2, 如果未在注册表或命令行参数指定 INI，使用 TC 安装目录下的 wcx_ftp.ini；
* 4, 忽略注册表的设置（但命令行参数指定的 INI 仍然优先）

上面3个数字可以进行叠加，比如说设置为 7 的话，上面三个选项同时生效。

TC 的启动过程可以这样理解：首先最优先采用运行时指定的 `/i` `/f`；如无指定，则找 TC 目录下的 wincmd.ini（仅仅是找，不一定就用）：如果有 `UseIniInProgramDir` 且值为 4、5、6、7，则忽略注册表，直接使用 TC 目录的相应 ini 文件；如果无 `UseIniInProgramDir` 或值小于4，则读注册表：注册表中指定了文件，则采用；注册表中未指定，则使用 TC 目录下的文件。

所以综上，要做绿色版的 TC，先把两个配置文件放到 TC 程序所在路径下，再修改 `wincmd.ini` 中的配置项 `UseIniInProgramDir=7`，还有要注意的是把配置文件中的绝对路径都改成代表 TC 程序安装路径的变量 `%Commander_Path%`，如指定插件的默认路径为 `pluginbasedir=%Commander_Path%\plugins`，指定默认工具栏的路径 `Buttonbar=%Commander_Path%\BARS\DEFAULT.BAR` 等等。

想让 TC 启动后就最大化？就在 TC 最大化后再从菜单栏的 `Configuration` 里点击“Save Position”，以后每次打开就都是最大化的。

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

Addons 就是一些扩展的小工具，每一个都可以独立开发，通过 TC 调用。

### 搜索

[QuickSearch eXtended](https://www.ghisler.ch/board/viewtopic.php?t=22592)

TC 默认的快捷搜索输入能匹配到的字符串，并且支持拼音首字母搜索，QuickSearch eXtended 能让搜索更方便快捷，支持使用空格做“且”条件的匹配搜索。

配合快捷键 Ctrl+D x 使用效率加倍，先用 Ctrl+D x 快速跳转到一个较外层文件夹处，
如果只是直接搜索文件，就开始输入字母，在列表里就直接显示匹配后的文件，
如果需要跳转到内层某个文件夹里的文件，也一样开始输入字母，定位到首个选项为目标文件夹时，回车进入文件夹，如果还需进入子文件夹则重复上述步骤，搜索文件也一样输入字母定位；
如果需要搜索该文件夹内任意深度的子文件夹内的所有文件，一种办法是使用 Alt+F7 唤出 TC 的搜索对话框进行灵活的搜索，支持正则匹配，支持指定深度，支持匹配文件内容等，
另一种适用这种只是匹配文件名的场景的快捷方法是直接在文件夹根目录下使用 Ctrl+B 直接在列表里列出任意深度的子文件夹中的所有文件，再直接通过输入字母进行快捷搜索，两步到位。

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

## 插件下载排名

[Totalcmd.net](https://totalcmd.net/) 是非官方的收集 TC 工具和插件的网站，里面包含很丰富的内容，下面是从网站上截取的各类插件和工具下载量排名列表，最后有拉取数据的 python 脚本。

### 工具列表

[工具列表](https://totalcmd.net/directory/util.html)下载排名

| --- | --- |
| name | download_times |
| --- | --- |
| TCIMG 32.4 | 365291 |
| TC Plugins Manager 2.2.8 | 290368 |
| QuickSearch eXtended - | 227969 |
| Ultra TC Editors 6.42 Final | 160356 |
| FTP passwords' decrypting tool 1.2 | 149126 |
| Total Updater 0.8.6.9 (Final) | 147230 |
| Tweak Total Commander 10 (zombie) | 144254 |
| TC Safe Run 1.00 | 100642 |
| Windows Commander FTP crack | 96592 |
| Open File shell for TC 1.8c | 53872 |
| NTFS Links 1.30 | 40479 |
| Vic Plugin manager 1.4.9.4a | 39766 |
| Total Calculator v4.0 PL | 38761 |
| TCShell 1.4 | 37148 |
| ChoiceEditor 1.95c | 35774 |
| TotalRun 0.3.0.0 | 34619 |
| WCX Tweak 0.5.2b | 34000 |
| Aezay TC Color Presets 1.2 build 274 | 32648 |
| WDX Guide 1.9.0 | 30584 |
| Camper 3.0 beta 1 | 30062 |
| Inireloc 20040916 | 29979 |
| Total Commander Loader 1.0 | 29926 |
| Total Commander Edit Redirector 1.4.2.0 | 28510 |
| Mbius TC Tweaker 1.0.0.42Beta | 27317 |
| TCFS2 2.4.3.584 | 26752 |
| Total Commander .ICL Toolkit 1.1 | 26750 |
| NoClose Replacer 1.3 | 25699 |
| TCFullScreen 2.0.rc1 | 25513 |
| ReloadTC 1.1 | 24944 |
| Aezay TC Script Editor 1.0 final - build 116 | 24328 |
| TCmenu 1.9 | 23885 |
| Total Commander Menu Editor 1.05 | 23250 |
| TCFS2Tools 1.4.4.216 | 22879 |
| Total Commander extDir (Utility) 1.6.0.5 | 22544 |
| LogViewer Pro 2.2.0 | 22103 |
| LaunchTC 1.03 | 21562 |
| Clear History TC 1.5 | 21488 |
| TC Commands List 1.3 | 21159 |
| FileListViewer 3.3.0 | 19950 |
| View64 1.49 | 19908 |
| FavMenu & Menu Editor 2.0 | 19842 |
| Wincmd Directory Menu Customizer 1.2 | 18934 |
| Astrolabe 1.0 beta 3 | 18674 |
| AskParam 1.0.6.152 | 18544 |
| ButtonBar eXtended 2.3 | 18344 |
| DupSelector 1.0.0.1 | 18223 |
| NTLinks Maker 1.4.1.416 | 17935 |
| Inireloc (WC) 20021029 | 16332 |
| Impomezia TC Color Presets 0.1.1 | 16244 |
| TotalSet 0.3 | 16138 |
| TCAMPER 1.0b | 16076 |
| Camp 1.4 | 15421 |
| List2Clipboard 1.02 | 15380 |
| Aezay TC FTP Checker 1.3.180 beta | 15088 |
| TC Log Viewer 1.50 Final | 14989 |
| AddTime Addon 1.03 | 14905 |
| NuCov 1.21.54 Beta RC 2 | 14862 |
| TC Restar 1.3.1.10 | 14370 |
| BarEditor 1.5 | 13901 |
| Nested Button Bar Creator 2.00 | 13894 |
| iniEditor for Total Commander 0.2beta | 13862 |
| Tinny TC Restarter 1.0.0.4 | 13820 |
| Command icon library test menu 7.00 BETA 2 | 13720 |
| Sudo 1.1.0.50 | 13559 |
| LinuxMove 1.1.2 | 13475 |
| TCALLO 1.0.b | 13248 |
| WALaunch4TC 1.1 | 13200 |
| ReDate Addon 1.04 | 13080 |
| ChoiceEditor 1.95c_patched | 13008 |
| TCsrv4dos | 12954 |
| MultiLister Configuration Tool 2.0 | 12329 |
| Playlist Tip 0.1 | 12270 |
| AmpView Skin Maker 1.0.0.5 | 12225 |
| ContentAlt 1.0 | 12092 |
| Simplest converters for MultiLister 1.0 | 11911 |
| ReDate Addon 1.1.7.2 | 11728 |
| TC User Command Converter 1.00 | 11076 |
| Full Name Launcher 1.0 | 10760 |
| ClpBrd 1.3.1 | 10442 |
| F4Menu 0.59 | 10374 |
| T2FN | 10190 |
| kIT Universal Presets 0.4.0.397 | 10051 |
| SM2BT 0.5 beta 4 | 10037 |
| TC Fav Menu 1.0 beta 7 | 9128 |
| cmdTotal 2.02 | 8842 |
| TCMetadataViewer 2.0 | 8548 |
| TCM as MSI installation 7.50a | 8237 |
| SetFolderDate 1.5 | 8202 |
| kIT TC Color Presets 1.0.0 | 8183 |
| TC Changes Viewer 2.50 Final | 8103 |
| TC History Cleaner | 8046 |
| ToFroWin 0.1.0.0 | 7825 |
| kIT Portable Launcher 1.9.3 | 7807 |
| Total Commander Application Starter 1.3 | 7735 |
| ChooseEditor 2.10 | 7472 |
| AddTime Addon 1.1.1.2 | 7306 |
| Choose Media Player 1.53 | 7070 |
| Exe2Bat | 6059 |
| TC Logfile Viewer 0.3 | 5715 |
| List to MultiInstance 2005 | 5183 |
| WideActivePanelTC 0.3 | 5129 |
| ViATc 0.4.1 | 5030 |
| TCBL 1.04 | 4914 |
| Fix Time 1.11 | 4843 |
| TotalMouseEx 0.7 | 4658 |
| Wlx2Explorer 1.2.1 | 4596 |
| NewFiles 2.0.1.0 & 2.1.0.4 | 4417 |
| TCBgColors | 4372 |
| TCFullScreen | 3450 |
| BarPanel 3.0 | 3285 |
| WDX Guide 2.0.6 | 2888 |
| decTC32Host 2014.06.17 | 2522 |
| Copy file contents to the clipboard 1.0 | 1936 |
| TCbarGen 1.3 | 1715 |
| Command-line Compression Utilities 1.0 | 1654 |
| tacklebar | 1537 |
| BarToLnk 1 | 1484 |
| Total Commander Send/Receive 2.2 | 1477 |
| TCbarGcmd 1 | 1439 |
| NoCancel 1.0.1 | 1240 |
| ViATc 0.5.5 | 1213 |
| TCCD 1.0 | 410 |
| Download Torrent 2.0 | 3   |
| --- | --- |

### FS Plugins

[File system plugins](https://totalcmd.net/directory/fsplugin.html)下载排名。

| --- | --- |
| name | download_times |
| --- | --- |
| Android ADB 8.7 | 369673 |
| Virtual Disk 1.3.3 Final | 282080 |
| SFTP plugin 1.4.67.4 | 194906 |
| Uninstaller 1.8.1 | 185248 |
| Registry 5.2 | 163949 |
| WinCE 2.2 | 155986 |
| CD/DVD Burning Plugin 0.9.3 | 142125 |
| Ext2fs+Reiser 1.6 | 130075 |
| LAN Seeker 0.31 | 107862 |
| PluginManager 2.6 | 102864 |
| AceHelper 0.3.7 | 101823 |
| MotoPK 0.4 | 97204 |
| SFTP 1.04 | 93574 |
| VirtualPanel 2.0.7.1372 | 84653 |
| T-PoT 1.3 | 80115 |
| DiskInternals Reader 1.9.3 | 79456 |
| Startup Guard 0.5.1 | 78703 |
| Services 2.4 | 77244 |
| Device Manager 1.4 | 75813 |
| TConsole 2.7 | 75354 |
| CD-Ripper 1.6.1 | 72289 |
| ProcFS 2.0 | 68954 |
| MSIE Cache Browser 1.4.4.2 | 68247 |
| WebDAV 2.5 | 66870 |
| NokiaFS 0.0.1.4 | 66803 |
| NetworkAlt 0.2 | 66348 |
| ADO Data Sources 1.6 | 65761 |
| CanonCam 1.7 | 63601 |
| TotalAndDroid 4.0 | 62940 |
| VNavigator Siemens Obex File System 1.7.7 | 62848 |
| CDDataBase 4.00.2657.0 Release | 61259 |
| Complex TC burner 3.70 | 60802 |
| Calendar 1.02 | 59446 |
| decClipboardFS 3.6 | 57850 |
| Shared Files 1.0.2 | 57546 |
| SYMBFS 0.4 | 53479 |
| NTFS4TC 1.0 | 52646 |
| Environment Variables 1.3.0.222v | 51877 |
| RedDetect 16.03.2013 | 51699 |
| MAIL_WFX 0.99b6 | 50367 |
| Neropanel 0.0.4b | 48989 |
| badcopy 1.0.0.4 | 47650 |
| ext4tc 0.17 | 46798 |
| TWinAmp2 1.5.2 | 44542 |
| Google Drive for Total Commander 0.10 | 43597 |
| HTTP 1.04 | 42520 |
| Back2Life 2.7 | 42317 |
| SGHFS 1.3 | 42044 |
| POP3&SMTP 1.2 | 41783 |
| TC Services 1.0.0.0 | 41311 |
| FSClipboard 2.0b | 40895 |
| File Redirector 5.4 | 40117 |
| Siemens DES 1.1.0.0 | 39373 |
| iPod | 38795 |
| TCRadmin beta 3.1e | 38427 |
| TWinAmp 1.8.2.9 debug | 36343 |
| RamCopy 1.3 | 35577 |
| RSS Reader 0.7 | 35394 |
| MS SQL Servers 1.3 | 35256 |
| PassStore 0.61 | 34321 |
| Services2 0.8.1 | 34097 |
| photofile 2.6.0 | 32245 |
| TotalConsole 0.5.2.1 | 31665 |
| FSNetStat | 31564 |
| HTTP_SmartBrowserPlugin 1.1 | 30969 |
| FTP over SSL/TLS 0.1 alpha | 30776 |
| Serial 1.0 | 29551 |
| TurboRegistry 1.02 Beta | 29403 |
| NTFS FileStreams 1.0 | 28693 |
| FSNetShare 0.11b | 28357 |
| Events NT 1.3 | 28219 |
| Privileges 1.01 | 28104 |
| Windows Media Audio 2 1.2 | 28096 |
| FTP List 0.6 | 27916 |
| SIFS 1.1 | 27839 |
| EFS 1.1.2 | 27545 |
| CVSBrowser 1.2.0 | 27415 |
| MirandaFS 0.0.4.1 beta | 26655 |
| Versions 1.51 | 26112 |
| TipTop 1.0 | 25731 |
| Uninstall 1.0 | 24963 |
| TMedia 0.1.D | 24934 |
| Temporary Panel 1.0 | 24395 |
| CPL 1.0 | 24235 |
| TempDrive 1.5 | 23937 |
| tcPhonebook 0.9.5.2 | 23426 |
| Uninstaller64 1.0.1 | 23372 |
| S.T.A.L.K.E.R. db explorer 0.0.4 | 23011 |
| Environment Variables Ex 1.0 | 22795 |
| Wipe plugin (FS) 0.1 | 22451 |
| TWinAmp3 3.02 | 21843 |
| wfx_iOS 1.3 | 20389 |
| FTP monitor 1.1 beta 2 | 20377 |
| MKS Integrity Browser 1.0.8.1 | 19910 |
| DialPWD 1.0 | 19467 |
| Bluetooth OBEX Object Push 1.2.1 | 19413 |
| T-PoT 1.1 | 17848 |
| Perl FS 1.05 | 16886 |
| TestFTP 0.5.1 | 16642 |
| Iriver Storage 2.2b | 16553 |
| Visual SourceSafe 0.4 Beta | 16184 |
| ScriptWFX 1.3 | 15985 |
| Diamond Rio PMP300 0.2b | 15637 |
| HPLX 1.2 | 14906 |
| Ghisler SFTP Plugin 1.4.1 | 14765 |
| NTFS FileStreams 2.0.6 Beta | 14567 |
| Startups 0.4.0 | 14407 |
| procViewer 1.5.1 beta | 14198 |
| FDC TC 28.04.2008 | 13968 |
| WIACam 1.12 | 13964 |
| CVSBrowser_1.0.4.zip 1.0.4 | 13904 |
| Mpio 0.1 | 13853 |
| System Events Ex 1.0.3 | 13764 |
| MP3Commander 0.1.0.70 | 13754 |
| HTTP Browser 1.2.1 | 13159 |
| RadminPlg 3.27 (19.09.2013) | 13125 |
| iPlugin | 12863 |
| DotNet Wrapper 0.4 beta | 12590 |
| CoRegistry 1.1.0.0 | 12307 |
| OperaFS 0.5 | 11757 |
| Branch View Extended 1.03 | 11649 |
| wfx_Opera | 11607 |
| Temp drive | 11441 |
| S3 Browser 1.9.5 | 11232 |
| WinWalk 0.0.0.3-alpha | 10785 |
| RedLOCK \[01.04.2013\] | 10706 |
| Link drive | 10170 |
| Tweak Collector 1.25l | 9830 |
| RedGUARD \[13.03.2013\] | 8598 |
| Brew Mobile Plugin 0.2.0 beta | 8214 |
| EFS2splugin 0.9.3 | 8190 |
| Transformer Framework 1.0 | 8145 |
| RadminPlg64 1.0.0 | 8139 |
| CVSBrowser_1.0.3.zip 1.0.3 | 7799 |
| Sequences 0.10 | 7773 |
| EnsoniqFS 0.57 BETA | 7739 |
| Versions 2.0.2 | 7587 |
| Total Upgrade 1.0.2.0 | 7381 |
| XBox DVD 1.2 | 7381 |
| wfx_ONotes | 7258 |
| AGacVEd 1.0.1 | 6430 |
| WFX HTTPS Browser 1.1 | 6421 |
| OPC DA 1.0 | 6417 |
| Delicious Posts 2.5.1 | 6316 |
| DocClassifier 1.6 | 5681 |
| REB1100 0.2 | 5595 |
| RedClipboard 16.04.2019 \[08.29\] | 5557 |
| RamCopy 1.3.1.1 | 4906 |
| MP3 Database 0.9 Beta | 4450 |
| cpmimg 0.7 | 4192 |
| AzureBlob 0.3 Alpha | 4098 |
| FB2Lib 0.6 | 4032 |
| TFS Version Control 1.0 | 3996 |
| RedSmart 15.04.19 \[08.29\] | 3826 |
| RedOHM 19.06.19 | 3229 |
| RedOneC 16.08.2019 | 2596 |
| MSIE Cache Browser 1.4.4.2 | 2150 |
| CloudMailRu | 237 |
| Privileges 1.01, 28104 |     |
| --- | --- |

### Lister plugins

[Lister plugins](https://totalcmd.net/directory/lister.html)下载排名。

| --- | --- |
| name | download_times |
| --- | --- |
| Imagine 1.1.4 | 408142 |
| xBaseView 10.0 | 311486 |
| Mmedia 2.62 | 202569 |
| FileInfo 2.23 | 197955 |
| ICLView 26.3.2022 | 194590 |
| OpenOffice Simple Viewer 1.2.0 | 179270 |
| AmpView 3.3 beta 3 | 176176 |
| SynWrite 6.40.2770 | 169435 |
| SGViewer 1.9.3.1 | 164421 |
| OpenOffice/DOCX/FB2 Viewer 1.7.2 | 146443 |
| SQLite Viewer 2.17 | 136647 |
| PDFView 1.09 | 125592 |
| Excellence 1.20 | 124478 |
| SWFView 1.4.1 | 120418 |
| 2D CAD View Plugin: DWG DXF HPGL SVG CGM 9.1.5 | 103195 |
| EML Viewer 0.6 | 100879 |
| SWF Lister 2.0 | 95524 |
| Multimedia Factory 0.8.3 | 89624 |
| tcCalendar 2.0u10 | 86675 |
| ListDoc 1.2 | 80606 |
| IEView 1.94a | 80306 |
| TTFviewer 0.1.2.4 | 78629 |
| Office2007wlx 0.0.6.2 | 76691 |
| PE Viewer 2.0 | 75200 |
| Boot Screen View 1.1 release | 72264 |
| ArchView 0.9.1.2 | 72263 |
| VisualDirSize 1.2 | 71658 |
| MATLAB MAT-file Viewer 1.6.13.0 | 69997 |
| DjvuList | 69061 |
| MultiLister (former PDF Filter) 1.50a | 66830 |
| Office 1.1 | 66694 |
| NFO View 1.5 | 66166 |
| TCTorrent 2.1.3 | 65018 |
| anytag 0.97 | 64828 |
| sLister 1.1.2 | 62912 |
| uLister 4.0.0 | 62761 |
| 3D File viewer 2.040524 | 62356 |
| Media Show 0.9.5 | 60658 |
| File Thumbnails 1.0.2 | 57924 |
| Sumatra PDF based plugin 0.8.1 | 56227 |
| FlashView 1.4 | 55097 |
| Autodesk 3ds Max Preview 1.3.0.1 | 54963 |
| LinkInfo 1.52 | 49917 |
| CSV Viewer 0.6.1 | 49748 |
| TxQuickView 1.30 | 48550 |
| DSView 1.3.1 | 46930 |
| Syn 1.5 | 43144 |
| Audio Tag View 1.6 | 42752 |
| IniEd 2.0 | 42326 |
| ActivePDFView 1.0 | 40423 |
| decThumbsDBViewer 4.7 | 40258 |
| PhotoViewer 0.18 Beta | 39388 |
| Office2007wlx_64 0.0.6.5 | 39229 |
| FileView v2.0 alpha | 38432 |
| Torrent 1.3 | 37098 |
| SWF Lister lite 1.5 | 37097 |
| edt-pack for tcCalendar 22.12.07 | 37072 |
| SolidWorks Preview 1.3.0.1 | 35831 |
| DBF-view 1.20 | 35810 |
| BaseView 1.2 | 35204 |
| CudaLister 1.8.1.0 | 34778 |
| AppLoader 0.9.6.3 | 34458 |
| AKFont 2.8.1 | 34442 |
| gswlx 0.2 beta6 | 34287 |
| Imagine (beta) 1.0.0.0 beta 10 | 33557 |
| SVGView 1.4.5 | 32715 |
| CDRView 0.95 | 32468 |
| ArcView 1.2.0.28 | 32467 |
| GisLister 1.0.4 | 32283 |
| EventLog 2.5 | 31092 |
| SynUs 1.6 | 31012 |
| Font 0.08 | 30491 |
| SynWrite x64 Edition 3.0.610 | 30292 |
| GDBView 0.0.3 | 30053 |
| WebView 0.7 | 29927 |
| LogViewer 1.1.2 | 29425 |
| Imgview 2.0 | 28502 |
| IEView 1.0 | 27895 |
| HTMLView 1.1 | 27763 |
| MP3 TAG editor 1.1 | 26977 |
| CDR thumbnail 1.0 | 26183 |
| ruDwgPreview 1.1 | 25898 |
| TorrentLister 0.02 | 25612 |
| mplayer4tc 0.2 | 25611 |
| Wise Tracker 2.2 | 25366 |
| TotalHLT 1.7.0.160 | 24377 |
| ImageLister 1.00 | 23979 |
| MyViewPad 4.1 | 23461 |
| hpg_ed 0.5.13 | 23407 |
| URL Shortcut Viewer 1.1.1.0 | 23310 |
| SMViewer 1.4.1 b | 23174 |
| CSV View 0.9.5.5 Beta | 22062 |
| SystemInfo 3.0 | 22016 |
| PdbView 0.1.1 | 21423 |
| mp3tag 0.98 | 20525 |
| SyntaxColorizer 1.1 | 20231 |
| GDBViewer 0.1.0.0 | 20220 |
| decFastThumbs 1.9 | 20051 |
| AmpView Classic 1.1 RC5 | 19965 |
| XSudoku 1.2.0.2 | 19384 |
| SymbolView 2.1.2 beta | 19347 |
| RedCell \[22.03.2013\] | 19293 |
| RedDOC \[02.04.2013\] | 18744 |
| Modelviewer | 18742 |
| IniView 1.2 beta | 18447 |
| AnyELF 1.6 | 18341 |
| EMLView 1.2.6.5 Beta | 18280 |
| MXP Lister 1.2 | 18097 |
| AmpView Lite 1.2 | 17972 |
| ANSI viewer plugin 2016-10-09 | 17831 |
| DmpView 0.2.3 | 17708 |
| RVLister 2.1 | 17532 |
| Putty | 16898 |
| scrlist 1.0 | 16768 |
| inSCR 4.0 | 16707 |
| Firebird DB Viewer 0.9.4.3 Beta | 16694 |
| TC Jad - Java Decompiler Plugin 1.1 | 16677 |
| Script plugin-maker 0.5.1 | 16632 |
| JSON Viewer 1.3.1 | 16570 |
| Rhinoceros Preview 2.0.0.0 | 16470 |
| WhoOpenDoc 0.3 | 16361 |
| eBookInfo WLX 2.4.1.0 | 16205 |
| OriginView 1.20 | 16180 |
| Playlist 1.06 | 16142 |
| NFOViewer 0.8 | 15819 |
| DBLister 2.01 | 15805 |
| Flic 1.0.0.0 | 15675 |
| wLx_SQLLite 17.02.2009 | 15459 |
| IEWebLister 1.01 | 15064 |
| JccView 5.3.1.2 | 14907 |
| Scintilla Lister 0.1.1 | 14836 |
| DBFViewer 1.4.2 | 14646 |
| tLister 1.2.0 | 14500 |
| TC IrfanView Plugin 2.54 | 14455 |
| WaveView 1.0.0 | 14290 |
| DVI Simple Viewer 1.0.0.1 | 14269 |
| Winamp Playlist Lister 1.01 | 13957 |
| ActiveSnapView 1.0.1 | 13831 |
| CBxThumbs 0.24b | 13281 |
| LogTail 0.1.1.12 | 13240 |
| decFLTViewer 1.1 | 12675 |
| TCPlayer 1.05 | 12635 |
| Multimedia Factory Preview 0.9 | 12494 |
| DirSizeCalc Charts 1.10 | 12360 |
| XML Review 3.5 | 12239 |
| Mathematica Link 1.0.1.0 | 12093 |
| sLister - view more file formats | 11958 |
| WDXGuideInLister 1.01 | 11775 |
| WSZView 2.95.522 | 11603 |
| MD2wlx 1.0 | 11461 |
| PalmDump 0.02 beta | 11345 |
| sqlite-wlx 1.1.3 | 10855 |
| RedHTML 2013.03.22 | 10756 |
| mthumbs.wlx 20210405 | 10576 |
| Access DB Viewer 1.3.2.2 | 10003 |
| SVGwlx 0.0.2 | 9989 |
| TC IrfanView Plugin 1.72 | 9768 |
| CharsOccurrences 1.7.2 | 9698 |
| AnyCmd 1.2 | 9688 |
| GSA Lister 1.02.2 | 9685 |
| ruDWGPreview New 1.0 | 9677 |
| XML Viewer 1.0.2.1 | 9659 |
| GSF View 1.0 | 9526 |
| xmltab 1.0.5 | 9517 |
| csvtab 1.0.3 | 9458 |
| WLX Markdown Viewer 2.3 | 9387 |
| DMF Lister 1.0 | 9125 |
| MP3 Tag View 1.1.1 | 9039 |
| jsontab 1.0.5 | 9009 |
| tcCalendar 1.3 - German files | 8870 |
| Folder Picture 1.2.4 | 8743 |
| MKInfoLS 1.0.5 | 8608 |
| inAlasm 3.01 | 8599 |
| odbc-wlx 1.0.4 | 8490 |
| DDS\_DD\_Plugin 05.06.2006 | 8331 |
| wlx_fb2 2.2 | 8326 |
| dirtyJOE 1.5 (c359) | 8090 |
| WDXGuideInLister64 1.04 | 7624 |
| decJsgWLX | 7484 |
| HexViewer 1.1.1.1 Beta | 7395 |
| M3U view | 7243 |
| PdbView 2 - 1.1 | 7163 |
| RtfHtml | 7036 |
| Aml View 2.02 (2016.06.12) | 6626 |
| AKPic 1.6 | 6591 |
| APlayer v0.1 | 6406 |
| ObjView 1.2 | 6274 |
| CertView 2.5.1 | 6141 |
| PictViewer | 6034 |
| decMetaExpertWLX 1.4 | 5985 |
| decMaffWLX 2015.03.21 | 5870 |
| decWinCodecWLX 1.1.0.2 | 5311 |
| mplayer4tc 0.3.1.1 | 5092 |
| DataView 0.5b | 5080 |
| Modules Player 0.3 | 4629 |
| decID3WLX 2014.12.08 | 4595 |
| Dune aai 1.0.1 | 4492 |
| listtap 0.2.4.2 | 4245 |
| Total DICOM Lister 2.0.0 | 4012 |
| GisViewer 1.0.1.0 | 3998 |
| ArchView 0.9.3.0 | 3992 |
| Autodesk Revit Preview 1.0.0.3 | 3845 |
| wlx_fb2 1.11 | 3825 |
| QtUiViewer 1.0.0.0 | 3690 |
| MarkdownViewer 0.2 | 3221 |
| LookFits 1.0.1 | 3096 |
| ExifToolView 1.2 | 2837 |
| Nothing 1.0 | 2495 |
| Autodesk Inventor Preview 1.0.0.2 | 2450 |
| unhide-wlx 0.9.4 | 2394 |
| Solid Edge Preview 1.0.0.1 | 2084 |
| TC ModPlug Plugin 1.3 | 1940 |
| NTFS Stream Viewer 0.9.1 Beta | 1793 |
| WLX Edge Viewer 1.0.0 | 806 |
| TCSumatraPDF Plugin 1.0 | 646 |
| --- | --- |

### Packer plugins

[Packer plugins](https://totalcmd.net/directory/packer.html)下载排名。

| --- | --- |
| name | download_times |
| --- | --- |
| 7Zip Plugin 0.7.6.6 | 563816 |
| Total7zip 0.8.5.6 | 292753 |
| ISO 1.7.4 beta 1 | 205250 |
| Game Archive UnPacker 0.6.0.3 PRO | 195819 |
| CHMDir 0.41-alpha | 111894 |
| DiskDir Extended 1.68 | 92261 |
| InstallExplorer 0.9.2 | 91233 |
| DarkCrypt IV 2013.03.16 | 86774 |
| 7z plugin 1.0.1.0 | 85418 |
| ICLRead 1.5.4.4 | 78886 |
| MhtUnPack 2.2 | 73467 |
| Resource Extractor 1.1.1 | 70591 |
| MPQ Plugin 1.6.0.104 | 68396 |
| audioconverter 0.992 alpha 1 | 63532 |
| MSI Plus 0.5 | 54044 |
| CopyTree 1.3.0.328 | 52056 |
| MSI 1.2.1 | 51930 |
| DBX 1.2 | 49837 |
| TotalISO 1.0.0.155 | 49430 |
| Blat Mailer 1.3.4.1 | 47565 |
| CatalogMaker 4.1.3 | 47046 |
| Access Viewer 0.7.1 | 41105 |
| InstallExporer Port 2004-06-04 | 40108 |
| TreeCopyPlus 1.051 | 37888 |
| 7Zip Plugin 0.6.4 | 37345 |
| MHT Unpacker 0.1.1 | 36503 |
| AES encryptor plugin 0.6.3 | 36396 |
| 7zip Plugin 0.7.2.1 | 35835 |
| DirCopy 1.10 | 32322 |
| WdxInfoPacker 1.4.1 | 32035 |
| AVIWCX 1.9 | 31716 |
| IShield 0.9.1 | 31587 |
| Graphics Converter 1.81 | 31353 |
| BZIP2 1.5 | 29480 |
| Graphic Converter 1.8.6 | 28416 |
| TotalObserver 1.2.0 | 27946 |
| PUZZLE 3.04 | 27631 |
| UnLZX 2.2 | 27614 |
| ISO 1.7.7 beta 4 | 27345 |
| RPM(+cpio) 1.5 | 27271 |
| GIFWCX 1.3 | 26183 |
| NSCopy 2.2 | 26177 |
| Total SQX 2.11 | 26165 |
| DiskDir 1.3 | 26146 |
| Checksum 0.2b | 24970 |
| targzbz2 0.02 | 24504 |
| Wipe plugin 0.2 | 23734 |
| IMaGinator 1.6 | 23684 |
| SIS 0.91 | 23684 |
| Far2wc 1.3 | 23240 |
| S.T.A.L.K.E.R. db unpacker 0.0.3 | 22915 |
| Wcrez 1.0.1.1 | 22885 |
| HA 1.1.0 | 22711 |
| TotalRSZ 2.5 | 22701 |
| Z Archiver 1.0 | 22574 |
| alz Unpacker 0.1i | 21551 |
| PSARC 1.4 | 21297 |
| Mbox 1.10 | 21210 |
| WordArc \[27.02.2013\] | 21153 |
| CopyLinkTarget 1.10 | 21093 |
| Total Converter 2.0.1 | 20462 |
| Treecopy 1.3 | 20417 |
| Imaginator 2.0 (2010) | 20233 |
| AmigaDX 3.3 beta | 20217 |
| MakeBat 1.3 | 20142 |
| IMG 0.9 | 20060 |
| Disc Maker 1.1 | 20000 |
| DEB 1.0 | 19571 |
| DIRCBM 0.12 | 19547 |
| Cab Packer | 18743 |
| DSP Plugin | 18153 |
| inTRD 6.52 | 17917 |
| Mod2Wav 0.5 beta | 17825 |
| KillCopy plug-in for Total Commander 0.9 alpha | 17756 |
| Cryptonite 1.0 | 17358 |
| RegXtract 1.6 | 17353 |
| Webshots plug-in for Total Commander 0.981 | 17322 |
| CabCE 2.0 | 17300 |
| Disk Explorer Professional Database Viewer 1.3 | 17256 |
| inSCL 6.52 | 17181 |
| DiskDirW (Unicode) 1.2.4 | 16856 |
| WADFile 1.0 | 16519 |
| HLP/MVB 1.0.2.0 | 16281 |
| UnImz 1.0 beta | 16152 |
| XBox ISO Plugin ver 1.4 | 15950 |
| umod.wcx 0.0.6 | 15686 |
| H4R 1.1 | 15493 |
| FileFactory 0.3 beta | 15486 |
| StegoTC 2012.01.03 | 15231 |
| Operation Flashpoint PBO 1.0 | 15231 |
| GPAK 0.1 (beta) | 15062 |
| Z4 Archive plugin 0.9.7 | 14847 |
| MultiArc MVV Build 1.4.3.162 | 14790 |
| PACK 1.1 | 14521 |
| fhRAR 0.1 | 14512 |
| ExtrKarText 0.1 | 14295 |
| Heroes III wcx Pack 1.0 | 14250 |
| ert_wcx 0.9.2 | 14247 |
| CreateHardLink 1.0.0.1 | 14194 |
| SFF 1.2 | 14073 |
| ivtdir 0.3 | 13976 |
| ATR.wcx 0.5 beta | 13876 |
| Lib 1.1 | 13850 |
| GRP 1.02 | 13712 |
| D64 0.2 | 13588 |
| PPMd 1.0 | 13482 |
| btdir 0.1 beta4 | 13201 |
| Kryptel 8.0.2.0 | 13200 |
| TRD 1.0 | 13191 |
| LZOP 1.0 | 12724 |
| BFC 0.9.2 | 12397 |
| SCL 1.0 | 12302 |
| PPMPackTC 2010-07-14 | 12214 |
| PL Plugin 1.2 | 12114 |
| UFO VFS plugin 0.1 | 12112 |
| ICQScheme 2.0 (OpenSource) | 12106 |
| decStorageWCX 1.0.1.15 | 12101 |
| BMC 0.2 (alpha) | 11633 |
| RPM_64 1.7 | 11541 |
| ZPAQ 1.5.5 | 11464 |
| LISP packer plugin 1.1 | 11422 |
| Novell DSView 1.0 | 11366 |
| iniPacker 1.0 | 11297 |
| Operation Flashpoint PBO Plugin 0.81 beta | 11228 |
| UnPSF 1.1 | 11201 |
| ICO wcx plugin 0.1 | 11164 |
| WCReg_patched Packer Plugin 1.4 | 11154 |
| LowTraffic v2.0 | 11154 |
| Power Packer 1.0 | 11090 |
| UnArkWCX 1.0 | 10946 |
| Mover 0.1 | 10681 |
| Red JPEG XT \[06.02.2013\] | 10595 |
| Webcompiler Unpacker 1.0 | 10433 |
| TOW 0.1 beta | 10313 |
| Java Class Unpacker 0.7.1 | 9833 |
| CPIO_64 1.6 | 9787 |
| LZOPackTC 12.02.2013 | 9774 |
| fobia 1.2.1 | 9657 |
| WebArc 0.01 | 9358 |
| xz 1.0 | 9130 |
| PalmDB zTXT Plugin 1.1 | 8679 |
| MHTep | 8551 |
| executor.wcx 0.0.0.5 | 8534 |
| SSSR TC 12.10.2011 | 8216 |
| Sure Copy 20.03.2008 | 8092 |
| JustZip 21.10.2011 | 7972 |
| decJpegWCX | 7740 |
| TotalZAR 2 | 7552 |
| MSC 0.1 | 7511 |
| alz Unpacker 0.65 | 7510 |
| inHrust 2.10 | 7503 |
| ABC-TC 14.02.2013 | 7385 |
| LineCount 0.3 | 7347 |
| AES plugin 0.6.3 \[64-bit port\] | 7165 |
| wcx_fb2 1.0 | 7139 |
| JustBZLP 24.10.2011 | 7105 |
| English Mover wcx plugin 1.0a | 7104 |
| ICONew 1.0 | 7090 |
| UkrPack TC 18.02.2013 | 7017 |
| X3 resource browser/unpacker 1.0 beta 2 | 7005 |
| GCA plugin 0.1beta | 6963 |
| ELKA TC 12.10.2011 | 6938 |
| UCComp TC 12.10.2011 | 6892 |
| APLibTC 14.02.2013 | 6772 |
| LZRComp TC 12.10.2011 | 6755 |
| LZ8Comp TC 18.02.2013 | 6674 |
| dar wcx 4.2012 | 6640 |
| StegoTC G2 2012.01.03 | 6492 |
| GCF 1.1 | 6229 |
| EnsoniqUnpackerEFE 1.23 | 6145 |
| EnsoniqUnpacker 1.23 | 6121 |
| fb2wcx 1.0.3 | 6112 |
| LibView 1.1 | 6070 |
| tthGen 0.2 | 5958 |
| fb2wcx_64 1.0.3 | 5785 |
| SetFolderDate 1.3.0.0 | 5692 |
| deb_64 1.0 | 5497 |
| WCX_PDB 0.6 | 5496 |
| MS-Compress Packer Plugin 1.0 | 5475 |
| lzma 2.1 | 5370 |
| MATLab plugin 1.83 beta | 5344 |
| PDB_PRC 1.0.0.8 | 5275 |
| RAF packer 1.2 | 5207 |
| Zstandard packer plugin 1.1.3.5 | 5072 |
| RisenPak 1.0 | 5068 |
| LZOP plugin \[12.02.2013\] | 5001 |
| PDUnSIS 1.0 | 4982 |
| inTAP 0.71 | 4652 |
| Zip2Zero 1.0.1.0 | 4607 |
| LTAR 1.0 | 4551 |
| decRegWCX 2014.07.07 | 4543 |
| BS-DOS support bundle 2015.05.10 | 4427 |
| AlbumPack 1.03 | 4382 |
| decMpoWCX 2016.09.21 | 4157 |
| Windows Media Audio 1.0 | 3931 |
| Mover 2.0.0.2 | 3902 |
| wcx_storage 1.0 | 3061 |
| Hard Link meta-packer 1.0 | 2972 |
| Audioconverter 1.0 | 2847 |
| urlData 0.1 | 2553 |
| KillCopy plug-in 0.9.1 alpha | 2134 |
| Thousand Types (packer plugin version) 1.0 | 2132 |
| DiskDirCrc 1.1 | 2009 |
| Webshots 0.99 | 1992 |
| Java Decompiler 1.1 | 1879 |
| M3U/M3U8 1.0.0 | 1759 |
| Wcrez 2.0 | 1724 |
| casMSXwcx 1.3 | 1697 |
| ICQScheme 2.0.2 | 1494 |
| --- | --- |

### Content plugins

[Content plugins](https://totalcmd.net/directory/content.html)下载排名。

| --- | --- |
| name | download_times |
| --- | --- |
| DirSizeCalc 2.22 | 138485 |
| ShellDetails 1.26 | 86403 |
| File Descriptions 2.6.2-x32 / 1.2.3-x64 | 71709 |
| ImageMetaData for JPG comment, Exif, IPTC and XMP metadata 2.4.0.0 | 64806 |
| Translit_wdx 1.6 | 57743 |
| ImgSize 2.03 | 54710 |
| TextSearch 1.6.4 | 52295 |
| UnicodeTest/LockedTest 1.2.3 | 48538 |
| xPDFSearch 1.11 | 47402 |
| AudioInfo 2019.04.17 | 45871 |
| super_wdx 2.2 beta | 41180 |
| FileX 2.2 | 37197 |
| anytag.wdx 1.00 | 35806 |
| MediaInfoWDX 2.03 | 35476 |
| WDX for Images 0.5 | 35384 |
| Filename ChrCount 2.02 | 34628 |
| Exif 2.3 | 33337 |
| Exif plugin 1.47b | 33108 |
| Media 0.6.1 | 32331 |
| NTLinks 1.6.0.244 | 31730 |
| Autorun 2.1.1 | 28747 |
| Opera_Cache 1.2 | 28116 |
| LotsOfHashes 1.4 | 26741 |
| NL_Info 1.20 | 23301 |
| Image Info 1.42 | 23248 |
| CDocProp 1.10 | 23050 |
| FileDateTime 2.07 | 21231 |
| SWF Content 1.2 | 20851 |
| OpenOfficeInfo 1.3.0 | 20708 |
| Translit_wdx 2.0.4.1 | 20690 |
| Script Content Plugin 0.2.0.2 | 20668 |
| ExeFormat 0.6a | 20668 |
| wdx_exeinfo 1.10 | 20079 |
| wdx\_global\_diz 0.8b2 | 18894 |
| File 1.30 | 18604 |
| WDXTagLib | 18542 |
| Fast Fb2 wdx 1.2.14 | 17971 |
| Torrent_wdx | 17907 |
| Directory 1.10 | 17783 |
| Security Info 1.0.1 | 17682 |
| id3 1.2 | 17024 |
| Content plugin JPG-Comment 2.0 | 16946 |
| crc32tag 0.25beta | 16466 |
| MP3Info 1.9 | 16257 |
| APK-wdx 2.1 | 15988 |
| TCMediaInfo 1.0.7 | 15530 |
| RedHat Linux package content plugin 1.0.0 | 15460 |
| Shortcut 2.10 | 14768 |
| Debian Linux package plugin 1.02 | 14751 |
| DateNames 1.03 | 14749 |
| Simulink 1.1.1.0 | 14562 |
| RarColumns | 13387 |
| XPIInfo 1.1d | 13381 |
| EML info 0.9 | 13315 |
| Office2007wdx 0.0.3 | 13250 |
| wdHash 1.0 | 13164 |
| Summary 1.10 | 13026 |
| regexp_wdx 0.1.0.4 | 12536 |
| CDR info 0.3 (11) | 12471 |
| Permissions 1.11 | 12423 |
| RarInfo 0.9 beta | 12183 |
| NTFS Descriptions 1.2.1 | 12173 |
| SVNdetails 3.10 | 12128 |
| expander 0.1 | 12078 |
| MediaInfo 22.03 | 11976 |
| URL Grank 1.0.1.0 | 11931 |
| TypeLib Info 1.0 | 11383 |
| ExifToolWDX 1.04 | 11365 |
| EML New 1.3.1 | 11229 |
| TrID 0.1 | 11219 |
| Age 1.04 | 10903 |
| Total SQX Content 2.1 | 10273 |
| Palm DB File info content plugin 1.0 | 10248 |
| readGbx 1 | 9838 |
| MIDlet 1.0.2 | 9724 |
| decID3WDX 2.0 | 9261 |
| 7zip info 0.2.3 | 9170 |
| PCREsearch 2.5 | 8907 |
| NTFS Stream 1.0.1.59 | 8699 |
| eBookInfo WDX 1.0.4 | 8631 |
| Expander2 0.5.1 | 8628 |
| wdx_Eml | 8569 |
| ExeFormat_64 0.6c | 8539 |
| NTFSFileStreams.wdx 1.5 | 8452 |
| Office2007wdx_64 0.0.3.1 | 7990 |
| SEO HTML 2.0 | 7892 |
| HashSys 0.2 | 7868 |
| Text Line 1.1.0 | 7739 |
| cputil 1.2 | 7623 |
| MediaTime 1.1 | 7618 |
| Tempus 1.01 | 7595 |
| Misc 1.06 | 7443 |
| MhtUnPack 2.2 | 7212 |
| Similarity 0.02 | 7200 |
| ZipType 1.0 | 7093 |
| EmptyCheck 1.0.0.0 | 6942 |
| Fast Fb2 Epub 2.8.2 | 6899 |
| CDA File Info 1.0 | 6795 |
| Group Sort 0.8.2b | 6754 |
| WinScript Advanced 1.7 | 6726 |
| SVGwdx 0.0.1 | 6681 |
| EncInfo 1.2.1 | 6628 |
| AKFontInfo 1.5 | 6490 |
| MKInfoCP 1.0.3 | 6456 |
| Image 1.10 | 6454 |
| AKMedia 2.3 | 6295 |
| SWF Content New 1.0 | 6272 |
| RegInfo 21.05.2005 | 6137 |
| wdx_Rename 0.5a | 6101 |
| pdfOCR 0.9 | 6057 |
| EmptyWDX 0.0.2 | 6057 |
| decIcoWDX 2.0 | 6030 |
| FileScanner 1.0 | 6024 |
| wdx_Code | 5899 |
| FileTime Delta 1.3 | 5816 |
| anyXML 0.3.3 | 5783 |
| Bitchaos 0.1 | 5702 |
| FileContent 1.10 | 5669 |
| In4Info 1.3.3 | 5539 |
| RichText 0.3 | 5494 |
| TcSvn 1.0 | 5461 |
| FileGroups 1.10 | 5444 |
| ShareInfo 1.10 | 5361 |
| super_wdx 2.4.0.3 beta | 5241 |
| FileInDir 2.0.0.2 | 5193 |
| IsDotNET 1.0.6 | 5182 |
| ShellInfo 1.10 | 5159 |
| Jad Info 1.0.2 | 5149 |
| Volume 1.10 | 5083 |
| NicePaths 1.10 | 5060 |
| decRecycleBinWDX 2019.02.03 | 5017 |
| Attributes 1.50 | 5016 |
| IconLibrary 1.10 | 4961 |
| decHexWDX 1.0.0.3 | 4880 |
| FileInDir 1.1 | 4874 |
| wdx\_nm2\_info 0.1 | 4827 |
| GSF Info 1.0 | 4736 |
| SkipCompare 1.0.0.30 | 4618 |
| SVGwdx_64 0.0.1.1 | 4516 |
| Persian Calendar 0.95 beta | 4483 |
| ShedkoBadgesTC 1.0 | 4477 |
| Today 1.6 | 4430 |
| Groups 1.0.2.1 | 4414 |
| firstByte 0.5 | 4341 |
| NameCompare 1.0.0.24 | 4334 |
| NFCname 1.1 | 4256 |
| RPM\_wdx\_64 1.0.1 | 4159 |
| decAdobeSaveWDX 1.0 | 4004 |
| Cert 1.0 | 3995 |
| AKVegasUsage 1.0.2.1 | 3909 |
| TrID_Identifier 1.0 | 3822 |
| Palm DB File info content plugin 2 - 1.0 | 3779 |
| decPeExtraWDX 2016.02.20 | 3690 |
| SVGInfo 1.0.2 | 3515 |
| wdx\_global\_diz 0.9 | 3373 |
| decTCPluginInfoWDX 2016.03.22 | 3303 |
| CDA Info New 1.0.1 | 3258 |
| wdx_xml 0.3.1 | 3119 |
| XPI_Info 1.0.2 | 2956 |
| RarInfoNew 1.2.1 | 2928 |
| WDX_GitCommander 2.0.1.0 | 2442 |
| MIME Info 1.0 | 2382 |
| WebpInfo 1.0.1 | 2100 |
| kbyte 0.2 | 2086 |
| 7zip Info 2.0.0.0 | 2017 |
| PngInfo 1.0.3 | 1831 |
| JpegQuality 1.0.1 | 1796 |
| ZipType 2.0.1.0 | 1766 |
| PsdInfo 1.0.1 | 1156 |
| CertificateInfo 0.3.0 | 951 |
| TiffInfo 1.0 | 915 |
| --- | --- |

### Icon 包

[Icon 包](https://totalcmd.net/directory/iconpack.html)下载排名。

| --- | --- |
| name | download_times |
| --- | --- |
| X-Qute Button Bar Icons 1.60 | 74880 |
| tcmd.xp | 59322 |
| tcmd.vista | 52632 |
| TCIcons 1.0 | 42099 |
| XPStyle Icons Pack 1.0 | 39762 |
| Windows XP 0.06 | 35468 |
| ALESY Button Bar 1.0 | 33043 |
| Object icons TC WinXP 0.9 | 32493 |
| XPdreams ICL | 32053 |
| Drive buttons TC DriveXP 0.3 | 27983 |
| GANT Icon Pack | 24543 |
| tcmd.fullpack | 23706 |
| tcmd.op75 | 23022 |
| TrueXP ICL | 22463 |
| Soul\_XP\_icl 1.0 | 21969 |
| MS Office 2003 IconLib for Total Commander | 20207 |
| Total Se7en v.1.0 | 20067 |
| tGL ICL | 19960 |
| caramel WCMICONS.DLL 0.2 beta | 18593 |
| oxy-gnome icon library for TC | 18000 |
| flat_wcmicons 1.0.2 | 17776 |
| Object icons TC WinClassic 0.8 | 17449 |
| TheBat IconLib for Total Commander | 17357 |
| Drivebmp Candy | 16992 |
| Total7_icons (Disks & Files) 0.1b | 16550 |
| Drivebmp Orion(Amber) | 14986 |
| Drivebmp Orion(Universal) | 14835 |
| Total7 Fugue icons (Toolbars & Menus) 0.1 | 14618 |
| tcmd.op72 | 14119 |
| Fenix icons library 0.1 | 13301 |
| Imagine Toolbar v.2.0 | 13243 |
| tc\_disk\_icons v.1.0 | 12535 |
| GNOME icon theme 1 | 11314 |
| tcmd.2013 | 10305 |
| flat_FileIcons 1.0.0 | 10170 |
| Mac exe ICL | 10118 |
| tcm-plus pack | 9791 |
| Flat Drives Icons 1.0 | 9024 |
| Imagine Toolbar v.1.0 | 6907 |
| Comicicons2 0.2 | 6430 |
| --- | --- |


{% highlight python linedivs %}
import requests
from bs4 import BeautifulSoup

url_list = (
    "https://totalcmd.net/directory/fsplugin.html",
    "https://totalcmd.net/directory/util.html",
    "https://totalcmd.net/directory/lister.html",
    "https://totalcmd.net/directory/packer.html",
    "https://totalcmd.net/directory/content.html",
    "https://totalcmd.net/directory/iconpack.html",
)

for url in url_list:
    response = requests.get(url)
    soup = BeautifulSoup(response.content, 'html.parser')

    titles = soup.find_all('h3', {'class': 'name'})
    downloads = soup.find_all('p', {'class': 'opis'})

    file_name = url.split('/')[-1].split('.')[0] + '.csv'
    with open(file_name, 'w', encoding='utf-8') as out_file:
        out_file.write('name,download_times\n')
        for i in range(len(titles)):
            title = titles[i].find('a').text.strip()
            download_text = downloads[i].find('small').text.strip()
            downloads_count = download_text.split('Downloaded')[1].strip().split()[0].replace(",","")
            out_file.write(f'"{title}",{downloads_count}\n')

{% endhighlight %}


## 参考资料

[TC学堂——最易读的Total Commander教程](https://xbeta.info/studytc/index.htm "善用佳软")  

[totalcmd.net](https://totalcmd.net/)

[TC 官方论坛](https://www.ghisler.ch/board/)

[TC 官网](https://www.ghisler.com/addons.htm)