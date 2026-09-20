# Cyclic Groups and Symmetric Groups（deep）

这一章的两个主角看起来差别很大：cyclic group 只需要一个 generator，symmetric group 却收集了所有 permutation。它们共享的结构其实很统一：先看一个 operation 重复作用产生的轨道，再研究轨道何时闭合、多个局部周期如何组合，以及这些组合怎样影响整个 group。

## 1. 从一个元素的轨道开始

给定 group $G$ 中的 $x$，反复使用 operation 会得到

$$
\ldots,x^{-2},x^{-1},e,x,x^2,x^3,\ldots
$$

把这条轨道收集起来就是

$$
\langle x\rangle=\{x^m:m\in\mathbb Z\}.
$$

它自动是 subgroup：指数相加对应 $x^a x^b=x^{a+b}$，指数取负对应 inverse。任何包含 $x$ 的 subgroup 都必须对 multiplication 和 inverse 封闭，所以不得不包含所有 $x^m$；这就解释了为什么 $\langle x\rangle$ 是包含 $x$ 的最小 subgroup。

若整个 group 都能由一个元素生成，即 $G=\langle x\rangle$，则 $G$ 是 **cyclic group**，$x$ 是 **generator**。重点不在于 $x$ 这个元素“特别”，而在于 group 的元素都能由一个整数 exponent 编码。

### order 是轨道何时闭合

令

$$
S=\{k\in\mathbb Z:x^k=e\}.
$$

课件先把问题转回 additive group $(\mathbb Z,+)$：$0\in S$，且若 $k,\ell\in S$，则 $x^{k-\ell}=1$，所以 $k-\ell\in S$。因此 $S$ 是 $(\mathbb Z,+)$ 的 subgroup。整数 subgroup 的结构非常刚性：要么 $S=\{0\}$，要么存在最小正整数 $n$ 使得 $S=n\mathbb Z$。

如果 $S=n\mathbb Z$，任意 $k\in\mathbb Z$ 都能写成 $k=qn+r$，其中 $0\le r<n$，于是

$$
x^k=x^{qn+r}=x^r.
$$

而 $1,x,\ldots,x^{n-1}$ 互不相同，因为再早出现 $x^r=x^s$ 就会给出一个比 $n$ 更小的正整数 $|r-s|$ 使得 $x^{|r-s|}=e$。所以 $|x|=n$ 时，轨道恰好在 $n$ 个位置后闭合：

$$
x^r=x^s
\iff n\mid(r-s)
\iff r\equiv s\pmod n.
$$

若 $S=\{0\}$，就没有任何正整数 exponent 让轨道回到 $e$，此时 $|x|=\infty$，并且 $x^r=x^s$ 只能发生在 $r=s$。

<span class="green">可以把 exponent 想成沿同一个按钮反复按下的次数：finite order 会回到起点，infinite order 则永远不会闭合。</span> 这个比喻只负责解释周期；真正可计算的边界仍是 $r\equiv s\pmod n$。

## 2. 为什么 $x^k$ 的行为由 gcd 决定

令 $|x|=n$。从 $x$ 换成 $x^k$，相当于不再每次走一格，而是在原来的 $n$ 个位置上每次跳 $k$ 格。于是问题变成：在 $(\mathbb Z/n\mathbb Z,+)$ 中，从 $[0]$ 反复加 $[k]$，究竟能访问多少个 residue classes？

令 $d=\gcd(n,k)$。每次加 $k$ 都不会离开由 $d$ 控制的 residue pattern；另一方面，$k/d$ 与 $n/d$ 互素，所以在缩小后的 $n/d$ 个位置上最终可以走遍全部位置。回到 group notation，就是

$$
\langle x^k\rangle=\left\langle x^d\right\rangle,
\qquad
|x^k|=\frac{n}{d}
\qquad(d=\gcd(n,k)).
$$

这条公式真正表达的是“跳步是否漏位置”：若 $d>1$，循环被分成更小的轨道；若 $d=1$，跳步最终仍会访问全部 $n$ 个位置。因此

$$
x^k\text{ is a generator of }\langle x\rangle
\iff \gcd(n,k)=1.
$$

在 $(\mathbb Z/n\mathbb Z,+)$ 中，这就是 $[k]$ 是 generator 当且仅当 $k$ 与 $n$ coprime。group structure 在这里直接变成了 number-theoretic divisibility。

## 3. Subgroups 不必枚举：它们由 exponent 的 subgroup 决定

设 $G=\langle x\rangle$，$H\le G$。$H$ 中允许出现的 exponent 组成

$$
T=\{m\in\mathbb Z:x^m\in H\}.
$$

由于 $H$ 是 subgroup，$T$ 是 $(\mathbb Z,+)$ 的 subgroup，因此 $T=r\mathbb Z$ 或 $T=\{0\}$。于是

$$
H=\{x^m:m\in r\mathbb Z\}
=\{(x^r)^t:t\in\mathbb Z\}
=\langle x^r\rangle.
$$

这就是“cyclic group 的 subgroup 仍 cyclic”的机制：group 里的 subgroup 选择，其实对应整数 exponent 里的 subgroup 选择。

<span class="red">Fundamental Theorem of Cyclic Groups</span>：若 $|G|=n<\infty$，则每个 subgroup 的 order 都整除 $n$，而每个正因子 $d\mid n$ 恰好对应一个 order 为 $d$ 的 subgroup：

$$
H_d=\left\langle x^{n/d}\right\rangle,
\qquad |H_d|=d.
$$

为什么是 $n/d$？原来的 cyclic order 是 $n$，每次跳 $n/d$ 格后，恰好得到 $d$ 个不同位置。为什么是唯一的？因为任意 subgroup 都来自某个 exponent subgroup $r\mathbb Z$，而在有限循环中不同的跳步最终会按 gcd 合并成同一个 subgroup。

因此，order 为 $12$ 的 cyclic group 的 subgroup orders 只能是 $1,2,3,4,6,12$，并且每种 order 都只有一个 subgroup。这不是偶然的“元素数量刚好对上”，而是 $(\mathbb Z,+)$ 的 subgroup 结构被 group operation 搬运了过来。

## 4. Euler $\varphi$：把 generators 按 order 数出来

Euler’s totient function 定义为

$$
\varphi(n)=\left|\left\{k\in\{1,\ldots,n\}:\gcd(k,n)=1\right\}\right|.
$$

上一节已经说明了：在 order 为 $n$ 的 cyclic group 中，$x^k$ 是 generator 的充要条件是 $\gcd(n,k)=1$。因此 $\varphi(n)$ 恰好就是 generators 的数量。

更一般地，令 $C$ 是 order 为 $n$ 的 cyclic group，且 $d\mid n$。$C$ 中唯一的 order-$d$ subgroup 本身是 cyclic 的；其中的 generators 恰好是 $C$ 中 order 为 $d$ 的元素。因此 order 恰为 $d$ 的元素有 $\varphi(d)$ 个。把 $C$ 按元素的 order 分层，所有层互不交叠且覆盖 $C$，得到

$$
\sum_{d\mid n}\varphi(d)=n.
$$

所以这个 divisor-sum identity 并不是孤立的 number theory 公式，而是在数一个 cyclic group 的所有可能周期。

课件还给出 prime power 情形

$$
\varphi(p^a)=p^a-p^{a-1},
$$

以及 multiplicativity：若 $\gcd(m,n)=1$，则

$$
\varphi(mn)=\varphi(m)\varphi(n).
$$

这把“互素的跳步选择”拆成两个独立的选择；在本章中，整除关系始终在承担同一个角色：描述重复 operation 的周期如何分裂或合并。

## 5. $S_n$：把所有可能的重排变成一个 group

令 $[n]=\{1,2,\ldots,n\}$。symmetric group 定义为

$$
S_n=\operatorname{Sym}([n])
=\{\sigma:[n]\to[n]:\sigma\text{ is bijective}\},
\qquad |S_n|=n!.
$$

为什么它是 group？identity 是不改变任何元素的 map，inverse 是反向重排，而两个 bijections 的 composition 仍是 bijection。operation 的方向必须固定：

$$
(\sigma\tau)(a)=\sigma(\tau(a)).
$$

也就是说，写在右边的 $\tau$ 先作用。Permutation multiplication 最稳妥的做法是跟踪每个 $a\in[n]$ 的 image，而不是凭图形猜“哪一个看起来先发生”。

### $S_3$：最小的 nonabelian 观察窗口

在 $S_3$ 中，六个元素为

$$
S_3=\{e,r,r^2,i_1,i_2,i_3\},
$$

其中

$$
r=(123),\quad r^2=(132),\quad
i_1=(23),\quad i_2=(13),\quad i_3=(12).
$$

cycle $(123)$ 表示 $1\mapsto2$、$2\mapsto3$、$3\mapsto1$；没有写出的元素固定不动，identity 可写成 $()$。

![[MATH203-cyclic-symmetric-s3.png]]

图中的 composition 是一个很好的方向检查：

$$
i_3r=(12)(123)=(23)=i_1.
$$

逐点看，右边的 $r$ 先把 $1,2,3$ 分别送到 $2,3,1$，再由左边的 $i_3=(12)$ 交换 $1,2$，最终得到 $(23)$。交换顺序后结果不同，所以 $S_3$ nonabelian。更一般地，$S_3$ 可以嵌入 $S_n$：让它作用在 $\{1,2,3\}$ 上并固定 $4,\ldots,n$，因此 $n\ge3$ 时 $S_n$ nonabelian。

## 6. Cycle decomposition：把 permutation 的周期拆成局部周期

一个 finite permutation 的 action 会把有限集合分成若干个 orbit；沿着每个 orbit 走一圈，就得到一个 cycle。不同 orbit 没有共同 entry，因此得到 disjoint cycles 的乘积表示。

若 $\alpha$ 和 $\beta$ disjoint，它们作用在互不相干的 entry 上，因此

$$
\alpha\beta=\beta\alpha.
$$

这解释了为什么 disjoint cycles 可以交换，而一般 permutation 不能交换。若 $\sigma$ 的 disjoint cycle lengths 为 $m_1,\ldots,m_r$，每个局部 cycle 都要在自身长度的倍数次后回到原状；所有局部同时回到 identity 的最小次数就是

$$
|\sigma|=\operatorname{lcm}(m_1,\ldots,m_r).
$$

例如

$$
|(132)(45)|=\operatorname{lcm}(3,2)=6,
\qquad
|(123)(456)(78)|=\operatorname{lcm}(3,3,2)=6.
$$

这里和 cyclic group 的连接很直接：任意 permutation $\sigma$ 都生成 cyclic subgroup $\langle\sigma\rangle$，而 $|\sigma|$ 正是不断执行同一个 permutation 后的闭合周期。disjoint cycle decomposition 只是把这个 global period 拆成了多个 local period。

但非-disjoint cycles 不能直接套 lcm。例如

$$
(123)(145)=(14523).
$$

左边两个 cycles 共享 entry $1$，必须先按 composition convention 计算，再改写为 disjoint cycle form；此时 order 才能从 cycle lengths 读取。

## 7. Transposition、parity 与 alternating group

只交换两个不同元素的 cycle $(ab)$ 称为 **transposition**。任何 $S_n$ 中的 permutation 都能分解成 transpositions；真正重要的不是某一次具体分解，而是任意两种分解所含 transpositions 数量的奇偶性相同。正因为 parity 不依赖分解方式，下面的 sign 才是良定义的：

$$
\operatorname{sgn}(\sigma)=
\begin{cases}
1,&\sigma\text{ is even},\\
-1,&\sigma\text{ is odd}.
\end{cases}
$$

所有 even permutations 组成 alternating group

$$
A_n=\{\sigma\in S_n:\operatorname{sgn}(\sigma)=1\}.
$$

当 $n>1$ 时，$|A_n|=n!/2$。直观上，固定一个 transposition $\tau$，映射 $\sigma\mapsto\tau\sigma$ 会把 even permutation 配对到 odd permutation，并且这个配对是双射，所以两类数量相等。

## 8. 为什么 determinant 需要 $S_n$

对 $A=(a_{ij})\in M_n(\mathbb C)$，Leibniz formula 为

$$
\det(A)=\sum_{\sigma\in S_n}\operatorname{sgn}(\sigma)\,a_{1,\sigma(1)}\cdots a_{n,\sigma(n)}.
$$

这里每个 permutation $\sigma$ 都代表一种合法的“选列方式”：第 $i$ 行选择第 $\sigma(i)$ 列。因为 $\sigma$ 是 bijection，每一列恰好被选一次；如果允许重复选列，就不再是在计算 determinant 的合法项。于是 $S_n$ 负责枚举项，$\operatorname{sgn}(\sigma)$ 负责记录重排的 parity，并把交换两列导致的变号编码进去。

课件给出的另一种 characterization 是：determinant 是唯一一个 alternating、multilinear 且满足 $\det(I_n)=1$ 的函数。Leibniz formula 负责把这个对象展开成可计算的有限和；alternating 与 multilinearity 则说明为什么 permutation 的 parity 必须出现。

这也把整章收回到同一条主线：cyclic group 研究一个 operation 的重复轨道，$S_n$ 研究所有重排的组合；前者的周期由 divisors 和 gcd 组织，后者的周期由 cycles 的 lcm 组织，而 determinant 正好把这些 permutation 的组合信息压缩进一个代数对象。
