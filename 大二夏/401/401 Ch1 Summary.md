这是一份基于课件第一部分（Elements of Probability Theory）整理的概率论基础核心知识点、分布与重要定理公式的 Markdown 格式梳理文档。

# 工程概率方法 (ECE4010J) - 概率论基础 (Elements of Probability Theory) 核心知识点梳理

## 一、 核心概率分布总结 (Probability Distributions)

### 1. 离散型随机变量分布 (Discrete Distributions)

- **伯努利分布 (Bernoulli Distribution)**：表示单次试验的成功与失败，参数为 $p \in (0,1)$。概率质量函数 (PMF) 为 $f_X(0)=1-p$, $f_X(1)=p$。
    
- **二项分布 (Binomial Distribution)**：$X \sim B(n, p)$，表示 $n$ 次独立同分布的伯努利试验中成功的总次数。PMF 公式为 $f_X(x) = \binom{n}{x}p^x(1-p)^{n-x}$。其期望为 $E[X] = np$，方差为 $Var[X] = np(1-p)$。矩母函数为 $m_X(t) = (1-p + pe^t)^n$。
    
- **几何分布 (Geometric Distribution)**：$X \sim Geom(p)$，表示连续进行独立伯努利试验直到**第一次**获得成功所需的试验总次数。PMF 为 $f_X(x) = (1-p)^{x-1}p$。期望为 $E[X] = \frac{1}{p}$，方差为 $Var[X] = \frac{1-p}{p^2}$。矩母函数为 $m_X(t) = \frac{pe^t}{1-(1-p)e^t}$。
    
- **帕斯卡分布 (Pascal Distribution)**：表示获得第 $r$ 次成功所需的总试验次数 $x$。PMF 为 $f_X(x) = \binom{x-1}{r-1}p^r(1-p)^{x-r}$ ($x \ge r$)。期望为 $E[X] = \frac{r}{p}$，方差为 $Var[X] = \frac{r(1-p)}{p^2}$。矩母函数为 $m_X(t) = \left(\frac{pe^t}{1-(1-p)e^t}\right)^r$。
    
- **负二项分布 (Negative Binomial Distribution)**：与帕斯卡分布等价，但其变量 $x$ 记录的是在获得 $r$ 次成功前所经历的**失败次数**。PMF 为 $f_X(x) = \binom{x+r-1}{r-1}p^r(1-p)^x$。
	- <span class="green"> 这里的 x 相当于 帕斯卡分布直接加 r, 因为这里的 x 是失败次数，加上 r (成功次数) 等于帕斯卡分布中的 x (总次数)   </span>

    
- **泊松分布 (Poisson Distribution)**：描述在连续环境中以恒定速率发生事件的次数，参数为 $k$。 PMF 为 $f_X(x) = \frac{k^x e^{-k}}{x!}$。其期望与方差相等，均为 $E[X] = k$, $Var[X] = k$。矩母函数为 $m_X(t) = e^{k(e^t - 1)}$。
    
- **超几何分布 (Hypergeometric Distribution)**：描述在总数为 $N$ 的总体（其中 $r$ 个为指定类别）中，**无放回**地抽取 $n$ 个样本时，包含指定类别数量 $x$ 的概率。PMF 为 $f_X(x) = \frac{\binom{r}{x}\binom{N-r}{n-x}}{\binom{N}{n}}$。期望为 $E[X] = n\frac{r}{N}$。方差为 $Var[X] = n\frac{r}{N}\left(1-\frac{r}{N}\right)\left(\frac{N-n}{N-1}\right)$。
    

### 2. 连续型随机变量分布 (Continuous Distributions)

- **指数分布 (Exponential Distribution)**：常用于描述泊松过程中两次相邻事件发生的时间间隔，参数为 $\alpha > 0$。概率密度函数 (PDF) 为 $f_\alpha(x) = \alpha e^{-\alpha x}$ ($x > 0$)。期望为 $E[X] = \frac{1}{\alpha}$，方差为 $Var[X] = \frac{1}{\alpha^2}$。矩母函数为 $m_X(t) = (1 - t/\alpha)^{-1}$。
    
- **伽马分布 (Gamma Distribution)**：参数为 $\lambda, \alpha > 0$，可表示泊松过程中发生 $r$ 次事件所需的时间 (当 $\lambda = r, \alpha = \text{rate}$ 时)。PDF 为 $f_{\lambda, \alpha}(x) = \frac{\alpha^\lambda}{\Gamma(\lambda)} x^{\lambda-1} e^{-\alpha x}$ ($x > 0$)。期望为 $E[X] = \frac{\lambda}{\alpha}$，方差为 $Var[X] = \frac{\lambda}{\alpha^2}$。矩母函数为 $m_X(t) = (1 - t/\alpha)^{-\lambda}$。
    
- **卡方分布 (Chi-Squared Distribution, $\chi^2$)**：是 $\alpha=1/2, \lambda=\nu/2$ 的==特例伽马分布==，$\nu$ 称为自由度。 PDF 为 $f_\nu(x) = \frac{1}{\Gamma(\nu/2)2^{\nu/2}} x^{\nu/2-1} e^{-x/2}$。期望为 $E[\chi^2_\nu] = \nu$，方差为 $Var[\chi^2_\nu] = 2\nu$。**重要性质**：$n$ 个独立的标准正态分布随机变量的平方和服从自由度为 $n$ 的卡方分布。
    
- **正态分布 (Normal / Gaussian Distribution)**：参数为均值 $\mu$ 与标准差 $\sigma$。 PDF 为 $f(x) = \frac{1}{\sqrt{2\pi}\sigma} e^{-\frac{(x-\mu)^2}{2\sigma^2}}$。标准正态分布 $Z \sim N(0,1)$ 的累积分布函数常记为 $\Phi(z)$。
    
- **二元正态分布 (Bivariate Normal Distribution)**：描述具有相关系数 $\rho$ 的两个边缘正态分布变量的联合分布。联合密度函数中包含相关系数项，当且仅当 $\rho = 0$ 时两个变量相互独立。
    
- **威布尔分布 (Weibull Distribution)**：常用于可靠度理论中描述组件的故障模型。其故障率函数为 $\rho(t) = \lambda \alpha t^{\alpha-1}$，对应的可靠度函数为 $R(t) = e^{-\lambda t^\alpha}$，密度函数为 $f(t) = \lambda \alpha t^{\alpha-1} e^{-\lambda t^\alpha}$。
    

---

## 二、 重要定理 (Important Theorems)

- **全概率公式 (Total Probability Formula)**：若 $A_1, ..., A_n$ 是一组互斥且穷尽样本空间的事件，则对任意事件 $B$，有 $P[B] = \sum_{k=1}^n P[B|A_k] \cdot P[A_k]$。
    
- **贝叶斯定理 (Bayes's Theorem)**：在已知全概率的基础上，用于反推条件概率。公式为 $P[A_k|B] = \frac{P[B|A_k] \cdot P[A_k]}{\sum_{j=1}^n P[B|A_j] \cdot P[A_j]}$。
    
- **切比雪夫不等式 (Chebyshev's Inequality)**：对于均值为 $\mu$、标准差为 $\sigma$ 的随机变量，其偏离均值超过 $k$ 倍标准差的概率有上限界定。公式为 $P[|X-\mu| \ge k\sigma] \le \frac{1}{k^2}$。
    
- **棣莫弗-拉普拉斯定理 (Theorem of De Moivre-Laplace)**：二项分布的正态近似。当 $n \to \infty$ 时，成功次数 $S_n$ 的标准化变量依分布收敛于标准正态分布：$\lim_{n \to \infty} P\left[a < \frac{S_n - np}{\sqrt{np(1-p)}} \le b\right] = \frac{1}{\sqrt{2\pi}} \int_a^b e^{-x^2/2} dx$。在实际有限次试验计算时需引入**半个单位修正 (Half-Unit Correction)**。
    
- **中心极限定理 (Central Limit Theorem, CLT)**：设 $X_1, X_2, ...$ 为独立同分布序列，期望为 $\mu$，方差为 $\sigma^2$。其样本和 $S_n$ 的标准化形式 $\frac{S_n - n\mu}{\sigma \sqrt{n}}$ 当 $n \to \infty$ 时，其累积分布函数收敛于标准正态分布的累积分布函数 $\Phi(x)$。
    
- **弱大数定律 (Weak Law of Large Numbers)**：对于独立同分布的随机变量序列，随着样本量 $n$ 的增加，样本均值依概率收敛于总体期望 $\mu$。即对于任意 $\epsilon > 0$，有 $\lim_{n \to \infty} P\left[\left|\frac{1}{n}\sum_{i=1}^n X_i - \mu\right| \ge \epsilon\right] = 0$。
    
- **随机变量变换定理 (Transformation of Random Variables)**：若 $\phi$ 为严格单调可导函数且 $Y = \phi(X)$，则连续随机变量 $Y$ 的密度函数为 $f_Y(y) = f_X(\phi^{-1}(y)) \cdot \left| \frac{d\phi^{-1}(y)}{dy} \right|$。在多维情况下，绝对值内替换为雅可比矩阵的行列式 (Jacobian Determinant) $\left|\det D\phi^{-1}(y)\right|$。
    

---

## 三、 重要公式与定义 (Key Formulas)

### 1. 基础概率

- **组合数与二项式系数 (Binomial Coefficients)**：$\binom{\alpha}{n} = \frac{\alpha \cdot (\alpha-1) \cdots (\alpha-n+1)}{n!}$。
    
- **条件概率 (Conditional Probability)**：$P[B|A] = \frac{P[A \cap B]}{P[A]}$，前提是 $P[A] \ne 0$。
    
- **独立性判定 (Independence of Events)**：事件 $A$ 和 $B$ 独立当且仅当 $P[A \cap B] = P[A]P[B]$。
    

### 2. 矩、期望与方差 (Moments, Expectation, Variance)

- **离散随机变量期望 (Expectation)**：$E[X] = \sum_{x \in \Omega} x \cdot f_X(x)$。
    
- **函数期望 (Expectation of a Function)**：$E[\phi(X)] = \sum_{x \in \Omega} \phi(x) \cdot f_X(x)$ (离散情况)；$E[\phi(X)] = \int_{-\infty}^\infty \phi(x) f_X(x) dx$ (连续情况)。
    
- **方差公式 (Variance)**：$Var[X] = E[(X - E[X])^2] = E[X^2] - E[X]^2$。
    
- **标准化变量 (Standardized Random Variable)**：$Y = \frac{X - \mu}{\sigma}$，具有 $E[Y]=0$ 以及 $Var[Y]=1$。
    
- **矩母函数 (Moment-Generating Function, MGF)**：$m_X(t) = E[e^{tX}]$。其与原点矩的关系为：$E[X^k] = \frac{d^k m_X(t)}{dt^k} \bigg|_{t=0}$。
    

### 3. 多维随机变量与相关性 (Multivariate Variables & Correlation)

- **和的期望与方差**：对于任意随机变量 $X, Y$，有 $E[X+Y] = E[X] + E[Y]$。方差为 $Var[X+Y] = Var[X] + Var[Y] + 2Cov[X,Y]$。
    
- **协方差 (Covariance)**：$Cov[X,Y] = E[(X-\mu_X)(Y-\mu_Y)]$，其简便计算公式为 $Cov[X,Y] = E[XY] - E[X]E[Y]$。若 $X$ 与 $Y$ 独立，则 $Cov[X,Y] = 0$。
    
- **相关系数 (Correlation Coefficient)**：衡量线性相关性的无量纲指标 $\rho_{XY} = \frac{Cov[X,Y]}{\sigma_X \sigma_Y}$，取值范围为 $[-1, 1]$。
    
- **费雪变换 (Fisher Transformation)**：为了使相关分析更具数学优良性质，将 $\rho_{XY}$ 变换为：$\text{Artanh}(\rho_{XY}) = \frac{1}{2} \ln \left( \frac{1+\rho_{XY}}{1-\rho_{XY}} \right)$。
    

### 4. 可靠性理论 (Reliability)

- **可靠度函数 (Reliability Function)**：系统在时间 $t$ 之前正常运行的概率 $R_A(t) = 1 - P[\text{失败在 } t \text{ 之前}] = 1 - F_A(t)$。
    
- **故障率函数 (Hazard Rate)**：在时间 $t$ 幸存的前提下，立刻发生故障的条件概率密度 $\rho_A(t) = \frac{f_A(t)}{R_A(t)}$。
    
- - **根据故障率求可靠度公式**：$R(t) = e^{-\int_0^t \rho(x)dx}$。
        
- **系统可靠度 (System Reliability)**：
    
    - **串联系统 (Series System)**：$R_{\text{series}}(t) = \prod_{i=1}^k R_i(t)$。
        
    - **并联系统 (Parallel System)**：$R_{\text{parallel}}(t) = 1 - \prod_{i=1}^k (1 - R_i(t))$。