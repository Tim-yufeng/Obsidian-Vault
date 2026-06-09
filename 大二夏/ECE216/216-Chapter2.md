P135: delay 

这一章的核心思想，就是借鉴了线性代数的基底思维，来研究信号/函数

在线代中，以 $\mathbb{R}^2$ 为例，我们找这样一对基底 $\begin{pmatrix}1\\0\end{pmatrix}$, $\begin{pmatrix}0\\1\end{pmatrix}$, 用来表示任何向量 $\begin{pmatrix}x_{1}\\x_{2}\end{pmatrix}$。只需要找到正确的组合系数：$x_{1}, x_{2}$:
$$
\begin{pmatrix}x_{1}\\x_{2}\end{pmatrix}=x_{1}\begin{pmatrix}1\\0\end{pmatrix}+x_{2}\begin{pmatrix}0\\1\end{pmatrix}
$$
系数如何确定？通过原向量和基底向量做内积，也就是投影：
$$
\left \langle \begin{pmatrix}x_{1}\\x_{2}\end{pmatrix}, \begin{pmatrix}1\\0\end{pmatrix} \right \rangle =x_{1}
$$
$$
\left \langle \begin{pmatrix}x_{1}\\x_{2}\end{pmatrix}, \begin{pmatrix}0\\1\end{pmatrix} \right \rangle =x_{2}
$$
在信号与系统这边，我们把函数当作向量，我们找的基底向量是上一章学的 $\delta(t)$,  而内积操作就是两个函数相乘，在 $(-\infty, \infty)$ 积分

已知一个信号函数 $x(t)$, 我们通过和脉冲函数内积，找到点 $t_{0}$ 处的函数值：
$$
\int_{-\infty}^\infty x(t)\delta(t-t_{0})dt=x(t_{0})
$$
 套用线代的理解，其实每个点处的函数值相当于函数这个“向量”的一个维度的值，我们把所有维度组合起来，就组装出了一个完整的向量，于是：
 $$
\int_{-\infty}^\infty x(\tau)\delta(\tau-t)d\tau=x(t)
$$
鉴于 $\delta(t)=\delta(-t)$ 的性质，我们通常写为：
$$
\int_{-\infty}^\infty x(\tau)\delta(t-\tau)d\tau=x(t)
$$
其实这样更加直观了，因为我们对 $\delta$ 函数最直观的理解就是，它代表一个位置的单位1，当你把相应位置的 $\delta$ 函数乘以对应的函数值，然后所有位置累加起来（积分），就是对一个完整函数的复刻

某种意义上，它很像 214 中的 linear form，我们当时把他当成一个 “过滤器”（见 《214的胡思乱想》），可以过滤出特定维度（位置）的向量值（函数值），在信号与系统的世界里，他就是我们获取某个信号函数某个点处函数值的基本工具

### LTI System

回归正题，这一章节我们围绕一类特殊的、简化的系统，LTI System，即 Linear Time-invariant System:

![[Pasted image 20260602140554.png]]
通过这类系统的特殊性质，我们可以完成以下推导：
![[9b812a950ca8c61395c3603ed9c09866.jpg]]
最终得到的结论就是，定义 系统的**响应函数** $h(t)$，是施加一个 impulse $\delta(t)$ 的结果：
$$
\delta(t) \xrightarrow[]{T}h(t)
$$
而系统函数 $y(t)$ 就可以写成信号函数 $x(t)$ 和这个系统响应函数的卷积：
$$
y(t) = x(t)*h(t)
$$
也就是：
$$
y(t) = \int_{-\infty}^{\infty}x(\tau)h(t-\tau)d\tau
$$
非常有意思的两点：
1. 一个LTI系统的全部性质，都可以被这个系统响应函数表示
2. 一个LTI函数可以表示成这个式子，反过来也成立：如果一个系统可以被表示成这个形式，那么他一定是LTI系统
![[Pasted image 20260602141809.png]]

**卷积的性质 (Properties of Convolution)**

$$
h(t-\tau) \text{ 可以通过对 } h(t) \text{ 的基本变换得到}
$$
(对 $h(t)$ 进行时间反转和移位)

 **双线性 (Bilinear)**
$$
x(t) * [h_1(t) + h_2(t)] = x(t) * h_1(t) + x(t) * h_2(t)
$$
$$
[x_1(t) + x_2(t)] * h(t) = x_1(t) * h(t) + x_2(t) * h(t)
$$

Fix one, to the other it's linear, both holds.

**交换律 (Commutative Property)**
$$
\text{Commutative: } x(t) * h(t) = h(t) * x(t)
$$
数学上成立，但实际上不一定任意 (x(t)) 函数都能成为 system
(不一定能设计出这样一个系统)

**结合律 (Associative Property)**
$$
\text{Associative: } [x(t) * h_1(t)] * h_2(t) = x(t) * [h_1(t) * h_2(t)]
$$

卷积也可以找到子系统(的结合)、等价系统。
$$
\text{subsystems } h_1(t), \dots, h_k(t) \xrightarrow{\text{convolution}} \text{whole system } h(t)
$$

对于一个线性时不变 (LTI) 系统，冲激响应为 \(h(t)\)，输入为 \(x(t)\)。分配律描述了**系统对多个输入信号之和的响应**等于**系统对每个输入信号的响应之和**。

$$
\boxed{x(t) * [h_1(t) + h_2(t)] = x(t) * h_1(t) + x(t) * h_2(t)}
$$

$$
\boxed{[x_1(t) + x_2(t)] * h(t) = x_1(t) * h(t) + x_2(t) * h(t)}
$$

**Delay Property**

一个非常有意思的特性，就是和 $\delta(t-t_{0})$ 做卷积，可以让自己延迟 $t_{0}$ ：
$$
x(t)*\delta(t-t_{0})=x(t-t_{0})
$$
好玩的是，这个延迟效果可以叠加：
$$
\delta(t-t_{0})*\delta(t-t_{1})=\delta(t-t_{0}-t_{1})
$$

更进一步的就可以推出如下性质：
![[Pasted image 20260602143520.png]]
证明方法很好玩，就是拆出各自的 delay： $x(t-t_{0})=x(t)*\delta(t-t_{0})$，$h(t-t_{1})=h(t)*\delta(t-t_{1})$
然后换个顺序

既然 $h(t)$ 能直接反应系统的性质，那么根据 $h(t)$ 可以直接判断系统满足的性质：

**Causality**
等价于，对于任意 $\tau<0, h(\tau)=0$
注意到这其实是 $u(t)$ 的性质，因此证明这个我们可以证明 $h(\tau)$ 可以被表示成一个函数和 $u(t)$ 相乘的形式

**Static or Memoryless**
等价于，$h(t)=0$, for $t\neq 0$
也就是，和 $\delta(t)$ 一样

![[Pasted image 20260602144429.png]]

![[Pasted image 20260602144523.png]]
![[Pasted image 20260602144515.png]]

**Stability**

也就是 BIBO stability，要求对于任意有界的输入，输出也都是有界的，可以证明，其**充要条件**就是：==impulse response is absolutely integrable==:
$$
\int_{-\infty}^\infty |h(t)|dt<\infty
$$

**Invertible** 

一个很重要的结论：如果一个系统是 LTI，而且是可逆的，那么它的逆系统同样是 LTI

对于系统 $h(t)$ ，我们表示它的逆系统为 $h_{i}(t)$ , 之前我们知道，卷积反应了两个系统的叠加组合，于是不难理解，如果 $h(t)$ 是可逆的，那么：
$$
h(t) * h_{i}(t) = \delta(t)
$$
![[Pasted image 20260604191704.png]]

有趣的是这甚至不是 Theorem, 而是 Definition

### Step response

在很多时候，寻找一个 LTI System 的 $h(t)$，我们不是直接用 $\delta(t)$ 积分，而是先用 step function $u(t)$ 积分，得到的结果称为 step response, 然后对它求导，得到 impulse response，这得益于 LTI 系统的交换律性质
step response 表示为 $s(t)$

![[Pasted image 20260604192044.png]]

<span class="green"> 这里我认为有必要强调一下，对于 impulse function, step function 这类函数，不能或不建议用传统函数的思维去思考他们，一个比较合适的思维切入点是， focus on 函数括号内的，whatever it is 的整体值，比方说 step function，这个整体值大于0，函数值就是1，否则就是0，按照这个思路去分析会容易得多 </span>

然后就是久违的，微分方程了，这门课我们研究的还都是线性微分方程，回忆286中一种很常见的线性微分方程形式：
$$
a_{1}(x)y'(t) + a_{0}(x)y(t)=f(x)
$$
对应到这门课，$y(t)$ 就是我们研究的系统函数，而 $f(x)$ 是信号函数，$a_{1}(x), a_{0}(x)$, 我们不用管，so far 我们对付的都是系数是常数的线性微分方程：

![[Pasted image 20260604193254.png]]

$N$ 称为 **order of the system**

然后和286基本没什么区别的：

![[Pasted image 20260604193455.png]]
![[Pasted image 20260604193505.png]]

natural response 就是解右侧是0的微分方程，解法也是非常的简单粗暴，或者说非常的 "engineer"，假设 $y(t)=Ce^{st}$ ，然后代入把 s 解出来
最终会得到这样一个多项式方程：
$$
\sum^N_{k=0}a_{k}s^k=0
$$

