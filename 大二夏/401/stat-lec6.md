前半部分：Wilcoxon signed-rank test 的大样本近似

上一节课我们讲了 Wilcoxon signed-rank test。

它的思想是：

对于每一个样本：

$$D_i=X_i-M_0$$

然后：

1. 看正负号；
    
2. 对：
    

$$|D_i|$$

排序；  
3. 用 rank 代替原始大小。

定义：

$$W^+=\sum_{D_i>0}R_i$$

也就是所有正差值对应 rank 的和。

---

为什么可以求 $W^+$ 的分布？

板书第 1 页定义：

$$B_k=  
\begin{cases}  
1,&\text{rank }k\text{ is positive}\  
0,&\text{rank }k\text{ is negative}  
\end{cases}  
$$

在零假设：

$$H_0:M=M_0$$

成立时，由于正负号应该随机：

$$B_k\sim Bernoulli(\frac12)$$

也就是说：

每一个 rank：

- 有一半概率属于正方向；
    
- 有一半概率属于负方向。
    

因此：

$$W^+=1B_1+2B_2+\cdots+nB_n$$

写成：

$$W^+=\sum_{k=1}^{n}kB_k$$

---

接下来计算它的均值。

因为：

$$E(B_k)=\frac12$$

所以：

$$E(W^+)=\sum_{k=1}^{n}kE(B_k)$$

得到：

$$E(W^+)=\frac12\sum_{k=1}^{n}k$$

而：

$$\sum_{k=1}^{n}k=\frac{n(n+1)}2$$

因此：

$$E(W^+)=\frac{n(n+1)}4$$

---

然后计算方差。

因为不同 rank 的符号独立：

$$Var(W^+)=\sum_{k=1}^{n}k^2Var(B_k)$$

而：

$$Var(B_k)=\frac12(1-\frac12)=\frac14$$

所以：

$$Var(W^+)=\frac14\sum_{k=1}^{n}k^2$$

利用：

$$\sum_{k=1}^{n}k^2=\frac{n(n+1)(2n+1)}6$$

得到：

$$Var(W^+)=\frac{n(n+1)(2n+1)}{24}$$

---

因此，当样本量较大时，根据中心极限定理：

$$W^+\approx Normal  
\left(  
\frac{n(n+1)}4,  
\frac{n(n+1)(2n+1)}{24}  
\right)  
$$

这就是板书第 2 页的结论。

但是注意：

实际考试中如果 $n$ 不大，一般使用 Wilcoxon table，而不是这个正态近似。

---

接下来进入新的大章节：

## 一、总体比例（Inference on Proportions）

这里开始研究：

一个总体中某种属性出现的比例：

例如：

- 产品合格率；
    
- 电路失效率；
    
- 用户满意比例。
    

设：

总体真实比例：

$$p$$

但是我们不知道。

我们随机抽：

$$n$$

个样本。

其中成功次数：

$$X$$

那么样本比例：

$$\hat p$$

定义为：

$$\hat p=\frac Xn$$

这就是比例的点估计。

---

为什么 $\hat p$ 可以估计 $p$？

因为每个样本可以表示成：

$$X_i=  
\begin{cases}  
1,&\text{success}\  
0,&\text{failure}  
\end{cases}  
$$

于是：

$$X=X_1+\cdots+X_n$$

并且：

$$X_i\sim Bernoulli(p)  
$$

所以：

$$E(X_i)=p$$

因此：

$$E(\hat p)=p$$

说明：

$$\hat p$$

是 $p$ 的无偏估计。

---

## 二、比例的置信区间

因为：

$$X\sim Binomial(n,p)$$

当：

$$n$$

足够大时，根据中心极限定理：

$$\hat p\approx Normal  
\left(  
p,  
\frac{p(1-p)}n  
\right)  
$$

标准化：

$$Z=  
\frac{\hat p-p}  
{\sqrt{\frac{p(1-p)}n}}  
$$

近似服从：

$$Normal(0,1)$$

但是问题：

$p$ 不知道。

所以实际计算时用：

$$\hat p$$

替代：

$$p$$

得到：

$$\hat p  
\pm  
z_{\alpha/2}  
\sqrt{  
\frac{\hat p(1-\hat p)}n  
}  
$$

这就是板书第 3 页公式：

$$\boxed{  
\hat p\pm z_{\alpha/2}  
\sqrt{\frac{\hat p(1-\hat p)}n}  
}  
$$

---

例子：

100 个电路测试：

91 个正常。

所以：

$$\hat p=\frac{91}{100}=0.91$$

95% 置信：

$$z_{0.025}=1.96$$

误差：

$$  
1.96  
\sqrt{\frac{0.91(0.09)}{100}}  
$$

得到：

$$0.056$$

所以：

$$CI=0.91\pm0.056$$

即：

$$[0.854,0.966]$$

解释：

我们有约 95% 信心认为真实合格率在：

$$85.4\%\sim96.6\%$$

之间。

---

## 三、如何决定需要多少样本量？

现在反过来：

如果希望误差：

$$d$$

以内：

即：

$$|\hat p-p|\leq d$$

需要多少样本？

误差来自：

$$  
z_{\alpha/2}  
\sqrt{\frac{p(1-p)}n}  
$$

令：

$$  
d=z_{\alpha/2}  
\sqrt{\frac{p(1-p)}n}  
$$

整理：

$$  
n=  
\frac{z_{\alpha/2}^2p(1-p)}  
{d^2}  
$$

如果已有历史估计：

用：

$$\hat p$$

代替：

$$p$$

得到：

$$  
n=  
\frac{  
z_{\alpha/2}^2  
\hat p(1-\hat p)  
}  
{d^2}  
$$

---

如果完全不知道 $p$：

怎么办？

因为：

$$p(1-p)$$

最大值是多少？

令：

$$f(p)=p(1-p)$$

最大在：

$$p=0.5$$

所以：

$$p(1-p)\leq0.25$$

于是使用最保守估计：

$$  
n=  
\frac{z_{\alpha/2}^2}{4d^2}  
$$

---

## 四、比例的假设检验

现在不是估计，而是判断一个说法是否正确。

例如：

“超过 70% 的输电故障由闪电造成”。

设：

$$p=$$

真实比例。

研究：

$$H_0:p\leq0.7$$

$$H_1:p>0.7$$

右尾检验。

---

检验统计量：

$$  
Z=  
\frac{\hat p-p_0}  
{\sqrt{\frac{p_0(1-p_0)}n}}  
$$

注意：

这里分母使用：

$$p_0$$

因为零假设成立时：

$$p=p_0$$

---

例子：

200 个故障：

151 个由闪电造成。

所以：

$$\hat p=\frac{151}{200}=0.755$$

统计量：

$$  
Z=  
\frac{0.755-0.7}  
{\sqrt{0.7(0.3)/200}}  
$$

得到：

$$Z=1.697$$

查标准正态：

$$p\text{-value}=P(Z>1.697)$$

约：

$$0.0446$$

因为：

$$0.0446<0.05$$

所以：

拒绝：

$$H_0$$

认为：

$$p>0.7$$

---

## 五、两个总体比例比较

现在比较：

两个总体：

$$p_1,p_2$$

例如：

加拿大企业拥有大型机比例；

美国企业拥有大型机比例。

估计：

$$  
\hat p_1-\hat p_2  
$$

其中：

$$  
\hat p_1=\frac{x_1}{n_1}  
$$

$$  
\hat p_2=\frac{x_2}{n_2}  
$$

---

大样本情况下：

$$  
\hat p_1-\hat p_2  
$$

近似：

$$Normal  
\left(  
p_1-p_2,  
\frac{p_1(1-p_1)}{n_1}  
+  
\frac{p_2(1-p_2)}{n_2}  
\right)  
$$

所以置信区间：

$$  
(\hat p_1-\hat p_2)  
\pm  
z_{\alpha/2}  
\sqrt{  
\frac{\hat p_1(1-\hat p_1)}{n_1}  
+  
\frac{\hat p_2(1-\hat p_2)}{n_2}  
}  
$$

---

例如：

加拿大：

$$\hat p_1=0.589$$

美国：

$$\hat p_2=0.619$$

差：

$$  
\hat p_1-\hat p_2=-0.03  
$$

95% CI：

$$  
-0.03\pm0.07  
$$

得到：

$$[-0.10,0.04]$$

因为包含：

$$0$$

所以不能认为两个比例不同。

---

## 六、两个比例假设检验

现在检验：

$$H_0:p_1-p_2=0$$

或者：

$$p_1=p_2$$

此时两个总体共享同一个比例：

$$p$$

因此使用 pooled estimator：

$$  
\hat p=  
\frac{  
n_1\hat p_1+n_2\hat p_2  
}  
{n_1+n_2}  
$$

也可以写：

$$  
\hat p=  
\frac{x_1+x_2}{n_1+n_2}  
$$

---

检验统计量：

$$  
Z=  
\frac{\hat p_1-\hat p_2}  
{  
\sqrt{  
\hat p(1-\hat p)  
(\frac1{n_1}+\frac1{n_2})  
}  
}  
$$

---

## 七、两个总体均值比较（开始新章节）

最后几页开始进入：

Comparing Two Means。

目标：

比较：

$$\mu_1-\mu_2$$

估计：

$$  
\bar X_1-\bar X_2  
$$

如果两个样本独立：

$$  
\bar X_1-\bar X_2  
\sim  
Normal  
\left(  
\mu_1-\mu_2,  
\frac{\sigma_1^2}{n_1}  
+  
\frac{\sigma_2^2}{n_2}  
\right)  
$$

---

但是这里出现新的问题：

两个方差：

$$\sigma_1^2,\sigma_2^2$$

是否相等？

板书最后提出两种情况：

$$\sigma_1^2=\sigma_2^2$$

$$\sigma_1^2\neq\sigma_2^2$$

这会导致不同的 two-sample t test。

---

为了比较两个方差，需要引入：

F 分布。

定义：

如果：

$$  
X_1\sim\chi^2(\gamma_1)  
$$

$$  
X_2\sim\chi^2(\gamma_2)  
$$

且独立，

那么：

$$  
F=  
\frac{X_1/\gamma_1}  
{X_2/\gamma_2}  
$$

服从：

$$  
F(\gamma_1,\gamma_2)  
$$

这就是下一节课的起点。

---

总结这一节课：

1. Wilcoxon：
    

$$  
W^+\approx Normal  
\left(  
\frac{n(n+1)}4,  
\frac{n(n+1)(2n+1)}{24}  
\right)  
$$

解决非参数检验的大样本问题。

2. 单比例：
    

估计：

$$  
\hat p=\frac xn  
$$

置信区间：

$$  
\hat p\pm z_{\alpha/2}  
\sqrt{\frac{\hat p(1-\hat p)}n}  
$$

检验：

$$  
Z=  
\frac{\hat p-p_0}  
{\sqrt{p_0(1-p_0)/n}}  
$$

3. 两比例：
    

估计：

$$  
\hat p_1-\hat p_2  
$$

检验 $p_1=p_2$ 时使用 pooled estimator。

4. 两均值比较：
    

核心问题变成：

**两个总体方差是否相等？**

因此引出：

$$F=\frac{X_1^2/\gamma_1}{X_2^2/\gamma_2}$$

下一节将围绕 F-test 和 two-sample t-test 展开。