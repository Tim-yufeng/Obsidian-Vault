你实际做题时，不要先问“这题看起来像 Z、t 还是卡方”，而要依次问三个问题：

1. **我要推断的参数是什么：均值 $\mu$，还是方差 $\sigma^2$？**
2. **总体方差 $\sigma^2$ 已知还是未知？**
3. **题目要做置信区间，还是假设检验？单侧还是双侧？**

先给最核心的选择表：

| 目标 | 条件 | 使用的统计量及分布 |
|---|---|---|
| 推断均值 $\mu$ | $\sigma$ 已知 | Z 分布 |
| 推断均值 $\mu$ | $\sigma$ 未知，正态总体 | Student-t 分布 |
| 推断方差 $\sigma^2$ 或标准差 $\sigma$ | 正态总体 | 卡方分布 $\chi^2$ |
| 比较两个方差 | 两个独立正态总体 | F 分布，若课程后续涉及 |
| 推断比例 $p$ | 大样本正态近似 | Z 分布 |

你们这部分课件中的“Chi 分布”实际上主要使用的是 **chi-square distribution，卡方分布 $\chi^2$**，不是通常所说的 $\chi$ 分布。两者不要混淆。

---

## 一、先判断研究的是哪个参数

看到题目后，先圈出未知参数。

如果题目出现：

- population mean
- average
- expected value
- mean lifetime
- mean burning rate

通常研究的是：

$$\mu$$

这时在 Z 和 t 之间选。

如果出现：

- population variance
- variability
- standard deviation
- consistency
- precision
- fluctuation

通常研究的是：

$$\sigma^2$$

或者：

$$\sigma$$

这时通常用：

$$\chi^2$$

所以最基本的分流是：

$$\mu\longrightarrow Z\text{ 或 }t$$

$$\sigma^2\longrightarrow\chi^2$$

---

# 二、均值问题：什么时候用 Z test？

## 1. 适用条件

单总体均值的 Z 方法通常要求：

- 样本独立同分布；
- 总体正态，或者样本量足够大；
- **总体标准差 $\sigma$ 已知**。

核心统计量是：

$$Z=\frac{\bar X-\mu_0}{\sigma/\sqrt n}$$

在零假设：

$$H_0:\mu=\mu_0$$

成立时：

$$Z\sim Normal(0,1)$$

这里最关键的识别标志是：

> 题目直接给了 population standard deviation $\sigma$，不是从样本算出的 $s$。

例如火箭燃料题中：

$$\sigma=2$$

是已知总体标准差，所以用 Z test。

---

## 2. Z 置信区间套路

若要估计均值 $\mu$，置信水平为 $1-\alpha$：

$$\bar X\pm z_{\alpha/2}\frac{\sigma}{\sqrt n}$$

做题流程：

1. 找出 $\bar x,\sigma,n$；
2. 确定置信水平，算 $\alpha$；
3. 双侧区间查 $z_{\alpha/2}$；
4. 计算误差界：

$$E=z_{\alpha/2}\frac{\sigma}{\sqrt n}$$

5. 写出：

$$[\bar x-E,\bar x+E]$$

例如 $95\%$ 置信区间：

$$z_{0.025}=1.96$$

所以：

$$\bar x\pm1.96\frac{\sigma}{\sqrt n}$$

---

## 3. Z 假设检验套路

先写：

$$H_0:\mu=\mu_0$$

再根据题意写 $H_1$：

右尾：

$$H_1:\mu>\mu_0$$

左尾：

$$H_1:\mu<\mu_0$$

双尾：

$$H_1:\mu\neq\mu_0$$

然后计算：

$$z_{\mathrm{obs}}=\frac{\bar x-\mu_0}{\sigma/\sqrt n}$$

之后有两种等价方法。

临界值法：

- 右尾：若 $z_{\mathrm{obs}}>z_\alpha$，拒绝 $H_0$；
- 左尾：若 $z_{\mathrm{obs}}<-z_\alpha$，拒绝 $H_0$；
- 双尾：若 $|z_{\mathrm{obs}}|>z_{\alpha/2}$，拒绝 $H_0$。

$p$-value 法：

- 右尾：

$$p=P(Z\geq z_{\mathrm{obs}})$$

- 左尾：

$$p=P(Z\leq z_{\mathrm{obs}})$$

- 双尾：

$$p=P(|Z|\geq|z_{\mathrm{obs}}|)$$

最后比较：

$$p\leq\alpha\Rightarrow\text{reject }H_0$$

$$p>\alpha\Rightarrow\text{fail to reject }H_0$$

---

# 三、均值问题：什么时候用 t test？

## 1. 适用条件

当研究均值 $\mu$，但是总体标准差 $\sigma$ 未知，只知道样本标准差 $s$ 时，用 Student-t。

核心统计量：

$$T=\frac{\bar X-\mu_0}{S/\sqrt n}$$

如果总体正态，则：

$$T\sim t(n-1)$$

自由度：

$$d=n-1$$

识别关键词是：

> 题目没有给 population standard deviation，只给 sample standard deviation，或者需要你由样本数据计算 $s$。

---

## 2. 为什么不能继续用 Z？

如果 $\sigma$ 已知：

$$\frac{\bar X-\mu}{\sigma/\sqrt n}\sim Normal(0,1)$$

但 $\sigma$ 未知时，只能把它换成随机变量 $S$：

$$\frac{\bar X-\mu}{S/\sqrt n}$$

分母自身也会波动，所以不确定性增加，分布尾部比正态更厚，因而服从：

$$t(n-1)$$

这意味着相同置信水平下：

$$t_{\alpha/2}(n-1)>z_{\alpha/2}$$

通常 t 区间比 Z 区间更宽。

---

## 3. t 置信区间套路

$$\bar X\pm t_{\alpha/2}(n-1)\frac{S}{\sqrt n}$$

具体步骤：

1. 找出 $\bar x,s,n$；
2. 自由度：

$$d=n-1$$

3. 根据置信水平查：

$$t_{\alpha/2}(d)$$

4. 计算误差界：

$$E=t_{\alpha/2}(d)\frac{s}{\sqrt n}$$

5. 写出区间：

$$[\bar x-E,\bar x+E]$$

---

## 4. t 假设检验套路

先写 $H_0,H_1$，然后计算：

$$t_{\mathrm{obs}}=\frac{\bar x-\mu_0}{s/\sqrt n}$$

自由度：

$$d=n-1$$

之后和 Z 检验完全同样地判断左右尾，只是查 t 表，而不是标准正态表。

右尾：

$$p=P(T_d\geq t_{\mathrm{obs}})$$

左尾：

$$p=P(T_d\leq t_{\mathrm{obs}})$$

双尾：

$$p=P(|T_d|\geq|t_{\mathrm{obs}}|)$$

最终仍然是：

$$p\leq\alpha\Rightarrow\text{reject }H_0$$

---

# 四、什么时候用卡方分布 $\chi^2$？

## 1. 适用对象

卡方方法不是用于总体均值，而是用于正态总体的：

$$\sigma^2$$

或者：

$$\sigma$$

核心结论：

如果：

$$X_1,\dots,X_n\overset{iid}{\sim}Normal(\mu,\sigma^2)$$

那么：

$$\frac{(n-1)S^2}{\sigma^2}\sim\chi^2(n-1)$$

所以看到题目问：

- 总体方差的置信区间；
- 总体标准差的置信区间；
- 方差是否等于某个规格；
- 波动是否超过某标准；

通常就想到卡方分布。

---

## 2. 为什么卡方分布只取正值？

因为：

$$\frac{(n-1)S^2}{\sigma^2}\geq0$$

方差和平方和不可能为负，所以卡方分布只在正半轴上。

它不像 Z 和 t 那样关于 $0$ 对称。因此卡方双侧区间的两个临界值不是简单的正负关系，必须分别查左右临界值。

---

## 3. 方差置信区间套路

对于置信水平 $1-\alpha$：

$$\left[
\frac{(n-1)S^2}{\chi^2_{\alpha/2}(n-1)},
\frac{(n-1)S^2}{\chi^2_{1-\alpha/2}(n-1)}
\right]$$

这里沿用你们板书中的**右尾临界值记法**：

$$P\left(\chi^2_d>\chi^2_\gamma(d)\right)=\gamma$$

因此：

- 分母较大的临界值放在下界；
- 分母较小的临界值放在上界。

做题流程：

1. 求 $n$ 和 $s^2$；
2. 自由度：

$$d=n-1$$

3. 查：

$$\chi^2_{\alpha/2}(d)$$

和：

$$\chi^2_{1-\alpha/2}(d)$$

4. 代入上下界；
5. 如果题目问标准差 $\sigma$，对两个端点开根号。

即若方差区间为：

$$[L,U]$$

则标准差区间为：

$$[\sqrt L,\sqrt U]$$

---

## 4. 方差假设检验套路

例如：

$$H_0:\sigma^2=\sigma_0^2$$

检验统计量：

$$Q=\frac{(n-1)S^2}{\sigma_0^2}$$

在 $H_0$ 下：

$$Q\sim\chi^2(n-1)$$

根据备择假设判断尾部。

右尾：

$$H_1:\sigma^2>\sigma_0^2$$

样本方差过大才反对 $H_0$，所以看右尾：

$$p=P(\chi^2_d\geq q_{\mathrm{obs}})$$

左尾：

$$H_1:\sigma^2<\sigma_0^2$$

看左尾：

$$p=P(\chi^2_d\leq q_{\mathrm{obs}})$$

双尾：

$$H_1:\sigma^2\neq\sigma_0^2$$

两边都算，但因为卡方分布不对称，不能机械地理解成“横坐标正负对称”。常见定义是：

$$p=2\min\left\{P(\chi^2_d\leq q_{\mathrm{obs}}),P(\chi^2_d\geq q_{\mathrm{obs}})\right\}$$

具体考试中应按老师或教材采用的双侧卡方定义处理。


# 置信区间和假设检验怎么联系？

如果用的是同一种统计方法，那么双侧显著性水平 $\alpha$ 的检验，与置信水平 $1-\alpha$ 的区间对应。

即：

$$H_0:\theta=\theta_0$$

在显著性水平 $\alpha$ 下不被拒绝，当且仅当：

$$\theta_0\in CI_{1-\alpha}$$

适用于：

- Z 均值检验与 Z 置信区间；
- t 均值检验与 t 置信区间；
- 卡方方差检验与卡方方差置信区间。

所以：

$$95\%\ CI\Longleftrightarrow\alpha=0.05\text{ 的双侧检验}$$

$$99\%\ CI\Longleftrightarrow\alpha=0.01\text{ 的双侧检验}$$

---

# 一个快速决策树

看到题目后按下面走：

$$\boxed{\text{问的是均值 }\mu\text{ 吗？}}$$

若是，再问：

$$\boxed{\sigma\text{ 已知吗？}}$$

已知：

$$\boxed{Z}$$

未知：

$$\boxed{t,\ d=n-1}$$

如果问的是：

$$\boxed{\sigma^2\text{ 或 }\sigma}$$

并且总体正态：

$$\boxed{\chi^2,\ d=n-1}$$

然后最后再判断：

$$>,\ <,\ \neq$$

分别对应右尾、左尾、双尾。

最值得记住的不是三个孤立公式，而是它们分别来自三个不同的“标准化量”：

$$\frac{\bar X-\mu}{\sigma/\sqrt n}\sim Normal(0,1)$$

$$\frac{\bar X-\mu}{S/\sqrt n}\sim t(n-1)$$

$$\frac{(n-1)S^2}{\sigma^2}\sim\chi^2(n-1)$$

前两个处理均值，区别是 $\sigma$ 已知还是未知；第三个处理方差。这三行基本覆盖了你们当前课件里的主要题型。