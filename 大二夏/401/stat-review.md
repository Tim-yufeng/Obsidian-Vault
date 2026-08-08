## 0. 记号与分位数约定

- $X_1,\ldots,X_n$ / $x_1,\ldots,x_n$：抽样前的随机样本 / 已观测数据。

- $\bar X,\bar x$：样本均值 / 样本均值的观测值。

- $S^2,s^2$：样本方差 / 样本方差的观测值。

- $\hat\theta$：总体参数 $\theta$ 的估计量。

- $\alpha,\beta,1-\beta$：第一类错误率、第二类错误率、检验功效。

本笔记采用右尾分位数记号：

$$

P(Z>z_\alpha)=\alpha,\qquad P(T_\nu>t_{\alpha,\nu})=\alpha,\qquad

P(\chi^2_\nu>\chi^2_{\alpha,\nu})=\alpha.

$$

## 1. 随机样本、统计量与点估计

### 随机样本与统计量

- 随机样本要求 $X_1,\ldots,X_n$ 相互独立，且每个 $X_i$ 与总体变量 $X$ 同分布。

- 统计量是样本的函数，不能包含未知参数。例如 $\bar X,S^2,\max X_i$ 是统计量；$X_1-\mu$ 不是统计量。

- 样本中位数：先将观测值排序为 $x_{(1)}\le\cdots\le x_{(n)}$。$n$ 为奇数时取 $x_{((n+1)/2)}$；$n$ 为偶数时取两个中间值的平均。

### 样本均值与样本方差

$$

\bar X=\frac{1}{n}\sum_{i=1}^nX_i,\qquad

S^2=\frac{1}{n-1}\sum_{i=1}^n(X_i-\bar X)^2

=\frac{n\sum X_i^2-(\sum X_i)^2}{n(n-1)},\qquad S=\sqrt{S^2}.

$$

若总体均值为 $\mu$、方差为 $\sigma^2$，则

$$

E(\bar X)=\mu,\qquad Var(\bar X)=\frac{\sigma^2}{n},\qquad

SE(\bar X)=\frac{\sigma}{\sqrt n},\qquad E(S^2)=\sigma^2.

$$

$S^2$ 是 $\sigma^2$ 的无偏估计量；$S$ 一般不是 $\sigma$ 的无偏估计量。

### 无偏估计、矩估计与最大似然估计

- 无偏性：$E(\hat\theta)=\theta$。若 $\sum_i a_i=1$，则 $\sum_i a_iX_i$ 无偏估计 $\mu$；估计量的方差也决定其稳定性。

- 矩估计：若有 $k$ 个未知参数，以前 $k$ 个样本矩替代理论矩：

$$

M_j=\frac1n\sum_{i=1}^nX_i^j=E(X^j),\qquad j=1,\ldots,k.

$$

- 最大似然估计：对于密度或概率函数 $f(x;\theta)$，

$$

L(\theta)=\prod_{i=1}^nf(x_i;\theta),\qquad \ell(\theta)=\log L(\theta).

$$

通过最大化 $\ell(\theta)$ 求 $\hat\theta$；内部解通常满足 $\partial\ell/\partial\theta=0$。

常用结论：
$$

X\sim Poisson(\lambda):\ \hat\lambda_{MLE}=\bar X;

\qquad

X\sim N(\mu,\sigma^2):\ \hat\mu_{MLE}=\bar X,\qquad

\widehat{\sigma^2}_{MLE}=\frac1n\sum(X_i-\bar X)^2.

$$

正态总体方差的 MLE 分母为 $n$；无偏样本方差的分母为 $n-1$。

## 2. 置信区间

$100(1-\alpha)\%$ 置信区间是一个覆盖率为 $1-\alpha$ 的构造方法：反复抽样时，该方法构造的区间约有 $1-\alpha$ 覆盖真参数。

- 推断未知的 $\mu$，总体标准差 $\sigma$ 已知：正态总体或大样本时，区间为 $\bar x\pm z_{\alpha/2}\sigma/\sqrt n$。

- 推断未知的 $\mu$，总体标准差 $\sigma$ 未知：正态总体时，区间为 $\bar x\pm t_{\alpha/2,n-1}s/\sqrt n$。

- $\sigma^2$：正态总体时，区间为 $\left[\frac{(n-1)s^2}{\chi^2_{\alpha/2,n-1}},\frac{(n-1)s^2}{\chi^2_{1-\alpha/2,n-1}}\right]$。

- $\sigma$：先求 $\sigma^2$ 的区间，再对两个端点开根号。

- 单一比例 $p$：当 $n\hat p,n(1-\hat p)$ 均足够大时，区间为 $\hat p\pm z_{\alpha/2}\sqrt{\hat p(1-\hat p)/n}$。

- 两独立比例差 $p_1-p_2$：两组均为大样本时，区间为 $(\hat p_1-\hat p_2)\pm z_{\alpha/2}\sqrt{\hat p_1(1-\hat p_1)/n_1+\hat p_2(1-\hat p_2)/n_2}$。

对于两个独立均值：若方差相等，使用

$$

s_p^2=\frac{(n_1-1)s_1^2+(n_2-1)s_2^2}{n_1+n_2-2},

$$
$$

(\bar x_1-\bar x_2)\pm t_{\alpha/2,n_1+n_2-2}s_p\sqrt{\frac1{n_1}+\frac1{n_2}}.

$$

若方差不等，使用 Welch 区间：
$$

(\bar x_1-\bar x_2)\pm t_{\alpha/2,\nu}\sqrt{\frac{s_1^2}{n_1}+\frac{s_2^2}{n_2}},

$$

$$

\nu\approx\frac{(s_1^2/n_1+s_2^2/n_2)^2}

{(s_1^2/n_1)^2/(n_1-1)+(s_2^2/n_2)^2/(n_2-1)}.

$$

配对数据的均值差 $\mu_D$ 使用

$$

\bar d\pm t_{\alpha/2,n-1}\frac{s_D}{\sqrt n}.

$$
## 3. 假设检验、错误率与功效

### 假设、尾部与 p-value

- 参数是否不同：$H_0:\theta=\theta_0$，$H_1:\theta\ne\theta_0$，使用双尾检验。

- 参数是否增大：$H_0:\theta\le\theta_0$，$H_1:\theta>\theta_0$，使用右尾检验。

- 参数是否减小：$H_0:\theta\ge\theta_0$，$H_1:\theta<\theta_0$，使用左尾检验。

p-value 是在 $H_0$ 及模型前提成立时，获得当前结果或更极端结果的概率。右、左、双尾的形式分别为
$$

P(T\ge t_{obs}\mid H_0),\qquad P(T\le t_{obs}\mid H_0),\qquad

P(\lvert T\rvert\ge\lvert t_{obs}\rvert\mid H_0)

$$

（最后一式适用于零假设分布对称的统计量）。若 $p\le\alpha$，拒绝 $H_0$；若 $p>\alpha$，不拒绝 $H_0$。

p-value 不表示 $P(H_0\mid\text{data})$，也不表示效应大小。

### 第一类错误、第二类错误与功效

- $H_0$ 真且拒绝 $H_0$：第一类错误，概率为 $\alpha$。

- $H_0$ 假且不拒绝 $H_0$：第二类错误，概率为 $\beta$。

- $H_0$ 假且拒绝 $H_0$：正确决策，概率为 $1-\beta$，即功效。

功效为 $1-\beta$。它随效应量、样本量和 $\alpha$ 增大而增大。

已知 $\sigma$，希望检出均值偏离 $\delta$ 时：
$$

n\approx\frac{(z_{\alpha/2}+z_\beta)^2\sigma^2}{\delta^2}

\quad\text{（双侧）},\qquad

n\approx\frac{(z_\alpha+z_\beta)^2\sigma^2}{\delta^2}

\quad\text{（单侧）}.

$$

## 4. 一个均值与一个方差的推断

- 检验未知的总体均值 $\mu$，且总体标准差 $\sigma$ 已知：正态总体或大样本下，$Z=(\bar X-\mu_0)/(\sigma/\sqrt n)\sim N(0,1)$。

- 检验未知的总体均值 $\mu$，且总体标准差 $\sigma$ 未知：正态总体下，$T=(\bar X-\mu_0)/(S/\sqrt n)\sim t_{n-1}$。

- 检验未知的总体方差 $\sigma^2$ 或标准差 $\sigma$：正态总体下，$Y=(n-1)S^2/\sigma_0^2\sim\chi^2_{n-1}$。

对 t 检验，双尾、右尾、左尾拒绝规则依次是

$$

\lvert t\rvert>t_{\alpha/2,n-1},\qquad t>t_{\alpha,n-1},\qquad t<-t_{\alpha,n-1}.

$$

对卡方方差检验，右尾、左尾的拒绝规则依次是

$$

Y>\chi^2_{\alpha,n-1},\qquad Y<\chi^2_{1-\alpha,n-1}.

$$

卡方方差推断依赖总体正态性。对备择 $\sigma=\lambda\sigma_0$，功效由 $\lambda,n,\alpha$ 和卡方分布共同决定。

## 5. 非参数位置检验

### Sign test

适用于连续数据的总体中位数 $M$。对于 $D_i=X_i-M_0$，删除 $D_i=0$ 后，定义正号数 $Q^+$ 与负号数 $Q^-$。在 $H_0:M=M_0$ 下：

$$

Q^+\sim Binomial(n,1/2),\qquad Q^-\sim Binomial(n,1/2).

$$

- $H_1:M>M_0$：正号过多或负号过少。

- $H_1:M<M_0$：负号过多。

- 双尾检验使用 $\min(Q^+,Q^-)$ 的二项分布概率。

### Wilcoxon signed-rank test

适用于单样本或配对差值，要求总体或差值分布关于中位数近似对称。

1. 计算 $D_i=X_i-M_0$，删除零差值。

2. 对 $\lvert D_i\rvert$ 排秩；并列绝对值取平均秩。

3. 计算 $W^+=\sum_{D_i>0}R_i$ 与 $W^-=\sum_{D_i<0}R_i$。

$$

W^++\lvert W^-\rvert=\frac{n(n+1)}2.

$$

右尾看 $W^+$ 是否很大，左尾看 $W^+$ 是否很小；双尾使用 $\min(W^+,\lvert W^-\rvert)$。大样本时

$$

W^+\approx N\left(\frac{n(n+1)}4,\frac{n(n+1)(2n+1)}{24}\right).

$$
## 6. 比例推断

若 $X\sim Binomial(n,p)$，则样本比例为 $\hat p=X/n$，且 $E(\hat p)=p$。
### 单一比例

检验 $H_0:p=p_0$ 时：

$$

Z=\frac{\hat p-p_0}{\sqrt{p_0(1-p_0)/n}}.

$$

比例检验的标准误使用零假设值 $p_0$。估计比例时，若允许误差为 $d$，所需样本量为
$$

n=\frac{z_{\alpha/2}^2p(1-p)}{d^2}.

$$
没有先验比例时，$p(1-p)$ 的最大值为 $0.25$，故保守样本量为
$$

n=\frac{z_{\alpha/2}^2}{4d^2}.

$$
### 两个独立比例

点估计为 $\hat p_1-\hat p_2$。检验 $H_0:p_1=p_2$ 时使用合并比例：
$$

\hat p=\frac{x_1+x_2}{n_1+n_2},\qquad

Z=\frac{\hat p_1-\hat p_2}

{\sqrt{\hat p(1-\hat p)(1/n_1+1/n_2)}}.

$$
两个比例差的置信区间不使用合并比例，使用第 2 节的非合并标准误。

## 7. 两总体比较

### 两个独立方差与均值

若两个独立正态样本的方差分别为 $S_1^2,S_2^2$，在 $H_0:\sigma_1^2=\sigma_2^2$ 下：

$$

F=\frac{S_1^2}{S_2^2}\sim F(n_1-1,n_2-1).

$$
通常将较大的样本方差放在分子。F 检验对非正态性敏感。

若方差相等，使用 pooled two-sample t；若方差不等，使用 Welch two-sample t 及第 2 节的 Welch 自由度。两种方法均要求两组样本独立。

### 配对均值与 Wilcoxon rank-sum test

  

配对数据中，每一对观测有自然对应关系。定义 $D_i=X_i-Y_i$ 后，对 $\mu_D$ 做单样本 t 推断或 signed-rank 推断。

  

Wilcoxon rank-sum test 用于两个独立、连续且不愿采用正态假设的样本。合并两组数据并排序，计算其中一组的秩和 $W$；若 $W$ 落在相应的极端区域，则认为两总体位置不同。

  

## 8. 分类数据与卡方检验

  

### 多项分布与拟合优度检验

  

若 $n$ 次试验有 $k$ 个类别、类别概率为 $p_1,\ldots,p_k$，则类别计数服从多项分布：

  

$$

E(X_i)=np_i,\qquad Var(X_i)=np_i(1-p_i),\qquad Cov(X_i,X_j)=-np_ip_j\ (i\ne j).

$$

  

拟合优度检验检验观察频数 $O_i$ 是否符合给定理论比例。令 $E_i=np_{i0}$，则

  

$$

\chi^2=\sum_{i=1}^k\frac{(O_i-E_i)^2}{E_i},\qquad df=k-1-m.

$$

  

$m$ 是由数据估计的分布参数数目；若全部类别概率已知，$m=0$。

  

### 独立性与同质性检验

  

对于 $r\times c$ 列联表：

  

$$

E_{ij}=\frac{(\text{第 }i\text{ 行和})(\text{第 }j\text{ 列和})}{n},\qquad

\chi^2=\sum_i\sum_j\frac{(O_{ij}-E_{ij})^2}{E_{ij}},\qquad

df=(r-1)(c-1).

$$

  

- 独立性检验：一个总体内，两个分类变量是否独立。

- 同质性检验：多个总体的类别分布是否相同。

  

两者计算相同，差别在抽样设计。

  

### 卡方近似与 McNemar test

  

卡方近似要求每个期望频数至少为 $1$，并且至少 $80\%$ 的格子期望频数不小于 $5$。条件不满足时可合并合理类别。

  

同一对象经两种二分类方法处理时，使用 McNemar 检验。若不一致格为 $b$ 与 $c$，则

  

$$

\chi^2=\frac{(b-c)^2}{b+c},\qquad df=1.

$$

  

只有不一致格 $b,c$ 提供两种方法差异的信息。