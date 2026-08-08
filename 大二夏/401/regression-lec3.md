# Analysis of Variance（ANOVA，方差分析）

  

> 本节包括两个相互对应的主题：

>

> 1. 用单因素固定效应 ANOVA 比较多个总体均值；

> 2. 用同一套平方和分解理解简单线性回归的 $F$ 检验、$t$ 检验与 $R^2$。

  

# 一、为什么需要 ANOVA

  

若只有两个正态总体，比较均值可用共同方差的两样本 $t$ 检验；不假定方差相等时，可用 Welch--Satterthwaite 方法。

  

若有 $k>2$ 个总体，目标是检验

  

$$

H_0:\mu_1=\mu_2=\cdots=\mu_k.

$$

  

对立假设为

  

$$

H_a:\mu_i\ne\mu_j

\quad\text{对至少一对 }i\ne j\text{ 成立}.

$$

  

拒绝 $H_0$ 只说明并非所有总体均值都相同，不能直接指出哪几组不同。

  

若对所有组逐对做 $t$ 检验，需要进行

  

$$

\binom{k}{2}

$$

  

次比较。比较次数增加会累积第一类错误概率。因此，ANOVA 先以一个总体 $F$ 检验判断是否存在任何均值差异。

  

# 二、单因素固定效应模型

  

## 1. 基本术语

  

- 响应变量：实际测量的输出，记为 $Y$。

- 因素：可能影响响应变量的分类输入。

- 因素水平：因素的不同类别。

- 处理：单因素 ANOVA 中，通常与一个因素水平对应。

- 固定效应：研究的水平由实验者或研究问题明确指定，结论直接针对这些水平。

  

例如煤层含硫量问题中：

  

- 因素是煤层；

- 有五个因素水平；

- 响应变量是煤样中的含硫百分比；

- 五个煤层是固定的研究对象。

  

## 2. 数据记号

  

设共有 $k$ 个处理。第 $i$ 个处理下有 $n_i$ 个观测：

  

$$

Y_{i1},Y_{i2},\ldots,Y_{in_i}.

$$

  

其中

  

$$

i=1,\ldots,k,

\qquad

j=1,\ldots,n_i.

$$

  

总样本量为

  

$$

N=\sum_{i=1}^k n_i.

$$

  

第 $i$ 组的总和与均值为

  

$$

T_{i\cdot}=\sum_{j=1}^{n_i}Y_{ij},

$$

  

$$

\bar Y_{i\cdot}

=\frac{T_{i\cdot}}{n_i}

=\frac{1}{n_i}\sum_{j=1}^{n_i}Y_{ij}.

$$

  

所有观测的总和与总均值为

  

$$

T_{\cdot\cdot}

=\sum_{i=1}^kT_{i\cdot}

=\sum_{i=1}^k\sum_{j=1}^{n_i}Y_{ij},

$$

  

$$

\bar Y_{\cdot\cdot}

=\frac{T_{\cdot\cdot}}{N}.

$$

  

$\bar Y_{i\cdot}$ 是第 $i$ 组均值；$\bar Y_{\cdot\cdot}$ 是把全部数据合并后的总均值。

  

## 3. 模型、效应与假设

  

第 $i$ 组第 $j$ 个观测写为

  

$$

Y_{ij}=\mu_i+E_{ij}.

$$

  

其中 $\mu_i$ 是第 $i$ 个总体均值。

  

定义加权总体均值和处理效应：

  

$$

\mu=\frac{1}{N}\sum_{i=1}^k n_i\mu_i,

$$

  

$$

\alpha_i=\mu_i-\mu.

$$

  

于是

  

$$

\mu_i=\mu+\alpha_i,

$$

  

$$

Y_{ij}=\mu+\alpha_i+E_{ij}.

$$

  

并且

  

$$

\sum_{i=1}^k n_i\alpha_i=0.

$$

  

若各组样本量相同，该约束可简化为

  

$$

\sum_{i=1}^k\alpha_i=0.

$$

  

均值相同的原假设等价于

  

$$

H_0:\alpha_1=\alpha_2=\cdots=\alpha_k=0.

$$

  

标准的一元 ANOVA 假设为

  

$$

E_{ij}\overset{\mathrm{ind}}{\sim}N(0,\sigma^2).

$$

  

这同时表示观测独立、各组正态、各组具有相同误差方差。因此

  

$$

Y_{ij}\sim N(\mu_i,\sigma^2),

$$

  

$$

\operatorname{Var}(Y_{ij})=\sigma^2.

$$

  

# 三、最小二乘估计与偏差分解

  

处理均值的最小二乘估计是

  

$$

\widehat\mu_i=\bar Y_{i\cdot}.

$$

  

因此

  

$$

\widehat\mu=\bar Y_{\cdot\cdot},

$$

  

$$

\widehat\alpha_i

=\bar Y_{i\cdot}-\bar Y_{\cdot\cdot}.

$$

  

第 $i$ 组的拟合值为

  

$$

\widehat Y_{ij}

=\widehat\mu+\widehat\alpha_i

=\bar Y_{i\cdot}.

$$

  

残差为

  

$$

e_{ij}

=Y_{ij}-\widehat Y_{ij}

=Y_{ij}-\bar Y_{i\cdot}.

$$

  

所以每一个观测均可写成

  

$$

Y_{ij}

=

\bar Y_{\cdot\cdot}

+

\left(

\bar Y_{i\cdot}-\bar Y_{\cdot\cdot}

\right)

+

\left(

Y_{ij}-\bar Y_{i\cdot}

\right).

$$

  

这三项依次表示总均值、处理效应和残差。

  

两边减去总均值：

  

$$

Y_{ij}-\bar Y_{\cdot\cdot}

=

\left(

\bar Y_{i\cdot}-\bar Y_{\cdot\cdot}

\right)

+

\left(

Y_{ij}-\bar Y_{i\cdot}

\right).

$$

  

左边是观测相对总均值的总偏差；右边依次是组间偏差和组内偏差。

  

# 四、平方和分解

  

定义总平方和：

  

$$

SS_{\mathrm{Tot}}

=

\sum_{i=1}^k\sum_{j=1}^{n_i}

\left(

Y_{ij}-\bar Y_{\cdot\cdot}

\right)^2.

$$

  

定义处理平方和：

  

$$

SS_{\mathrm{Tr}}

=

\sum_{i=1}^k n_i

\left(

\bar Y_{i\cdot}-\bar Y_{\cdot\cdot}

\right)^2.

$$

  

定义误差平方和：

  

$$

SS_E

=

\sum_{i=1}^k\sum_{j=1}^{n_i}

\left(

Y_{ij}-\bar Y_{i\cdot}

\right)^2.

$$

  

由于每一组内

  

$$

\sum_{j=1}^{n_i}

\left(

Y_{ij}-\bar Y_{i\cdot}

\right)=0,

$$

  

平方展开中的交叉项为零。因此有基本恒等式：

  

$$

SS_{\mathrm{Tot}}=SS_{\mathrm{Tr}}+SS_E.

$$

  

三者的含义是：

  

- $SS_{\mathrm{Tot}}$：所有观测围绕总均值的总变异；

- $SS_{\mathrm{Tr}}$：各组均值不同所对应的组间变异；

- $SS_E$：同一组内部围绕本组均值的随机变异。

  

这与条件方差分解的思想相同：

  

$$

\operatorname{Var}(Y)

=

E[\operatorname{Var}(Y\mid X)]

+

\operatorname{Var}(E[Y\mid X]).

$$

  

在 ANOVA 中，$SS_E$ 对应组内条件变异，$SS_{\mathrm{Tr}}$ 对应不同条件均值之间的变异。

  

# 五、自由度、均方与 ANOVA 的 $F$ 检验

  

平方和对应的自由度为

  

$$

\operatorname{df}_{\mathrm{Tot}}=N-1,

$$

  

$$

\operatorname{df}_{\mathrm{Tr}}=k-1,

$$

  

$$

\operatorname{df}_E=N-k.

$$

  

其中：

  

- 总自由度为 $N-1$，因为使用一个总均值；

- 处理自由度为 $k-1$，因为 $k$ 个组均值相对总均值的偏差有一个约束；

- 误差自由度为 $N-k$，因为估计了 $k$ 个组均值。

  

它们满足

  

$$

N-1=(k-1)+(N-k).

$$

  

由于处理与误差平方和的自由度不同，不能直接比较它们。定义均方：

  

$$

MS_{\mathrm{Tr}}

=\frac{SS_{\mathrm{Tr}}}{k-1},

$$

  

$$

MS_E=\frac{SS_E}{N-k}.

$$

  

误差均方是共同方差的无偏估计：

  

$$

E(MS_E)=\sigma^2.

$$

  

固定效应模型下，

  

$$

E(MS_{\mathrm{Tr}})

=

\sigma^2+

\frac{\sum_{i=1}^k n_i\alpha_i^2}{k-1}.

$$

  

因此：

  

- 在 $H_0$ 下，所有 $\alpha_i=0$，两个均方都估计 $\sigma^2$；

- 在 $H_a$ 下，处理均方通常因真实均值差异而变大。

  

检验统计量为

  

$$

F

=

\frac{MS_{\mathrm{Tr}}}{MS_E}

=

\frac{SS_{\mathrm{Tr}}/(k-1)}{SS_E/(N-k)}.

$$

  

在 $H_0$ 下，

  

$$

F\sim F_{k-1,N-k}.

$$

  

当观测到的 $F$ 很大时，组均值之间的分离程度超过正常组内随机波动，故拒绝所有均值相同的原假设。

  

右尾拒绝规则为

  

$$

F_{\mathrm{obs}}>F_{\alpha;k-1,N-k}.

$$

  

等价地，若 $p$ 值小于 $\alpha$，则拒绝 $H_0$。

  

# 六、手算平方和的快捷公式

  

直接按偏差定义计算时，可使用

  

$$

SS_{\mathrm{Tot}}

=

\sum_{i=1}^k\sum_{j=1}^{n_i}Y_{ij}^2

-\frac{T_{\cdot\cdot}^2}{N},

$$

  

$$

SS_{\mathrm{Tr}}

=

\sum_{i=1}^k\frac{T_{i\cdot}^2}{n_i}

-\frac{T_{\cdot\cdot}^2}{N},

$$

  

$$

SS_E=SS_{\mathrm{Tot}}-SS_{\mathrm{Tr}}.

$$

  

标准 ANOVA 输出包含：

  

- 处理行：自由度 $k-1$、平方和 $SS_{\mathrm{Tr}}$、均方 $MS_{\mathrm{Tr}}$；

- 误差行：自由度 $N-k$、平方和 $SS_E$、均方 $MS_E$；

- 总计行：自由度 $N-1$、平方和 $SS_{\mathrm{Tot}}$；

- 检验统计量：

  

  $$

  F=\frac{MS_{\mathrm{Tr}}}{MS_E}.

  $$

  

# 七、煤层硫含量例子

  

五个煤层的样本量为

  

$$

n_1=7,

\qquad

n_2=8,

\qquad

n_3=9,

\qquad

n_4=8,

\qquad

n_5=10.

$$

  

因此

  

$$

k=5,

\qquad

N=42.

$$

  

各组总和为

  

$$

T_{1\cdot}=11.62,

\qquad

T_{2\cdot}=9.36,

\qquad

T_{3\cdot}=13.14,

$$

  

$$

T_{4\cdot}=7.04,

\qquad

T_{5\cdot}=8.80,

\qquad

T_{\cdot\cdot}=49.96.

$$

  

并且

  

$$

\sum_{i=1}^5\sum_{j=1}^{n_i}Y_{ij}^2=67.861.

$$

  

总平方和为

  

$$

SS_{\mathrm{Tot}}

=

67.861-\frac{49.96^2}{42}

=

8.43239.

$$

  

处理平方和为

  

$$

SS_{\mathrm{Tr}}

=

\frac{11.62^2}{7}

+\frac{9.36^2}{8}

+\frac{13.14^2}{9}

+\frac{7.04^2}{8}

+\frac{8.80^2}{10}

-\frac{49.96^2}{42}

=

3.93539.

$$

  

误差平方和为

  

$$

SS_E=8.43239-3.93539=4.49700.

$$

  

自由度与均方为

  

$$

\operatorname{df}_{\mathrm{Tr}}=4,

\qquad

MS_{\mathrm{Tr}}

=\frac{3.93539}{4}

=0.983848,

$$

  

$$

\operatorname{df}_E=37,

\qquad

MS_E

=\frac{4.49700}{37}

=0.121541.

$$

  

因此

  

$$

F

=

\frac{0.983848}{0.121541}

=

8.09481.

$$

  

在显著性水平 $\alpha=0.05$ 下，

  

$$

F_{0.05;4,37}\approx2.626.

$$

  

因为

  

$$

8.09481>2.626,

$$

  

拒绝

  

$$

H_0:\mu_1=\mu_2=\mu_3=\mu_4=\mu_5.

$$

  

结论是：有统计证据表明五个煤层的平均含硫量并非全部相同，至少存在一对煤层的平均含硫量不同。总体 ANOVA 本身不告诉我们具体是哪一对不同。

  

# 八、回归的 ANOVA 分解

  

简单线性回归模型为

  

$$

Y_i=\beta_0+\beta_1x_i+\varepsilon_i.

$$

  

拟合值为

  

$$

\widehat Y_i=b_0+b_1x_i.

$$

  

由于回归线经过 $(\bar x,\bar y)$，

  

$$

\widehat Y_i-\bar Y

=

b_1(x_i-\bar x).

$$

  

对每个观测，

  

$$

Y_i-\bar Y

=

(\widehat Y_i-\bar Y)

+

(Y_i-\widehat Y_i).

$$

  

最小二乘的正交性质使平方和分解为

  

$$

SS_T=SS_R+SS_E,

$$

  

其中

  

$$

SS_T

=

\sum_{i=1}^n(Y_i-\bar Y)^2

=

S_{yy},

$$

  

$$

SS_R

=

\sum_{i=1}^n(\widehat Y_i-\bar Y)^2

=

b_1^2S_{xx},

$$

  

$$

SS_E

=

\sum_{i=1}^n(Y_i-\widehat Y_i)^2.

$$

  

又因为

  

$$

b_1=\frac{S_{xy}}{S_{xx}},

$$

  

所以

  

$$

SS_R=b_1S_{xy},

$$

  

$$

SS_E=S_{yy}-b_1S_{xy}.

$$

  

回归平方和表示加入 $x$ 后，相比只用 $\bar Y$ 预测所减少的平方误差；误差平方和表示直线拟合后仍无法解释的变异。

  

# 九、回归显著性的 $F$ 检验

  

简单线性回归中，回归自由度为 $1$，误差自由度为 $n-2$：

  

$$

MS_R=SS_R,

$$

  

$$

MS_E=\frac{SS_E}{n-2}.

$$

  

检验

  

$$

H_0:\beta_1=0

$$

  

时，使用

  

$$

F

=

\frac{MS_R}{MS_E}

=

\frac{SS_R/1}{SS_E/(n-2)}.

$$

  

在 $H_0$ 下，

  

$$

F\sim F_{1,n-2}.

$$

  

$H_0:\beta_1=0$ 表示条件均值不随 $x$ 线性变化，加入 $x$ 后不应带来超过随机误差水平的系统性平方和减少。大的 $F$ 值说明回归解释的变异相对于残差变异很大。

  

斜率 $t$ 统计量为

  

$$

T=

\frac{b_1}{s/\sqrt{S_{xx}}},

\qquad

s^2=MS_E.

$$

  

平方后，

  

$$

T^2

=

\frac{b_1^2S_{xx}}{MS_E}

=

\frac{SS_R}{MS_E}

=

F.

$$

  

因此，简单线性回归中的回归 $F$ 检验与斜率的双侧 $t$ 检验完全等价：

  

$$

F=T^2.

$$

  

$t$ 保留斜率的正负方向；$F$ 始终非负，只进行右尾检验。

  

# 十、决定系数 $R^2$

  

定义

  

$$

R^2=\frac{SS_R}{SS_T}.

$$

  

由平方和分解，

  

$$

R^2

=

1-\frac{SS_E}{SS_T}.

$$

  

并且

  

$$

0\leq R^2\leq1.

$$

  

$R^2$ 表示回归模型解释的样本总变异比例。在线性回归含截距时，

  

$$

R^2=r^2,

$$

  

其中 $r$ 是样本 Pearson 相关系数。

  

应注意：

  

- $R^2$ 不表示斜率的大小；改变变量单位会改变斜率，但通常不会改变 $R^2$。

- $R^2$ 高不保证真实均值关系一定是直线；仍须检查散点图、残差图和失拟。

- $R^2$ 高不保证外推预测可靠；预测不确定性还取决于残差方差、样本量与预测点的位置。