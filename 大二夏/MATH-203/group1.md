# Cyclic Groups and Symmetric Groups

这一章从两个方向看 group 的结构：先研究一个元素反复作用能生成什么，再把视角换到所有 permutation 的组合。前者由整数的加法与整除关系控制，后者则由 cycle decomposition、composition 和 parity 控制。

## Cyclic group：一个 generator 产生的世界

若存在 $x\in G$ 使得 $G=\langle x\rangle$，则称 $G$ 是 **cyclic group**，$x$ 是它的 **generator**。由 $x$ 生成的 cyclic subgroup 为

$$
\langle x\rangle=\{x^m:m\in\mathbb Z\}
$$

它是包含 $x$ 的最小 subgroup：任何包含 $x$ 的 subgroup 为了对 multiplication 和 inverse 封闭，都必须包含所有 $x^m$。

元素 $x$ 的 **order** 是最小的正整数 $n$ 使得 $x^n=e$；若不存在这样的 $n$，则 $|x|=\infty$。不要把 $|x|$ 和 group 的 order $|G|$ 混在一起：前者描述一个元素重复作用多久回到 identity，后者描述整个 group 有多少个元素。

若 $|x|=n<\infty$，则 powers 每 $n$ 步循环一次，并且

$$
x^r=x^s\iff n\mid(r-s)\iff r\equiv s\pmod n.
$$

因此

$$
\langle x\rangle=\{e,x,x^2,\ldots,x^{n-1}\},\qquad |\langle x\rangle|=|x|=n.
$$

典型例子是 $(\mathbb Z,+)=\langle 1\rangle$、正 $n$ 边形的旋转 group，以及复数 $n$ 次单位根组成的 multiplicative cyclic group。课件还给出 $\mathbb Z/8\mathbb Z$ 的 generators 为 $[1],[3],[5],[7]$。Klein four group 和 quaternion group 则是 non-cyclic 的例子：它们都没有一个元素能生成全部元素。

### 从 $x^k$ 判断能走多远

令 $|x|=n$，且 $k>0$。元素 $x^k$ 相当于沿原来的循环每次跳 $k$ 格，因此

$$
\langle x^k\rangle=\left\langle x^{\gcd(n,k)}\right\rangle,
\qquad
|x^k|=\frac{n}{\gcd(n,k)}.
$$

特别地，$x^k$ 是 $\langle x\rangle$ 的 generator 当且仅当 $\gcd(n,k)=1$。在 $(\mathbb Z/n\mathbb Z,+)$ 中，这就是 $[k]$ 是 generator 当且仅当 $k$ 与 $n$ 互素。

## Subgroup 结构：整除关系就是地图

<span class="red">Fundamental Theorem of Cyclic Groups</span>：cyclic group 的每个 subgroup 仍然是 cyclic；若 $|\langle x\rangle|=n$，则任意 subgroup 的 order 都整除 $n$，并且每个正因子 $d\mid n$ 恰好对应一个 order 为 $d$ 的 subgroup：

$$
H_d=\left\langle x^{n/d}\right\rangle.
$$

所以 order 为 $12$ 的 cyclic group 只有 order 为 $1,2,3,4,6,12$ 的 subgroup，而且每种 order 都只有一个。找 subgroup 不再需要枚举元素，只需要看 $n$ 的 divisors。

## Euler $\varphi$ function：数 generator 和 order 层

Euler’s totient function 定义为

$$
\varphi(n)=\left|\left\{k\in\{1,\ldots,n\}:\gcd(k,n)=1\right\}\right|.
$$

由 generator criterion，order 为 $n$ 的 cyclic group 恰有 $\varphi(n)$ 个 generators。更一般地，若 cyclic group $C$ 的 order 为 $n$，且 $d\mid n$，则 $C$ 中 order 恰为 $d$ 的元素有 $\varphi(d)$ 个。因此按元素的 order 分层，得到

$$
\sum_{d\mid n}\varphi(d)=n.
$$

课件还给出

$$
\varphi(p^a)=p^a-p^{a-1},
$$

以及当 $\gcd(m,n)=1$ 时的 multiplicativity：$\varphi(mn)=\varphi(m)\varphi(n)$。

## Symmetric group：所有重排放在一起

令 $[n]=\{1,2,\ldots,n\}$。degree-$n$ 的 **symmetric group** 是所有 $[n]$ 到自身的 bijective maps：

$$
S_n=\operatorname{Sym}([n])
=\{\sigma:[n]\to[n]:\sigma\text{ is bijective}\},
\qquad |S_n|=n!.
$$

group operation 是 function composition。写成 $\sigma\tau$ 时，右边的 $\tau$ 先作用，再作用左边的 $\sigma$：

$$
(\sigma\tau)(a)=\sigma(\tau(a)).
$$

### $S_3$ 与 cycle notation

在 $S_3$ 中，六个元素可以写成

$$
S_3=\{e,r,r^2,i_1,i_2,i_3\},
$$

其中 $r=(123)$、$r^2=(132)$，三个 transposition 可以取 $i_1=(23)$、$i_2=(13)$、$i_3=(12)$。cycle $(123)$ 表示 $1\mapsto2\mapsto3\mapsto1$；没有写出的元素保持不动，所以 identity 可以写成 $()$。

![[MATH203-cyclic-symmetric-s3.png]]

读 permutation product 时最好逐个追踪元素的 image。例如图中

$$
i_3r=(12)(123)=(23)=i_1,
$$

因为右边的 $r$ 先作用。这个例子也直接显示 $i_3r\ne ri_3$，所以 $S_3$ nonabelian。把 $S_3$ 嵌入 $S_n$ 并固定剩下的元素，可得 $n\ge3$ 时 $S_n$ 也是 nonabelian。

## Cycle、order 与 parity

每个 finite permutation 都可以写成一个 cycle，或写成若干个 **disjoint cycles** 的乘积。若两个 cycles 没有共同 entry，它们作用在互不干扰的元素上，因此可以交换。若 permutation 的 disjoint cycle lengths 为 $m_1,\ldots,m_r$，则它的 order 是

$$
|\sigma|=\operatorname{lcm}(m_1,\ldots,m_r).
$$

例如

$$
|(132)(45)|=\operatorname{lcm}(3,2)=6.
$$

如果 cycles 不 disjoint，就不能直接取 lcm；必须先完成 composition，再改写成 disjoint cycle form。例如课件中的 $(123)(145)=(14523)$。

形如 $(ab)$ 且 $a\ne b$ 的 permutation 称为 **transposition**。每个 $S_n$ 中的 permutation 都能写成 transpositions 的乘积，而且不同分解中 transpositions 数量的奇偶性相同。因此可以定义

$$
\operatorname{sgn}(\sigma)=
\begin{cases}
1,&\sigma\text{ is even},\\
-1,&\sigma\text{ is odd}.
\end{cases}
$$

所有 even permutations 构成 **alternating group** $A_n$。当 $n>1$ 时，

$$
|A_n|=\frac{n!}{2}.
$$

## 为什么 determinant 会用到 symmetric group

对 $A=(a_{ij})\in M_n(\mathbb C)$，Leibniz formula 为

$$
\det(A)=\sum_{\sigma\in S_n}\operatorname{sgn}(\sigma)\,a_{1,\sigma(1)}\cdots a_{n,\sigma(n)}.
$$

每个 $\sigma$ 选择“第 $i$ 行取第 $\sigma(i)$ 列”；bijectivity 保证每一列恰好被选一次，$\operatorname{sgn}(\sigma)$ 则决定这一项带正号还是负号。课件还给出等价的 characterization：determinant 是唯一一个 alternating、multilinear 且满足 $\det(I_n)=1$ 的函数。
