---
layout: post
title: 剪线键盘入坑记
categories: 生活
tags: 键盘
toc: false
---

剪线键盘就是被剪掉 USB 线的老旧键盘，闲鱼上花了 80 元包邮买了两个 Cherry 的 G80-3000 最经典一款键盘，不包好坏，一青轴一黑轴，来看下我买到了啥。

![剪线键盘](/assets/img/post/keyboard-rework-01.jpg)

![剪线键盘](/assets/img/post/keyboard-rework-02.jpg)

拍的效果看着好像还不错，原来对青轴还有点期望，后面才醒悟青轴这种段落轴坏的快，真还不如黑轴耐用。黑轴的键帽打油严重，使用很多，青轴缺键帽，按了一遍很多都不回弹，几乎没几个好用的轴。

回头来说下为啥这么想不开入坑剪线键盘。最早是我用了多年的罗技 Anywhere 2 突然有天发现左键选择文本的时候偶尔会选不上，因为鼠标自动帮我又点了一下，把我选择的文字又给放掉了，查了下发现这是鼠标的一个常见问题，双击问题，就是有一定概率单击会被识别成双击，解决办法也很简单（后面实操后才发现也没有那么简单），就是把微动给换了，**微动**是鼠标里负责点击的开关，双击问题一般都是微动老化，只要换了就行。

入坑就是这样循序渐进，为了换鼠标微动，除了缺新微动外，还需要有电烙铁给微动针脚去锡从 PCB 板上取下再换上新微动上锡固定到板子上。新微动电商网站上几块钱一个，电烙铁买个入门的也得小几十，一咬牙想想可能是为了修鼠标就买下了。然后很艰难地把微动换好了，同时明白了锡焊还是要多多练习，同时也把鼠标滚轮给彻底修坏了，应该是拆微动的时候把边上那个不知道是什么的小原件给弄下来导致的。

继鼠标出症状后我的青轴 G80-3000 的几个轴出现问题，按了不回弹，和几个不常用的轴换了上盖后好了几天又手感不对了，这时候知道有了剪线键盘，这才想着买个剪线键盘先练练手。

开始行动吧，把断线焊上提前买好准备做键线分离的 Type-C 母座。聊聊几笔，饱含挫折 :dog:。

![Type-C 母座](/assets/img/post/keyboard-rework-03.jpg)

![Type-C 母座](/assets/img/post/keyboard-rework-04.jpg)

插上电脑测下，两个键盘都有几个轴没反应。

![剪线键盘测试](/assets/img/post/keyboard-rework-05.png)

知道了问题，开始拆。真脏！

![键盘开拆-去键帽](/assets/img/post/keyboard-rework-06.jpg)

![键盘开拆-壳](/assets/img/post/keyboard-rework-07.jpg)

![键盘开拆-PCB板](/assets/img/post/keyboard-rework-08.jpg)

直接水洗，洗洁精洗衣粉加上！

![一盆键帽](/assets/img/post/keyboard-rework-09.jpg)

来看看坏了的青轴，不回弹的轴。

![坏青轴](/assets/img/post/keyboard-rework-10.jpg)


![坏青轴](/assets/img/post/keyboard-rework-11.jpg)

![坏青轴](/assets/img/post/keyboard-rework-12.jpg)

拆开黑轴，发现不通的是轴里铜片锈断了。

![锈断的黑轴轴体](/assets/img/post/keyboard-rework-14.jpg)

那简单，直接换轴就行。

![去掉锈断的黑轴](/assets/img/post/keyboard-rework-15.jpg)

清洗干净，接上老的 USB 线，凑出来一副键帽装上，黑轴键盘可以上手使用。

![黑轴键盘](/assets/img/post/keyboard-rework-16.jpg)

用了一天发现手感太硬了，用不动，:joy:，拿出我之前买的 45g 双段加长弹簧换掉黑轴里主键盘区和 ESC 键的弹簧，手感轻了很多，顺滑！

![黑轴弹簧](/assets/img/post/keyboard-rework-17.jpg)

![黑轴换弹簧](/assets/img/post/keyboard-rework-18.jpg)

青轴的 PCB 板把主键盘区的两个针脚焊上，后面可以直接上普通的三针脚轴体。

![青轴 PCB 板](/assets/img/post/keyboard-rework-19.jpg)


