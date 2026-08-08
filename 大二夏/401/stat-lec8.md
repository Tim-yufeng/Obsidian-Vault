这个章节的主题其实是：

**Categorical Data（分类数据）的假设检验**

前面我们学的是：

- 均值 $\mu$ 的检验（Z-test / t-test）
    
- 方差 $\sigma^2$ 的检验（$\chi^2$）
    
- 两个比例比较
    

这一章换了对象：

> 当数据不是连续数值，而是“属于哪个类别”的计数数据时，如何判断一个理论分布、两个变量之间关系是否成立？

核心工具：

$$  
\chi^2\text{ test}  
$$

也就是卡方检验。板书从 multinomial distribution 开始，到最后的 independence test、homogeneity test、McNemar test。

---

## 1. Categorical data 的基本思想：只统计类别数量

例如：

一个工厂生产产品：

- 1%：不可修复缺陷
    
- 5%：可修复缺陷
    
- 94%：正常
    

每个产品只有三个可能结果：

$$  
p_1=0.01,\quad p_2=0.05,\quad p_3=0.94  
$$

这就是 multinomial trial（多项试验）。

和二项分布相比：

二项：

只有两个结果：

$$  
success/failure  
$$

多项：

有多个类别：

$$  
1,2,\dots,k  
$$

例如：

产品质量：

$$  
{A,B,C,D}  
$$

---

## 2. Multinomial random variable（多项随机变量）

假设重复做 $n$ 次实验。

第 $i$ 类出现次数：

$$  
X_i  
$$

例如：

抽取 100 个产品：

- 缺陷不可修复：
    

$$  
X_1=2  
$$

- 缺陷可修复：
    

$$  
X_2=6  
$$

- 正常：
    

$$  
X_3=92  
$$

那么：

$$  
(X_1,X_2,\dots,X_k)  
$$

服从 multinomial distribution。

满足：

$$  
X_1+X_2+\cdots+X_k=n  
$$

概率质量函数：

$$  
P(X_1=x_1,\dots,X_k=x_k)

\frac{n!}{x_1!x_2!\cdots x_k!}  
p_1^{x_1}p_2^{x_2}\cdots p_k^{x_k}  
$$

其中：

$$  
x_1+x_2+\cdots+x_k=n  
$$

这里：

$$  
\frac{n!}{x_1!\cdots x_k!}  
$$

叫 multinomial coefficient。

它表示：

同样数量的类别组合，有多少种排列方式。

例如：

100个产品中：

2个坏，98个好。

坏产品可以出现在任意两个位置。

---

# 3. Multinomial 的均值和方差

对于第 $i$ 类：

$$  
E(X_i)=np_i  
$$

因为：

100个产品：

缺陷概率：

$$  
p_i=0.01  
$$

那么期望缺陷：

$$  
E(X_i)=100\times0.01=1  
$$

---

方差：

$$  
Var(X_i)=np_i(1-p_i)  
$$

和二项分布完全一样。

因为：

每一个类别单独看，本质就是：

“属于该类别 / 不属于该类别”。

---

但是不同类别之间不是独立的。

例如：

如果100个产品中：

缺陷数量增加。

正常数量一定减少。

所以：

$$  
Cov(X_i,X_j)=-np_ip_j  
$$

这是负相关。

板书这里强调：

multinomial 的 covariance matrix 不是 diagonal。

---

# 4. Chi-square Goodness-of-Fit Test（拟合优度检验）

这是这一章第一个核心。

问题：

> 我观察到的数据，是否符合某个理论分布？

例如：

厂家说：

缺陷概率：

$$  
(0.01,0.05,0.94)  
$$

现在抽100个：

实际：

$$  
(2,6,92)  
$$

问：

这个差异是不是太大？

---

## Step 1：建立假设

Null hypothesis：

$$  
H_0:  
p_i=p_{i0}  
$$

也就是：

数据符合理论比例。

Alternative：

$$  
H_1:  
\text{至少一个 }p_i\text{ 不符合}  
$$

---

## Step 2：计算 expected frequency

理论上第 $i$ 类应该出现：

$$  
E_i=np_i  
$$

例如：

100个产品：

不可修复：

$$  
E_1=100(0.01)=1  
$$

---

实际：

$$  
O_i  
$$

(observed frequency)

---

## Step 3：构造 Pearson statistic

核心公式：

$$  
\chi^2=  
\sum_{i=1}^{k}  
\frac{(O_i-E_i)^2}{E_i}  
$$

直观理解：

每个类别：

实际 - 理论

差多少？

然后除以：

理论波动尺度。

---

为什么除以 $E_i$？

因为：

100个类别期望：

100

和：

期望1

差5

意义完全不同。

$$  
\frac{(O_i-E_i)^2}{E_i}  
$$

就是标准化后的误差。

---

## Step 4：自由度

如果所有 $p_i$ 已知：

$$  
df=k-1  
$$

为什么？

因为：

$$  
X_1+\cdots+X_k=n  
$$

最后一个类别由前面决定。

例如：

3个类别：

知道：

$$  
X_1,X_2  
$$

那么：

$$  
X_3=n-X_1-X_2  
$$

所以少一个自由度。

---

如果参数需要从数据估计：

例如：

Poisson 的 $\lambda$ 不知道。

需要估计：

$$  
m  
$$

个参数。

那么：

$$  
df=k-1-m  
$$

板书后面 Poisson 例子就是这个情况。

---

# 5. Pearson test 的使用条件：Cochran Rule

卡方近似不是永远成立。

要求 expected frequency 足够大。

通常：

$$  
E_i\geq1  
$$

并且：

至少80%类别满足：

$$  
E_i\geq5  
$$

如果不满足：

怎么办？

两个选择：

1. 合并类别
    
2. 增加样本量
    

板书中的 defect Poisson 例子就是因为某类别 expected frequency 太小，所以合并最后两类。

---

# 6. Goodness-of-fit 和之前假设检验的联系

其实和之前 t-test 完全一样。

结构：

|之前|现在|
|---|---|
|观察均值|观察频数|
|理论均值|理论频数|
|误差/标准差|误差/expected frequency|
|t/Z分布|$\chi^2$分布|

核心思想：

> 看观察结果偏离理论模型多少。

---

# 7. Test for Independence（独立性检验）

第二大部分。

现在不是问：

“一个变量是否符合某分布”

而是：

> 两个分类变量有没有关系？

例如：

吸烟是否导致癌症？

两个变量：

Cancer：

$$  
C  
$$

Asbestos exposure：

$$  
A  
$$

形成二维表：

|           | Exposure | No exposure |
| --------- | -------- | ----------- |
| Cancer    | 10       | 40          |
| No cancer | 490      | 4460        |

---

## Null hypothesis

没有关系：

$$  
H_0:  
A\text{ and }C\text{ independent}  
$$

数学：

$$  
P(A,C)=P(A)P(C)  
$$

---

## 如果独立，应该出现多少？

这就是 expected count。

例如：

某格：

$$  
(i,j)  
$$

如果独立：

行比例：

$$  
\frac{n_{i.}}n  
$$

列比例：

$$  
\frac{n_{.j}}n  
$$

所以：

$$  
E_{ij}

n  
\frac{n_{i.}}n  
\frac{n_{.j}}n  
$$

化简：

$$  
E_{ij}

\frac{n_{i.}n_{.j}}n  
$$

也就是：

$$  
E_{ij}

\frac{  
\text{row total}\times\text{column total}  
}  
{\text{sample size}}  
$$

---

然后仍然：

$$  
\chi^2=  
\sum_i\sum_j  
\frac{(O_{ij}-E_{ij})^2}{E_{ij}}  
$$

自由度：

如果：

$r$ 行：

$c$ 列：

$$  
df=(r-1)(c-1)  
$$

原因：

总共有：

$$  
rc  
$$

个格子。

但是：

行列限制消除了自由度。

---

# 8. Homogeneity Test（同质性检验）

这个和 independence 很像。

区别：

## Independence:

一个总体里面：

两个变量是否相关？

例如：

1000个人：

安全带类型 vs 伤害程度。

---

## Homogeneity:

多个总体：

分布是否一样？

例如：

三个地区：

观察污染程度是否影响树叶叶绿素。

实际上数学形式完全一样：

都是：

$$  
\chi^2  
$$

区别在实验设计。

---

# 9. Comparing proportions（比例比较）

如果只有两个类别：

其实就是：

二维表：

$$  
2\times2  
$$

例如：

暴露组：

300人。

非暴露：

320人。

结果：

有没有疾病。

检验：

$$  
H_0:  
p_1=p_2  
$$

也可以转化为：

独立性检验。

---

# 10. McNemar Test（配对比例）

最后一部分非常重要，因为它和之前 paired data 对应。

普通比例比较：

要求：

两个样本独立。

但是：

如果同一个对象接受两个方法：

例如：

100个物品：

方法A分类一次。

方法B分类一次。

数据：

不是：

两个独立样本。

而是：

pair。

---

构造：

2×2表：

| |B成功|B失败|
|---|---|---|
|A成功|a|b|
|A失败|c|d|

关键：

只看：

不一致部分：

$$  
b,c  
$$

因为：

如果：

A和B都成功：

没有信息。

如果：

A和B都失败：

也没有信息。

真正反映差异的是：

A成功B失败：

和：

A失败B成功。

---

McNemar统计量：

$$  
\chi^2=  
\frac{(b-c)^2}{b+c}  
$$

自由度：

$$  
df=1  
$$

---

# 整章总结

这章其实只有三个问题：

## 1. 一个分类变量是否符合理论分布？

例如：

缺陷率是否符合厂家声明？

↓

Goodness-of-fit

$$  
\chi^2=  
\sum  
\frac{(O-E)^2}{E}  
$$

---

## 2. 两个分类变量有没有关系？

例如：

吸烟和疾病是否相关？

↓

Independence test

$$  
df=(r-1)(c-1)  
$$

---

## 3. 两个总体分类比例是否相同？

例如：

两个方法成功率是否一样？

↓

Homogeneity / proportion test

如果数据配对：

↓

McNemar test

---

考试判断口诀：

- **一个分类变量 + 理论比例**  
    → Goodness-of-fit
    
- **一个样本 + 两个分类变量**  
    → Independence
    
- **多个总体比较分类比例**  
    → Homogeneity
    
- **同一个对象前后比较比例**  
    → McNemar
    

这一章表面上公式很多，但核心只有一句话：

> 把分类数据转换成“观察频数 vs 理论频数”的比较，然后用 $\chi^2$ 衡量偏离程度。