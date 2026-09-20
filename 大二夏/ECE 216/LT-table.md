## 1. 定义

连续时间信号 $x(t)$ 的双边拉普拉斯变换定义为

$$
X(s)
=
\mathcal{L}\{x(t)\}
=
\int_{-\infty}^{\infty}x(t)e^{-st}\,dt
$$

其中

$$
s=\sigma+j\omega
$$

记作

$$
x(t)
\overset{\mathcal{L}}{\longleftrightarrow}
X(s)
$$

对于双边拉普拉斯变换，一个完整的变换结果必须同时给出：

$$
X(s)
\quad\text{和}\quad
\mathrm{ROC}
$$

其中 ROC 表示收敛域，即 Region of Convergence。

---

## 2. 拉普拉斯变换的性质

设

$$
x(t)
\overset{\mathcal{L}}{\longleftrightarrow}
X(s),
\qquad
\mathrm{ROC}=R
$$

以及

$$
x_1(t)
\overset{\mathcal{L}}{\longleftrightarrow}
X_1(s),
\qquad
\mathrm{ROC}=R_1
$$

$$
x_2(t)
\overset{\mathcal{L}}{\longleftrightarrow}
X_2(s),
\qquad
\mathrm{ROC}=R_2
$$

| 性质 | 时域信号 | 拉普拉斯变换 | ROC |
|:---|:---:|:---:|:---|
| 线性 | $a x_1(t)+b x_2(t)$ | $aX_1(s)+bX_2(s)$ | 至少为 $R_1\cap R_2$ |
| 时间平移 | $x(t-t_0)$ | $e^{-st_0}X(s)$ | $R$ |
| $s$ 域平移 | $e^{s_0t}x(t)$ | $X(s-s_0)$ | $s\in R'$ 当且仅当 $s-s_0\in R$ |
| 时间尺度变换 | $x(at)$ | $\dfrac{1}{\lvert a\rvert}X\left(\dfrac{s}{a}\right)$ | $s\in R'$ 当且仅当 $\dfrac{s}{a}\in R$ |
| 共轭 | $x^*(t)$ | $X^*(s^*)$ | $R$ |
| 卷积 | $x_1(t)*x_2(t)$ | $X_1(s)X_2(s)$ | 至少为 $R_1\cap R_2$ |
| 时域微分 | $\dfrac{d}{dt}x(t)$ | $sX(s)$ | 至少为 $R$ |
| $s$ 域微分 | $t x(t)$ | $-\dfrac{dX(s)}{ds}$ | $R$ |
| 时域积分 | $\displaystyle\int_{-\infty}^{t}x(\tau)\,d\tau$ | $\dfrac{1}{s}X(s)$ | 至少为 $R\cap\{s:\operatorname{Re}(s)>0\}$ |

其中时间尺度变换要求

$$
a\in\mathbb{R},
\qquad
a\neq 0
$$

卷积定义为

$$
x_1(t)*x_2(t)
=
\int_{-\infty}^{\infty}
x_1(\tau)x_2(t-\tau)\,d\tau
$$

### 关于“至少为”的说明

在线性、卷积和时域微分性质中，实际 ROC 可能比表中给出的区域更大，因为不同项之间可能发生极点与零点相消。

---

## 3. 初值定理与终值定理

### 初值定理

若

$$
x(t)=0,
\qquad
t<0
$$

并且 $x(t)$ 在 $t=0$ 处不含冲激或更高阶奇异函数，则

$$
x(0^+)
=
\lim_{s\to\infty}sX(s)
$$

### 终值定理

若

$$
x(t)=0,
\qquad
t<0
$$

并且 $x(t)$ 在 $t\to\infty$ 时存在有限极限，则

$$
\lim_{t\to\infty}x(t)
=
\lim_{s\to0}sX(s)
$$

对于有理系统函数，常用的等价检查方法是：

$$
sX(s)
$$

除允许在原点存在一个简单极点的特殊表述外，其相关极点必须位于开左半平面，才能保证信号收敛到有限终值。

---

## 4. 基本拉普拉斯变换对

以下取

$$
n=1,2,3,\ldots
$$

$\alpha$ 可以是实数或复数。

| 编号 | 时域信号 $x(t)$ | 拉普拉斯变换 $X(s)$ | ROC |
|:---:|:---:|:---:|:---:|
| 1 | $\delta(t)$ | $1$ | 所有 $s$ |
| 2 | $u(t)$ | $\dfrac{1}{s}$ | $\operatorname{Re}(s)>0$ |
| 3 | $-u(-t)$ | $\dfrac{1}{s}$ | $\operatorname{Re}(s)<0$ |
| 4 | $\dfrac{t^{n-1}}{(n-1)!}u(t)$ | $\dfrac{1}{s^n}$ | $\operatorname{Re}(s)>0$ |
| 5 | $-\dfrac{t^{n-1}}{(n-1)!}u(-t)$ | $\dfrac{1}{s^n}$ | $\operatorname{Re}(s)<0$ |
| 6 | $e^{-\alpha t}u(t)$ | $\dfrac{1}{s+\alpha}$ | $\operatorname{Re}(s)>-\operatorname{Re}(\alpha)$ |
| 7 | $-e^{-\alpha t}u(-t)$ | $\dfrac{1}{s+\alpha}$ | $\operatorname{Re}(s)<-\operatorname{Re}(\alpha)$ |
| 8 | $\dfrac{t^{n-1}}{(n-1)!}e^{-\alpha t}u(t)$ | $\dfrac{1}{(s+\alpha)^n}$ | $\operatorname{Re}(s)>-\operatorname{Re}(\alpha)$ |
| 9 | $-\dfrac{t^{n-1}}{(n-1)!}e^{-\alpha t}u(-t)$ | $\dfrac{1}{(s+\alpha)^n}$ | $\operatorname{Re}(s)<-\operatorname{Re}(\alpha)$ |
| 10 | $\delta(t-T)$ | $e^{-sT}$ | 所有 $s$ |
| 11 | $\cos(\omega_0t)u(t)$ | $\dfrac{s}{s^2+\omega_0^2}$ | $\operatorname{Re}(s)>0$ |
| 12 | $\sin(\omega_0t)u(t)$ | $\dfrac{\omega_0}{s^2+\omega_0^2}$ | $\operatorname{Re}(s)>0$ |
| 13 | $e^{-\alpha t}\cos(\omega_0t)u(t)$ | $\dfrac{s+\alpha}{(s+\alpha)^2+\omega_0^2}$ | $\operatorname{Re}(s)>-\operatorname{Re}(\alpha)$ |
| 14 | $e^{-\alpha t}\sin(\omega_0t)u(t)$ | $\dfrac{\omega_0}{(s+\alpha)^2+\omega_0^2}$ | $\operatorname{Re}(s)>-\operatorname{Re}(\alpha)$ |
| 15 | $u_n(t)=\dfrac{d^n\delta(t)}{dt^n}$ | $s^n$ | 所有 $s$ |
| 16 | $\displaystyle u_{-n}(t)=\underbrace{u(t)*u(t)*\cdots*u(t)}_{n\text{ 次}}$ | $\dfrac{1}{s^n}$ | $\operatorname{Re}(s)>0$ |

---

## 5. 指数变换对的另一种常用写法

MIT/Oppenheim 表格采用

$$
e^{-\alpha t}
$$

的形式。如果改用 $e^{at}$，令

$$
a=-\alpha
$$

则有以下等价形式。

### 右边信号

$$
e^{at}u(t)
\overset{\mathcal{L}}{\longleftrightarrow}
\frac{1}{s-a},
\qquad
\operatorname{Re}(s)>\operatorname{Re}(a)
$$

### 左边信号

$$
e^{at}u(-t)
\overset{\mathcal{L}}{\longleftrightarrow}
-\frac{1}{s-a},
\qquad
\operatorname{Re}(s)<\operatorname{Re}(a)
$$

等价地，

$$
-e^{at}u(-t)
\overset{\mathcal{L}}{\longleftrightarrow}
\frac{1}{s-a},
\qquad
\operatorname{Re}(s)<\operatorname{Re}(a)
$$

因此，下面两个不同信号具有相同的代数表达式：

$$
e^{at}u(t)
\overset{\mathcal{L}}{\longleftrightarrow}
\frac{1}{s-a},
\qquad
\operatorname{Re}(s)>\operatorname{Re}(a)
$$

$$
-e^{at}u(-t)
\overset{\mathcal{L}}{\longleftrightarrow}
\frac{1}{s-a},
\qquad
\operatorname{Re}(s)<\operatorname{Re}(a)
$$

它们必须依靠 ROC 加以区分。

---

## 6. 关于双边拉普拉斯变换与 ROC

对于双边拉普拉斯变换，仅给出

$$
X(s)
$$

通常不足以唯一确定 $x(t)$，还必须给出 ROC。

例如：

$$
X(s)=\frac{1}{s+1}
$$

若

$$
\operatorname{Re}(s)>-1
$$

则

$$
x(t)=e^{-t}u(t)
$$

若

$$
\operatorname{Re}(s)<-1
$$

则

$$
x(t)=-e^{-t}u(-t)
$$

因此，严格的变换对应该写成

$$
x(t)
\overset{\mathcal{L}}{\longleftrightarrow}
\bigl[X(s),\mathrm{ROC}\bigr]
$$

而不应只写代数表达式 $X(s)$。

---

## 7. 常用 ROC 规律

1. ROC 内不包含任何极点。

2. 对右边信号，ROC 位于最右侧极点的右边：

$$
\operatorname{Re}(s)>
\text{最右侧极点的实部}
$$

3. 对左边信号，ROC 位于最左侧极点的左边：

$$
\operatorname{Re}(s)<
\text{最左侧极点的实部}
$$

4. 对双边信号，ROC 通常是两条垂直线之间的区域：

$$
\sigma_1<\operatorname{Re}(s)<\sigma_2
$$

5. 若连续时间 LTI 系统因果，并且其系统函数为有理函数，则 ROC 位于最右侧极点的右边。

6. 若连续时间 LTI 系统稳定，则系统函数的 ROC 必须包含虚轴：

$$
s=j\omega
$$

7. 若一个有理系统既因果又稳定，则它的所有极点必须位于开左半平面：

$$
\operatorname{Re}(p_k)<0
$$

