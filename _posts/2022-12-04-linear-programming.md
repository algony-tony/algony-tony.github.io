---
layout: post
title: 线性规划及整数线性规划算法
categories: 自然科学
tags: 算法 线性规划 单纯形法
toc: true
mathjax: true
---

* TOC
{:toc}

## 运筹学基础

运筹学中的一套完整的工作流程，可分为如下六个步骤：
* **问题定义**：在实践中遇到的问题，最初可能是模糊的，不精确的，所以第一步就是要把问题明确下来。这一步需要确定研究目标，明确问题边界，列出问题约束和问题要素及其关系；
* **数据收集**：数据收集有可能贯穿研究的全过程，根据研究目标明确需要收集的数据范围，数据既能加深对问题的理解，也是为下一步构建模型提供数据输入；
* **模型构建**：模型是研究对象的抽象，__好的模型是保真性、灵活性和成本之间的巧妙平衡__，模型需要贴近现实世界的问题，当条件改变时模型也能适应变化，同时模型方便操作和维护；
* **模型求解**：模型求解一般使用计算机软件来完成，需要熟悉成熟模型的算法才好灵活运用；
* **模型验证**：一方面是检查模型是否得到了正确的解，另一方面验证模型的解是否正确反映了问题实际；
* **结论实施**：一般要实施交互式决策服务的工具，同时帮助决策者能够使用和实施，包括提供操作手册和相关培训等，在使用过程中实施全周期管理，当发现原有假设严重偏离时，应重新检验模型并更新工具。

运筹学模型中的三要素：
* 决策变量（Decision Variables）：待优化的对象；
* 目标函数（Objective Function）：需要达成的目标的表达式，一般为寻求最大值或最小值，有时候可要求满意、可行、非劣等；
* 约束条件（Constraints）：表示进行优化时收到的限制，包括资源的限制，时间约束等；

还有模型中的常数项，称为模型的参数（Parameters），参数的取值一般需要收集数据后才能确定。对参数值的不确定性的研究称为灵敏度分析（Sensitivity Analysis）。


## 线性规划

线性规划用来解决这一类问题：如何使用有限的资源（人力、物力、财力或者时间等）达到一定的目标，很多时候还可能要求以最好的效果来达成目标。

线性指的是模型中所有表达式均为线性等式或不等式，线性规划问题的一般形式如下：

$$
\max (\min) z = c_1 x_1\ +\ c_2 x_2\ +\ \cdots \ +\ c_n x_n
$$

$$
\left\{
    \begin{array}{lcl}
    a_{11} x_1\ +\ a_{12} x_2\ +\ \cdots\ +\ a_{1n} x_n &\le (=, \ge)& b_1 \\
    a_{21} x_1\ +\ a_{22} x_2\ +\ \cdots\ +\ a_{2n} x_n &\le (=, \ge)& b_2 \\
    \qquad \vdots \\
    a_{m1} x_1\ +\ a_{m2} x_2\ +\ \cdots +\ \ a_{mn} x_n &\le (=, \ge)& b_m \\
    x_1, x_2, \ldots, x_n \le (=, \ge)~0, \text{或无约束}
    \end{array}
\right.
$$

### 标准形式

满足下面 3 个条件的形式为线性规划模型的标准形式，
1. 目标函数最大化；
2. 约束条件等式化；
3. 决策变量非负化；

设线性规划模型中变量数为 $n$ 个，非负约束条件共 $m$ 个，标准形式可写为

$$
\max z = c_1 x_1\ +\ c_2 x_2\ +\ \cdots \ +\ c_n x_n
$$

$$
\left\{
    \begin{array}{lcl}
    a_{11} x_1\ +\ a_{12} x_2\ +\ \cdots\ +\ a_{1n} x_n & = & b_1 \\
    a_{21} x_1\ +\ a_{22} x_2\ +\ \cdots\ +\ a_{2n} x_n & = & b_2 \\
    \qquad \vdots \\
    a_{m1} x_1\ +\ a_{m2} x_2\ +\ \cdots +\ \ a_{mn} x_n & = & b_m \\
    x_1, x_2, \ldots, x_n \ge 0
    \end{array}
\right.
$$

改写成矩阵形式：

$$
\max z = \mathbf{C} \mathbf{X}
$$

$$
\left\{
    \begin{array}{l}
    \mathbf{A} \mathbf{X} = \mathbf{b} \\
    \mathbf{X} \ge \mathbf{0}
    \end{array}
\right.
$$

其中

$$
\mathbf{C} =
\left(
    \begin{matrix}
    c_1\\
    c_2\\
    \vdots \\
    c_n
    \end{matrix}
\right)^ T,\quad

\mathbf{X} =
\left(
    \begin{matrix}
    x_1\\
    x_2\\
    \vdots \\
    x_n
    \end{matrix}
\right),\quad

\mathbf{P_j} =
\left(
    \begin{matrix}
    a_{1j}\\
    a_{2j}\\
    \vdots \\
    a_{mj}
    \end{matrix}
\right),\quad

\mathbf{b} =
\left(
    \begin{matrix}
    b_1\\
    b_2\\
    \vdots \\
    b_m
    \end{matrix}
\right)
$$

$$
\mathbf{A} = \mathbf{A_{m \times n}} =
\left(
    \begin{matrix}
    a_{11} & a_{12} & \cdots & a_{1n} \\
    \vdots & \vdots & \ddots & \vdots \\
    a_{m1} & a_{m2} & \cdots & a_{mn} \\
    \end{matrix}
\right)
= (\mathbf{P_1},\mathbf{P_2},\cdots,\mathbf{P_n})
$$

其中，$\mathbf{A}$ 称为 $m \times n$ **系数矩阵**，一般有 $m < n$，$\mathbf{b}$ 称为**资源向量**，$\mathbf{C}$ 称为**价值向量**，
$\mathbf{X}$ 称为**决策变量向量**，$\mathbf{P_j}$ 称为**系数列向量**。

#### 转换到标准形式的步骤

所有一般形式的线性规划模型都可以转换为标准形式，步骤如下
1. 决策变量非负化：若原变量不是非负化的约束，可以对原变量做加减一个常数值，或者乘以 -1 来转化为非负约束的形式；如果原来是无约束变量如 $x_k$，可以转换成两个带有非负约束的变量 $x_k = x_k' - x_k''$，其中 $x_k', x_k'' \ge 0$；
2. 约束条件等式化：若约束方程为 $\le$ 可在不等式的左端加入非负松弛变量将不等式转换为等式；若不等式为 $\ge$ 则在左端减去一个非负剩余变量，同样可以转换为等式；
3. 目标函数最大化：若原目标函数是要求最小值，只需要取 $z' = -z$，就可以转换为求最大值的形式 $\max z' = (- \mathbf{C}) \mathbf{X}$。

#### 基可行解

区域 $\mathbf{D} = \\{ \mathbf{X} \in \mathbf{R}^n\ \|\ \mathbf{A} \mathbf{X} = \mathbf{b},\ \mathbf{X} \ge 0 \\}$ 称为**可行域**，若 $\mathbf{X} \in \mathbf{D}$，则称 $\mathbf{X}$ 为**可行解**（Feasible Solution），若对任意 $\mathbf{X}' \in \mathbf{D}$，都有 $\mathbf{C} \mathbf{X}' \le \mathbf{C} \mathbf{X}$，则称 $\mathbf{X}$ 为线性规划问题的**最优解**。


可以假设系数矩阵 $\mathbf{A}$ 是行满秩（如果不是说明约束条件是线性相关，可以通过变换消去部分约束条件），也即 $\mathbf{A}$ 的秩为 $m$，从而可以从 $\mathbf{A}$ 中找到 $m$ 个线性无关的列向量 $ (\mathbf{P}\_{j_1}, \mathbf{P}\_{j_2}, \cdots, \mathbf{P}\_{j_m}) $，记为 $\mathbf{B}$，称为线性规划问题的一个**基**（Basis），其中每个向量称为**基向量**，称对应的决策变量为**基变量**，其他的变量称为**非基变量**。

假设 $\mathbf{B}$ 是一个基，可以通过调整变量顺序使得基向量排在前面 $\mathbf{B} = (\mathbf{P}_1, \mathbf{P}_2, \cdots, \mathbf{P}_m)$，设 $\mathbf{N} = (\mathbf{P}\_{m+1}, \cdots, \mathbf{P}_n)$，这样导出

$$
(\mathbf{B},\ \mathbf{N})
\left(
    \begin{matrix}
    \mathbf{X}_{\mathbf{B}} \\
    \mathbf{X}_{\mathbf{N}}
    \end{matrix}
\right)
= \mathbf{b}
$$

因为 $\mathbf{B}$ 是可逆矩阵，可以得出

$$
\mathbf{X}_{\mathbf{B}} = \mathbf{B}^{-1} \mathbf{b} - \mathbf{B}^{-1} \mathbf{N} \mathbf{X}_{\mathbf{N}}
$$

在上式中令非基变量为 0，这样得到

$$
\mathbf{X} =
\left(
    \begin{matrix}
    \mathbf{X}_{\mathbf{B}} \\
    \mathbf{X}_{\mathbf{N}}
    \end{matrix}
\right) =
\left(
    \begin{matrix}
    \mathbf{B}^{-1} \mathbf{b} \\
    \mathbf{0}
    \end{matrix}
\right)
$$

满足条件 $\mathbf{A} \mathbf{X} = \mathbf{b}$，称为**基解**（basic solution），此时如果有 $\mathbf{B}^{-1} \mathbf{b} \ge 0$，则有 $\mathbf{X} \ge 0$ 满足条件，这样的 $\mathbf{X}$ 称为**基可行解**（Basic feasible solution，BFS），对应的基称为**可行基**（feasible basis）。他们的关系如下图。

![基可行解](/assets/img/post/linear-programming-basis.png "基可行解是可行解和基解的交集")

线性规划问题的基最多有 $\binom{n}{m}$ 个（假定任意从 $n$ 个列向量中抽取 $m$ 个都线性无关，则基的数量取到最大值），基解对应于约束条件对应的多面体的交角（corner of the polyhedron），基可行解是位于可行域中的基解。在两个变量的二维平面中，基解就是任意两个约束条件的交点，如下面五个约束条件两两相交对应图中的 $A,B,C,D,E,F,G,H$ 总共 8 个点（有两对直线平行（线性相关）无交点，所以 $\binom{5}{2} - 2 = 8$ ），其中位于可行域中的 $A,B,C,D,E$ 是基可行解，再结合目标函数至少可以找到一个最优解。

$$
\left\{
    \begin{matrix}
        x_1&+&2 x_2 &\le& 8 \\
        x_1&&&\le& 4 \\
        && x_2 &\le& 3 \\
        x_1&&&\ge& 0 \\
        && x_2 &\ge& 0
    \end{matrix}
\right.
$$

!["基解和基可行解"](/assets/img/post/linear-programming-bfs.png)

### 线性规划的解

关于线性规划问题有下面几个结论：
1. 线性规划问题的可行域如果非空，则一定是凸集；
2. 如果是有界凸集，由于目标函数的连续性，则一定可以在可行域的有界凸集上取得极值，也就是最优解；
3. 在有界可行域的顶点处一定可以找到至少一个最优解；
4. 线性规划问题的基可行解对应于可行域的顶点；（从代数角度定义的“基可行解”和几何角度定义的“顶点”两者本质上是一回事。）

线性规划的解有几种情况：
1. 唯一的最优解；
2. 无穷多最优解；
3. 无界解；
4. 无可行解；

当线性规划问题的可行域非空时，它是有界或无界凸多边形；若线性规划问题存在最优解，它一定在可行域的某个顶点得到；若在两个顶点同时得到最优解，则它们连线上的任意一点都是最优解，即有无穷最优解。

### 单纯形法

单纯形法（Simplex Method ）是建立在线性规划模型的“标准形式”之上的，总体来说可以分为 5 步：
1. 寻找一个初始解；
2. 构建单纯性表；
3. 判断当前解是否最优；
4. 如果是最优解就结束，不是最优解就换到一个新解上；
5. 在单纯性表中计算相关值，返回第三步重复直到解出最优解或者其他终止条件；


如求解这个例子的单纯行表步骤如下：

$$
\max z = 2 x_1 + 3 x_2
$$

$$
\left\{
    \begin{matrix}
        x_1 + 2 x_2 &\le& 8 \\
        x_1 &\le& 4 \\
        x_2 &\le& 3 \\
        x_1,x_2&\ge& 0
    \end{matrix}
\right.
$$

![单纯形法](/assets/img/post/linear-programming-simplex-method.png "单纯形法")

上面步骤中的检验数从下面可以推导出，它代表着目标函数会随着该变量的变化方向，以及变化的快慢，它是资源的**影子价格**，也被称为**边际价格**。

$$
\begin{array}{rcl}
z &=& \mathbf{C} \mathbf{X} \\
 &=& \mathbf{C}_{\mathbf{B}} \mathbf{X}_{\mathbf{B}} + \mathbf{C}_{\mathbf{N}} \mathbf{X}_{\mathbf{N}} \\
 &=& \mathbf{C}_{\mathbf{B}} (\mathbf{B}^{-1} \mathbf{b} - \mathbf{B}^{-1} \mathbf{N} \mathbf{X}_{\mathbf{N}}) + \mathbf{C}_{\mathbf{N}} \mathbf{X}_{\mathbf{N}} \\
 &=& \mathbf{C}_{\mathbf{B}} \mathbf{B}^{-1} \mathbf{b} + ( \mathbf{C}_{\mathbf{N}} - \mathbf{C}_{\mathbf{B}} \mathbf{B}^{-1} \mathbf{N} ) \mathbf{X}_{\mathbf{N}}
 \end{array}
$$

从而对于非基变量 $x_j$ 的检验数为

$$
\frac{\partial{z}}{\partial{x_j}} = c_j - \mathbf{C}_{\mathbf{B}} \mathbf{B}^{-1} \mathbf{P}_j = \sigma_j
$$

### 大 M 法

单纯形法开始迭代时需要找到一个初始基可行解，但是上面把线性规划问题转换成标准形式的过程中不能自然得到一个单位矩阵，
**大 M 法**是在上面转换标准形式的过程中加入**人工变量**（artificial variables）和惩罚系数如下：
1. 若约束条件为“$\le$”，在不等式左边加入非负松弛变量；
2. 若约束条件为等式，在等式左边加入一个非负人工变量；
3. 若约束条件为“$\ge$”，在不等式左边减去非负剩余变量，再加入一个非负人工变量；
4. 在目标函数中，加入的松弛变量和剩余变量的系数为 0，加入的人工变量系数为 $-M$，是一个任意大的正数，惩罚系数。

如下面的线性规划问题

$$
\min z = -3x_1 -2x_2
$$

$$
\left\{
    \begin{array}
        2x_1 + 4 x_2 - x_3 \le 5 \\
        -x_1 + x_2 - x_3 \ge -1 \\
        -x_2+x_3 = 1 \\
        x_1,x_2,x_3 \ge 0
    \end{array}
\right.
$$

用大 M 法转成标准形式：

$$
\max z = 3x_1 + 2x_2 - M x_6
$$

$$
\left\{
    \begin{array}{rcccl}
        2x_1 + 4 x_2 - x_3 &+ x_4 &&&= 5 \\
        x_1 - x_2 + x_3 &&+ x_5 & &= 1 \\
        -x_2+x_3 &&&+ x_6 &= 1 \\
        x_1,x_2,x_3,x_4,x_5,x_6 &&&&\ge 0
    \end{array}
\right.
$$

其中 $x_6$ 是人工变量，这样可以得到 $x_4,x_5,x_6$ 的系数列向量构成单位矩阵 $\mathbf{B}$，初始基解 $\mathbf{X} = (0,0,0,5,1,1)^T$ 为基可行解，从而开始单纯形法计算。

这里可以得到线性规划问题四种解的**判别准则**：
1. 唯一的最优解：对于所有非基变量，检验数都有 $\sigma_j < 0$；
2. 无穷多最优解：对于所有非基变量，检验数都有 $\sigma_j \le 0$，且存在某个非基变量的检验数等于 0；
3. 无界解：存在一个非基变量的检验数 $\sigma_{m+k} > 0$，且该变量在系数矩阵中对应的列 $\mathbf{P}_{m+k} \le 0$；
4. 无可行解：满足上面的迭代终止条件，但是存在取非零值的人工变量，则此线性规划问题无可行解；

![单纯形法的计算流程](/assets/img/post/linear-programming-simplex-method-procedure.png "单纯形法的计算流程")

### 两阶段法

大 M 法在用计算机求解的过程中 M 值一般用很大的数来近似替代，这会造成计算上的累计误差，两阶段法就是用拆分成两个阶段的办法来解决这个问题，使得计算过程中不出现大 M。

第一阶段用来寻找一个不包含人工变量的初始基可行解。步骤是在原问题引入松弛变量和人工变量进行标准化，构造仅含人工变量的目标函数，将其价值系数设置为 -1，使用单纯形法求解，若得到了目标函数为 0，也即是得到了不包含人工变量的一个基可行解，从而转入第二阶段，否则原问题无可行解。

第二阶段，使用第一阶段得到的最终单纯形表，去掉其中的人工变量，并将目标函数还原成原问题的目标函数，继续使用单纯形法求解即可。

例子，线性规划问题如下

$$
\max z = -4 x_1 - x_2 +2x_3
$$

$$
\left\{
    \begin{array}{c}
    x_1 -2x_2+x_3 \le 11 \\
    -4x_1+x_2 + 2x_3 \ge 3 \\
    -2x_1 + x_3 = 1 \\
    x_1,x_2,x_3 \ge 0
    \end{array}
\right.
$$

第一阶段，转换成带人工变量的标准形式，用单纯形法第一次迭代 $x_3$ 替换掉 $x_7$，第二次 $x_2$ 替换掉 $x_6$，这样第一阶段就结束了。

$$
\max w = -x_6 - x_7
$$

$$
\left\{
    \begin{array}{c}
        x_1 - 2x_2+x_3+x_4 = 11 \\
        -4 x_1 + x_2 +2x_3 - x_5 + x_6 = 3 \\
        -2x_1 + x_3 + x_7 = 1 \\
        x_1,x_2,x_3,x_4,x_5,x_6,x_7 \ge 0
    \end{array}
\right.
$$

### 退化情形与勃兰特准则

在单纯形法的求解中可能出现 $\theta$ 为 0 的情形，即该行的资源系数为 0，称这种情况是退化的。出现退化的情形是因为约束条件中存在线性相关的条件。

出现退化的情况可能导致迭代出现局部循环，而最优解不在其中。解决的办法就是使用勃兰特准则（Bland's rule）：
1. 换入变量不用检验数最大的那个，而是用大于 0 的检验数中下标最小的决策变量；
2. 换出变量还是使用 $\theta$ 最小的那个，如果有出现两个以上的相同最小值，使用下标最小的决策变量作为换出变量。

## 整数线性规划

在上述的线性规划问题的基础上，再加上对全部或者部分


## 参考链接

[运筹学基础，李志猛著](https://item.jd.com/12769676.html)

[Simplex method calculator](https://cbom.atozmath.com/CBOM/Simplex.aspx)