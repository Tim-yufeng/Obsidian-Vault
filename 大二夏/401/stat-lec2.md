这节课承接上一讲“点估计”和“矩估计法”，继续讲三个核心内容：**最大似然估计 MLE、均值的置信区间、方差/标准差的置信区间，以及引出 Student-t 分布**。整节课的主线是：我们已经有样本 $x_1,\dots,x_n$，现在要更系统地估计总体参数，并且不仅给一个点估计，还要给一个“可信范围”。

**1. 最大似然估计：选择“最能解释样本”的参数**

先看第 1 页的 Poisson 例子。假设河水样本中大肠杆菌数量 $X$ 服从 Poisson 分布：

$$X\sim Poisson(k)$$

其中 $k$ 是未知参数。Poisson 分布的概率质量函数是：

$$P(X=x)=f(x;k)=\frac{e^{-k}k^x}{x!},\qquad x=0,1,2,\dots$$

现在我们抽到一组样本：

$$x_1,x_2,\dots,x_n$$

因为随机样本意味着 $X_1,\dots,X_n$ 独立同分布，所以同时观察到这一组样本的概率是各个概率的乘积：

$$P(X_1=x_1,\dots,X_n=x_n)=\prod_{i=1}^n P(X_i=x_i)$$

代入 Poisson 分布：

$$L(k)=\prod_{i=1}^n \frac{e^{-k}k^{x_i}}{x_i!}$$

这个 $L(k)$ 就叫 likelihood function，似然函数。它的意思不是“在 $k$ 已知时样本出现的概率”这么简单，而是：**样本已经固定了，把它看成关于参数 $k$ 的函数，问哪个 $k$ 最能让这组样本变得合理。**

把乘积整理一下：

$$L(k)=\frac{e^{-nk}k^{\sum_{i=1}^n x_i}}{\prod_{i=1}^n x_i!}$$

我们要找使 $L(k)$ 最大的 $k$。直接最大化乘积比较麻烦，所以通常取对数。因为 $\log x$ 是单调递增函数，最大化 $L(k)$ 和最大化 $\log L(k)$ 得到的参数一样。

$$\log L(k)=-nk+\left(\sum_{i=1}^n x_i\right)\log k-\log\left(\prod_{i=1}^n x_i!\right)$$

对 $k$ 求导：

$$\frac{d}{dk}\log L(k)=-n+\frac{1}{k}\sum_{i=1}^n x_i$$

令导数等于 $0$：

$$-n+\frac{1}{k}\sum_{i=1}^n x_i=0$$

解得：

$$\hat k=\frac{1}{n}\sum_{i=1}^n x_i=\bar x$$

所以 Poisson 分布参数 $k$ 的最大似然估计就是样本均值：

$$\hat k=\bar X$$

直观理解：Poisson 分布的参数 $k$ 本来就是它的均值，即 $E(X)=k$。所以我们用样本均值估计它，这也很合理。

**2. likelihood 和 probability 的区别**

第 2 页老师专门提醒：在统计里，likelihood 不等于 probability。

如果参数 $\theta$ 固定，变量 $x$ 在变化，那么：

$$f(x;\theta)$$

是概率密度函数或概率质量函数。它描述的是：在这个参数下，不同 $x$ 出现的可能性。

但如果样本观测值 $x$ 已经固定，参数 $\theta$ 在变化，那么：

$$L(\theta)=f(x;\theta)$$

就是似然函数。它描述的是：不同参数 $\theta$ 对这组已观察数据的解释能力。

所以可以这样记：

$x$ 变，$\theta$ 固定，是 probability；

$x$ 固定，$\theta$ 变，是 likelihood。

对于随机样本 $x_1,\dots,x_n$，一般似然函数写成：

$$L(\theta)=\prod_{i=1}^n f(x_i;\theta)$$

最大似然法的标准流程是：

先写出样本的联合概率或联合密度；

把它看作关于参数 $\theta$ 的函数 $L(\theta)$；

最大化 $L(\theta)$ 或 $\log L(\theta)$；

把使它最大的参数记为 $\hat\theta$。

第 2 页还写了 score function。对于单参数情况，score function 定义为：

$$S(\theta)=\frac{d}{d\theta}\log L(\theta)$$

多参数时，它就是梯度：

$$S(\theta)=\nabla_\theta \log L(\theta)$$

最大似然估计常常通过解下面这个方程得到：

$$S(\theta)=0$$

也就是“令 log-likelihood 的导数为零”。

**3. 正态分布下的最大似然估计**

第 3 页讲 Normal 分布的 MLE。设：

$$X_1,\dots,X_n\overset{iid}{\sim}Normal(\mu,\sigma^2)$$

其中 $\mu$ 和 $\sigma^2$ 都未知。正态分布密度是：

$$f(x)=\frac{1}{\sqrt{2\pi}\sigma}e^{-\frac{1}{2}\left(\frac{x-\mu}{\sigma}\right)^2}$$

所以样本似然函数为：

$$L(\mu,\sigma)=\prod_{i=1}^n \frac{1}{\sqrt{2\pi}\sigma}e^{-\frac{1}{2}\left(\frac{x_i-\mu}{\sigma}\right)^2}$$

整理得到：

$$L(\mu,\sigma)=\left(\frac{1}{\sqrt{2\pi}}\right)^n\left(\frac{1}{\sigma}\right)^n e^{-\frac{1}{2\sigma^2}\sum_{i=1}^n(x_i-\mu)^2}$$

取对数：

$$\log L(\mu,\sigma)=-n\log\sqrt{2\pi}-n\log\sigma-\frac{1}{2\sigma^2}\sum_{i=1}^n(x_i-\mu)^2$$

对 $\mu$ 求偏导：

$$\frac{\partial}{\partial\mu}\log L(\mu,\sigma)=\frac{1}{\sigma^2}\sum_{i=1}^n(x_i-\mu)$$

令它为 $0$：

$$\sum_{i=1}^n(x_i-\mu)=0$$

所以：

$$\hat\mu=\frac{1}{n}\sum_{i=1}^n x_i=\bar x$$

再对 $\sigma$ 求偏导，可以得到：

$$\hat\sigma^2=\frac{1}{n}\sum_{i=1}^n(x_i-\hat\mu)^2$$

因为 $\hat\mu=\bar x$，所以：

$$\hat\sigma^2=\frac{1}{n}\sum_{i=1}^n(x_i-\bar x)^2$$

这里要特别注意：**正态分布下 $\sigma^2$ 的 MLE 分母是 $n$，不是 $n-1$。**

上一讲的样本方差是：

$$S^2=\frac{1}{n-1}\sum_{i=1}^n(X_i-\bar X)^2$$

它是 $\sigma^2$ 的无偏估计量。而 MLE 给出的是：

$$\hat\sigma^2=\frac{1}{n}\sum_{i=1}^n(X_i-\bar X)^2$$

它不是无偏的，但它是最大似然估计。这里说明一个重要事实：**无偏估计和最大似然估计不是同一个标准，二者可能给出不同公式。**

**4. 区间估计：不只给一个点，而是给一个范围**

第 4 页开始讲 interval estimation。点估计只给一个数，比如：

$$\hat\mu=\bar x$$

但现实中我们知道，这个数不可能刚好等于真实参数。于是我们希望给一个区间：

$$[L_1,L_2]$$

并且希望它有较高概率包含真实参数 $\theta$。

置信区间的定义是：一个 $100(1-\alpha)%$ 的置信区间 $[L_1,L_2]$ 满足：

$$P(L_1\leq \theta\leq L_2)=1-\alpha$

注意这里的 $L_1,L_2$ 是随机变量，因为它们由样本算出来；而 $\theta$ 是固定但未知的真实参数。

这句话容易误解。比如 $95\%$ 置信区间不是说“这个已经算出来的区间有 $95\%$ 概率包含真值”。更准确地说：**如果我们反复抽样，并且每次都按同一种方法构造区间，那么长期来看大约 $95\%$ 的区间会覆盖真实参数。**

板书第 6 页也特别强调了这个点：一个具体区间要么包含真值，要么不包含真值；95% 描述的是构造区间这个 procedure 的长期成功率。

**5. 方差已知时，正态总体均值的置信区间**

第 4 页和第 5 页讲最经典的情况：总体服从正态分布，$\sigma^2$ 已知，$\mu$ 未知。

设：

$$X_1,\dots,X_n\overset{iid}{\sim}Normal(\mu,\sigma^2)$$

由于正态分布样本均值仍然正态：

$$\bar X\sim Normal\left(\mu,\frac{\sigma^2}{n}\right)$$

标准化后：

$$Z=\frac{\bar X-\mu}{\sigma/\sqrt n}\sim Normal(0,1)$$

如果我们要做 $95%$ 置信区间，就使用标准正态分布中间 $95%$ 的范围：

$$P(-1.96\leq Z\leq 1.96)=0.95$

代入 $Z$：

$$P\left(-1.96\leq \frac{\bar X-\mu}{\sigma/\sqrt n}\leq 1.96\right)=0.95$$

接下来把不等式变形成关于 $\mu$ 的范围：

$$P\left(\bar X-1.96\frac{\sigma}{\sqrt n}\leq \mu\leq \bar X+1.96\frac{\sigma}{\sqrt n}\right)=0.95$$

所以 $95%$ 置信区间是：

$$\left[\bar X-1.96\frac{\sigma}{\sqrt n},\ \bar X+1.96\frac{\sigma}{\sqrt n}\right]$

更一般地，$100(1-\alpha)%$ 置信区间是：

$$\bar X\pm z_{\alpha/2}\frac{\sigma}{\sqrt n}$

其中 $z_{\alpha/2}$ 满足：

$$P(Z>z_{\alpha/2})=\frac{\alpha}{2}$$

也就是说，右尾面积是 $\frac{\alpha}{2}$。

对于 $95%$ 置信区间：

$$\alpha=0.05$

所以：

$$z_{\alpha/2}=z_{0.025}=1.96$$

**6. 白血病例子：计算均值的 95% 置信区间**

第 4 页到第 5 页的例子是急性白血病患者在新疗法下的生存时间。已知标准差：

$$\sigma=3$$

样本容量：

$$n=16$$

样本均值：

$$\bar x=13.88$$

要求 $\mu$ 的 $95%$ 置信区间。套公式：

$$\bar x\pm 1.96\frac{\sigma}{\sqrt n}$

代入：

$$13.88\pm 1.96\frac{3}{\sqrt{16}}$$

因为：

$$1.96\frac{3}{4}=1.47$$

所以区间下界：

$$L_1=13.88-1.47=12.41$$

区间上界：

$$L_2=13.88+1.47=15.35$$

因此 $95%$ 置信区间为：

$$[12.41,\ 15.35]$

解释为：按照这个构造方法，在假设成立时，长期有 $95\%$ 的这类区间会覆盖真实平均生存时间 $\mu$。对于这次样本，我们得到的区间是 $[12.41,15.35]$ months。

**7. 置信区间的真正含义**

第 6 页画了一张图，展示很多次抽样得到很多个区间。有些区间盖住了真实均值 $\mu$，有些没有。$95%$ 的意思是：如果反复抽样并构造区间，大约 $95%$ 的区间会包含真实 $\mu$。

所以不能说：

$$P(\mu\in[12.41,15.35])=0.95$$

因为在频率学派框架下，$\mu$ 是固定常数，不是随机变量。这个具体区间也已经算出来了，它是否包含 $\mu$ 是一个确定事实，只是我们不知道。

应该说：这个区间是由一个覆盖率为 $95\%$ 的方法产生的。

**8. 方差的区间估计：为什么要用卡方分布**

第 7 页开始讲“variability 的区间估计”，也就是总体方差 $\sigma^2$ 或总体标准差 $\sigma$ 的置信区间。

如果：

$$X_1,\dots,X_n\overset{iid}{\sim}Normal(\mu,\sigma^2)$$

那么有一个重要定理：

$$\frac{(n-1)S^2}{\sigma^2}\sim \chi^2(n-1)$$

其中 $S^2$ 是样本方差：

$$S^2=\frac{1}{n-1}\sum_{i=1}^n(X_i-\bar X)^2$$

这个分布是 chi-square distribution，卡方分布，自由度是 $n-1$。

为什么自由度是 $n-1$？直观上，$n$ 个偏差 $X_i-\bar X$ 不是完全自由的，因为它们满足：

$$\sum_{i=1}^n(X_i-\bar X)=0$$

所以只有 $n-1$ 个可以自由变化。

第 7 页还回顾了几个事实：

如果：

$$Z\sim Normal(0,1)$$

那么：

$$Z^2\sim \chi^2(1)$$

如果：

$$X_1,\dots,X_n\overset{iid}{\sim}\chi^2(1)$$

那么：

$$X_1+\cdots+X_n\sim\chi^2(n)$$

而 Cochran 定理告诉我们，对于正态样本：

$$\sum_{i=1}^n\left(\frac{X_i-\bar X}{\sigma}\right)^2\sim\chi^2(n-1)$$

也就是：

$$\frac{(n-1)S^2}{\sigma^2}\sim\chi^2(n-1)$$

这就是构造方差置信区间的基础。

**9. 方差 $\sigma^2$ 的置信区间公式**

我们希望构造：

$$P(L_1\leq \sigma^2\leq L_2)=1-\alpha$$

因为：

$$\frac{(n-1)S^2}{\sigma^2}\sim\chi^2(n-1)$$

所以我们先在卡方分布中取中间 $1-\alpha$ 的概率：

$$P\left(\chi^2_{1-\alpha/2}(n-1)\leq \frac{(n-1)S^2}{\sigma^2}\leq \chi^2_{\alpha/2}(n-1)\right)=1-\alpha$$

这里符号要注意：板书采用的是右尾记号，即 $\chi^2_\alpha(d)$ 表示右尾面积为 $\alpha$ 的临界值：

$$P(\chi^2(d)>\chi^2_\alpha(d))=\alpha$$

因为卡方分布不对称，所以左右临界值不能简单写成正负。

现在把不等式解成关于 $\sigma^2$ 的形式。最终得到：

$$L_1=\frac{(n-1)S^2}{\chi^2_{\alpha/2}(n-1)}$$

$$L_2=\frac{(n-1)S^2}{\chi^2_{1-\alpha/2}(n-1)}$$

因此 $100(1-\alpha)%$ 的方差置信区间为：

$$\left[\frac{(n-1)S^2}{\chi^2_{\alpha/2}(n-1)},\ \frac{(n-1)S^2}{\chi^2_{1-\alpha/2}(n-1)}\right]$

注意这里下界用了较大的卡方临界值 $\chi^2_{\alpha/2}(n-1)$，上界用了较小的卡方临界值 $\chi^2_{1-\alpha/2}(n-1)$。这是因为 $\sigma^2$ 在分母里，取倒数后不等号方向会影响上下界。

如果要求标准差 $\sigma$ 的置信区间，只要对方差区间开根号：

$$\left[\sqrt{L_1},\sqrt{L_2}\right]$$

**10. I/O workload 例子：标准差的 95% 置信区间**

第 8 页和第 9 页给了一个计算机 workload 的例子。样本数量是：

$$n=25$$

所以自由度：

$$n-1=24$$

计算得到样本方差：

$$s^2=1.4075$$

要构造 $95%$ 置信区间，所以：

$$\alpha=0.05$

$$\frac{\alpha}{2}=0.025$$

板书给出的卡方临界值是：

$$\chi^2_{0.025}(24)=39.4$$

$$\chi^2_{0.975}(24)=12.4$$

于是方差区间下界：

$$L_1=\frac{24s^2}{\chi^2_{0.025}(24)}=\frac{24(1.4075)}{39.4}=0.858$$

方差区间上界：

$$L_2=\frac{24s^2}{\chi^2_{0.975}(24)}=\frac{24(1.4075)}{12.4}=2.725$$

所以 $\sigma^2$ 的 $95%$ 置信区间是：

$$[0.858,\ 2.725]$

如果题目要的是标准差 $\sigma$ 的置信区间，就开根号：

$$[\sqrt{0.858},\sqrt{2.725}]$$

近似为：

$$[0.926,\ 1.651]$$

所以标准差的 $95%$ 置信区间约为：

$$[0.93,\ 1.65]$

**11. 引出 Student-t 分布：均值区间里 $\sigma$ 未知怎么办**

第 9 页最后引入 Student-t distribution。前面我们构造均值 $\mu$ 的置信区间时，用的是：

$$Z=\frac{\bar X-\mu}{\sigma/\sqrt n}$$

但这个公式要求 $\sigma$ 已知。现实中总体标准差 $\sigma$ 通常未知，于是很自然地想用样本标准差 $S$ 替代 $\sigma$：

$$\frac{\bar X-\mu}{S/\sqrt n}$$

但是一旦把 $\sigma$ 换成随机变量 $S$，这个量就不再服从标准正态分布，而是服从 Student-t 分布。

板书给出 t 分布的定义：如果：

$$Z\sim Normal(0,1)$$

且：

$$V\sim \chi^2(d)$$

并且 $Z$ 与 $V$ 独立，那么：

$$T=\frac{Z}{\sqrt{V/d}}$$

服从自由度为 $d$ 的 t 分布：

$$T\sim t(d)$$

在正态总体抽样中，有：

$$\frac{\bar X-\mu}{\sigma/\sqrt n}\sim Normal(0,1)$$

并且：

$$\frac{(n-1)S^2}{\sigma^2}\sim\chi^2(n-1)$$

二者独立，所以：

$$\frac{\bar X-\mu}{S/\sqrt n}\sim t(n-1)$$

这就是下一节会继续使用的核心结论。它对应的均值置信区间会变成：

$$\bar X\pm t_{\alpha/2}(n-1)\frac{S}{\sqrt n}$$

和方差已知时的公式：

$$\bar X\pm z_{\alpha/2}\frac{\sigma}{\sqrt n}$$

相比，区别只有两个：

$\sigma$ 换成 $S$；

$z_{\alpha/2}$ 换成 $t_{\alpha/2}(n-1)$。

直观上，$\sigma$ 未知时，我们多了一层不确定性，所以 t 分布尾部比标准正态更厚，临界值通常更大，置信区间也会更宽。

**12. 整节课的逻辑总结**

这节课可以压缩成三条主线。

第一，最大似然估计 MLE。思想是：样本已经观察到了，选择让这组样本“最可能出现”的参数。似然函数是：

$$L(\theta)=\prod_{i=1}^n f(x_i;\theta)$$

常用做法是最大化：

$$\log L(\theta)$$

Poisson 分布的 MLE 是：

$$\hat k=\bar X$$

正态分布中：

$$\hat\mu=\bar X$$

$$\hat\sigma^2=\frac{1}{n}\sum_{i=1}^n(X_i-\bar X)^2$$

第二，均值的置信区间。若总体正态且 $\sigma^2$ 已知：

$$\frac{\bar X-\mu}{\sigma/\sqrt n}\sim Normal(0,1)$$

所以：

$$
\mu\text{ 的 }100(1-\alpha)%\text{ 置信区间}=\bar X\pm z_{\alpha/2}\frac{\sigma}{\sqrt n}
$$

第三，方差和标准差的置信区间。若总体正态：

$$\frac{(n-1)S^2}{\sigma^2}\sim\chi^2(n-1)$$

所以：

$$
\sigma^2\text{ 的 }100(1-\alpha)%\text{ 置信区间}=\left[\frac{(n-1)S^2}{\chi^2_{\alpha/2}(n-1)},\frac{(n-1)S^2}{\chi^2_{1-\alpha/2}(n-1)}\right]
$$

如果要求 $\sigma$，就对两个端点开根号。

最后，当均值置信区间中 $\sigma$ 未知时，我们不能继续用标准正态，而要用 t 分布：

$$\frac{\bar X-\mu}{S/\sqrt n}\sim t(n-1)$$

所以这节课的整体思想就是：**先用 MLE 找最合理的点估计，再用抽样分布构造置信区间；均值靠正态或 t 分布，方差靠卡方分布。**