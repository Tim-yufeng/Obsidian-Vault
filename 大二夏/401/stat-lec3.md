下面按这份板书的顺序讲。整节课可以分成三大块：**先补完 Student-t 分布和 $\sigma^2$ 未知时的均值置信区间；然后进入 Hypothesis Testing；最后重点讲 Fisher significance test、$p$-value、显著性水平和 p-hacking 误用。**

**一、先回顾 Student-t 分布**

板书第 1 页先回顾记号：我们可以写

$$T_d,\ t_d,\ T(d),\ t(d)$$

来表示自由度为 $d$ 的 Student-t 随机变量或 t 分布。自由度 $d$ 一般是正整数：

$$d=1,2,3,\dots$$

自由度为 $d$ 的 t 分布密度函数是：

$$f_{T_d}(t)=\frac{\Gamma\left(\frac{d+1}{2}\right)}{\Gamma\left(\frac{d}{2}\right)\sqrt{\pi d}}\left(1+\frac{t^2}{d}\right)^{-\frac{d+1}{2}},\qquad t\in\mathbb{R}$$

其中 $\Gamma(\cdot)$ 是 Gamma 函数。这个公式不需要你每次手推，但要知道它来自 t 分布的定义：

$$T=\frac{Z}{\sqrt{V/d}}$$

其中：

$$Z\sim Normal(0,1)$$

$$V\sim \chi^2(d)$$

并且 $Z$ 与 $V$ 独立。

直观理解：t 分布就是“标准正态变量除以一个随机尺度”。因为分母 $\sqrt{V/d}$ 是随机的，所以 t 分布比标准正态更容易出现很大的绝对值，也就是**尾巴更厚**。

t 分布有几个性质：

第一，它关于 $0$ 对称。因为密度函数里和 $t$ 有关的部分只有 $t^2$，所以：

$$f_{T_d}(-t)=f_{T_d}(t)$$

第二，自由度越大，t 分布越接近标准正态分布：

$$T_d\xrightarrow[d\to\infty]{}Z$$

其中：

$$Z\sim Normal(0,1)$$

原因是：

$$V\sim \chi^2(d)$$

并且：

$$E(V)=d$$

当 $d$ 很大时，$\frac{V}{d}$ 会越来越稳定地接近 $1$，所以：

$$T=\frac{Z}{\sqrt{V/d}}\approx Z$$

第三，$d=1$ 的 t 分布就是 Cauchy distribution。板书写：

$$f_{T_1}(x)=\frac{1}{\pi}\frac{1}{1+x^2}$$

Cauchy 分布非常“野”，它的期望不存在：

$$E(T_1)\text{ does not exist}$$

更一般地，如果：

$$X\sim t(d)$$

那么 $E(X^k)$ 存在的条件是：

$$k<d$$

所以当 $d>1$ 时，均值存在，而且：

$$E(X)=0$$

当 $d>2$ 时，方差存在，而且：

$$Var(X)=\frac{d}{d-2}$$

这也解释了为什么 t 分布小自由度时尾巴很厚：小自由度时高阶矩甚至可能不存在。

**二、为什么 $\sigma^2$ 未知时要用 t 分布**

前面我们学过，如果总体正态且 $\sigma$ 已知，那么：

$$X_1,\dots,X_n\overset{iid}{\sim}Normal(\mu,\sigma^2)$$

则样本均值满足：

$$\bar X\sim Normal\left(\mu,\frac{\sigma^2}{n}\right)$$

所以标准化后：

$$Z=\frac{\bar X-\mu}{\sigma/\sqrt n}\sim Normal(0,1)$$

于是 $\mu$ 的置信区间是：

$$\bar X\pm z_{\alpha/2}\frac{\sigma}{\sqrt n}$$

但是现实中 $\sigma$ 通常未知。我们只能用样本标准差 $S$ 代替 $\sigma$，得到：

$$\frac{\bar X-\mu}{S/\sqrt n}$$

关键点是：一旦把固定的 $\sigma$ 换成随机的 $S$，这个量就不再服从标准正态分布，而是服从 t 分布。

板书第 1 页的定理就是：

如果：

$$X_1,\dots,X_n\overset{iid}{\sim}Normal(\mu,\sigma^2)$$

那么：

$$\frac{\bar X-\mu}{S/\sqrt n}\sim t(n-1)$$

这个式子怎么来的？利用两个事实：

$$Z=\frac{\bar X-\mu}{\sigma/\sqrt n}\sim Normal(0,1)$$

以及：

$$V=\frac{(n-1)S^2}{\sigma^2}\sim \chi^2(n-1)$$

而且在正态样本下，$\bar X$ 和 $S^2$ 独立，所以 $Z$ 和 $V$ 独立。于是：

$$\frac{Z}{\sqrt{V/(n-1)}}\sim t(n-1)$$

把 $Z$ 和 $V$ 代进去：

$$\frac{\frac{\bar X-\mu}{\sigma/\sqrt n}}{\sqrt{\frac{(n-1)S^2/\sigma^2}{n-1}}}=\frac{\frac{\bar X-\mu}{\sigma/\sqrt n}}{S/\sigma}=\frac{\bar X-\mu}{S/\sqrt n}$$

所以：

$$\frac{\bar X-\mu}{S/\sqrt n}\sim t(n-1)$$

这就是 t 分布在统计推断里最重要的来源。

**三、$\sigma^2$ 未知时，均值 $\mu$ 的置信区间**

由刚才的结论：

$$\frac{\bar X-\mu}{S/\sqrt n}\sim t(n-1)$$

所以对于 $100(1-\alpha)%$ 置信区间，有：

$$P\left(-t_{\alpha/2}(n-1)\leq \frac{\bar X-\mu}{S/\sqrt n}\leq t_{\alpha/2}(n-1)\right)=1-\alpha$$

把不等式解成关于 $\mu$ 的形式，得到：

$$\bar X-t_{\alpha/2}(n-1)\frac{S}{\sqrt n}\leq \mu\leq \bar X+t_{\alpha/2}(n-1)\frac{S}{\sqrt n}$$

所以置信区间公式是：

$$\bar X\pm t_{\alpha/2}(n-1)\frac{S}{\sqrt n}$$

和 $\sigma$ 已知时的公式比较：

$$\bar X\pm z_{\alpha/2}\frac{\sigma}{\sqrt n}$$

区别只有两个：

$\sigma$ 未知，所以用 $S$ 代替；

标准正态临界值 $z_{\alpha/2}$ 换成 t 临界值 $t_{\alpha/2}(n-1)$。

因为 t 分布尾巴更厚，所以同样置信水平下，$t_{\alpha/2}(n-1)$ 通常比 $z_{\alpha/2}$ 大，区间会更宽。这很合理：$\sigma$ 未知，多了一层不确定性，所以区间应该更保守。

**四、二氧化硫浓度例子**

板书第 2 页给了一个例子：某巴伐利亚森林被认为受到酸雨损害，测得 $24$ 个 sulfur dioxide concentration 数据。计算器给出：

$$n=24$$

$$\bar x=53.91666667$$

$$s=10.07371382$$

四舍五入后：

$$\bar x\approx 53.92$$

$$s\approx 10.07$$

因为 $\sigma$ 未知，所以用 t 置信区间。自由度是：

$$n-1=23$$

做 $95%$ 置信区间时：

$$\alpha=0.05$$

$$\frac{\alpha}{2}=0.025$$

查表得到：

$$t_{0.025}(23)=2.069$$

于是：

$$\bar x\pm t_{0.025}(23)\frac{s}{\sqrt n}=53.92\pm 2.069\frac{10.07}{\sqrt{24}}$$

计算得到：

$$53.92\pm 4.25$$

所以区间是：

$$[49.67,\ 58.17]$$

这个区间表示：我们用这组样本构造出的 $95%$ 置信区间为 $[49.67,58.17]$。未受损地区的平均浓度是 $20\ \mu g/m^3$，而：

$$20\notin [49.67,\ 58.17]$$

所以有证据认为该受损森林的二氧化硫平均浓度显著偏高。

**五、进入 Hypothesis Testing：三种思想**

第 3 页开始进入假设检验。老师先区分了三种东西：

Fisher's Test of Significance；

Neyman-Pearson's Test of Acceptance；

Null Hypothesis Significance Testing，简称 NHST。

它们经常被混在一起，但思想不同。

Fisher significance test 的重点是：计算 $p$-value，把它当作反对零假设的证据强弱。

Neyman-Pearson test 的重点是：预先设定 $H_0,H_1,\alpha,\beta$，然后根据 critical region 做接受或拒绝的决策。

NHST 是现代课程和论文里常见的混合版本：既设零假设和备择假设，又看 $p$-value，并用 $\alpha=0.05$ 这类阈值判断是否显著。

这一节课主要讲的是 Fisher significance test 和 NHST 中的 $p$-value 思想。

**六、Fisher's Test of Significance 的流程**

板书第 4 页写了 Fisher 显著性检验的五步：

第一，选择合适的检验方法；

第二，设定零假设：

$$H_0$$

第三，在 $H_0$ 成立的前提下，计算观察结果出现的理论概率，也就是：

$$p\text{-value}$$

第四，判断结果是否 significant；

第五，解释结果的统计显著性。

Fisher 方法的几个特点是：

它很灵活；

适合 ad-hoc research projects，也就是探索性、临时性的研究问题；

它是 inferential，也就是从样本推断总体；

它不强调 power analysis；

它不一定需要明确写出 alternative hypothesis。

这和 Neyman-Pearson 方法不一样。Fisher 更像是在问：

“如果 $H_0$ 真的成立，我观察到现在这么极端的数据，有多罕见？”

而 Neyman-Pearson 更像是在说：

“我提前规定好错误率和拒绝域，然后根据样本做一个明确决策。”

**七、零假设 $H_0$ 是什么**

板书第 4 页写：

$$H_0:\theta\in\Theta_0$$

这里 $\theta$ 是总体参数，$\Theta_0$ 是零假设允许的参数集合。

常见形式有：

$$H_0:\theta=\theta_0$$

$$H_0:\theta\leq \theta_0$$

$$H_0:\theta\geq \theta_0$$

其中 $\theta_0$ 是 null value，也就是零假设中的基准值。

比如检验火箭燃料燃烧速率是否等于 $40$ cm/s，可以写：

$$H_0:\mu=40$$

为什么叫 null hypothesis？因为它是“准备被数据推翻”的默认假设。通常它表示“没有变化”“没有效果”“没有差异”或“等于某个标准值”。

**八、$p$-value 的定义**

第 5 页是这节课最关键的一页。板书给出的定义是：

$p$-value 是在零假设 $H_0$ 以及其他模型假设都成立时，得到当前结果或更极端结果的概率。

公式化写法是：

$$p\text{-value}=P(\text{observed result or more extreme result}\mid H_0\text{ is true})$$

注意，它不是：

$$P(H_0\text{ is true}\mid \text{data})$$

这两个方向完全不同。$p$-value 是在假设 $H_0$ 为真的前提下，看数据有多极端；不是在看到数据以后，反推 $H_0$ 为真的概率。

假设检验通常有一个检验统计量：

$$T$$

样本算出来的观测值记作：

$$t$$

然后根据检验方向不同，$p$-value 的公式不同。

**九、右尾检验、左尾检验、双尾检验**

右尾检验适合研究“参数是否变大”。例如：

$$H_0:\theta\leq \theta_0$$

研究方向是：

$$\theta>\theta_0$$

如果观察到的 $t$ 很大，就对 $H_0$ 不利。于是：

$$p=P_{H_0}(T\geq t)$$

也就是右尾面积。

左尾检验适合研究“参数是否变小”。例如：

$$H_0:\theta\geq \theta_0$$

研究方向是：

$$\theta<\theta_0$$

如果观察到的 $t$ 很小，就对 $H_0$ 不利。于是：

$$p=P_{H_0}(T\leq t)$$

也就是左尾面积。

双尾检验适合研究“参数是否不等于某个值”。例如：

$$H_0:\theta=\theta_0$$

研究方向是：

$$\theta\neq\theta_0$$

这时太大或太小都算极端。一般写成：

$$p=2\min{P_{H_0}(T\geq t),\ P_{H_0}(T\leq t)}$$

如果 $T$ 的零假设分布关于 $0$ 对称，例如标准正态或 t 分布，那么双尾 $p$-value 可以写成：

$$p=P_{H_0}(|T|\geq |t|)$$

这句话特别重要：**双尾检验看的是绝对值有多极端。**

**十、假设检验和置信区间的关系**

第 6 页讲 hypothesis testing 和 confidence interval 的联系。

对于双尾检验，有一个非常重要的对应关系：

如果 $95%$ 置信区间不包含 null value，那么在显著性水平：

$$\alpha=0.05$$

下，双尾检验会拒绝 $H_0$。

反过来也可以理解为：

一个 $95%$ 置信区间就是所有在 $\alpha=0.05$ 双尾检验下不会被拒绝的 null values 的集合。

比如如果：

$$H_0:\mu=\mu_0$$

而 $95%$ 置信区间是：

$$[49.67,\ 58.17]$$

那么任何落在这个区间外的 $\mu_0$，都会在 $\alpha=0.05$ 的双尾检验下被拒绝。

板书写的意思就是：

如果双尾 $p$-value 小于 $0.05$，那么 $95%$ CI 不包含 null hypothesis 的值；

$95%$ CI 是在 $\alpha=0.05$ 下不会被拒绝的零假设集合。

**十一、Z-test 例子：火箭燃料燃烧速率**

第 6 页给了一个 two-tailed test based on normal distribution 的例子。

题目背景：火箭推进剂的平均燃烧速率要求是：

$$40\ \text{cm/s}$$

已知总体标准差：

$$\sigma=2\ \text{cm/s}$$

样本量：

$$n=25$$

样本均值：

$$\bar x=41.25\ \text{cm/s}$$

零假设是：

$$H_0:\mu=40$$

因为是检验“是否不等于 $40$”，所以是双尾检验：

$$H_1:\mu\neq 40$$

在 $H_0$ 成立时：

$$Z=\frac{\bar X-\mu_0}{\sigma/\sqrt n}\sim Normal(0,1)$$

把数据代入：

$$z=\frac{\bar x-\mu_0}{\sigma/\sqrt n}=\frac{41.25-40}{2/\sqrt{25}}$$

因为：

$$2/\sqrt{25}=2/5=0.4$$

所以：

$$z=\frac{1.25}{0.4}=3.125$$

先算右尾概率：

$$P(Z\geq 3.125\mid H_0)=1-P(Z\leq 3.125\mid H_0)$$

板书给出：

$$P(Z\leq 3.125\mid H_0)=0.9991$$

所以：

$$P(Z\geq 3.125\mid H_0)=1-0.9991=0.0009$$

因为是双尾检验，另一边同样极端的情况也要算进去：

$$p=2(0.0009)=0.0018$$

所以：

$$p=0.0018$$

也就是：

$$p=0.18\%$$

这非常小，说明如果真实均值真的是 $40$，观察到 $\bar x=41.25$ 或更极端结果的概率非常低。因此拒绝 $H_0$，结论是：有证据表明燃烧速率不是 $40$ cm/s。

注意这里不是说“燃烧速率一定不是 $40$”，而是说：数据对 $H_0:\mu=40$ 提供了很强的反对证据。

**十二、显著性水平 $\alpha$**

第 7 页讲 level of significance，也就是显著性水平。

在显著性检验中，如果：

$$p\text{-value}\leq \alpha$$

就拒绝：

$$H_0$$

$\alpha$ 也叫 alpha level 或 significance level。它不是从数据里算出来的，而是研究者在看数据之前设定的阈值。常见取值是：

$$\alpha=0.05$$

或者：

$$\alpha=0.01$$

如果写成一个完整检验，可以说：

$$H_0:\theta=\theta_0,\qquad \alpha=0.05$$

$p$-value 越小，表示数据在 $H_0$ 下越不寻常，因此反对 $H_0$ 的证据越强。

决策规则是：

如果：

$$p\leq \alpha$$

则：

$$\text{reject }H_0$$

如果：

$$p>\alpha$$

则：

$$\text{fail to reject }H_0$$

注意，更严谨的说法是 fail to reject $H_0$，而不是 accept $H_0$。因为样本没有提供足够证据反对 $H_0$，不代表 $H_0$ 已经被证明为真。

比如一个检验得到：

$$p=0.08$$

在：

$$\alpha=0.05$$

下不拒绝 $H_0$。但在：

$$\alpha=0.10$$

下会拒绝 $H_0$。所以是否显著依赖于预先选定的显著性水平。

**十三、$p$-value 的常见误解**

第 8 页讲 p-hacking 和 misconceptions，特别强调 $p$-value 很容易被误用。

第一，$p$-value 不是零假设为真的概率。

错误说法是：

$$p=P(H_0\text{ is true}\mid \text{data})$$

正确理解是：

$$p=P(\text{data as extreme as observed}\mid H_0\text{ is true})$$

第二，$p$-value 不是“结果由随机巧合造成的概率”。它是在 $H_0$ 和模型假设都成立时，观察到这么极端结果的概率。

第三，$0.05$ 只是一个惯例，不是宇宙真理。比如：

$$p=0.049$$

和：

$$p=0.051$$

本质上差别很小，不应该被解释成一个“绝对有发现”、另一个“绝对没发现”。

第四，$p$-value 不表示效应大小或实际重要性。一个很小的 $p$-value 可能只是因为样本量很大。即使差异非常小，只要 $n$ 足够大，也可能显著。

例如检验均值时：

$$Z=\frac{\bar X-\mu_0}{\sigma/\sqrt n}$$

当 $n$ 很大时，分母：

$$\frac{\sigma}{\sqrt n}$$

会很小，所以即使 $\bar X-\mu_0$ 很小，也可能让 $Z$ 很大，从而得到很小的 $p$-value。

所以 statistical significance 不等于 practical significance。

**十四、p-hacking：为什么多次检验会制造“显著结果”**

第 9 页用漫画解释 p-hacking。漫画里的逻辑是：先检验 jelly beans 和 acne 有没有关系，没发现；然后继续分颜色检验 purple、brown、pink、blue、green 等等，最后发现 green jelly beans 的 $p<0.05$，于是新闻标题写“绿色软糖和痤疮有关”。

问题在于：如果你做很多很多个检验，每个检验都用：

$$\alpha=0.05$$

那么即使所有零假设都是真的，也很容易出现至少一个“显著结果”。

假设做 $20$ 个相互独立的检验，而且每个零假设都是真的。单个检验不犯假阳性错误的概率是：

$$1-0.05=0.95$$

二十个都不犯假阳性错误的概率大约是：

$$0.95^{20}$$

所以至少出现一个假阳性结果的概率是：

$$1-0.95^{20}\approx 0.642$$

也就是说，做得越多，越容易“捞”出一个看起来显著的结果。这就是 p-hacking 的核心危险。

p-hacking 的常见形式包括：

反复尝试不同变量；

反复尝试不同分组；

删掉某些数据点；

尝试很多模型但只报告显著的；

看到结果后再决定假设怎么写。

这些行为会让 $p$-value 失去原本的意义，因为 $p$-value 的理论解释依赖于“检验方案是事先确定的”。

**十五、本节课的完整逻辑总结**

这节课前半部分补完了 t 分布和 $\sigma$ 未知时的均值置信区间。

核心公式是：

$$\frac{\bar X-\mu}{S/\sqrt n}\sim t(n-1)$$

所以：

$$\mu\text{ 的 }100(1-\alpha)\%\text{ 置信区间为 }\bar X\pm t_{\alpha/2}(n-1)\frac{S}{\sqrt n}$$

后半部分进入假设检验。Fisher significance test 的核心是 $p$-value：

$$p\text{-value}=P(\text{observed or more extreme result}\mid H_0\text{ is true})$$

右尾检验：

$$p=P_{H_0}(T\geq t)$$

左尾检验：

$$p=P_{H_0}(T\leq t)$$

双尾检验：

$$p=2\min{P_{H_0}(T\geq t),P_{H_0}(T\leq t)}$$

如果分布关于 $0$ 对称，双尾检验可以写成：

$$p=P_{H_0}(|T|\geq |t|)$$

显著性水平 $\alpha$ 是预先设定的阈值：

$$p\leq \alpha\Rightarrow \text{reject }H_0$$

$$p>\alpha\Rightarrow \text{fail to reject }H_0$$

置信区间和双尾检验之间有对应关系：如果 $95\%$ CI 不包含 null value，那么在 $\alpha=0.05$ 的双尾检验下会拒绝 $H_0$。

最后，$p$-value 不能被解释为 $H_0$ 为真的概率，不能表示效应大小，也不能用来支持 p-hacking。它只是衡量：**如果零假设和模型假设都成立，我们现在看到的数据有多极端。**

一句话概括整节课：**当 $\sigma$ 未知时，用 t 分布做均值推断；进入假设检验后，用 $p$-value 衡量样本对零假设的反对程度，但必须小心解释和避免 p-hacking。**