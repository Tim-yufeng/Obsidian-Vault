# Cyclic Groups and Symmetric Groups — Deep

这一章真正贯穿始终的问题是：**一个 group 的元素能否用某种“整数参数”统一描述？** 对 cyclic group，答案非常彻底——所有元素都是同一个 $x$ 的整数次幂，equality、order、generator 与 subgroup 因而都被整数中的 divisibility 控制。Symmetric group 则把视角转向所有 bijection；它的困难不在元素从哪里来，而在 composition 的先后顺序。

## 从整数到 cyclic subgroup

设 $G$ 是一个 group，identity 为 $e$。固定 $x\in G$，考虑映射

$$
\mathbb Z\longrightarrow G,\qquad m\longmapsto x^m.
$$

整数加法在这里对应 group multiplication，因为

$$
x^{m+n}=x^mx^n.
$$

这个映射的所有输出组成

$$
\langle x\rangle=\{x^m\mid m\in\mathbb Z\},
$$

称为由 $x$ generated 的 cyclic subgroup。它必然是包含 $x$ 的最小 subgroup：只要一个 subgroup 包含 $x$，closure 便迫使它同时包含所有 positive powers、inverse powers 与 $e=x^0$。

若 $G=\langle x\rangle$，则 $G$ 是 cyclic group，$x$ 是 generator。在 additive group 中，同一个结构写成

$$
\langle x\rangle=\{mx\mid m\in\mathbb Z\}.
$$

因此 $(\mathbb Z,+)$ 由 $1$ 或 $-1$ 生成，而 $(\mathbb Z/n\mathbb Z,+)$ 中的反复加法就是 exponent 对 $n$ 取模后的版本。

## 重复何时开始：relation subgroup 与 element order

真正决定 cyclic subgroup 结构的不是 $x$ 看起来像什么，而是哪些 exponent 会回到 identity。令

$$
S=\{k\in\mathbb Z\mid x^k=e\}.
$$

$S$ 是 $(\mathbb Z,+)$ 的 subgroup：$0\in S$；若 $k,\ell\in S$，则

$$
x^{k-\ell}=x^k(x^\ell)^{-1}=e.
$$

而整数加法群的 subgroup 只能是 $\{0\}$ 或 $n\mathbb Z$。这一步把 group 中看似复杂的重复关系压回了整数中的一个最小正数。

### Infinite order

若 $S=\{0\}$，没有非零 exponent 能使 $x^k=e$，于是 $|x|=\infty$。此时

$$
x^r=x^s
\iff x^{r-s}=e
\iff r-s=0
\iff r=s.
$$

所以 $\ldots,x^{-1},e,x,x^2,\ldots$ 全部不同，$\langle x\rangle$ 与整数加法的结构相同。

### Finite order

若 $S\neq\{0\}$，则 $S=n\mathbb Z$，其中 $n$ 是使 $x^n=e$ 的最小正整数。定义 $|x|=n$。对任意 $k\in\mathbb Z$，由 division algorithm 写成 $k=qn+r$，其中 $0\leq r<n$，于是

$$
x^k=x^{qn+r}=(x^n)^qx^r=x^r.
$$

因此 $e,x,x^2,\ldots,x^{n-1}$ 已经包含全部可能，而且彼此不同。更一般地，

$$
x^r=x^s
\iff r-s\in n\mathbb Z
\iff r\equiv s\pmod n.
$$

这也立即给出

$$
|\langle x\rangle|=|x|,
\qquad
x^k=e\iff n\mid k.
$$

这里的 $|x|$ 是 element order，$|G|$ 是 group order。二者只在 $x$ 确实生成整个有限 group 时相等。

## 哪些例子真的只需要一个 generator？

$(\mathbb Z,+)$ 是 infinite cyclic group。有限例子包括 $(\mathbb Z/n\mathbb Z,+)$、正 $n$ 边形的 rotation group，以及 complex plane 上的 $n$ 次单位根：

$$
\left\{e^{2\pi i k/n}\mid k\in\mathbb Z\right\}
=\left\langle e^{2\pi i/n}\right\rangle.
$$

后两个例子其实共享同一个 mental model：每做一次 generator，就沿圆周前进固定角度；走满 $n$ 步回到 identity。

判断 nonexample 时，不需要穷举所有长乘积，只要检查每个元素能生成的 subgroup 大小。Klein four group $V_4$ 中所有 nonidentity element 的 order 都是 $2$，所以最多生成两个元素。Quaternion group

$$
Q_8=\{\pm1,\pm i,\pm j,\pm k\}
$$

中，$i,j,k$ 的 order 都是 $4$，例如 $\langle i\rangle=\{1,i,-1,-i\}$，仍然覆盖不了八个元素。因此它们都不是 cyclic。

## Power of a generator：$x^k$ 会丢掉多少元素？

设 $|x|=n<\infty$。$x^k$ 的 powers 是 $x^{kt}$；但在 $\langle x\rangle$ 中，exponent 相差 $n$ 的倍数代表同一元素。因此真正可达的 exponent 由

$$
\{kt+ns\mid t,s\in\mathbb Z\}
=k\mathbb Z+n\mathbb Z
=\gcd(n,k)\mathbb Z
$$

控制。于是

$$
\boxed{\langle x^k\rangle=\langle x^{\gcd(n,k)}\rangle}.
$$

若记 $d=\gcd(n,k)$，要让 $(x^k)^t=e$，需要 $n\mid kt$。约去 $d$ 后，$n/d$ 与 $k/d$ coprime，所以最小可行正整数是 $t=n/d$：

$$
\boxed{|x^k|=\frac{n}{\gcd(n,k)}}.
$$

这个公式同时回答了三个问题：

- $x^k$ 仍生成整个 $\langle x\rangle$ 当且仅当 $\gcd(n,k)=1$；
- $x^i$ 与 $x^j$ 生成同一 subgroup 当且仅当 $\gcd(n,i)=\gcd(n,j)$；
- cyclic group 中任意元素的 order 都整除 group order。

例如在 $(\mathbb Z/8\mathbb Z,+)$ 中，

| Element | $\gcd(8,k)$ | Order of $[k]$ | Generated subgroup |
|---|---:|---:|---|
| $[1],[3],[5],[7]$ | $1$ | $8$ | $\mathbb Z/8\mathbb Z$ |
| $[2],[6]$ | $2$ | $4$ | $\{[0],[2],[4],[6]\}$ |
| $[4]$ | $4$ | $2$ | $\{[0],[4]\}$ |
| $[0]$ | $8$ | $1$ | $\{[0]\}$ |

看似是在 group 中不断运算，实际上只是整数 $k$ 与 $n$ 的 gcd 在决定“每次跨几格、最终能否走遍整圈”。

## Fundamental Theorem of Cyclic Groups

<span class="red">Cyclic group 的所有 subgroup 仍是 cyclic；有限情形下，每个正因数对应且只对应一个 subgroup。</span>

先证明 subgroup 仍 cyclic。设 $G=\langle x\rangle$，$H\leq G$，并定义

$$
T=\{m\in\mathbb Z\mid x^m\in H\}.
$$

若 $a,b\in T$，则 $x^a,x^b\in H$，由 subgroup closure 得 $x^{a-b}\in H$，所以 $a-b\in T$。因此 $T\leq\mathbb Z$，必有 $T=q\mathbb Z$ 或 $T=\{0\}$。前一种情形给出

$$
H=\{x^{qt}\mid t\in\mathbb Z\}=\langle x^q\rangle;
$$

后一种情形对应 trivial subgroup，同样 cyclic。

现在设 $|G|=n$。任意 $H\leq G$ 都能写成 $H=\langle x^q\rangle$，所以

$$
|H|=|x^q|=\frac{n}{\gcd(n,q)},
$$

自然整除 $n$。反过来，若 $d\mid n$，则

$$
\left|x^{n/d}\right|
=\frac{n}{\gcd(n,n/d)}
=d,
$$

故 $\langle x^{n/d}\rangle$ 是一个 order 为 $d$ 的 subgroup。若另一个 $\langle x^q\rangle$ 也有 order $d$，则 $\gcd(n,q)=n/d$，从前面的 power theorem 得

$$
\langle x^q\rangle
=\langle x^{\gcd(n,q)}\rangle
=\left\langle x^{n/d}\right\rangle.
$$

这就同时证明了 existence 与 uniqueness。

## Euler’s Totient Function 把结构变成计数

Euler’s totient function 定义为

$$
\varphi(n)
=\left|\{k\in\mathbb N\mid 1\leq k\leq n,\ \gcd(k,n)=1\}\right|.
$$

若 $p$ 是 prime，$a\geq1$，则

$$
\varphi(p)=p-1,
\qquad
\varphi(p^a)=p^a-p^{a-1},
$$

因为 $1,2,\ldots,p^a$ 中不与 $p^a$ coprime 的数恰好是 $p$ 的倍数，共有 $p^{a-1}$ 个。

### 为什么 order 为 $d$ 的元素正好有 $\varphi(d)$ 个？

设 $C$ 是 order 为 $n$ 的 cyclic group，且 $d\mid n$。Fundamental Theorem 保证 $C$ 中恰有一个 order 为 $d$ 的 subgroup，记为 $C_d=\langle y\rangle$。其中 $y^k$ 的 order 为 $d$ 当且仅当

$$
|y^k|=\frac{d}{\gcd(d,k)}=d
\iff \gcd(d,k)=1.
$$

所以 order 为 $d$ 的元素就是 $C_d$ 的 generators，共有 $\varphi(d)$ 个。值得注意的是，这个数量只依赖 $d$，不依赖外层 group 的 order $n$。

### Gauss divisor sum 的两个读法

把 order 为 $n$ 的 cyclic group 按 element order 分块。每个 element 的 order 都是 $n$ 的正因数，而 order 为 $d$ 的那一块有 $\varphi(d)$ 个元素，因此

$$
\boxed{\sum_{d\mid n}\varphi(d)=n}.
$$

同一个等式也可以从 fractions 看见。把

$$
\frac1n,\frac2n,\ldots,\frac nn
$$

全部约到 lowest terms。约分后的 denominator 必为 $n$ 的某个正因数 $d$；固定 denominator $d$ 后，允许的 numerator 与 $d$ coprime，恰有 $\varphi(d)$ 个。所有 denominator 分组加起来仍是原来的 $n$ 个 fractions。

### 为什么 $\varphi$ multiplicative？

课件使用一个更一般的事实。设

$$
g(m)=\sum_{d\mid m}f(d).
$$

若 $g$ multiplicative，则 $f$ 也 multiplicative。对 coprime 的 $m_1,m_2$，$m_1m_2$ 的每个 divisor 都唯一写成 $d_1d_2$，其中 $d_1\mid m_1$、$d_2\mid m_2$。用 induction 假设处理所有较小的 $d_1d_2$，比较

$$
g(m_1m_2)
=\sum_{d_1\mid m_1}\sum_{d_2\mid m_2}f(d_1d_2)
$$

与

$$
g(m_1)g(m_2)
=\left(\sum_{d_1\mid m_1}f(d_1)\right)
\left(\sum_{d_2\mid m_2}f(d_2)\right),
$$

除最顶层的 $f(m_1m_2)$ 外，其余项都已能配对，故剩余项必须满足

$$
f(m_1m_2)=f(m_1)f(m_2).
$$

对 $f=\varphi$，Gauss divisor sum 给出 $g(m)=m$，而 identity function 显然 multiplicative，所以当 $\gcd(m_1,m_2)=1$ 时

$$
\boxed{\varphi(m_1m_2)=\varphi(m_1)\varphi(m_2)}.
$$

## Symmetric group：从一个 generator 转向所有 bijection

令 $[n]=\{1,2,\ldots,n\}$。Symmetric group of degree $n$ 是

$$
S_n
=\operatorname{Sym}([n])
=\{f:[n]\to[n]\mid f\text{ is bijective}\}.
$$

Group operation 是 function composition。Bijection 的 composition 仍是 bijection；identity map 是 identity；每个 bijection 都有 inverse，因此这些 permutation 确实组成 group。

依次选择 $1,2,\ldots,n$ 的像：第一个有 $n$ 种选择，第二个剩 $n-1$ 种，直到最后只剩一种，所以

$$
|S_n|=n!.
$$

这里最容易混淆的是：$n$ 是 degree，也就是被 permutation 的对象数量；$n!$ 才是 group order。

$S_1=\{e\}$。$S_2=\{e,\tau\}$，其中 $\tau=(12)$ 且 $\tau^2=e$，所以 $S_2$ 本身是 cyclic。真正出现顺序问题的是 $S_3$。

## $S_3$：cycle notation 与 composition order

$S_3$ 的六个元素可写为

$$
S_3=\{e,r,r^2,i_1,i_2,i_3\},
$$

其中

$$
e=(),\quad r=(123),\quad r^2=(132),\quad
i_1=(23),\quad i_2=(13),\quad i_3=(12).
$$

![[MATH203-cyclic-symmetric-s3.png]]

Cycle $(123)$ 表示

$$
1\mapsto2,\qquad2\mapsto3,\qquad3\mapsto1.
$$

图中的三个 rotation $e,r,r^2$ 与三条 reflection $i_1,i_2,i_3$ 正好给出六个 permutation。几何图并不是额外的一套规则，而是把相同的 composition 变成可观察的“先旋转还是先反射”。

Composition 从右向左执行。以课件中的例子为例，

$$
i_3r=i_3\circ r.
$$

逐个追踪三个元素：

$$
1\xrightarrow{r}2\xrightarrow{i_3}1,
\qquad
2\xrightarrow{r}3\xrightarrow{i_3}3,
\qquad
3\xrightarrow{r}1\xrightarrow{i_3}2.
$$

所以 $i_3r=(23)=i_1$。若交换顺序，

$$
ri_3=r\circ i_3=(13)=i_2.
$$

因此

$$
i_3r\neq ri_3,
$$

即 $S_3$ nonabelian。这个例子也提供了一个很实用的检查法：不要凭 cycle 的外观猜 composition，选取 $1,2,3$ 逐个从右向左追踪即可。

对 $n\geq3$，让上述六个 permutation 只作用于 $\{1,2,3\}$ 并固定 $4,\ldots,n$，便在 $S_n$ 中得到一个与 $S_3$ 相同的 subgroup。若 $S_n$ abelian，它的每个 subgroup 也应 abelian，与 $S_3$ 矛盾。因此

$$
\boxed{S_n\text{ is nonabelian for every }n\geq3.}
$$

最后再把两条主线合起来：cyclic group 中任意元素都写成同一个 $x$ 的 power，所以

$$
x^ax^b=x^{a+b}=x^{b+a}=x^bx^a,
$$

每个 cyclic group 都 abelian。于是 $S_1$ 与 $S_2$ 可以 cyclic，而 $S_n$ 在 $n\geq3$ 时绝不可能 cyclic。一个 generator 带来的极强整数结构，正是 symmetric group 从三个对象开始就不再拥有的东西。

## 容易混淆的边界

- $|x|$ 是 element order，$|G|$ 是 group order；只有 $\langle x\rangle=G$ 时才有 $|x|=|G|$。
- $x^r=x^s$ 并不总推出 $r=s$；finite order 为 $n$ 时只能推出 $r\equiv s\pmod n$。
- $x\in G$ 不代表 $x$ 是 generator；在 finite cyclic group 中需要 $\gcd(n,k)=1$ 才能让 $x^k$ 继续生成整个 group。
- $S_n$ 的 degree 是 $n$，order 是 $n!$。
- Permutation product $\sigma\tau$ 表示先做右侧的 $\tau$，再做左侧的 $\sigma$；交换书写顺序通常会改变结果。
