---
layout: post
title: LaTeX 使用手册
categories: 软件技术
tags: LaTeX MathJax
toc: false
mathjax: true
---

[LaTeX 数学符号参考文档(PDF, 256 KB)](https://www.cmor-faculty.rice.edu/~heinken/latex/symbols.pdf)，[备份本地文件](/assets/file/LATEX-Mathematical-Symbol.pdf)。

CTAN 上的 [LaTeX 符号全列表(PDF, 22 MB)](https://tug.ctan.org/info/symbols/comprehensive/symbols-a4.pdf)，[备份本地文件](/assets/file/The-Comprehensive-LATEX-Symbol-List-a4.pdf)。

## 希腊字母表

|          | 小写形式     |          | 大写形式     |             | 变形形式        |
| ----     | ---          | ---      | ---          | ---         | ---             |
| \alpha   | $$\alpha$$   | A        | $$A$$        |             |                 |
| \beta    | $$\beta$$    | B        | $$B$$        |             |                 |
| \gamma   | $$\gamma$$   | \Gamma   | $$\Gamma$$   |             |                 |
| \delta   | $$\delta$$   | \Delta   | $$\Delta$$   |             |                 |
| \epsilon | $$\epsilon$$ | E        | $$E$$        | \varepsilon | $$\varepsilon$$ |
| \zeta    | $$\zeta$$    | Z        | $$Z$$        |             |                 |
| \eta     | $$\eta$$     | H        | $$H$$        |             |                 |
| \theta   | $$\theta$$   | \Theta   | $$\Theta$$   | \vartheta   | $$\vartheta$$   |
| \iota    | $$\iota$$    | I        | $$I$$        |             |                 |
| \kappa   | $$\kappa$$   | K        | $$K$$        | \varkappa   | $$\varkappa$$   |
| \lambda  | $$\lambda$$  | \Lambda  | $$\Lambda$$  |             |                 |
| \mu      | $$\mu$$      | M        | $$M$$        |             |                 |
| \nu      | $$\nu$$      | N        | $$N$$        |             |                 |
| \xi      | $$\xi$$      | \Xi      | $$\Xi$$      |             |                 |
| o        | $$o$$        | O        | $$O$$        |             |                 |
| \pi      | $$\pi$$      | \Pi      | $$\Pi$$      | \varpi      | $$\varpi$$      |
| \rho     | $$\rho$$     | P        | $$P$$        | \varrho     | $$\varrho$$     |
| \sigma   | $$\sigma$$   | \Sigma   | $$\Sigma$$   | \varsigma   | $$\varsigma$$   |
| \tau     | $$\tau$$     | T        | $$T$$        |             |                 |
| \upsilon | $$\upsilon$$ | \Upsilon | $$\Upsilon$$ |             |                 |
| \phi     | $$\phi$$     | \Phi     | $$\Phi$$     | \varphi     | $$\varphi$$     |
| \chi     | $$\chi$$     | X        | $$X$$        |             |                 |
| \psi     | $$\psi$$     | \Psi     | $$\Psi$$     |             |                 |
| \omega   | $$\omega$$   | \Omega   | $$\Omega$$   |             |                 |

希腊字母中有七个变形形式，它们与 LaTeX 相关的历史可以参考文章 [What does the \var prefix stand for in \varphi and \varepsilon etc?](https://tex.stackexchange.com/questions/304534/what-does-the-var-prefix-stand-for-in-varphi-and-varepsilon-etc)


## 常用符号

| **比较符号** | <                   | $$<$$                   | >                  | $$>$$                   | =                    | $$=$$                    |
|              | \leq                | $$\leq$$                | \geq               | $$\geq$$                | \equiv               | $$\equiv$$               |
|              | \subset             | $$\subset$$             | \supset            | $$\supset$$             | \sim                 | $$\sim$$                 |
|              | \subseteq           | $$\subseteq$$           | \supseteq          | $$\supseteq$$           | \simeq               | $$\simeq$$               |
|              | \in                 | $$\in$$                 | \ni                | $$\ni$$                 | \approx              | $$\approx$$              |
|              | \mid                | $$\mid$$                | \parallel          | $$\parallel$$           | \cong                | $$\cong$$                |
|              | \neq                | $$\neq$$                | \propto            | $$\propto$$             | \doteq               | $$\doteq$$               |
| **箭头**     | \leftarrow          | $$\leftarrow$$          | \rightarrow        | $$\rightarrow$$         | \uparrow             | $$\uparrow$$             |
|              | \longleftarrow      | $$\longleftarrow$$      | \longrightarrow    | $$\longrightarrow$$     | \downarrow           | $$\downarrow$$           |
|              | \Leftarrow          | $$\Leftarrow$$          | \Rightarrow        | $$\Rightarrow$$         | \Uparrow             | $$\Uparrow$$             |
|              | \Longleftarrow      | $$\Longleftarrow$$      | \Longrightarrow    | $$\Longrightarrow$$     | \Downarrow           | $$\Downarrow$$           |
|              | \leftrightarrow     | $$\leftrightarrow$$     | \Leftrigtarrow     | $$\Leftrightarrow$$     | \updownarrow         | $$\updownarrow$$         |
|              | \longleftrightarrow | $$\longleftrightarrow$$ | \Longleftrigtarrow | $$\Longleftrightarrow$$ | \Updownarrow         | $$\Updownarrow$$         |
|              | \mapsto             | $$\mapsto$$             | \longmapsto        | $$\longmapsto$$         | \nearrow             | $$\nearrow$$             |
|              | \searrow            | $$\searrow$$            | \swarrow           | $$\swarrow$$            | \nwarrow             | $$\nwarrow$$             |
| **结构符号** | \frac{abc}{xyz}     | $$\frac{abc}{xyz}$$     | \overline{abc}     | $$\overline{abc}$$      | \overrightarrow{abc} | $$\overrightarrow{abc}$$ |
|              | f'                  | $$f'$$                  | \underline{abc}    | $$\underline{abc}$$     | \overleftarrow{abc}  | $$\overleftarrow{abc}$$  |
|              | \sqrt{abc}          | $$\sqrt{abc}$$          | \widehat{abc}      | $$\widehat{abc}$$       | \overbrace{abc}      | $$\overbrace{abc}$$      |
|              | \sqrt[n]{abc}       | $$\sqrt[n]{abc}$$       | \widetilde{abc}    | $$\widetilde{abc}$$     | \underbrace{abc}     | $$\underbrace{abc}$$     |
|              | \acute{a}           | $$\acute{a}$$           | \bar{a}            | $$\bar{a}$$             | \hat{a}              | $$\hat{a}$$              |
|              | \dot{a}             | $$\dot{a}$$             | \ddot{a}           | $$\ddot{a}$$            | \grave{a}            | $$\grave{a}$$            |
|              | \breve{a}           | $$\breve{a}$$           | \vec{a}            | $$\vec{a}$$             | \tilde{a}            | $$\tilde{a}$$            |
|              | \binom{a}{b}        | $$\binom{a}{b}$$        |                    |                         |                      |                          |
| **函数名**   | \lim_{h\to 0}       | $$\lim_{h\to 0}$$       | \ln                | $$\ln$$                 | \sin                 | $$\sin$$                 |
|              | \exp                | $$\exp$$                | \max               | $$\max$$                | \inf                 | $$\inf$$                 |
|              | \limsup             | $$\limsup$$             | \liminf            | $$\liminf$$             | \gcd                 | $$\gcd$$                 |
| **其他符号** | \cdots              | $$\cdots$$              | \vdots             | $$\vdots$$              | \ldots               | $$\ldots$$               |
|              | \infty              | $$\infty$$              | \forall            | $$\forall$$             | \exists              | $$\exists$$              |
|              | \nabla              | $$\nabla$$              | \partial           | $$\partial$$            | \nexists             | $$\nexists$$             |
|              | \emptyset           | $$\emptyset$$           | \varnothing        | $$\varnothing$$         | \square              | $$\square$$              |
|              | \clubsuit           | $$\clubsuit$$           | \diamondsuit       | $$\diamondsuit$$        | \heartsuit           | $$\heartsuit$$           |
|              | \spadesuit          | $$\spadesuit$$          | \triangle          | $$\triangle$$           | \triangledown        | $$\triangledown$$        |
|              | \int                | $$\int$$                | \iint              | $$\iint$$               | \oint                | $$\oint$$                |
|              | \cdot               | $$\cdot$$               | \ast               | $$\ast$$                | \star                | $$\star$$                |
|              | \circ               | $$\circ$$               | \bullet            | $$\bullet$$             | \bigcirc             | $$\bigcirc$$             |
|              | \times              | $$\times$$              | \div               | $$\div$$                | \odot                | $$\odot$$                |
|              | \ominus             | $$\ominus$$             | \oplus             | $$\oplus$$              | \otimes              | $$\otimes$$              |
|              | \sum                | $$\sum$$                | \prod              | $$\prod$$               | \coprod              | $$\coprod$$              |
|              | \bigcap             | $$\bigcap$$             | \bigcup            | $$\bigcup$$             | \bigotimes           | $$\bigotimes$$           |

## 数学字体

**Caligraphic letters**：\mathcal{A}

$$\mathcal{A B C D E F G H I J K L M N O P Q R S T U V W X Y Z}$$

$$\mathcal{a b c d e f g h i j k l m n o p q r s t u v w x y z}$$

$$\mathcal{1 2 3 4 5 6 7 8 9 0}$$

**Mathbb letters**：\mathbb{A}

$$\mathbb{A B C D E F G H I J K L M N O P Q R S T U V W X Y Z}$$

$$\mathbb{a b c d e f g h i j k l m n o p q r s t u v w x y z}$$

$$\mathbb{1 2 3 4 5 6 7 8 9 0}$$

**Mathfrak letters**：\mathfrak{A}

$$\mathfrak{A B C D E F G H I J K L M N O P Q R S T U V W X Y Z}$$

$$\mathfrak{a b c d e f g h i j k l m n o p q r s t u v w x y z}$$

$$\mathfrak{1 2 3 4 5 6 7 8 9 0}$$

**Math Sans serif letters**：\mathsf{A}

$$\mathsf{A B C D E F G H I J K L M N O P Q R S T U V W X Y Z}$$

$$\mathsf{a b c d e f g h i j k l m n o p q r s t u v w x y z}$$

$$\mathsf{1 2 3 4 5 6 7 8 9 0}$$

**Math bold letters**：\mathbf{A}

$$\mathbf{A B C D E F G H I J K L M N O P Q R S T U V W X Y Z}$$

$$\mathbf{a b c d e f g h i j k l m n o p q r s t u v w x y z}$$

$$\mathbf{1 2 3 4 5 6 7 8 9 0}$$


## 矩阵和方程组

用 `array` 环境生成公式，基本语法如下，其中的 `cols` 对每一列取 `[lrc]` 中的一个字符表示相应列的对齐方式，还可以加上 `|` 来加上竖线，每一行的 $$row_j$$ 用 `&` 做列分隔符。用 `\hline` 可以在行中间加上横线。

`Array` 环境是 LaTeX 中数学模式下的表格对齐环境，`tabular` 是文本模式下表格环境。

```latex
\begin{array}{cols}
row1 \\
row2 \\
... \\
rowm
\end{array}
```

代码 1：
```latex
\left(
    \begin{array}{cc}
     2\tau & 7\phi-\frac5{12} \\
        3\psi & \frac{\pi}8
    \end{array}
\right)
\left( \begin{array}{c} x \\ y \end{array} \right)
~\mbox{and}~
\left[
    \begin{array}{cc|r}
    3 & 4 & 5 \\
    1 & 3 & 729
    \end{array}
\right]
```

效果 1：
$$
\left(
    \begin{array}{cc}
        2\tau & 7\phi-\frac5{12} \\
        3\psi & \frac{\pi}8
    \end{array}
\right)
\left( \begin{array}{c} x \\ y \end{array} \right)
~\mbox{and}~
\left[
    \begin{array}{cc|r}
        3 & 4 & 5 \\
        1 & 3 & 729
    \end{array}
\right]
$$

代码 2：
```latex
f(z) = 
\left\{
    \begin{array}{rcl}
        \overline{\overline{z^2}+\cos z} & \mbox{for} & |z|<3 \\
        0 & \mbox{for} & 3\leq|z|\leq5 \\
        \sin\overline{z} & \mbox{for} & |z|>5
    \end{array}
\right.
```

效果 2：
$$
f(z) = 
\left\{
    \begin{array}{rcl}
        \overline{\overline{z^2}+\cos z} & \mbox{for} & |z|<3 \\
        0 & \mbox{for} & 3\leq|z|\leq5 \\
        \sin\overline{z} & \mbox{for} & |z|>5
    \end{array}
\right.
$$

下面是使用 `align` 环境来对齐公式。`align` 是 [AMS-LaTeX](https://latex-programming.fandom.com/wiki/Align_(LaTeX_environment)) 项目提供的环境。

代码 1：

```latex
$$
\begin{align}
  \frac{d}{dx} \ln x &= \lim_{h\to 0} \frac{\ln(x+h) - \ln x}{h} \\
  &= \ln e^{1/x} &&\text{How this follows is left as an exercise.}\\
  &= \frac{1}{x} &&\text{Using the definition of ln as inverse function}
 \end{align}
$$
```

效果 1：

$$
\begin{align}
  \frac{d}{dx} \ln x &= \lim_{h\to 0} \frac{\ln(x+h) - \ln x}{h} \\
  &= \ln e^{1/x} &&\text{How this follows is left as an exercise.}\\
  &= \frac{1}{x} &&\text{Using the definition of ln as inverse function}
 \end{align}
$$

代码 2：

```latex
$$
\left\{
\begin{matrix}
\begin{align}
& l_0(x_0) = 1, l_0(x_1) = 0, ..., l_0(x_n) = 0, \\
& l_1(x_0) = 0, l_1(x_1) = 1, ..., l_1(x_n) = 0, \\
& \cdots \cdots \\
& l_n(x_0) = 0, l_n(x_1) = 0, ..., l_n(x_n) = 1. \\
\end{align}
\end{matrix}
\right. \qquad (6)
$$
```

效果 2：

$$
\left\{
\begin{matrix}
\begin{align}
& l_0(x_0) = 1, l_0(x_1) = 0, ..., l_0(x_n) = 0, \\
& l_1(x_0) = 0, l_1(x_1) = 1, ..., l_1(x_n) = 0, \\
& \cdots \cdots \\
& l_n(x_0) = 0, l_n(x_1) = 0, ..., l_n(x_n) = 1. \\
\end{align}
\end{matrix}
\right. \qquad (6)
$$

代码 3：

```latex
$$
c[i, j] = 
\left\{
\begin{matrix}
\begin{align}
& {0} && {if \quad i = 0 \; or \; j = 0,} \\
& {c[i - 1, j - 1] + 1} && {if \quad i, j > 0 \; and \; x_i = y_j,} \\
& {max(c[i, j - 1], c[i - 1, j])} && {if \quad i, j > 0 \; and \; x_i \neq y_j.} \\
\end{align}
\end{matrix}
\right.
$$
```
效果 3：

$$
c[i, j] = 
\left\{
\begin{matrix}
\begin{align}
& {0} && {if \quad i = 0 \; or \; j = 0,} \\
& {c[i - 1, j - 1] + 1} && {if \quad i, j > 0 \; and \; x_i = y_j,} \\
& {max(c[i, j - 1], c[i - 1, j])} && {if \quad i, j > 0 \; and \; x_i \neq y_j.} \\
\end{align}
\end{matrix}
\right.
$$

## 参考链接

[LaTex 数学公式花括号右侧数学公式每行保持左对齐(及部分内容左对齐)](https://fanlumaster.github.io/2021/06/01/LaTex-%E6%95%B0%E5%AD%A6%E5%85%AC%E5%BC%8F%E8%8A%B1%E6%8B%AC%E5%8F%B7%E5%8F%B3%E4%BE%A7%E6%95%B0%E5%AD%A6%E5%85%AC%E5%BC%8F%E6%AF%8F%E8%A1%8C%E4%BF%9D%E6%8C%81%E5%B7%A6%E5%AF%B9%E9%BD%90(%E5%8F%8A%E9%83%A8%E5%88%86%E5%86%85%E5%AE%B9%E5%B7%A6%E5%AF%B9%E9%BD%90)/)

[MathJax-demos-web](https://mathjax.github.io/MathJax-demos-web/)

[MathJax Example Pages](https://www.tuhh.de/MathJax/test/examples.html)

[MathJax basic tutorial and quick reference](https://math.meta.stackexchange.com/questions/5020/mathjax-basic-tutorial-and-quick-reference)

[Greek Letters in LaTeX](https://www.geeksforgeeks.org/greek-letters-in-latex/)

[Align (LaTeX environment)](https://latex-programming.fandom.com/wiki/Align_(LaTeX_environment))

[array (LaTeX environment)](https://latex-programming.fandom.com/wiki/Array_(LaTeX_environment))
