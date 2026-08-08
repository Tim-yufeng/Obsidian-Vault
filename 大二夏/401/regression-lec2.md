我会按照这份板书的结构讲。这一节实际上是上一节“线性回归推断”的延续，主要分成四部分：

1. 回归模型的进一步应用：置信区间与预测区间（page 1–2）
    
2. 重复测量数据下的 lack of fit 检验（page 3–5）
    
3. Pearson correlation coefficient（相关系数）（page 6–8）
    
4. 相关系数的区间估计与假设检验（delta method，page 9–13）
    

整节课的核心思想是：

> 回归研究的是“一个变量如何随着另一个变量变化”；相关系数研究的是“两个变量之间线性关系强弱”。当模型不确定时，我们需要用统计检验判断这种关系是否真实存在。

---

## 一、回归中的置信区间和预测区间（page 1–2）

板书首先回顾汽车油耗例子：

- $X$：汽车重量（tons）
    
- $Y$：油耗（miles/gallon）
    

建立简单线性回归：

$$  
Y=\beta_0+\beta_1X+\epsilon  
$$

目标：

根据汽车重量预测油耗。

通过最小二乘得到：

$$  
\hat Y=b_0+b_1X  
$$

板书计算得到：

$$  
b_1=-4.03  
$$

$$  
b_0=23.75  
$$

所以：

$$  
\hat Y=23.75-4.03X  
$$

意思：

汽车越重，油耗越低。

例如：

如果：

$$  
X=1.7  
$$

则预测：

$$  
\hat Y=23.75-4.03(1.7)=16.899  
$$

但是这里有一个问题：

这个 $16.899$ 是一个估计值，不可能完全准确。

所以我们需要回答两个问题：

1. 平均油耗是多少？
    
2. 一辆具体汽车的油耗是多少？
    

这对应两个不同区间。

---

**1. Mean response 的置信区间**

问题：

对于所有重量为 $x_0$ 的汽车，它们平均油耗是多少？

即：

$$  
E(Y|X=x_0)  
$$

估计：

$$  
\hat\mu_Y(x_0)  
$$

它的不确定性来自估计直线的位置。

置信区间：

$$  
\hat\mu_Y(x_0)  
\pm  
t_{\alpha/2,n-2}  
S  
\sqrt{  
\frac1n+  
\frac{(x_0-\bar x)^2}{S_{xx}}  
}  
$$

注意里面：

$$  
\frac1n  
$$

代表估计整体平均的误差。

---

**2. Individual prediction interval**

如果问：

“一辆重量 1.7 tons 的具体汽车，它的油耗是多少？”

那么除了回归线估计误差，还多了汽车自身随机误差：

$$  
\epsilon  
$$

因此：

$$  
\hat Y(x_0)  
\pm  
t_{\alpha/2,n-2}  
S  
\sqrt{  
1+\frac1n+  
\frac{(x_0-\bar x)^2}{S_{xx}}  
}  
$$

相比前一个，多了：

$$  
1  
$$

所以预测区间一定更宽。

直观理解：

预测平均油耗：

> 看一群这种车平均是多少。

预测单辆车：

> 不仅不知道平均位置，还不知道这辆车自身偏离多少。

所以：

$$  
Prediction\ interval

Confidence\ interval  
$$

---

## 二、Repeated measurements 和 Lack of Fit 检验（page 3–5）

这一部分是这节课最容易混淆的地方。

普通线性回归假设：

$$  
Y_i=\beta_0+\beta_1x_i+\epsilon_i  
$$

但是如果模型不好，会出现：

真实关系不是直线。

例如：

真实：

$$  
Y=x^2  
$$

但是你硬拟合：

$$  
Y=\beta_0+\beta_1x  
$$

那么误差会很大。

问题：

SSE 大，到底是什么原因？

有两个可能：

---

第一种：

实验本身噪声大。

比如：

同样温度做实验，每次结果不同。

这是：

pure error

---

第二种：

模型形式错了。

比如：

真实是二次函数，你用了直线。

这是：

lack of fit error

---

所以板书把 SSE 分解：

$$  
SSE=SSE_{pe}+SSE_{lf}  
$$

其中：

$$  
SSE_{pe}  
$$

是纯实验误差。

$$  
SSE_{lf}  
$$

是模型缺失导致的误差。

---

为什么需要 repeated measurements？

因为如果每个 $x$ 只测一次：

例如：

$$  
x=30,\quad y=13.7  
$$

你无法知道：

这个偏差到底来自：

- 实验随机误差？
    
- 模型错误？
    

但是如果：

$$  
x=30  
$$

测三次：

$$  
13.7,14.0,14.6  
$$

那么同一个 $x$ 下的波动就是纯误差。

因此：

$$  
SSE_{pe}

\sum_i\sum_j(Y_{ij}-\bar Y_i)^2  
$$

表示同一个 $x_i$ 内部的波动。

---

然后定义：

$$  
SSE_{lf}=SSE-SSE_{pe}  
$$

如果：

$$  
SSE_{lf}  
$$

很大：

说明线性模型解释不了数据。

---

建立假设：

$$  
H_0:  
\text{linear regression model is appropriate}  
$$

$$  
H_1:  
\text{linear regression model is not appropriate}  
$$

构造 F statistic：

$$  
F=  
\frac{SSE_{lf}/(k-2)}  
{SSE_{pe}/(n-k)}  
$$

为什么是 F？

因为：

分子：

$$  
\frac{SSE_{lf}}{\sigma^2}  
$$

服从：

$$  
\chi^2(k-2)  
$$

分母：

$$  
\frac{SSE_{pe}}{\sigma^2}  
$$

服从：

$$  
\chi^2(n-k)  
$$

两个独立卡方相除：

得到 F 分布：

$$  
F\sim F(k-2,n-k)  
$$

---

例子中：

计算：

$$  
F=26.928  
$$

临界值：

$$  
F_{0.05}(3,10)=3.708  
$$

因为：

$$  
26.928>3.708  
$$

拒绝：

$$  
H_0  
$$

说明：

线性模型不合适。

---

## 三、Pearson correlation coefficient（page 6–8）

相关系数回答：

两个变量是否线性相关。

定义：

$$  
\rho=  
\frac{Cov(X,Y)}  
{\sqrt{Var(X)Var(Y)}}  
$$

范围：

$$  
-1\leq\rho\leq1  
$$

含义：

$$  
\rho=1  
$$

完全正线性关系。

$$  
\rho=-1  
$$

完全负线性关系。

$$  
\rho=0  
$$

没有线性关系。

注意：

$$  
\rho=0  
$$

不代表完全没有关系。

例如板书中的抛物线：

$$  
Y=X^2  
$$

虽然明显相关，但是 Pearson correlation 可能为：

$$  
\rho=0  
$$

因为它只测量线性关系。

---

样本估计：

$$  
R=  
\frac{S_{xy}}  
{\sqrt{S_{xx}S_{yy}}}  
$$

其中：

$$  
S_{xy}  
$$

表示共同变化。

如果：

$X$ 增大时 $Y$ 也增大：

$$  
S_{xy}>0  
$$

所以：

$$  
R>0  
$$

---

## 四、相关系数和回归斜率的关系（page 8）

这里是一个重要联系。

回归：

$$  
E(Y|X)=\beta_0+\beta_1X  
$$

斜率：

$$  
\beta_1
=
\rho  
\frac{\sigma_Y}{\sigma_X}  
$$

因为：

$$  
\sigma_X,\sigma_Y>0  
$$

所以：

$$  
\rho=0  
\iff  
\beta_1=0  
$$

也就是说：

检验：

“没有相关”

等价于：

“回归斜率为 0”。

---

因此：

检验：

$$  
H_0:\rho=0  
$$

可以转化为：

$$  
H_0:\beta_1=0  
$$

而之前学过：

$$  
T=  
\frac{B_1}{S/\sqrt{S_{xx}}}  
$$

服从：

$$  
t(n-2)  
$$

板书进一步推导得到：

$$  
T_{n-2}
=
\frac{R\sqrt{n-2}}  
{\sqrt{1-R^2}}  
$$

这就是检验 Pearson correlation 的经典公式。

---

## 五、为什么需要 delta method？（page 9–13）

## 1. 前置：为什么相关系数 $R$ 需要特殊处理？

前面我们已经得到：

总体相关系数：

$$  
\rho=  
\frac{Cov(X,Y)}  
{\sqrt{Var(X)Var(Y)}}  
$$

样本估计：

$$  
R=  
\frac{S_{xy}}  
{\sqrt{S_{xx}S_{yy}}}  
$$

我们希望知道：

- $R$ 离真实 $\rho$ 有多远？
    
- 如何构造 $\rho$ 的置信区间？
    

最直接想法：

如果：

$$  
R\sim Normal(\rho,\sigma_R^2)  
$$

那么直接：

$$  
R\pm z_{\alpha/2}\sigma_R  
$$

即可。

但是问题：

相关系数的方差不是固定的。

板书第11页写：

$$  
R\approx  
Normal  
\left(  
\rho,  
\frac{(1-\rho^2)^2}{n}  
\right)  
$$

注意这里：

方差：

$$  
\frac{(1-\rho^2)^2}{n}  
$$

依赖：

$$  
\rho  
$$

而 $\rho$ 正是未知量。

例如：

如果：

$$  
\rho=0  
$$

则：

$$  
Var(R)\approx\frac1n  
$$

但是如果：

$$  
\rho=0.9  
$$

则：

$$  
Var(R)\approx  
\frac{(1-0.81)^2}{n}

\frac{0.0361}{n}  
$$

方差小很多。

所以直接用 $R$ 做正态近似不好。

---

# 2. delta method 是什么？

板书第9页先回顾 delta method。

核心思想：

如果：

$$  
X_n  
$$

已经近似正态：

$$  
\sqrt n(X_n-\theta)  
\rightarrow  
N(0,\sigma^2)  
$$

但是我们关心：

$$  
g(X_n)  
$$

怎么办？

答案：

对 $g$ 在 $\theta$ 附近做 Taylor 展开。

---

一阶 Taylor：

$$  
g(X_n)  
\approx  
g(\theta)  
+  
g'(\theta)(X_n-\theta)  
$$

移项：

$$  
g(X_n)-g(\theta)  
\approx  
g'(\theta)(X_n-\theta)  
$$

两边乘：

$$  
\sqrt n  
$$

得到：

$$  
\sqrt n(g(X_n)-g(\theta))  
\rightarrow  
N  
(0,  
\sigma^2[g'(\theta)]^2)  
$$

也就是说：

函数变换以后：

- 均值变成：
    

$$  
g(\theta)  
$$

- 方差乘：
    

$$  
[g'(\theta)]^2  
$$

---

# 3. 应用于相关系数

板书第10页开始真正进入推导。

最后化简得到：

$$  
Var(R)  
\approx  
\frac{(1-\rho^2)^2}{n}  
$$

这就是前面的结果来源。

---

# 4. Fisher 为什么选择这个变换？

现在问题：

我们知道：

$$  
R  
\approx  
N  
\left(  
\rho,  
\frac{(1-\rho^2)^2}{n}  
\right)  
$$

但是方差依赖 $\rho$。

所以希望找一个函数：

$$  
Z=g(R)  
$$

使得：

$$  
Var(Z)  
$$

不依赖 $\rho$。

---

delta method告诉我们：

如果：

$$  
Z=g(R)  
$$

那么：

$$  
Var(Z)  
\approx  
[g'(\rho)]^2  
Var(R)  
$$

代入：

$$  
Var(R)

\frac{(1-\rho^2)^2}{n}  
$$

得到：

$$  
Var(Z)  
\approx  
[g'(\rho)]^2  
\frac{(1-\rho^2)^2}{n}  
$$

我们的目标：

让：

$$  
[g'(\rho)]^2(1-\rho^2)^2=1  
$$

所以：

$$  
g'(\rho)

\frac1{1-\rho^2}  
$$

积分：

$$  
g(\rho)

\int  
\frac1{1-\rho^2}  
d\rho  
$$

得到：

$$  
g(\rho)

\frac12  
\ln  
\frac{1+\rho}{1-\rho}  
$$

这就是 Fisher transformation。

---

所以定义：

$$  
Z=  
\frac12  
\ln  
\frac{1+R}{1-R}  
$$

---

# 5. Fisher transformation 后得到什么？

根据 delta method：

$$  
Z  
\approx  
Normal  
\left(  
g(\rho),  
\frac1n  
\right)  
$$

更精确的修正：

板书写：

$$  
Z  
\approx  
Normal  
\left(  
atanh(\rho),  
\frac1{n-3}  
\right)  
$$

其中：

$$  
atanh(\rho)

\frac12  
\ln  
\frac{1+\rho}{1-\rho}  
$$

关键变化：

原来：

$$  
Var(R)

\frac{(1-\rho^2)^2}{n}  
$$

现在：

$$  
Var(Z)

\frac1{n-3}  
$$

不再依赖 $\rho$。

这就是 Fisher transformation 的意义。

---

# 6. 如何构造 $\rho$ 的置信区间？

我们现在有：

$$  
Z  
\approx  
N  
\left(  
atanh(\rho),  
\frac1{n-3}  
\right)  
$$

所以：

$$  
atanh(R)  
\pm  
\frac{z_{\alpha/2}}  
{\sqrt{n-3}}  
$$

这是：

$$  
atanh(\rho)  
$$

的置信区间。

但是我们最终想要：

$$  
\rho  
$$

所以需要反变换。

---

因为：

$$  
z=  
\frac12  
\ln  
\frac{1+\rho}{1-\rho}  
$$

解：

$$  
\rho=  
\frac{e^{2z}-1}  
{e^{2z}+1}  
$$

也就是：

$$  
\rho=\tanh(z)  
$$

---

板书第12页给出的公式：

本质就是：

1. 计算：
    

$$  
atanh(R)  
$$

2. 加减：
    

$$  
\frac{z_{\alpha/2}}{\sqrt{n-3}}  
$$

3. 再：
    

$$  
\tanh  
$$

变回来。

---

# 7. 最后的假设检验（page 13）

如果要检验：

$$  
H_0:\rho=\rho_0  
$$

那么：

根据 Fisher transformation：

$$  
atanh(R)  
\approx  
N  
\left(  
atanh(\rho_0),  
\frac1{n-3}  
\right)  
$$

标准化：

$$  
Z=  
\frac{  
atanh(R)-atanh(\rho_0)  
}  
{1/\sqrt{n-3}}  
$$

展开：

$$  
Z=  
\sqrt{n-3}  
\left(  
atanh(R)-atanh(\rho_0)  
\right)  
$$

服从：

$$  
N(0,1)  
$$

---

特殊情况：

检验：

$$  
H_0:\rho=0  
$$

因为：

$$  
atanh(0)=0  
$$

所以：

$$  
Z=  
\sqrt{n-3}  
atanh(R)  
$$

---

# 和前面 t-test 的关系

这里其实有两个检验方法：

### 方法1：利用回归等价关系

因为：

$$  
\rho=0  
\iff  
\beta_1=0  
$$

所以：

使用：

$$  
T=  
\frac{R\sqrt{n-2}}  
{\sqrt{1-R^2}}  
$$

服从：

$$  
t(n-2)  
$$

---

### 方法2：直接研究相关系数

利用：

Fisher transformation：

$$  
Z=  
\sqrt{n-3}  
(atanh(R)-atanh(\rho_0))  
$$

服从：

$$  
N(0,1)  
$$

---

所以 page 9–13 的主线不是“介绍 Fisher z 公式”，而是：

$$  
R  
$$

