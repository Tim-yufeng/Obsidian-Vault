 

> 对应课件 Part III：Introduction to Linear Regression，第 26—30 章。

  

## 0. 回归问题在研究什么

  

回归的目标是描述响应变量 $Y$ 如何随一个或多个解释变量变化，并把这种关系用于估计、检验和预测。

  

最基本的直线模型是

  

$$

Y_i=\beta_0+\beta_1x_i+\varepsilon_i.

$$

  

其中：

  

- $x_i$ 是给定的解释变量取值；

- $\beta_0+\beta_1x_i$ 是 $Y_i$ 在 $x_i$ 条件下的总体均值；

- $\varepsilon_i$ 是无法由直线解释的随机波动；

- $\beta_0$ 是截距，$\beta_1$ 是斜率。

  

必须区分“条件均值”和“某个具体观测值”：

  

$$

E(Y_i\mid x_i)=\beta_0+\beta_1x_i,

$$

  

但实际观测还包含误差 $\varepsilon_i$。因此，即使平均关系确实是一条直线，同一个 $x$ 下的不同个体也不会给出完全相同的 $Y$。

  

回归描述的是变量之间的统计关系，不会自动证明因果关系。“回归到均值”也不等于某种干预造成了反向效果：一个极端观测之后通常出现较不极端的观测，可能只是随机波动的自然结果。

  

---

  

# 第 26 章 简单线性回归 I

  

## 1. 模型与基本假设

  

简单线性回归只有一个解释变量：

  

$$

Y_i=\beta_0+\beta_1x_i+\varepsilon_i,\qquad i=1,\ldots,n.

$$

  

标准推断建立在以下假设上：

  

1. 均值结构正确：

  

   $$

   E(Y_i\mid x_i)=\beta_0+\beta_1x_i.

   $$

  

2. 误差均值为零：

  

   $$

   E(\varepsilon_i)=0.

   $$

  

3. 所有误差具有相同方差：

  

   $$

   \operatorname{Var}(\varepsilon_i)=\sigma^2.

   $$

  

4. 不同观测的误差相互独立。

  

5. 若要进行小样本下的精确 $t$、$F$ 和 $\chi^2$ 推断，还假设

  

   $$

   \varepsilon_i\sim N(0,\sigma^2).

   $$

  

通常把 $x_i$ 看作预先给定且没有测量误差。模型中的随机性来自 $Y_i$，不是来自当前这组 $x_i$。

  

## 2. 最小二乘估计

  

对任意候选直线

  

$$

\widehat y_i=b_0+b_1x_i,

$$

  

第 $i$ 个残差为

  

$$

e_i=y_i-\widehat y_i=y_i-b_0-b_1x_i.

$$

  

最小二乘法选择 $b_0,b_1$，使残差平方和最小：

  

$$

\operatorname{SSE}=\sum_{i=1}^n e_i^2

=\sum_{i=1}^n(y_i-b_0-b_1x_i)^2.

$$

  

定义

  

$$

S_{xx}=\sum_{i=1}^n(x_i-\bar x)^2,

$$

  

$$

S_{yy}=\sum_{i=1}^n(y_i-\bar y)^2,

$$

  

$$

S_{xy}=\sum_{i=1}^n(x_i-\bar x)(y_i-\bar y).

$$

  

最小二乘估计为

  

$$

b_1=\frac{S_{xy}}{S_{xx}},

\qquad

b_0=\bar y-b_1\bar x.

$$

  

因此拟合直线一定经过样本中心点 $(\bar x,\bar y)$。

  

计算时也可使用

  

$$

S_{xx}=\sum x_i^2-\frac{\left(\sum x_i\right)^2}{n},

$$

  

$$

S_{yy}=\sum y_i^2-\frac{\left(\sum y_i\right)^2}{n},

$$

  

$$

S_{xy}=\sum x_iy_i-\frac{\left(\sum x_i\right)\left(\sum y_i\right)}{n}.

$$

  

残差平方和可简化为

  

$$

\operatorname{SSE}=S_{yy}-b_1S_{xy}.

$$

  

### 斜率与截距应如何解释

  

- $b_1$：$x$ 每增加一个单位时，$Y$ 的估计平均值改变 $b_1$ 个单位。

- $b_0$：在 $x=0$ 时，$Y$ 的估计平均值。

  

截距只有在 $x=0$ 具有实际意义且接近数据范围时才适合直接解释。若所有数据都远离零，截距主要用于定位直线，不一定有现实含义。

  

## 3. 参数估计量的分布

  

把样本变化前的随机估计量记为 $B_0,B_1$。在模型假设成立时，

  

$$

E(B_1)=\beta_1,

\qquad

\operatorname{Var}(B_1)=\frac{\sigma^2}{S_{xx}},

$$

  

$$

E(B_0)=\beta_0,

\qquad

\operatorname{Var}(B_0)

=\sigma^2\left(\frac{1}{n}+\frac{\bar x^2}{S_{xx}}\right).

$$

  

因此 $B_0$ 和 $B_1$ 都是无偏估计量。若误差正态，则

  

$$

\frac{B_1-\beta_1}{\sigma/\sqrt{S_{xx}}}\sim N(0,1),

$$

  

$$

\frac{B_0-\beta_0}

{\sigma\sqrt{1/n+\bar x^2/S_{xx}}}

\sim N(0,1).

$$

  

$S_{xx}$ 越大，斜率估计的方差越小。这说明解释变量不仅要有足够多的观测，还需要覆盖足够宽的范围。

  

## 4. 误差方差的估计

  

拟合直线估计了两个参数 $\beta_0,\beta_1$，所以误差自由度是 $n-2$：

  

$$

S^2=\frac{\operatorname{SSE}}{n-2},

\qquad

s=\sqrt{\frac{\operatorname{SSE}}{n-2}}.

$$

  

$S^2$ 是 $\sigma^2$ 的无偏估计。正态误差下，

  

$$

\frac{\operatorname{SSE}}{\sigma^2}\sim\chi^2_{n-2},

$$

  

并且 $\operatorname{SSE}$ 与 $B_0,B_1$ 独立。用 $S$ 替换未知的 $\sigma$ 后，标准化统计量服从 $t_{n-2}$ 分布：

  

$$

\frac{B_1-\beta_1}{S/\sqrt{S_{xx}}}\sim t_{n-2},

$$

  

$$

\frac{B_0-\beta_0}

{S\sqrt{1/n+\bar x^2/S_{xx}}}

\sim t_{n-2}.

$$

  

## 5. 回归系数的置信区间

  

$\beta_1$ 的 $100(1-\alpha)\%$ 置信区间为

  

$$

b_1\pm t_{\alpha/2,n-2}\frac{s}{\sqrt{S_{xx}}}.

$$

  

$\beta_0$ 的 $100(1-\alpha)\%$ 置信区间为

  

$$

b_0\pm t_{\alpha/2,n-2}

s\sqrt{\frac{1}{n}+\frac{\bar x^2}{S_{xx}}}.

$$

  

这里 $t_{\alpha/2,\nu}$ 表示 $t_\nu$ 分布的上侧 $\alpha/2$ 分位点，即

  

$$

P(T>t_{\alpha/2,\nu})=\frac{\alpha}{2}.

$$

  

## 6. 斜率的显著性检验

  

检验解释变量是否具有线性贡献，通常考察

  

$$

H_0:\beta_1=0

\qquad\text{对比}\qquad

H_a:\beta_1\ne 0.

$$

  

统计量为

  

$$

T=\frac{b_1}{s/\sqrt{S_{xx}}},

\qquad

T\sim t_{n-2}\quad\text{在 }H_0\text{ 下}.

$$

  

拒绝 $H_0$ 表示数据支持非零线性斜率。它不表示 $x$ 必然导致 $Y$ 改变，也不保证直线模型在整个实数范围内都合理。

  

双侧检验与斜率置信区间相互对应：显著性水平为 $\alpha$ 时，若 $\beta_1$ 的 $100(1-\alpha)\%$ 置信区间不包含零，则拒绝 $H_0:\beta_1=0$。

  

## 7. 给定 $x_0$ 时的平均响应

  

在 $x=x_0$ 时，总体平均响应是

  

$$

\mu_{Y\mid x_0}=\beta_0+\beta_1x_0.

$$

  

它的点估计为

  

$$

\widehat y(x_0)=b_0+b_1x_0.

$$

  

估计量的方差为

  

$$

\operatorname{Var}\!\left(\widehat Y(x_0)\right)

=\sigma^2\left[

\frac{1}{n}+\frac{(x_0-\bar x)^2}{S_{xx}}

\right].

$$

  

所以平均响应的置信区间为

  

$$

\widehat y(x_0)\pm t_{\alpha/2,n-2}s

\sqrt{

\frac{1}{n}+\frac{(x_0-\bar x)^2}{S_{xx}}

}.

$$

  

区间在 $x_0=\bar x$ 时最窄，离 $\bar x$ 越远越宽，因为在数据中心附近对直线位置最有把握。

  

---

  

# 第 27 章 简单线性回归 II

  

## 8. 平均响应区间与个体预测区间

  

这是简单线性回归中最容易混淆的两个区间。

  

### 8.1 平均响应的置信区间

  

目标是 $x_0$ 处所有同类个体的平均值：

  

$$

E(Y\mid x_0)=\beta_0+\beta_1x_0.

$$

  

其区间为

  

$$

\widehat y(x_0)\pm t_{\alpha/2,n-2}s

\sqrt{

\frac{1}{n}+\frac{(x_0-\bar x)^2}{S_{xx}}

}.

$$

  

### 8.2 单个未来观测的预测区间

  

若目标是在 $x_0$ 处预测一个新的具体响应

  

$$

Y_{\mathrm{new}}=\beta_0+\beta_1x_0+\varepsilon_{\mathrm{new}},

$$

  

除了拟合直线本身的不确定性，还必须加入新个体的随机误差：

  

$$

\operatorname{Var}\!\left(

Y_{\mathrm{new}}-\widehat Y(x_0)

\right)

=\sigma^2\left[

1+\frac{1}{n}+\frac{(x_0-\bar x)^2}{S_{xx}}

\right].

$$

  

因此预测区间为

  

$$

\widehat y(x_0)\pm t_{\alpha/2,n-2}s

\sqrt{

1+\frac{1}{n}+\frac{(x_0-\bar x)^2}{S_{xx}}

}.

$$

  

预测区间中的额外项 $1$ 代表单个新观测无法消除的个体波动，所以预测区间一定比同一点的平均响应置信区间宽。

  

## 9. 平方和分解与决定系数

  

总离差平方和为

  

$$

\operatorname{SST}

=\sum_{i=1}^n(y_i-\bar y)^2

=S_{yy}.

$$

  

回归平方和为

  

$$

\operatorname{SSR}

=\sum_{i=1}^n(\widehat y_i-\bar y)^2.

$$

  

误差平方和为

  

$$

\operatorname{SSE}

=\sum_{i=1}^n(y_i-\widehat y_i)^2.

$$

  

含截距的最小二乘模型满足

  

$$

\operatorname{SST}=\operatorname{SSR}+\operatorname{SSE}.

$$

  

决定系数为

  

$$

R^2=\frac{\operatorname{SSR}}{\operatorname{SST}}

=1-\frac{\operatorname{SSE}}{\operatorname{SST}}.

$$

  

$R^2$ 表示样本中 $Y$ 的总变异有多大比例被拟合模型解释。它不衡量因果性，也不能单独判断模型形式是否正确。

  

在含截距的简单线性回归中，

  

$$

R^2=\frac{S_{xy}^2}{S_{xx}S_{yy}}=r^2,

$$

  

其中

  

$$

r=\frac{S_{xy}}{\sqrt{S_{xx}S_{yy}}}

$$

  

是样本相关系数。因此 $R^2$ 不保留方向，方向要由 $r$ 或 $b_1$ 的符号判断。

  

## 10. 回归的方差分析与 $F$ 检验

  

简单线性回归的自由度分解为：

  

- 回归：$1$；

- 误差：$n-2$；

- 总计：$n-1$。

  

均方为

  

$$

\operatorname{MSR}=\frac{\operatorname{SSR}}{1}

=\operatorname{SSR},

$$

  

$$

\operatorname{MSE}=\frac{\operatorname{SSE}}{n-2}=s^2.

$$

  

检验 $H_0:\beta_1=0$ 的统计量为

  

$$

F=\frac{\operatorname{MSR}}{\operatorname{MSE}}

=\frac{\operatorname{SSR}}{\operatorname{SSE}/(n-2)}.

$$

  

在 $H_0$ 下，

  

$$

F\sim F_{1,n-2}.

$$

  

还可写为

  

$$

F=\frac{(n-2)R^2}{1-R^2}.

$$

  

在简单线性回归中，斜率的双侧 $t$ 检验与回归 $F$ 检验完全等价：

  

$$

F=T^2.

$$

  

## 11. 相关系数的检验

  

若 $(X,Y)$ 来自二元正态总体，要检验总体相关系数

  

$$

H_0:\rho=0,

$$

  

可使用

  

$$

T=\frac{r\sqrt{n-2}}{\sqrt{1-r^2}}

\sim t_{n-2}\quad\text{在 }H_0\text{ 下}.

$$

  

数值上，这与简单线性回归中检验 $\beta_1=0$ 的统计量相同，但两者的建模观点不同：

  

- 回归通常把 $x_i$ 看作给定值，研究 $Y\mid x$；

- 相关分析把 $X,Y$ 都看作随机变量，研究其线性关联。

  

## 12. 重复观测下的失拟检验

  

普通的显著斜率只说明直线比水平线好，不说明直线本身足够好。若某些 $x$ 值有重复观测，就可以把残差误差拆成“纯误差”和“失拟误差”。

  

设共有 $k$ 个不同的 $x$ 水平，总观测数为 $n$。第 $i$ 个水平有若干重复响应 $Y_{ij}$，该水平的样本均值为 $\bar Y_i$。

  

纯误差平方和为

  

$$

\operatorname{SSE}_{\mathrm{PE}}

=\sum_{i=1}^k\sum_j(Y_{ij}-\bar Y_i)^2,

$$

  

自由度为

  

$$

n-k.

$$

  

失拟平方和为

  

$$

\operatorname{SSE}_{\mathrm{LOF}}

=\operatorname{SSE}-\operatorname{SSE}_{\mathrm{PE}},

$$

  

自由度为

  

$$

k-2.

$$

  

检验统计量为

  

$$

F=

\frac{\operatorname{SSE}_{\mathrm{LOF}}/(k-2)}

{\operatorname{SSE}_{\mathrm{PE}}/(n-k)}

\sim F_{k-2,n-k}

$$

  

在“线性均值结构正确”的原假设下成立。显著结果表明，残差中存在超出随机重复误差的系统性结构，直线形式不合适。

  

## 13. 残差诊断

  

残差图用于检查模型假设，而不是只看 $R^2$。

  

### 残差对拟合值或 $x$ 的图

  

理想情况是在零线附近无规律、宽度大致恒定的随机带状分布。

  

- 弯曲趋势：均值关系可能不是直线；

- 漏斗形：方差可能随均值或 $x$ 改变；

- 孤立的大残差：可能存在异常观测；

- 随时间成串出现：误差可能不独立。

  

### 正态性检查

  

可使用残差的直方图、箱线图或正态概率图。明显偏斜、重尾或离群点会使小样本推断不可靠。

  

### 为什么必须画图

  

Anscombe 四重奏说明：几组数据可以具有几乎相同的 $\bar x,\bar y$、方差、相关系数、拟合直线和 $R^2$，但实际图形可能分别表现为线性、弯曲、单个异常点主导或高杠杆点主导。相同的数字摘要不代表相同的数据结构。

  

## 14. 外推

  

在观测到的 $x$ 范围内使用模型称为内插；超出该范围称为外推。即使样本范围内的直线拟合很好，范围外的真实关系也可能改变，因此外推结论缺少数据支持。

  

---

  

# 第 28 章 多元线性回归 I

  

## 15. 多元回归与多项式回归

  

含 $p$ 个解释变量的多元线性回归为

  

$$

Y_i=\beta_0+\beta_1x_{i1}+\cdots+\beta_px_{ip}+\varepsilon_i.

$$

  

一个解释变量的 $p$ 次多项式回归为

  

$$

Y_i=\beta_0+\beta_1x_i+\beta_2x_i^2+\cdots+\beta_px_i^p+\varepsilon_i.

$$

  

多项式回归仍然属于线性回归，因为“线性”指模型对未知参数 $\beta_0,\ldots,\beta_p$ 是线性的，并不要求均值关于原始变量 $x$ 是直线。

  

## 16. 矩阵表示

  

把所有观测写成

  

$$

\mathbf Y=\mathbf X\boldsymbol\beta+\boldsymbol\varepsilon,

$$

  

其中

  

$$

\mathbf Y=

\begin{bmatrix}

Y_1\\

\vdots\\

Y_n

\end{bmatrix},

\qquad

\boldsymbol\beta=

\begin{bmatrix}

\beta_0\\

\vdots\\

\beta_p

\end{bmatrix},

\qquad

\boldsymbol\varepsilon=

\begin{bmatrix}

\varepsilon_1\\

\vdots\\

\varepsilon_n

\end{bmatrix}.

$$

  

含截距时，设计矩阵第一列全为 $1$：

  

$$

\mathbf X=

\begin{bmatrix}

1&x_{11}&\cdots&x_{1p}\\

1&x_{21}&\cdots&x_{2p}\\

\vdots&\vdots&&\vdots\\

1&x_{n1}&\cdots&x_{np}

\end{bmatrix}.

$$

  

模型假设写为

  

$$

\boldsymbol\varepsilon\sim

N_n(\mathbf 0,\sigma^2\mathbf I).

$$

  

这同时表示误差均值为零、方差相同、彼此独立且服从正态分布。

  

## 17. 多元最小二乘估计

  

残差平方和为

  

$$

\operatorname{SSE}

=(\mathbf Y-\mathbf X\mathbf b)^{\mathsf T}

(\mathbf Y-\mathbf X\mathbf b).

$$

  

令其最小得到正规方程

  

$$

\mathbf X^{\mathsf T}\mathbf X\mathbf b

=\mathbf X^{\mathsf T}\mathbf Y.

$$

  

若 $\mathbf X$ 的各列线性无关，则

  

$$

\mathbf b=

(\mathbf X^{\mathsf T}\mathbf X)^{-1}

\mathbf X^{\mathsf T}\mathbf Y.

$$

  

这里的条件非常重要。若一列可以由其他列精确表示，例如同时放入全部类别指示变量和截距，则 $\mathbf X^{\mathsf T}\mathbf X$ 不可逆，参数无法被唯一估计。这称为完全共线性。

  

## 18. 多元回归系数的含义

  

在

  

$$

E(Y\mid x_1,\ldots,x_p)

=\beta_0+\beta_1x_1+\cdots+\beta_px_p

$$

  

中，$\beta_j$ 表示：在其他解释变量保持不变时，$x_j$ 每增加一个单位，响应的条件均值改变 $\beta_j$ 个单位。

  

“保持其他变量不变”是多元回归解释的核心。多元回归系数一般不等于只用 $x_j$ 做简单回归时的斜率，因为两个模型控制的背景变量不同。

  

## 19. 投影、拟合值与帽子矩阵

  

定义帽子矩阵

  

$$

\mathbf H=

\mathbf X(\mathbf X^{\mathsf T}\mathbf X)^{-1}

\mathbf X^{\mathsf T}.

$$

  

则

  

$$

\widehat{\mathbf Y}=\mathbf H\mathbf Y,

$$

  

$$

\mathbf e=\mathbf Y-\widehat{\mathbf Y}

=(\mathbf I-\mathbf H)\mathbf Y.

$$

  

$\mathbf H$ 把观测向量投影到 $\mathbf X$ 各列张成的空间，所以

  

$$

\mathbf H^{\mathsf T}=\mathbf H,

\qquad

\mathbf H^2=\mathbf H,

\qquad

\mathbf H\mathbf X=\mathbf X.

$$

  

最小二乘残差与设计矩阵的每一列正交：

  

$$

\mathbf X^{\mathsf T}\mathbf e=\mathbf 0.

$$

  

若模型含截距，设计矩阵中包含全 $1$ 列，因此

  

$$

\sum_{i=1}^n e_i=0.

$$

  

这也是平方和能够正交分解的原因。

  

## 20. 多元回归的平方和分解

  

含截距时仍有

  

$$

\operatorname{SST}

=\sum_{i=1}^n(y_i-\bar y)^2,

$$

  

$$

\operatorname{SSR}

=\sum_{i=1}^n(\widehat y_i-\bar y)^2,

$$

  

$$

\operatorname{SSE}

=\sum_{i=1}^n(y_i-\widehat y_i)^2,

$$

  

以及

  

$$

\operatorname{SST}=\operatorname{SSR}+\operatorname{SSE}.

$$

  

因此

  

$$

R^2=1-\frac{\operatorname{SSE}}{\operatorname{SST}}.

$$

  

加入解释变量不会增大最小化后的 $\operatorname{SSE}$，所以普通 $R^2$ 不会下降。这正是不能仅凭最大 $R^2$ 选择模型的原因。

  

---

  

# 第 29 章 多元线性回归 II

  

## 21. 误差方差与自由度

  

若模型含截距和 $p$ 个非截距项，共估计 $p+1$ 个系数，误差自由度为

  

$$

n-p-1.

$$

  

误差方差估计为

  

$$

S^2=\frac{\operatorname{SSE}}{n-p-1}.

$$

  

正态模型下，

  

$$

\frac{\operatorname{SSE}}{\sigma^2}

\sim\chi^2_{n-p-1}.

$$

  

回归平方和也可计算为

  

$$

\operatorname{SSR}

=\mathbf b^{\mathsf T}\mathbf X^{\mathsf T}\mathbf y

-\frac{\left(\sum_{i=1}^ny_i\right)^2}{n}.

$$

  

## 22. 总体回归显著性检验

  

总体 $F$ 检验考察所有非截距项是否共同无效：

  

$$

H_0:\beta_1=\cdots=\beta_p=0.

$$

  

对立假设是至少一个斜率不为零。统计量为

  

$$

F=

\frac{\operatorname{SSR}/p}

{\operatorname{SSE}/(n-p-1)}

\sim F_{p,n-p-1}

$$

  

在 $H_0$ 下成立。利用 $R^2$ 也可写成

  

$$

F=

\frac{n-p-1}{p}

\frac{R^2}{1-R^2}.

$$

  

总体 $F$ 显著只说明解释变量整体上提供了信息，不说明每个变量都显著，也不说明模型形式没有问题。

  

## 23. 各回归系数的分布、区间与检验

  

最小二乘估计满足

  

$$

E(\mathbf b)=\boldsymbol\beta,

$$

  

$$

\operatorname{Var}(\mathbf b)

=\sigma^2(\mathbf X^{\mathsf T}\mathbf X)^{-1}.

$$

  

令

  

$$

\mathbf C=(\mathbf X^{\mathsf T}\mathbf X)^{-1},

$$

  

并以 $c_{jj}$ 表示与 $b_j$ 对应的对角元素，则

  

$$

\operatorname{Var}(B_j)=\sigma^2c_{jj}.

$$

  

$\beta_j$ 的置信区间为

  

$$

b_j\pm t_{\alpha/2,n-p-1}s\sqrt{c_{jj}}.

$$

  

检验

  

$$

H_0:\beta_j=0

$$

  

时使用

  

$$

T=\frac{b_j}{s\sqrt{c_{jj}}}

\sim t_{n-p-1}

$$

  

在 $H_0$ 下成立。

  

单个系数不显著而总体 $F$ 显著并不矛盾。若解释变量彼此高度相关，它们共同解释 $Y$ 的能力可能很强，但很难把贡献稳定地分配给某一个变量，导致单个系数标准误较大。

  

## 24. 多元模型中的平均响应与个体预测

  

把新输入写成包含截距项的列向量

  

$$

\mathbf x_0=

\begin{bmatrix}

1\\

x_{01}\\

\vdots\\

x_{0p}

\end{bmatrix}.

$$

  

平均响应为

  

$$

E(Y\mid\mathbf x_0)

=\mathbf x_0^{\mathsf T}\boldsymbol\beta,

$$

  

点估计为

  

$$

\widehat y(\mathbf x_0)

=\mathbf x_0^{\mathsf T}\mathbf b.

$$

  

令

  

$$

h_0=

\mathbf x_0^{\mathsf T}

(\mathbf X^{\mathsf T}\mathbf X)^{-1}

\mathbf x_0.

$$

  

平均响应估计量的方差为 $\sigma^2h_0$，所以其置信区间为

  

$$

\widehat y(\mathbf x_0)

\pm t_{\alpha/2,n-p-1}s\sqrt{h_0}.

$$

  

单个未来观测的预测区间为

  

$$

\widehat y(\mathbf x_0)

\pm t_{\alpha/2,n-p-1}s\sqrt{1+h_0}.

$$

  

两者的区别仍然是预测区间多出的 $1$，它代表新观测自身的随机误差。

  

## 25. 嵌套模型与部分 $F$ 检验

  

设完整模型含 $p$ 个非截距项，约简模型只保留其中 $m$ 个，且约简模型可以通过令完整模型的 $p-m$ 个系数为零得到。记两者的残差平方和为

  

$$

\operatorname{SSE}_{\mathrm F}

\quad\text{和}\quad

\operatorname{SSE}_{\mathrm R}.

$$

  

因为完整模型包含更多项，

  

$$

\operatorname{SSE}_{\mathrm F}

\leq

\operatorname{SSE}_{\mathrm R}.

$$

  

部分 $F$ 统计量为

  

$$

F=

\frac{

\left(\operatorname{SSE}_{\mathrm R}

-\operatorname{SSE}_{\mathrm F}\right)/(p-m)

}{

\operatorname{SSE}_{\mathrm F}/(n-p-1)

}.

$$

  

在被删去的 $p-m$ 个系数全部为零时，

  

$$

F\sim F_{p-m,n-p-1}.

$$

  

它回答的问题是：在已经保留约简模型中各项的条件下，新加入的这一组项是否带来显著的额外解释能力。

  

几个重要特例：

  

- 把完整模型与只有截距的模型比较，就得到总体 $F$ 检验；

- 一次只检验一个系数时，部分 $F$ 与相应双侧 $t$ 检验满足

  

  $$

  F=T^2.

  $$

  

若已知两个嵌套模型的 $R^2$，也可写成

  

$$

F=

\frac{

\left(R_{\mathrm F}^2-R_{\mathrm R}^2\right)/(p-m)

}{

\left(1-R_{\mathrm F}^2\right)/(n-p-1)

}.

$$

  

---

  

# 第 30 章 指示变量、交互作用与模型选择

  

## 26. 类别解释变量

  

若解释变量只有两个类别，可用一个 $0$—$1$ 指示变量表示。例如

  

$$

x_2=

\begin{cases}

1,&\text{品牌 A},\\

0,&\text{品牌 B}.

\end{cases}

$$

  

模型

  

$$

E(Y\mid x_1,x_2)

=\beta_0+\beta_1x_1+\beta_2x_2

$$

  

可分别写成：

  

品牌 B，即 $x_2=0$：

  

$$

E(Y\mid x_1,\text{B})

=\beta_0+\beta_1x_1.

$$

  

品牌 A，即 $x_2=1$：

  

$$

E(Y\mid x_1,\text{A})

=(\beta_0+\beta_2)+\beta_1x_1.

$$

  

因此：

  

- $\beta_0$ 是基准类别 B 的截距；

- $\beta_1$ 是两类共同的斜率；

- $\beta_2$ 是在相同 $x_1$ 下，A 相对 B 的平均响应差。

  

检验 $H_0:\beta_2=0$ 就是在控制 $x_1$ 后检验两个类别是否存在恒定的均值差。

  

若类别变量有 $L$ 个水平并且模型含截距，只使用 $L-1$ 个指示变量。被省略的类别是基准类别。若同时使用 $L$ 个类别指示变量和截距，各列之和恰好等于截距列，会产生完全共线性。

  

## 27. 交互作用

  

上一个模型强迫两类具有相同斜率。若类别可能改变连续变量的作用，应加入交互项：

  

$$

E(Y\mid x_1,x_2)

=\beta_0+\beta_1x_1+\beta_2x_2+\beta_3x_1x_2.

$$

  

基准类别 $x_2=0$：

  

$$

E(Y\mid x_1,x_2=0)

=\beta_0+\beta_1x_1.

$$

  

另一类别 $x_2=1$：

  

$$

E(Y\mid x_1,x_2=1)

=(\beta_0+\beta_2)+(\beta_1+\beta_3)x_1.

$$

  

所以：

  

- $\beta_2$ 是两类在 $x_1=0$ 时的截距差；

- $\beta_3$ 是两类斜率之差；

- 检验 $H_0:\beta_3=0$ 就是在检验两类是否可以使用共同斜率。

  

加入交互后，主效应的含义必须在另一变量取零时解释。例如 $\beta_2$ 不再是所有 $x_1$ 下恒定的类别差，因为类别差为

  

$$

\beta_2+\beta_3x_1.

$$

  

## 28. 为什么不能靠普通 $R^2$ 选模型

  

加入更多解释项后，完整模型至少可以把新增系数设为零，从而复制旧模型。因此

  

$$

\operatorname{SSE}_{\mathrm{new}}

\leq

\operatorname{SSE}_{\mathrm{old}},

$$

  

普通 $R^2$ 只会增加或保持不变。

  

但新增无用变量会消耗自由度，使

  

$$

s^2=\frac{\operatorname{SSE}}{n-p-1}

$$

  

不一定下降，系数和预测的不确定性也可能增加。模型若开始拟合样本中的偶然噪声，就会出现过拟合：训练数据拟合很好，新数据表现却变差。

  

## 29. 前向、后向与逐步选择

  

### 前向选择

  

从较小模型开始，每一步加入当前带来最大改进且满足进入标准的变量，直到没有变量值得加入。

  

### 后向消除

  

从完整候选模型开始，每一步删除当前最不重要且满足删除标准的变量，直到剩余变量都达到保留标准。

  

### 逐步选择

  

在前向加入的同时，重新检查已进入模型的变量是否仍应保留；变量可能进入后又被删除。

  

这些方法计算方便，但结果是数据驱动的。反复在同一数据上尝试和检验许多模型会带来以下问题：

  

- 至少一次偶然显著的概率上升；

- 选中模型的 $R^2$ 和效应大小容易偏高；

- 忽略选择过程后，常规置信区间容易过窄；

- 相近数据可能选出不同模型；

- 选择结果未必符合研究背景或变量层级关系。

  

若每次独立检验发生误拒绝的概率是 $p_0$，进行 $N$ 次检验时至少一次误拒绝的概率为

  

$$

1-(1-p_0)^N.

$$

  

因此检验次数增加时，偶然发现“显著变量”的机会也会增加。

  

## 30. 预测残差平方和

  

预测残差平方和使用留一法评估样本外预测能力。对每个观测 $i$：

  

1. 删除第 $i$ 个观测；

2. 用其余 $n-1$ 个观测重新拟合模型；

3. 得到对被删除响应的预测 $\widehat y_{(i)}$；

4. 计算留一预测误差 $y_i-\widehat y_{(i)}$。

  

定义

  

$$

\operatorname{PRESS}

=\sum_{i=1}^n

\left(y_i-\widehat y_{(i)}\right)^2.

$$

  

在同一数据和同一响应尺度下比较候选模型时，较小的 $\operatorname{PRESS}$ 通常表示更好的留一预测表现。它关注的是对未参与当前拟合的观测进行预测，因此比训练集上的 $\operatorname{SSE}$ 更能暴露过拟合。

  

---

  

# 31. 全部内容之间的联系

  

第 26—30 章可以归纳为同一个框架：

  

1. 先指定条件均值模型

  

   $$

   E(\mathbf Y\mid\mathbf X)=\mathbf X\boldsymbol\beta.

   $$

  

2. 用最小二乘求

  

   $$

   \mathbf b=

   (\mathbf X^{\mathsf T}\mathbf X)^{-1}

   \mathbf X^{\mathsf T}\mathbf y.

   $$

  

3. 用残差估计无法解释的波动

  

   $$

   s^2=\frac{\operatorname{SSE}}{n-p-1}.

   $$

  

4. 对单个系数使用 $t$ 推断，对一组系数使用部分 $F$ 检验，对全部斜率使用总体 $F$ 检验。

  

5. 估计平均响应时使用模型均值的不确定性；预测单个新观测时再加入一份不可约的个体误差。

  

6. 最后用残差图、失拟检验和样本外预测指标检查模型是否真正适合数据。显著性、较高的 $R^2$ 与正确的模型形式是三件不同的事。