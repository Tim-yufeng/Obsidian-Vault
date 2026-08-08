这一页板书讲的就是 **Student-t 分布的概率密度函数 PDF**，以及它的两个基本性质：

1. $t$ 分布关于 $0$ 对称；
    
2. 自由度 $d\to\infty$ 时，$t$ 分布趋近标准正态分布。
    

板书第一行写的是自由度为 $d$ 的 Student-t 分布密度函数：

$$f_{T_d}(t)=\frac{\Gamma\left(\frac{d+1}{2}\right)}{\Gamma\left(\frac{d}{2}\right)\sqrt{\pi d}}\left(1+\frac{t^2}{d}\right)^{-\frac{d+1}{2}},\qquad t\in\mathbb{R}$$

这里：

$T_d$ 表示自由度为 $d$ 的 t 分布随机变量；

$\Gamma(\cdot)$ 是 Gamma 函数；

$d$ 是 degrees of freedom，自由度；

$t$ 是随机变量可能取到的值。

它的符号可以写成：

$$T_d\sim t(d)$$

或者：

$$T_d\sim t_d$$

---

这页在讲什么？

你前面学到 t 分布是这样定义出来的：

如果

$$Z\sim Normal(0,1)$$

并且

$$V\sim \chi^2(d)$$

且 $Z$ 与 $V$ 独立，那么

$$T=\frac{Z}{\sqrt{V/d}}$$

服从自由度为 $d$ 的 Student-t 分布：

$$T\sim t(d)$$

这一页就是把这个 $T$ 的具体密度函数写出来。

也就是说，这个式子不是凭空定义的，而是从

$$T=\frac{Z}{\sqrt{V/d}}$$

推导出来的。

---

为什么 t 分布会长成这个形式？

我们不需要在工程概率课里完整推密度变换，但可以知道它来自两个分布的组合。

第一，标准正态变量 $Z$ 的密度是：

$$f_Z(z)=\frac{1}{\sqrt{2\pi}}e^{-z^2/2}$$

第二，卡方变量 $V\sim\chi^2(d)$ 的密度是：

$$f_V(v)=\frac{1}{2^{d/2}\Gamma(d/2)}v^{d/2-1}e^{-v/2},\qquad v>0$$

然后定义：

$$T=\frac{Z}{\sqrt{V/d}}$$

直观上，它是“标准正态变量除以一个由卡方变量产生的随机尺度”。

因为分母 $\sqrt{V/d}$ 是随机的，所以 $T$ 比标准正态更容易出现较大的绝对值。也就是说，t 分布的尾巴更厚。

如果真的要推导，就要做变量变换。令：

$$T=\frac{Z}{\sqrt{V/d}}$$

等价于：

$$Z=T\sqrt{\frac{V}{d}}$$

然后对联合密度 $f_{Z,V}(z,v)$ 做变量替换，把 $z$ 换成 $t\sqrt{v/d}$，再对 $v$ 积分掉，最后会得到：

$$f_{T_d}(t)=\frac{\Gamma\left(\frac{d+1}{2}\right)}{\Gamma\left(\frac{d}{2}\right)\sqrt{\pi d}}\left(1+\frac{t^2}{d}\right)^{-\frac{d+1}{2}}$$

你现在不用强行记住推导细节，重点是知道它从 “标准正态除以随机标准差” 得来。

---

为什么它关于 $0$ 对称？

看密度函数：

$$f_{T_d}(t)=\frac{\Gamma\left(\frac{d+1}{2}\right)}{\Gamma\left(\frac{d}{2}\right)\sqrt{\pi d}}\left(1+\frac{t^2}{d}\right)^{-\frac{d+1}{2}}$$

里面和 $t$ 有关的地方只有：

$$t^2$$

所以把 $t$ 换成 $-t$，密度不变：

$$f_{T_d}(-t)=f_{T_d}(t)$$

因此 t 分布是关于 $0$ 对称的。

这和标准正态分布一样，都是中间高、两边低、关于 $0$ 对称。

---

为什么 $d\to\infty$ 时趋近标准正态？

板书第二个性质写的是：

$$f_{T_d}\xrightarrow[d\to\infty]{}f_Z$$

其中：

$$Z\sim Normal(0,1)$$

意思是：自由度 $d$ 越大，t 分布越接近标准正态分布。

直观理解来自 t 分布的定义：

$$T=\frac{Z}{\sqrt{V/d}}$$

其中：

$$V\sim\chi^2(d)$$

而卡方分布有：

$$E(V)=d$$

所以：

$$E\left(\frac{V}{d}\right)=1$$

当自由度 $d$ 很大时，$\frac{V}{d}$ 会越来越稳定地接近 $1$。于是：

$$\sqrt{\frac{V}{d}}\approx 1$$

所以：

$$T=\frac{Z}{\sqrt{V/d}}\approx Z$$

因此 t 分布趋近于标准正态分布。

这就是为什么样本量很大时，t 检验和 z 检验差别很小。

---

它和前面置信区间有什么关系？

前面如果总体方差 $\sigma^2$ 已知，我们用：

$$Z=\frac{\bar X-\mu}{\sigma/\sqrt n}\sim Normal(0,1)$$

于是均值置信区间是：

$$\bar X\pm z_{\alpha/2}\frac{\sigma}{\sqrt n}$$

但现实中 $\sigma$ 常常未知，只能用样本标准差 $S$ 代替：

$$\frac{\bar X-\mu}{S/\sqrt n}$$

这个量就不再服从标准正态，而是服从 t 分布：

$$\frac{\bar X-\mu}{S/\sqrt n}\sim t(n-1)$$

所以均值置信区间变成：

$$\bar X\pm t_{\alpha/2}(n-1)\frac{S}{\sqrt n}$$

这里自由度是：

$$d=n-1$$

原因还是之前讲的：计算 $S^2$ 时用 $\bar X$ 估计了 $\mu$，消耗了一个自由度。

---

t 分布和标准正态最大的区别

t 分布和标准正态都满足：

中心在 $0$；

左右对称；

钟形曲线。

但 t 分布的尾巴更厚。也就是说，t 分布更容易出现离 $0$ 很远的值。

原因是 t 分布里面多了一个随机分母：

$$\sqrt{V/d}$$

当这个分母偶然偏小时，$T$ 的绝对值会被放大，所以尾部更厚。

自由度越小，分母的不确定性越大，尾巴越厚；

自由度越大，分母越稳定，t 分布越像标准正态。

---

一句话总结这页板书：

这一页是在给出自由度为 $d$ 的 Student-t 分布密度函数

$$f_{T_d}(t)=\frac{\Gamma\left(\frac{d+1}{2}\right)}{\Gamma\left(\frac{d}{2}\right)\sqrt{\pi d}}\left(1+\frac{t^2}{d}\right)^{-\frac{d+1}{2}}$$

并说明它是关于 $0$ 对称的，而且当自由度 $d$ 越来越大时，它会趋近标准正态分布：

$$t(d)\to Normal(0,1)$$

在实际做题里，你最需要记住的是：

$$\frac{\bar X-\mu}{S/\sqrt n}\sim t(n-1)$$

然后用它构造 $\sigma$ 未知时的均值置信区间或 t 检验。