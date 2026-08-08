这节课主要讲 **Neyman-Pearson 的假设检验框架**，然后把它和前面讲过的 Fisher 显著性检验、NHST、$p$-value 进行对比；后半部分进入具体检验：**均值的 $t$-test、方差/标准差的 chi-squared test，以及 power 和 sample size 的计算思想**。

**一、Neyman-Pearson：Test of Acceptance**

板书第 1 页标题是 **Neyman-Pearson: Test of Acceptance**。它和 Fisher 的显著性检验不同。Fisher 更关心 $p$-value，即“在 $H_0$ 为真时，观察到当前或更极端结果有多罕见”。Neyman-Pearson 更像正式实验设计：**在实验前就规定好规则，之后按规则做决策**。

板书把流程分成两部分：**A priori steps** 和 **A posteriori steps**。

A priori steps 是实验前要做的事：

1. 设定总体中的 expected effect size；
    
2. 选择 optimal test；
    
3. 设定 main/null hypothesis，也就是 $H_0$，并设定 $\alpha$；
    
4. 设定 alternative/research hypothesis，也就是 $H_1$；
    
5. 计算达到足够 power 所需的样本量 $N$；
    
6. 计算检验的 critical value。
    

A posteriori steps 是看到数据之后做的事：

7. 用样本计算 observed test value；
    
8. 判断观察结果是否落入 critical region，从而决定支持 $H_0$ 还是 $H_1$。
    

这里最重要的是：**Neyman-Pearson 不是先看数据再决定怎么检验，而是先设计检验规则，再看数据。**

如果 observed result 落入 critical region，就拒绝 $H_0$，支持 $H_1$。

如果 observed result 没有落入 critical region，并且这个检验有足够高的 power，那么可以接受 $H_0$。

如果 observed result 没有落入 critical region，但这个检验 power 很低，那么最好不要得出强结论。因为样本量太小或检验太弱，没发现差异不代表差异不存在。

所以板书中特别写了：如果检验 low power，conclude nothing。理想情况下，我们不应该做 low power 的研究。

**二、Neyman-Pearson 方法的特点**

板书第 1 页总结了 Neyman-Pearson 方法的特点：

它更 powerful；

更适合 repeated sampling projects；

它是 deductive，也就是演绎式的；

但比 Fisher 方法不灵活；

如果操作不当，很容易又退回 Fisher 的思路。

为什么说它更 powerful？因为它不只是看 $p$-value，而是在实验前就设定 $\alpha$、$\beta$、effect size 和 sample size。也就是说，它关心“我这个实验到底有没有能力发现我关心的效应”。

为什么说它更不灵活？因为你必须提前设定 $H_0$、$H_1$、$\alpha$、$\beta$ 和拒绝域，不能看到数据后再改规则。

**三、零假设和备择假设**

第 2 页讲 $H_0$ 和 $H_1$ 的一般形式。

设参数空间中有两个集合：

$$\Theta_0,\Theta_1\subseteq\Theta$$

且：

$$\Theta_0\cap\Theta_1=\varnothing$$

那么检验可以写成：

$$H_0:\theta\in\Theta_0$$

against

$$H_1:\theta\in\Theta_1$$

也就是说，$H_0$ 和 $H_1$ 是参数 $\theta$ 所处区域的两个互不重叠的说法。

比如可以检验：

$$H_0:\theta=\frac{1}{2}$$

against

$$H_1:\theta=\frac{1}{4}$$

也可以检验：

$$H_0:\theta\geq \frac{1}{2}$$

against

$$H_1:\theta<\frac{1}{4}$$

这里第二个例子很有意思，因为 $H_0$ 和 $H_1$ 中间有一个 gap：

$$\frac{1}{4}\leq \theta<\frac{1}{2}$$

这个区域既不属于 $H_0$，也不属于 $H_1$。这和 Neyman-Pearson 的 effect size 有关：我们不是检验任意小差异，而是关心“足够大的差异”。

**四、Effect size 是什么**

板书第 2 页写：roughly speaking，effect size 是 $H_0$ 和 $H_1$ 之间的 discrepancy，也就是差异大小。

比如：

$$H_0:\theta=\frac{1}{2}$$

against

$$H_1:\theta\leq \frac{1}{4}$$

这里你关心的差异大约是：

$$\delta=\left|\frac{1}{2}-\frac{1}{4}\right|=\frac{1}{4}$$

在均值检验中，如果：

$$H_0:\mu=\mu_0$$

而你希望检测到：

$$\mu=\mu_0+\delta$$

那么 $\delta$ 就是 effect size。更常见的标准化 effect size 是：

$$d=\frac{\delta}{\sigma}$$

或者在 $\sigma$ 未知时用样本标准差近似：

$$d=\frac{\delta}{s}$$

effect size 很重要，因为它决定了需要多大的样本量。如果你想检测很小的差异，就需要更大的 $n$；如果差异很大，就比较容易检测出来。

**五、Type I error 和 Type II error**

第 2 页下方画了一个 $2\times2$ 表，讲两类错误。

真实情况有两种：$H_0$ 为真，或者 $H_0$ 为假。你的决策也有两种：不拒绝 $H_0$，或者拒绝 $H_0$。

如果 $H_0$ 为真，你也没有拒绝 $H_0$，这是正确决策。

如果 $H_0$ 为假，你拒绝了 $H_0$，这也是正确决策。

如果 $H_0$ 为真，但你错误拒绝了它，这叫 Type I error，也叫 false positive。

$$\text{Type I error}=P(\text{reject }H_0\mid H_0\text{ is true})$$

这个概率记作：

$$\alpha$$

所以：

$$\alpha=P(\text{Type I error})$$

如果 $H_0$ 为假，但你没有拒绝它，这叫 Type II error，也叫 false negative。

$$\text{Type II error}=P(\text{fail to reject }H_0\mid H_0\text{ is false})$$

这个概率记作：

$$\beta$$

所以：

$$\beta=P(\text{Type II error})$$

power 定义为：

$$1-\beta$$

也就是当 $H_1$ 真的成立时，检验正确拒绝 $H_0$ 的概率：

$$1-\beta=P(\text{reject }H_0\mid H_1\text{ is true})$$

**六、$\alpha$、$\beta$ 和 power 的关系**

第 3 页继续解释两类错误。

Type I error 是 $H_0$ 被错误拒绝。它比较严重，因为这意味着你声称有发现，但其实没有。比如药物其实无效，你却说它有效。

$\alpha$ 是长期犯 Type I error 的概率，也叫 size of the test。常见取值是：

$$\alpha=0.05$$

或者：

$$\alpha=0.01$$

Type II error 是 $H_0$ 被错误保留。也就是实际有差异，但你没有发现。它的概率是：

$$\beta$$

power 是：

$$1-\beta$$

板书强调：一般来说，Type II error 没有 Type I error 那么严重，但我们仍然希望 $\beta$ 尽可能小，也就是 power 尽可能高。

不过不能简单让 $\beta$ 比 $\alpha$ 还小。板书写了一个提醒：如果 $\beta<\alpha$，那说明 $H_1$ 可能更应该成为 null hypothesis。直观上，$H_0$ 通常是我们更谨慎对待、需要避免错误拒绝的默认立场。

**七、Power 由什么决定**

第 4 页总结 power 受哪些因素影响。

Power 是正确拒绝 $H_0$、支持 $H_1$ 的概率：

$$\text{Power}=1-\beta$$

它受以下因素影响：

检验类型。比如 parametric test 通常比 nonparametric test 更有 power；one-tailed test 如果方向设定正确，通常比 two-tailed test 更有 power。

Effect size。效应越大，越容易被检测出来，所以 power 越大。

显著性水平 $\alpha$。$\alpha$ 越大，拒绝域越大，更容易拒绝 $H_0$，所以 power 增大。但代价是 Type I error 风险也增大。

$\beta$。$\beta$ 越大，power 越小；$\beta$ 越小，power 越大。

样本量 $n$。样本量越大，标准误越小，越容易检测到差异，所以 power 越大。

板书还提醒：样本量过大也有问题。因为 $n$ 很大时，即使一个非常小、实际意义不大的差异，也可能变成 statistically significant。这就是“统计显著不等于实际重要”。

**八、已知方差下，两侧均值检验的 sample size**

第 4 页下方开始推导 $\beta$ 和 sample size。考虑正态总体均值检验，且方差 $\sigma^2$ 已知。

我们做双侧检验：

$$H_0:\mu=\mu_0$$

against

$$H_1:|\mu-\mu_0|>\delta$$

也就是说，我们希望检测到至少 $\delta$ 这么大的差异：

$$\mu>\mu_0+\delta$$

或者：

$$\mu<\mu_0-\delta$$

检验统计量是：

$$Z=\frac{\bar X-\mu_0}{\sigma/\sqrt n}$$

在 $H_0$ 为真时：

$$Z\sim Normal(0,1)$$

双侧显著性水平为 $\alpha$ 时，拒绝域是：

$$Z<-z_{\alpha/2}$$

或者：

$$Z>z_{\alpha/2}$$

也就是不拒绝域为：

$$-z_{\alpha/2}\leq Z\leq z_{\alpha/2}$$

接下来假设 $H_1$ 真的成立，并且：

$$\mu=\mu_0+\delta$$

此时：

$$Z=\frac{\bar X-\mu_0}{\sigma/\sqrt n}$$

可以改写为：

$$Z=\frac{\bar X-(\mu_0+\delta)}{\sigma/\sqrt n}+\frac{\delta}{\sigma/\sqrt n}$$

第一项服从标准正态：

$$\frac{\bar X-(\mu_0+\delta)}{\sigma/\sqrt n}\sim Normal(0,1)$$

第二项是常数：

$$\frac{\delta}{\sigma/\sqrt n}=\frac{\delta\sqrt n}{\sigma}$$

所以在 $\mu=\mu_0+\delta$ 时：

$$Z\sim Normal\left(\frac{\delta\sqrt n}{\sigma},1\right)$$

这就是第 5 页图像的意思：黑色曲线是 $H_0$ 下的分布，蓝色曲线是 $H_1$ 下的分布。两条曲线越分开，越容易拒绝 $H_0$，power 越高。

**九、$\beta$ 的公式和 sample size 公式**

在 $H_1$ 为真时，Type II error 是“没有拒绝 $H_0$”。也就是 $Z$ 落在不拒绝域：

$$-z_{\alpha/2}\leq Z\leq z_{\alpha/2}$$

所以：

$$\beta=P\left(-z_{\alpha/2}\leq Z\leq z_{\alpha/2}\mid \mu=\mu_0+\delta\right)$$

因为此时 $Z\sim Normal\left(\frac{\delta\sqrt n}{\sigma},1\right)$，所以：

$$\beta=\Phi\left(z_{\alpha/2}-\frac{\delta\sqrt n}{\sigma}\right)-\Phi\left(-z_{\alpha/2}-\frac{\delta\sqrt n}{\sigma}\right)$$

当 $\delta>0$ 且样本量不太小时，第二项通常很小，可以近似忽略：

$$\beta\approx \Phi\left(z_{\alpha/2}-\frac{\delta\sqrt n}{\sigma}\right)$$

如果 $z_\beta$ 用右尾记号表示，即：

$$P(Z>z_\beta)=\beta$$

那么：

$$\Phi(-z_\beta)=\beta$$

于是近似令：

$$z_{\alpha/2}-\frac{\delta\sqrt n}{\sigma}\approx -z_\beta$$

整理得：

$$\frac{\delta\sqrt n}{\sigma}\approx z_{\alpha/2}+z_\beta$$

所以：

$$n\approx \frac{(z_{\alpha/2}+z_\beta)^2\sigma^2}{\delta^2}$$

这就是双侧检验的样本量公式。

如果是一侧检验，对应公式是：

$$n\approx \frac{(z_{\alpha}+z_\beta)^2\sigma^2}{\delta^2}$$

区别是双侧检验用 $z_{\alpha/2}$，单侧检验用 $z_\alpha$。

**十、火箭燃料燃烧速率的 sample size 例子**

第 6 页例子：火箭推进剂燃烧速率应该是：

$$\mu=40\ \text{cm/s}$$

已知标准差：

$$\sigma=2\ \text{cm/s}$$

如果燃烧速率太快或太慢，都不能用。所以设：

$$H_0:\mu=40$$

并且：

$$\alpha=0.05$$

研究者希望检测到至少 $1\ \text{cm/s}$ 的偏离：

$$H_1:|\mu-40|>1$$

也就是：

$$\delta=1$$

同时希望：

$$\beta=0.1$$

所以 power 是：

$$1-\beta=0.9$$

双侧检验的公式是：

$$n\approx \frac{(z_{\alpha/2}+z_\beta)^2\sigma^2}{\delta^2}$$

这里：

$$z_{\alpha/2}=z_{0.025}=1.96$$

$$z_\beta=z_{0.1}=1.28$$

代入：

$$n\approx \frac{(1.96+1.28)^2(2)^2}{1^2}$$

计算：

$$n\approx 42$$

所以大约需要：

$$n=42$$

个样本，才能在 $\alpha=0.05$、power 为 $0.9$ 的要求下检测到 $1\ \text{cm/s}$ 的差异。

**十一、NHST 和三种检验哲学的差别**

第 7 页讲 NHST，也就是 Null Hypothesis Significance Testing。

NHST 通常做法是：

设定相互对立的 $H_0$ 和 $H_1$；

有时也考虑 $\alpha$ 和 $\beta$；

目标是找到小的 $p$-value，比如：

$$p<0.05$$

或者：

$$p<0.01$$

板书接着讲了对 NHST 的批评。核心是：现代统计里的很多推理看起来像逻辑反证，但其实不是严格逻辑。

板书写了类似：

$$A\Rightarrow B$$

但从：

$$\neg B$$

不能严格推出：

$$\neg A$$

在统计语境里，错误逻辑大概是：

如果 $H_0$ 为真，那么观察结果 $O$ 应该不罕见；

现在 $O$ 很罕见；

所以 $H_0$ 很可能是假的。

这个逻辑不是严格必然的。因为“小概率事件”不是“不可能事件”。例如：如果一个人是美国人，他大概率不是国会议员。但如果你发现某人是国会议员，不能推出他大概率不是美国人。这个类比说明：概率推理不能直接当成简单逻辑反证。

板书还比较了三种解释：

Fisher：如果结果落入 critical region，要么发生了罕见事件，要么 $H_0$ 不能解释数据。

Neyman-Pearson：在给定 $\alpha$ 的情况下，$H_1$ 比 $H_0$ 更适合解释数据。

NHST：解释取决于作者，经常混用 Fisher 和 Neyman-Pearson 的语言。

所以这页的重点不是计算，而是提醒：**同样一个“显著结果”，不同统计哲学下解释并不完全一样。**

**十二、均值的 t-test**

第 8 页进入具体检验：The $T$-Test。

设：

$$X_1,\dots,X_n$$

来自正态总体，均值 $\mu$ 未知，方差 $\sigma^2$ 也未知。样本均值为：

$$\bar X$$

样本方差为：

$$S^2$$

如果要检验总体均值是否等于某个 null value $\mu_0$，用统计量：

$$T_{n-1}=\frac{\bar X-\mu_0}{S/\sqrt n}$$

在 $H_0:\mu=\mu_0$ 成立时：

$$T_{n-1}\sim t(n-1)$$

这就是 one-sample t-test。

拒绝规则如下。

双侧检验：

$$H_0:\mu=\mu_0$$

如果：

$$|T_{n-1}|>t_{\alpha/2,n-1}$$

则拒绝 $H_0$。

右尾检验：

$$H_0:\mu\leq \mu_0$$

如果：

$$T_{n-1}>t_{\alpha,n-1}$$

则拒绝 $H_0$。

左尾检验：

$$H_0:\mu\geq \mu_0$$

如果：

$$T_{n-1}<-t_{\alpha,n-1}$$

则拒绝 $H_0$。

这里 $t_{\alpha,n-1}$ 表示自由度 $n-1$ 的 t 分布右尾面积为 $\alpha$ 的临界值：

$$P(T>t_{\alpha,n-1})=\alpha$$

**十三、纤维断裂强度 t-test 例子**

第 8 页例子：某纺织纤维的断裂强度服从正态分布。规格要求平均断裂强度应该为：

$$150\ \text{psi}$$

制造商想检测是否有显著偏离，并关心至少：

$$2.5\ \text{psi}$$

的差异。假设显著性水平为：

$$\alpha=0.05$$

假设写成：

$$H_0:\mu=150$$

$$H_1:|\mu-150|>2.5$$

这里实际做检验时是双侧检验，因为偏大或偏小都算偏离。

样本量是：

$$n=15$$

样本均值：

$$\bar x=152.18$$

样本方差：

$$s^2=16.63$$

所以：

$$s=\sqrt{16.63}$$

检验统计量：

$$t=\frac{\bar x-\mu_0}{s/\sqrt n}$$

代入：

$$t=\frac{152.18-150}{\sqrt{16.63}/\sqrt{15}}$$

计算得到：

$$t=2.07$$

自由度是：

$$n-1=14$$

双侧检验的临界值是：

$$t_{0.025,14}=2.145$$

比较：

$$2.07<2.145$$

所以没有落入拒绝域，因此：

$$\text{fail to reject }H_0$$

解释：在 $\alpha=0.05$ 的双侧 t 检验下，样本没有提供足够证据说明平均断裂强度显著偏离 $150\ \text{psi}$。

注意：虽然样本均值 $152.18$ 比 $150$ 高，但考虑到样本波动和样本量，这个偏离还不足以达到显著水平。

**十四、t-test 的 power：为什么会出现 noncentral t 分布**

第 9 页进一步讨论 t-test 的 power。

前面已知 $\sigma$ 的情况比较简单，因为检验统计量在 $H_1$ 下仍然是正态分布。可是在 t-test 里，分母是随机的 $S$：

$$T=\frac{\bar X-\mu_0}{S/\sqrt n}$$

假设 $H_1$ 为真，并且：

$$\mu=\mu_0+\delta$$

那么：

$$T=\frac{\bar X-\mu_0}{S/\sqrt n}$$

可以改写为：

$$T=\frac{\bar X-(\mu_0+\delta)}{S/\sqrt n}+\frac{\delta}{S/\sqrt n}$$

为了看清结构，令：

$$Z=\frac{\bar X-(\mu_0+\delta)}{\sigma/\sqrt n}$$

则：

$$Z\sim Normal(0,1)$$

再令：

$$W=\frac{S}{\sigma}$$

那么：

$$\frac{(n-1)W^2}{1}=\frac{(n-1)S^2}{\sigma^2}\sim \chi^2(n-1)$$

因此：

$$T=\frac{Z+\frac{\delta\sqrt n}{\sigma}}{W}$$

这不再是普通 t 分布，而是 noncentral t distribution，非中心 t 分布。它的自由度是：

$$n-1$$

非中心参数是：

$$\frac{\delta\sqrt n}{\sigma}$$

这说明：t-test 的 power 计算比 z-test 更复杂，严格来说需要用 noncentral t 分布。

板书后面继续考虑纤维例子。如果希望以 power：

$$0.9$$

检测到：

$$|\mu-150|>2.5$$

那么：

$$\beta=1-0.9=0.1$$

样本中：

$$s^2=16.63$$

所以：

$$s=\sqrt{16.63}$$

标准化 effect size 近似为：

$$d=\frac{|\mu-\mu_0|}{s}=\frac{2.5}{\sqrt{16.63}}$$

计算得到：

$$d\approx 0.61$$

如果用正态近似的双侧样本量公式：

$$n\approx \frac{(z_{\alpha/2}+z_\beta)^2}{d^2}$$

代入：

$$z_{0.025}=1.96$$

$$z_{0.1}=1.28$$

得到：

$$n\approx \frac{(1.96+1.28)^2}{0.61^2}$$

大约：

$$n\approx 29$$

但因为这里严格来说应该使用 noncentral t 分布，所以实际所需样本量可能会略大。板书重点是让你理解：**当 $\sigma$ 未知时，power/sample size 要通过 noncentral t 分布处理，而不是简单标准正态。**

**十五、方差/标准差的 Chi-Squared Test**

第 10 页进入 chi-squared test。这个检验用于总体方差或标准差。

假设：

$$X_1,\dots,X_n$$

来自正态总体，样本方差为 $S^2$。如果要检验总体方差是否等于某个 null value：

$$\sigma_0^2$$

使用统计量：

$$\chi^2_{n-1}=\frac{(n-1)S^2}{\sigma_0^2}$$

在 $H_0:\sigma^2=\sigma_0^2$ 成立时：

$$\chi^2_{n-1}\sim \chi^2(n-1)$$

这是因为正态样本有结论：

$$\frac{(n-1)S^2}{\sigma^2}\sim \chi^2(n-1)$$

检验规则如下。

双侧检验：

$$H_0:\sigma=\sigma_0$$

如果统计量太大或太小，都拒绝 $H_0$：

$$\chi^2_{obs}>\chi^2_{\alpha/2,n-1}$$

或者：

$$\chi^2_{obs}<\chi^2_{1-\alpha/2,n-1}$$

右尾检验，也就是检验标准差是否太大：

$$H_0:\sigma\leq \sigma_0$$

如果：

$$\chi^2_{obs}>\chi^2_{\alpha,n-1}$$

则拒绝 $H_0$。

左尾检验，也就是检验标准差是否太小：

$$H_0:\sigma\geq \sigma_0$$

如果：

$$\chi^2_{obs}<\chi^2_{1-\alpha,n-1}$$

则拒绝 $H_0$。

这里要注意记号：$\chi^2_{\alpha,n-1}$ 通常表示右尾面积为 $\alpha$ 的临界值，即：

$$P(\chi^2>\chi^2_{\alpha,n-1})=\alpha$$

所以 $\chi^2_{1-\alpha,n-1}$ 是左尾 $\alpha$ 对应的临界值。

**十六、CV shaft 标准差检验例子**

第 10 页例子：工程师设计汽车前轮驱动 half-shaft，研究 CV joint 的 displacement。工程师声称标准差小于：

$$1.5\ \text{mm}$$

所以研究假设是：

$$H_1:\sigma<1.5$$

对应的零假设应该写成：

$$H_0:\sigma\geq 1.5$$

显著性水平：

$$\alpha=0.05$$

样本量：

$$n=20$$

样本标准差：

$$s=1.41$$

检验统计量：

$$\chi^2=\frac{(n-1)s^2}{\sigma_0^2}$$

其中：

$$\sigma_0=1.5$$

代入：

$$\chi^2=\frac{19(1.41)^2}{(1.5)^2}$$

计算：

$$\chi^2\approx 16.79$$

自由度为：

$$n-1=19$$

因为是左尾检验，拒绝域在左边。板书给出临界值：

$$\chi^2_{0.95,19}=10.1$$

拒绝规则是：

$$\chi^2<10.1$$

但实际：

$$16.79>10.1$$

所以没有落入拒绝域。因此：

$$\text{fail to reject }H_0$$

结论：这组数据不足以支持“标准差小于 $1.5\ \text{mm}$”这个说法。

注意：虽然样本标准差 $s=1.41$ 确实小于 $1.5$，但差距不够显著。统计检验不是只比较 $1.41<1.5$，还要考虑样本量和随机波动。

**十七、chi-squared test 的 power 和 sample size**

第 11 页最后讨论 chi-squared test 的 power。

考虑：

$$H_0:\sigma=\sigma_0$$

against

$$H_1:\sigma=\lambda\sigma_0<\sigma_0$$

其中：

$$\lambda<1$$

也就是说，真实标准差比 $\sigma_0$ 小。

左尾检验中，我们拒绝 $H_0$ 的条件是：

$$Y=\frac{(n-1)S^2}{\sigma_0^2}\leq c$$

其中 $c$ 是左尾 $\alpha$ 临界值，满足：

$$P_{H_0}(Y\leq c)=\alpha$$

在 $H_0$ 下：

$$Y\sim \chi^2(n-1)$$

但在 $H_1:\sigma=\lambda\sigma_0$ 下，有：

$$\frac{(n-1)S^2}{\sigma^2}\sim \chi^2(n-1)$$

而：

$$\sigma^2=\lambda^2\sigma_0^2$$

所以：

$$Y=\frac{(n-1)S^2}{\sigma_0^2}=\lambda^2\frac{(n-1)S^2}{\sigma^2}$$

因此在 $H_1$ 下：

$$Y=\lambda^2 X$$

其中：

$$X\sim \chi^2(n-1)$$

Type II error 是 $H_1$ 为真时，没有拒绝 $H_0$。对于左尾检验，这意味着：

$$Y>c$$

所以：

$$\beta=P(Y>c\mid H_1)$$

代入 $Y=\lambda^2X$：

$$\beta=P(\lambda^2X>c)$$

即：

$$\beta=P\left(X>\frac{c}{\lambda^2}\right)$$

所以：

$$\beta=1-F_{\chi^2(n-1)}\left(\frac{c}{\lambda^2}\right)$$

这就是第 11 页最后公式的含义。它告诉你：给定 $\alpha$、目标 $\lambda$ 和样本量 $n$，可以算出 $\beta$，也就能算出 power：

$$1-\beta$$

反过来，如果你想达到某个目标 power，就可以通过调整 $n$ 来满足要求。

**十八、整节课的主线总结**

这节课先完整讲了 Neyman-Pearson 检验框架。它要求实验前设定 effect size、$H_0$、$H_1$、$\alpha$、$\beta$、sample size 和 critical region；实验后再用 observed test value 做决策。

核心错误概率是：

$$\alpha=P(\text{reject }H_0\mid H_0\text{ true})$$

$$\beta=P(\text{fail to reject }H_0\mid H_1\text{ true})$$

power 是：

$$1-\beta$$

然后讲了 sample size 的计算思想。对于已知方差的双侧均值检验：

$$n\approx \frac{(z_{\alpha/2}+z_\beta)^2\sigma^2}{\delta^2}$$

对于单侧检验：

$$n\approx \frac{(z_{\alpha}+z_\beta)^2\sigma^2}{\delta^2}$$

接着讲了现代 NHST 的问题：它经常混合 Fisher 和 Neyman-Pearson 的语言，容易造成误解。一个显著结果不能简单解释成“$H_0$ 为假的概率很高”，也不能把小概率事件当成不可能事件。

后半部分进入具体检验。均值检验在 $\sigma$ 未知时用 t-test：

$$T_{n-1}=\frac{\bar X-\mu_0}{S/\sqrt n}$$

在 $H_0$ 下：

$$T_{n-1}\sim t(n-1)$$

方差或标准差检验用 chi-squared test：

$$\chi^2_{n-1}=\frac{(n-1)S^2}{\sigma_0^2}$$

在 $H_0$ 下：

$$\chi^2_{n-1}\sim \chi^2(n-1)$$

一句话概括：**这节课把假设检验从“看 $p$-value 是否小”推进到“系统设计一个检验”：控制 $\alpha$，考虑 $\beta$ 和 power，决定样本量，然后根据 t 分布或卡方分布做均值和方差的具体检验。**