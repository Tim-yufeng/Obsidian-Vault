# 9. Laplace Transforms

## 从 Fourier transform 到 Laplace transform

Fourier series 与 Fourier transform 都把信号拆成 $e^{j\omega t}$，一个重要原因是 complex exponential 是 LTI system 的 eigenfunction。Laplace transform 把这个指数从纯旋转推广为

$$
e^{st}=e^{(\sigma+j\omega)t}=e^{\sigma t}e^{j\omega t}.
$$

也就是说，$\omega$ 仍然控制振荡，而 $\sigma$ 允许指数增长或衰减。对一个原本无法直接做 Fourier transform 的信号，合适的 exponential weighting 可能先把它“压住”，再读取其 frequency content；这就是引入 Laplace transform 与 region of convergence (ROC) 的理由。

Bilateral Laplace transform 定义为

$$
X(s)=\int_{-\infty}^{\infty}x(t)e^{-st}\,dt,\qquad s=\sigma+j\omega,
$$

记作 $x(t)\xleftrightarrow{\mathcal L}X(s)$。Unilateral Laplace transform 把积分下限改为 $0^-$；本章按课件主要使用 bilateral form。对 causal signal，两者通常一致，因此之后不再反复标注 bilateral。

## Region of Convergence

对固定的 $s$，Laplace transform 是否存在取决于加权后的信号是否 absolutely integrable：

$$
\mathrm{ROC}=\left\{s:\int_{-\infty}^{\infty}|x(t)|e^{-\operatorname{Re}(s)t}\,dt<\infty\right\}.
$$

以 right-sided exponential 为例，积分中真正决定收敛的是 $e^{-(s+a)t}$。当 $t\to\infty$ 时必须有 $\operatorname{Re}(s+a)>0$，所以

$$
e^{-at}u(t)\xleftrightarrow{\mathcal L}\frac{1}{s+a},\qquad \operatorname{Re}(s)>\operatorname{Re}(-a).
$$

若把信号放到时间轴左侧，则同一个代数式对应完全不同的收敛方向：

$$
-e^{-at}u(-t)\xleftrightarrow{\mathcal L}\frac{1}{s+a},\qquad \operatorname{Re}(s)<\operatorname{Re}(-a).
$$

<span class="red">一个 bilateral Laplace transform 必须由代数表达式与 ROC 共同指定。</span> 只写 $1/(s+a)$ 无法判断原信号是 right-sided、left-sided 还是 two-sided。换句话说，ROC 不是附在答案后面的装饰，而是在记录哪些 exponential weighting 仍能让积分收敛。

当 $\sigma=0$ 时，Laplace transform 沿 $j\omega$ axis 的值退化为 Fourier transform：

$$
X(\omega)=X(s)\big|_{s=j\omega}=X(j\omega),
$$

但前提是 ROC 包含整个 $j\omega$ axis。课件中的 $\cos(\omega_0t)$ 例子正好说明边界：右半轴与左半轴的收敛要求无法同时满足，因此 bilateral LT 的 ROC 为空。

## Rational Laplace Transform 与 Pole-Zero Plot

当 $X(s)$ 可以写成多项式之比时，称其为 rational Laplace transform：

$$
X(s)=\frac{N(s)}{D(s)}
=\frac{b_ms^m+\cdots+b_1s+b_0}{a_ns^n+\cdots+a_1s+a_0}
=G\frac{(s-z_1)\cdots(s-z_m)}{(s-p_1)\cdots(s-p_n)},
$$

其中 $z_k$ 是 zeros，$p_k$ 是 poles，$G=b_m/a_n$ 是 gain。Pole-zero plot 与 $G$ 决定代数表达式，ROC 再决定它对应的时域信号；三者缺一不可。对于 rational LT，ROC 不能包含 pole，其边界只能落在 pole 或 infinity 上。

ROC 的形状由信号在时间轴上的支撑方向决定：
- finite-duration 且 absolutely integrable：ROC 是整个 $s$-plane；
- right-sided：ROC 是某条竖线右侧；rational LT 时位于最右 pole 的右边；
- left-sided：ROC 是某条竖线左侧；rational LT 时位于最左 pole 的左边；
- two-sided：ROC 是两条竖线之间的 strip；rational LT 时位于一对相邻 poles 之间。

这几类并不是要死记四张图。对 right-sided signal，增大 $\sigma$ 会让 $e^{-\sigma t}$ 在 $t\to\infty$ 方向衰减得更快，所以一旦某个 $\sigma_0$ 收敛，其右侧也会收敛；left-sided signal 的逻辑完全反向。

## 常用 Transform Pairs 与 Inverse Laplace Transform

本章真正需要反复调用的 pairs 不多：

| $x(t)$ | $X(s)$ | ROC |
|---|---|---|
| $\delta(t)$ | $1$ | entire $s$-plane |
| $u(t)$ | $1/s$ | $\operatorname{Re}(s)>0$ |
| $e^{-at}u(t)$ | $1/(s+a)$ | $\operatorname{Re}(s)>\operatorname{Re}(-a)$ |
| $-e^{-at}u(-t)$ | $1/(s+a)$ | $\operatorname{Re}(s)<\operatorname{Re}(-a)$ |
| $t^ne^{-at}u(t)$ | $n!/(s+a)^{n+1}$ | $\operatorname{Re}(s)>\operatorname{Re}(-a)$ |
| $\sin(\omega_0t)u(t)$ | $\omega_0/(s^2+\omega_0^2)$ | $\operatorname{Re}(s)>0$ |
| $\cos(\omega_0t)u(t)$ | $s/(s^2+\omega_0^2)$ | $\operatorname{Re}(s)>0$ |

Inverse LT 可以看成沿 ROC 中任意一条竖线做 inverse Fourier transform：

$$
x(t)=\frac{1}{2\pi j}\int_{\sigma-j\infty}^{\sigma+j\infty}X(s)e^{st}\,ds,
$$

其中固定的 $\sigma$ 必须位于 ROC 内。一般计算需要 complex analysis；本课程处理 rational LT 时，实际采用 partial fraction expansion (PFE) 与 table lookup：
1. 若 $X(s)$ 是 improper rational function，先用 long division 分成 polynomial 与 proper rational part；polynomial part 对应 $\delta(t)$ 及其 derivatives。
2. 对 proper part 做 PFE，把它拆成常见的 pole terms。
3. 用 ROC 决定每一项取 right-sided 还是 left-sided pair，再相加得到 $x(t)$。

例如

$$
X(s)=\frac{1}{(s+1)^2+1},\qquad \operatorname{Re}(s)>-1
$$

的两个 poles 位于 $-1\pm j$，ROC 在它们右侧，因此

$$
x(t)=e^{-t}\sin(t)u(t).
$$

若只有 pole-zero plot 而没有 ROC，inverse LT 通常不唯一。每种可能的 ROC 都在选择一组不同的 time-sided terms，这正是前面“代数式相同而信号不同”的系统版本。

## ROC、Causality 与 Stability

对 rational LTI system，system function $H(s)$ 的 ROC 直接编码了两种系统性质：

$$
\text{BIBO stable}\iff \mathrm{ROC}\text{ contains the }j\omega\text{ axis},
$$

$$
\text{causal}\iff \mathrm{ROC}\text{ is a right half-plane}.
$$

因此，对 causal rational system，若把 infinity 处的 pole 也计入，系统 stable 当且仅当所有 poles 都严格位于 left half-plane (LHP)。对通常的 proper transfer function，只检查 finite poles 就够了；$H(s)=s$ 没有 finite pole，但它是 differentiator，等价于在 infinity 有 pole，仍然不是 BIBO stable。

![[Pasted image 20260810000720.png]]

这张图把 time-sidedness 放在行上，把 stable、marginally stable 与 unstable 放在列上。灰色区域是 ROC，叉号是 poles；先看 ROC 朝哪边延伸判断 causality，再看它是否包含 $j\omega$ axis 判断 stability。这样读比单独背“pole 在左边”更可靠，因为 two-sided 与 anti-causal system 也可能稳定。

Pole 同时控制 natural response 的 mode。若 poles distinct，causal differential-equation system 的 impulse response 具有

$$
h(t)=\sum_k r_ke^{s_kt}u(t).
$$

写成 $s_k=\sigma_k+j\omega_k$ 后，$e^{\sigma_kt}$ 决定增长或衰减，$e^{j\omega_kt}$ 决定振荡；real-coefficient system 的 complex poles 与 residues 成 conjugate pairs，合并后得到 real damped sinusoid。Repeated pole 则会多出 $t^n e^{s_kt}$ 形式的 mode。

## 从 Pole-Zero Plot 读取 Frequency Response

只要 ROC 包含 $j\omega$ axis，frequency response 就是在 pole-zero expression 中代入 $s=j\omega$：

$$
H(\omega)=G\frac{(j\omega-z_1)\cdots(j\omega-z_m)}{(j\omega-p_1)\cdots(j\omega-p_n)}.
$$

![[Pasted image 20260810000734.png]]

图中的圆圈是 zero，$j\omega$ axis 上移动的观察点对应当前 frequency。每个 $j\omega-z_k$ 都是一条从 zero 指向观察点的 vector；pole term 同理。因此 magnitude 是距离的乘除，phase 是这些 vector angles 的加减：

$$
|H(\omega)|=|G|\frac{\prod_k|j\omega-z_k|}{\prod_k|j\omega-p_k|},
$$

$$
\angle H(\omega)=\angle G+\sum_k\angle(j\omega-z_k)-\sum_k\angle(j\omega-p_k).
$$

观察点靠近 zero 时 magnitude 被压低，靠近 pole 时 magnitude 被抬高；若 zero 正好落在 $j\omega$ axis 上，对应 frequency 的 response 为零，这就是 notch filter 的几何读法。课件也给出了常见 second-order system 的 searchable form：

$$
H(s)=\frac{\omega_n^2}{s^2+2\zeta\omega_ns+\omega_n^2}.
$$

## Properties of the Laplace Transform

对 LTI system 最关键的三条是 linearity、time differentiation 与 convolution；其余性质主要用于把复杂 signal 改写成已有 pair。

| Property | Time domain | $s$-domain / ROC |
|---|---|---|
| Linearity | $a_1x_1(t)+a_2x_2(t)$ | $a_1X_1(s)+a_2X_2(s)$；ROC 至少包含原 ROCs 的 intersection，term cancellation 可能使其扩大 |
| Time differentiation | $\dfrac{d}{dt}x(t)$ | $sX(s)$；pole cancellation 可能使 ROC 扩大 |
| Convolution | $x(t)*h(t)$ | $X(s)H(s)$；ROC 至少包含原 ROCs 的 intersection，cancellation 可能使其扩大 |
| Time shift | $x(t-t_0)$ | $e^{-t_0s}X(s)$；ROC 不变，但原本 rational 的 LT 通常变为 non-rational |
| Modulation | $e^{s_0t}x(t)$ | $X(s-s_0)$；ROC 沿 real axis 平移 $\operatorname{Re}(s_0)$ |
| Time scaling | $x(at)$，$a\ne0$ | $\dfrac{1}{\lvert a\rvert}X(s/a)$；ROC 按 $a$ 缩放并在 $a<0$ 时反向 |
| Differentiation in $s$ | $-tx(t)$ | $\dfrac{d}{ds}X(s)$；ROC 不变 |
| Running integration | $\displaystyle\int_{-\infty}^{t}x(\tau)\,d\tau$ | $X(s)/s$；新 ROC 必须包含旧 ROC 与 $\operatorname{Re}(s)>0$ 的 intersection |

Linearity 与 convolution 的 ROC 只保证“至少”为 intersection，因为代数运算可能消掉 pole。这个细节解释了为什么不能只对两个 ROC 做机械交集，还必须把最终 expression 化简后再检查。

## 用 Laplace Transform 解 LTI Differential Equation

课件最后把这些性质合并到一个 step-response 问题中。对 causal LTI system

$$
y(t)+2\frac{d}{dt}y(t)=x(t)+\frac{d}{dt}x(t),
$$

利用 linearity 与 differentiation property：

$$
(1+2s)Y(s)=(1+s)X(s),
$$

所以

$$
H(s)=\frac{Y(s)}{X(s)}=\frac{1+s}{1+2s}=\frac{1}{2}\frac{s+1}{s+1/2}.
$$

输入为 $x(t)=u(t)$ 时，$X(s)=1/s$。再用 convolution property 与 PFE：

$$
Y(s)=H(s)X(s)=-\frac{1/2}{s+1/2}+\frac{1}{s}.
$$

已知 input 与 system 都 causal，因此选择 right-sided inverse pairs：

$$
y(t)=-\frac{1}{2}e^{-t/2}u(t)+u(t).
$$

$-\frac{1}{2}e^{-t/2}u(t)$ 是由 pole $s=-1/2$ 决定、最终衰减到零的 natural/transient response；$u(t)$ 是由持续输入留下的 forced/steady-state response。至此，Laplace transform 的作用不再只是把积分换成代数，而是把 system mode、causality、stability 与实际求解放进同一张 $s$-plane 地图里。


