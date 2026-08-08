我会按照这份课件的顺序讲。这一章主题是 **Simple Linear Regression（简单线性回归）**。课件从第1页的 Anscombe's quartet 引入，说明“看似相同的统计量可能对应完全不同的数据结构”，然后进入线性回归模型、最小二乘估计、参数分布、斜率/截距推断、置信区间和预测区间。

这一章其实是工程概率里非常重要的一章，因为它把前面的：

- 正态分布
    
- 方差估计
    
- $\chi^2$
    
- t 分布
    
- 假设检验
    

全部串起来。

---

## 1. 为什么需要 Regression（回归）？

先看课件第一页的 Anscombe's quartet。

四组数据：

Dataset I, II, III, IV

它们有：

- 相同的 $x$ 均值；
    
- 相同的 $y$ 均值；
    
- 相同方差；
    
- 相同相关系数；
    
- 相同线性回归方程。
    

例如：

$$  
\hat y=3+0.5x  
$$

甚至：

$$  
R^2=0.67  
$$

但是画出来完全不同。

这说明：

> 单纯看统计量是不够的，必须看数据背后的关系结构。

例如：

第四组：

大量点集中在一个竖线上，但是有一个离群点决定了回归线。

所以 regression 的目标不是简单计算一个公式，而是：

寻找：

$$  
X  
$$

和：

$$  
Y  
$$

之间是否存在某种系统关系。

---

# 2. Simple Linear Regression Model（简单线性回归模型）

课件第3页：

真实关系：

$$  
\mu_{Y|X}=\beta_0+\beta_1X  
$$

意思：

如果给定：

$$  
X=x  
$$

那么：

$$  
Y  
$$

的平均值落在线：

$$  
\beta_0+\beta_1x  
$$

上。

但是实际观测：

不会全部在线上。

所以加入误差：

$$  
Y_i=\beta_0+\beta_1x_i+\epsilon_i  
$$

其中：

- $\beta_0$：intercept（截距）
    
- $\beta_1$：slope（斜率）
    
- $\epsilon_i$：随机误差
    

---

## 误差项的假设

这是后面所有推导的基础。

课件第9页总结：

简单线性回归假设：

$$  
Y_i  
$$

相互独立；

$$  
\epsilon_i  
$$

服从正态：

$$  
\epsilon_i\sim N(0,\sigma^2)  
$$

均值：

$$  
E(Y_i)=\beta_0+\beta_1x_i  
$$

所以：

$$  
Y_i\sim N(\beta_0+\beta_1x_i,\sigma^2)  
$$

---

# 3. Regression Line 和 Residual（残差）

课件第3、4页画了三个东西：

## True regression line

真实：

 $$  
\mu_{Y|X}
=
\beta_0+\beta_1x  
$$

但是：

我们不知道 $\beta_0,\beta_1$。

---

## Estimated regression line

根据样本估计：

$$  
\hat y=b_0+b_1x  
$$

这里：

$$  
b_0,b_1  
$$

是估计值。

---

## Residual（残差）

对于一个点：

$$  
(x_i,y_i)  
$$

预测：

$$  
\hat y_i=b_0+b_1x_i  
$$

真实值：

$$  
y_i  
$$

差：

$$  
e_i=y_i-\hat y_i  
$$

这就是 residual。

---

注意：

课件第4页强调：

真实误差：

$$  
\epsilon_i  
$$

和：

残差：

$$  
e_i  
$$

不是一个东西。

区别：

$$  
\epsilon_i  
$$

是：

真实模型中的随机误差。

但是：

$$  
e_i  
$$

是：

我们用估计线计算出来的误差。

---

# 4. Least Squares Method（最小二乘法）

核心思想：

让残差平方和最小。

即：

$$  
SSE
=
\sum_{i=1}^{n}e_i^2  
$$

代入：

$$  
e_i=y_i-b_0-b_1x_i  
$$

所以：

$$  
SSE
=
\sum_{i=1}^{n}  
(y_i-b_0-b_1x_i)^2  
$$

目标：

选择：

$$  
b_0,b_1  
$$

使：

$$  
SSE  
$$

最小。

---

为什么平方？

因为：

如果直接：

$$  
\sum e_i  
$$

正负会抵消。

平方以后：

- 大误差惩罚更大；
    
- 可以求导优化。
    

---

# 5. 如何得到 $b_0,b_1$？

课件第5–7页用了矩阵方法。

但最终结果非常重要：

$$  
b_1=  
\frac{  
n\sum x_iy_i-(\sum x_i)(\sum y_i)  
}  
{  
n\sum x_i^2-(\sum x_i)^2  
}  
$$

也可以写成更直观形式：

$$  
b_1=  
\frac{S_{xy}}{S_{xx}}  
$$

其中：

$$  
S_{xx}
=
\sum(x_i-\bar x)^2  
$$

表示：

$x$ 的变化程度。

$$  
S_{xy}
=
\sum(x_i-\bar x)(y_i-\bar y)  
$$

表示：

$x,y$共同变化。

---

截距：

$$  
b_0=\bar y-b_1\bar x  
$$

为什么？

因为回归线一定经过：

$$  
(\bar x,\bar y)  
$$

---

# 6. Example（课件第8–9页）

例子：

研究：

humidity（湿度）

和：

solvent evaporation（溶剂挥发量）

令：

$$  
X=\text{humidity}  
$$

$$  
Y=\text{evaporation}  
$$

收集：

$$  
n=25  
$$

计算：

$$  
\sum x=1314.90  
$$

$$  
\sum y=235.70  
$$

$$  
\sum x^2=76308.53  
$$

$$  
\sum xy=12281.44  
$$

代入：

得到：

$$  
b_1=-0.08  
$$

$$  
b_0=13.64  
$$

所以：

估计回归线：

$$  
\hat y=13.64-0.08x  
$$

解释：

湿度增加：

挥发量下降。

例如：

湿度：

$$  
x=50  
$$

预测：

$$  
\hat y
=
13.64-0.08(50)  
$$

得到：

$$  
\hat y=9.64  
$$

---

# 7. Regression coefficient 的分布

这是后半部分重点。

我们不仅想估计：

$$  
b_1  
$$

还想知道：

这个估计可靠吗？

---

## Slope 的分布

课件第11页：

$$  
B_1  
\sim  
N  
\left(  
\beta_1,  
\frac{\sigma^2}{S_{xx}}  
\right)  
$$

意思：

如果重复实验很多次：

得到很多：

$$  
b_1  
$$

它们会围绕：

$$  
\beta_1  
$$

正态分布。

---

方差：

$$  
Var(B_1)
=
\frac{\sigma^2}{S_{xx}}  
$$
如果：

$x$ 分布很散：

$$  
S_{xx}  
$$

大。

那么：

斜率估计更稳定。

---

# 8. 为什么出现 t 分布？

因为：

真实：

$$  
\sigma^2  
$$

不知道。

我们只能估计：

$$  
S^2  
$$

其中：

$$  
S^2=  
\frac{SSE}{n-2}  
$$

课件第11页：

$$  
\frac{(n-2)S^2}{\sigma^2}  
\sim  
\chi^2(n-2)  
$$

并且：

$$  
B_1  
$$

和：

$$  
S^2  
$$

独立。

于是：

构造：

$$  
T=  
\frac{B_1-\beta_1}  
{S/\sqrt{S_{xx}}}  
$$

得到：

$$  
T\sim t(n-2)  
$$

这就是为什么回归里的显著性检验用 t-test。

---

# 9. Test for slope（斜率检验）

课件第12页。

问题：

$x$ 是否真的影响 $y$？

就是：

$$  
H_0:\beta_1=0  
$$

意思：

没有线性关系。

备择：

$$  
H_1:\beta_1\neq0  
$$

统计量：

$$  
T=  
\frac{b_1-0}  
{S/\sqrt{S_{xx}}}  
$$

查：

$$  
t(n-2)  
$$

如果：

$p<\alpha$

拒绝：

$$  
H_0  
$$

说明：

斜率显著。

---

# 10. Confidence Interval for slope

课件第13页：

$$  
b_1  
\pm  
t_{\alpha/2,n-2}  
\frac{S}{\sqrt{S_{xx}}}  
$$

解释：

我们不知道真实：

$$  
\beta_1  
$$

但是可以给一个范围。

---

例如：

如果：

95% CI：

$$  
[-0.10,-0.05]  
$$

不包含：

$$  
0  
$$

说明：

斜率显著不为0。

---

# 11. Intercept inference（截距）

完全类似。

截距：

$$  
\beta_0  
$$

估计：

$$  
b_0  
$$

统计量：

$$  
T=  
\frac{b_0-\beta_0}  
{  
S  
\sqrt{  
\frac{\sum x_i^2}  
{nS_{xx}}  
}  
}  
$$

同样：

服从：

$$  
t(n-2)  
$$

---

# 12. Confidence Interval vs Prediction Interval（最后一页）

这是非常容易混的。

---

## Confidence interval for mean response

问题：

> 当 $X=x_0$ 时，平均 $Y$ 是多少？

预测的是：

$$  
\mu_{Y|x_0}  
$$

公式：

$$  
\hat y  
\pm  
t_{\alpha/2,n-2}  
S  
\sqrt{  
\frac1n+  
\frac{(x_0-\bar x)^2}{S_{xx}}  
}  
$$

---

## Prediction interval

问题：

> 下一个具体观测值是多少？

注意：

单个点除了均值不确定，还有随机误差。

所以更宽：

$$  
\hat y  
\pm  
t_{\alpha/2,n-2}  
S  
\sqrt{  
1+\frac1n+  
\frac{(x_0-\bar x)^2}{S_{xx}}  
}  
$$

多了：

$$  
1  
$$

因为包含新的随机误差。

---

所以：

Prediction interval 永远比 confidence interval 宽。

---

# 总结整章逻辑

这章可以串成一条线：

1. 假设：
    

$$  
Y_i=\beta_0+\beta_1x_i+\epsilon_i  
$$

2. 用最小二乘：
    

找到：

$$  
b_0,b_1  
$$

3. 得到：
    

$$  
\hat y=b_0+b_1x  
$$

4. 用误差估计：
    

$$  
S^2=\frac{SSE}{n-2}  
$$

5. 因为：
    

$$  
\sigma  
$$

未知：

所以：

$$  
t(n-2)  
$$

6. 做：
    

- slope test
    
- intercept test
    
- confidence interval
    
- prediction interval
    

这一章本质就是：

> **把线性模型中的参数估计问题，转化成一个基于正态分布、$\chi^2$ 和 t 分布的统计推断问题。**