---
layout: post
title: Java 中 0xff 的使用
---

0xff 是十六进制的表示, 转成二进制表示是 1111 1111, 对于 int 类型, 0xff 的高位用 0 补齐, 其对应数值为 255, 对于 byte 类型, byte 是 8 bit 长度, 高位会补齐 1, 这样转成的 int 类型值为 -1.

<pre><code>
int x = 0xff;
assertEquals(255, x);

byte y = (byte) 0xff;
assertEquals(-1, y);

</code></pre>

用法1
通过结合移位运算符和 0xff 提取八位数值, 假设有 32 bits 的 RGBA 如下:
R = 16 (00010000 in binary)
G = 57  (00111001 in binary)
B = 168 (10101000 in binary)
A = 7 (00000111 in binary)
所以整体的二进制数为 00010000 00111001 10101000 00000111, 通过如下的移位和 0xff 操作可以提取相应的位值,
<pre><code>
int rgba = 272214023;

int r = rgba >> 24 & 0xff;
assertEquals(16, r);

int g = rgba >> 16 & 0xff;
assertEquals(57, g);

int b = rgba >> 8 & 0xff;
assertEquals(168, b);

int a = rgba & 0xff;
assertEquals(7, a);
</code></pre>



参考
[Understanding the & 0xff Value in Java](https://www.baeldung.com/java-and-0xff)
