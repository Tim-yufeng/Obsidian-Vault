# Cyclic Groups and Symmetric Groups

这一章研究两种很典型、但性格几乎相反的 group。Cyclic group 由一个元素反复运算生成，结构最终被整数的整除关系控制；symmetric group 则收集一个有限集合上的所有 permutation，composition 的顺序会直接导致 noncommutativity。

## Cyclic group：由一个元素生成整个 group

设 $G$ 是一个 group，identity 记为 $e$。对 $x\in G$，由 $x$ 生成的 cyclic subgroup 定义为

$$
\langle x\rangle=\{x^m\mid m\in\mathbb Z\}.
$$

它是包含 $x$ 的最小 subgroup：任何包含 $x$ 的 subgroup 都必须对乘法与 inverse 封闭，所以必然包含 $x$ 的所有整数次幂。若 $G=\langle x\rangle$，就称 $G$ 是 cyclic group，$x$ 是一个 generator。

在 additive notation 下，$x^m$ 应读成 $mx$。例如 $(\mathbb Z,+)=\langle 1\rangle=\langle -1\rangle$；而在 $(\mathbb Z/n\mathbb Z,+)$ 中，$[k]$ 的整数倍不断绕回有限个 congruence classes。

### Element order 与 group order

若存在最小正整数 $n$ 使 $x^n=e$，则 $x$ 的 order 为 $|x|=n$；若不存在，则 $|x|=\infty$。Group order $|G|$ 是 $G$ 的元素个数，两者不要混淆。不过对 cyclic subgroup 有

$$
|x|=|\langle x\rangle|.
$$

令

$$
S=\{k\in\mathbb Z\mid x^k=e\}.
$$

$S$ 是 $(\mathbb Z,+)$ 的 subgroup，因为 $0\in S$，且 $k,\ell\in S$ 时 $x^{k-\ell}=e$。整数加法群的 subgroup 只有两种形态：$\{0\}$ 或 $n\mathbb Z$。因此：

- 若 $|x|=\infty$，则 $x^r=x^s$ 当且仅当 $r=s$；
- 若 $|x|=n<\infty$，则

$$
x^r=x^s\iff n\mid(r-s)\iff r\equiv s\pmod n.
$$

特别地，$x^k=e$ 当且仅当 $n\mid k$。有限 cyclic subgroup 中真正不同的元素正好是

$$
e,x,x^2,\ldots,x^{n-1}.
$$

### Examples 与 nonexamples

典型 cyclic groups 包括 $(\mathbb Z,+)$、$(\mathbb Z/n\mathbb Z,+)$、正 $n$ 边形的旋转群，以及 $n$ 次单位根

$$
\left\{e^{2\pi i k/n}\mid k\in\mathbb Z\right\}=\left\langle e^{2\pi i/n}\right\rangle.
$$

Klein four group $V_4$ 不是 cyclic：除 identity 外每个元素的 order 都是 $2$，没有元素能生成全部四个元素。Quaternion group $Q_8=\{\pm1,\pm i,\pm j,\pm k\}$ 也不是 cyclic；例如 $\langle i\rangle=\{1,i,-1,-i\}$ 只有四个元素，其他元素同样无法生成整个 $Q_8$。

## 一个 power 能生成多少东西？

设 $|x|=n<\infty$。对任意正整数 $k$，课件中的关键结论是

$$
\boxed{\langle x^k\rangle=\langle x^{\gcd(n,k)}\rangle},
\qquad
\boxed{|x^k|=\frac{n}{\gcd(n,k)}}.
$$

原因是 $x$ 的 exponent 可以模 $n$ 化简，而 $kt+ns$ 能取到的整数恰好组成

$$
k\mathbb Z+n\mathbb Z=\gcd(n,k)\mathbb Z.
$$

所以 $x^k$ 是否仍是 generator，只取决于 $k$ 与 $n$ 是否 coprime：

$$
\langle x^k\rangle=\langle x\rangle
\iff \gcd(n,k)=1.
$$

例如在 $(\mathbb Z/8\mathbb Z,+)$ 中，$[1],[3],[5],[7]$ 都能生成整个 group；$[2]$ 的 order 是 $4$，$[4]$ 的 order 是 $2$。

## Fundamental Theorem of Cyclic Groups

<span class="red">有限 cyclic group 的 subgroup 结构完全由其阶的正因数决定。</span>

设 $G=\langle x\rangle$ 且 $|G|=n$，则：

1. $G$ 的每个 subgroup 仍然是 cyclic；
2. 每个 subgroup 的 order 都整除 $n$；
3. 对每个正因数 $d\mid n$，$G$ 恰好有一个 order 为 $d$ 的 subgroup，即

$$
\left\langle x^{n/d}\right\rangle.
$$

证明的核心不是重新猜 generator，而是看 subgroup 中允许出现哪些 exponent。若 $H\leq\langle x\rangle$，则

$$
T=\{m\in\mathbb Z\mid x^m\in H\}
$$

是 $\mathbb Z$ 的 subgroup，因此 $T=a\mathbb Z$，进而 $H=\langle x^a\rangle$。再代入 $|x^a|=n/\gcd(n,a)$，便得到 order 的整除性与指定 order subgroup 的唯一性。

## Euler’s Totient Function：数 generator

Euler’s totient function 定义为

$$
\varphi(n)=\left|\{k\in\mathbb N\mid 1\leq k\leq n,\ \gcd(k,n)=1\}\right|.
$$

常用值包括

$$
\varphi(p)=p-1,
\qquad
\varphi(p^a)=p^a-p^{a-1}
$$

其中 $p$ 是 prime，$a\geq1$。在 order 为 $n$ 的 cyclic group 中，若 $d\mid n$，则 order 恰为 $d$ 的元素有 $\varphi(d)$ 个：order 为 $d$ 的 subgroup 唯一，而这些元素正是该 subgroup 的 generators。

把 group 中的元素按各自的 order 分类，就得到 Gauss divisor sum：

$$
\boxed{\sum_{d\mid n}\varphi(d)=n}.
$$

此外，$\varphi$ 是 multiplicative function：当 $\gcd(m_1,m_2)=1$ 时，

$$
\varphi(m_1m_2)=\varphi(m_1)\varphi(m_2).
$$

## Symmetric group：所有 permutation 组成的 group

对 $[n]=\{1,2,\ldots,n\}$，degree 为 $n$ 的 symmetric group 定义为

$$
S_n=\{f:[n]\to[n]\mid f\text{ is bijective}\}.
$$

运算是 function composition，identity 是什么也不改变的 permutation，每个 permutation 的 inverse 也是 permutation。依次决定 $1,2,\ldots,n$ 的像，共有

$$
|S_n|=n!
$$

种选择。这里的 degree 是 $n$，group order 是 $n!$。

$S_1=\{e\}$。在 $S_2=\{e,\tau\}$ 中，$\tau=(12)$ 交换两个元素，且 $\tau^2=e$，所以 $S_2$ 是 order 为 $2$ 的 cyclic group。

### $S_3$ 与 cycle notation

$S_3$ 有六个元素。课件把它们写成

$$
S_3=\{e,r,r^2,i_1,i_2,i_3\},
$$

其中

$$
e=(),\quad r=(123),\quad r^2=(132),\quad
i_1=(23),\quad i_2=(13),\quad i_3=(12).
$$

![[MATH203-cyclic-symmetric-s3.png]]

Cycle $(123)$ 表示 $1\mapsto2$、$2\mapsto3$、$3\mapsto1$。Composition 必须从右向左读；例如

$$
i_3r=i_3\circ r=i_1,
$$

因为先做 $r$，再做 $i_3$。反过来则有

$$
ri_3=r\circ i_3=i_2.
$$

两者不相等，所以 $S_3$ nonabelian。对任意 $n\geq3$，只让 permutation 改动前三个元素并固定其余元素，就能在 $S_n$ 中得到一个 $S_3$ subgroup，因此

$$
\boxed{S_n\text{ is nonabelian for }n\geq3.}
$$

Cyclic group 一定 abelian，因为 $x^ax^b=x^{a+b}=x^{b+a}=x^bx^a$。因此 $S_n$ 在 $n\geq3$ 时不可能是 cyclic；这也正好展示了两类 group 的结构差异。
