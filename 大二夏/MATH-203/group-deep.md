# Cyclic Groups and Symmetric Groups（deep）

这一章的两个对象看上去差得很远：cyclic group 由一个 generator 反复作用得到，symmetric group 则包含所有 permutation。它们其实都在训练同一件事：不要只列元素，而是抓住一个 operation 重复后的轨道、周期和可组合方式。对 cyclic group，这个轨道由整数的加法与整除控制；对 $S_n$，它由 cycles 的分解与 composition 控制。

## 1. 从一个元素的轨道开始

给定 group $G$ 中的元素 $x$，不断把 $x$ 和自己相乘，就得到

$$
\ldots,x^{-2},x^{-1},e,x,x^2,x^3,\ldots
$$

这整条轨道形成的集合是

$$
\langle x\rangle=\{x^m:m\in\mathbb Z\}.
$$

它自动是 subgroup：指数相加对应相乘，指数取负对应 inverse。也正因如此，$\langle x\rangle$ 是包含 $x$ 的最小 subgroup；任何包含 $x$ 的 subgroup 为了封闭，也不得不包含所有 $x^m$。

若 $G=\langle x\rangle$，$G$ 就是 cyclic group，$x$ 是 generator。这里的重点不是“有一个特别的元素”，而是 group 的全部信息可以被一个整数指数 $m$ 编码。

### order 是轨道何时闭合

若最小的正整数 $n$ 满足 $x^n=e$，则 $|x|=n$。一旦回到 $e$，后面的 powers 就会重复：

$$
x^{q n+r}=x^r\qquad (q\in\mathbb Z,\ 0\le r<n).
$$

因此 $1,x,\ldots,x^{n-1}$ 恰好是 $\langle x\rangle$ 的全部元素，而且互不相同。更精确地，

$$
x^r=x^s\iff n\mid(r-s)\iff r\equiv s\pmod n.
$$

如果没有任何正整数使 $x^n=e$，则 $|x|=\infty$，此时 $x^r=x^s$ 只能发生在 $r=s$。所以有限 cyclic group 的 exponent 本质上是在模 $n$ 的世界里运算；无限 cyclic group 则仍由整个 $\mathbb Z$ 编号。

<span class="green">可以把这个过程想成沿着同一个按钮反复按下去。</span> 有限 order 时会回到起点，之后只能重复已有的位置；无限 order 时永远不会回环。这个直觉只解释“周期”，真正的等价关系仍是 $r\equiv s\pmod n$。

## 2. 为什么 $x^k$ 的行为由最大公因数决定

令 $|x|=n$。从 $x$ 改成 $x^k$，并不是换了一个完全不同的轨道，而是每次沿原来的循环跳 $k$ 格。问题变成：从 $0$ 开始反复加 $k$，在 $\mathbb Z/n\mathbb Z$ 里能到哪些 residue classes？

答案是所有 $gcd(n,k)$ 的 multiples。因此

$$
\langle x^k\rangle=\left\langle x^{\gcd(n,k)}\right\rangle,
\qquad
|x^k|=\frac{n}{\gcd(n,k)}.
$$

这里的关键不是记公式，而是两种“跳步”何时会漏掉位置：若 $k$ 与 $n$ 有公因子，就会被分成若干个小循环；若 $gcd(n,k)=1$，跳步最终仍能访问所有 $n$ 个位置。因此

$$
x^k\text{ is a generator of }\langle x\rangle
\iff \gcd(n,k)=1.
$$

在 $(\mathbb Z/n\mathbb Z,+)$ 中，同一句话写成：$[k]$ 是 generator 当且仅当 $gcd(n,k)=1$。这将 group-theoretic generator 问题转成了 number theory 的 coprimality 问题。

## 3. Subgroups 不必枚举：它们已经由 divisors 编号

<span class="red">Fundamental Theorem of Cyclic Groups</span>：cyclic group 的每个 subgroup 仍是 cyclic；若 $G=\langle x\rangle$ 且 $|G|=n$，每个 subgroup 的 order 整除 $n$，并且每个正因子 $d\mid n$ 对应唯一一个 order-$d$ subgroup。

先看为什么“仍是 cyclic”。任何 $H\le\langle x\rangle$ 都只能包含一些 powers $x^m$。把这些允许的 exponents 收集成 $S\le(\mathbb Z,+)$；而整数加法群的每个 subgroup 都形如 $r\mathbb Z$。于是

$$
H=\{x^m:m\in r\mathbb Z\}
=\{(x^r)^t:t\in\mathbb Z\}
=\langle x^r\rangle.
$$

有限情形中，若想要 order $d$，就应每次跳 $n/d$ 格：

$$
H_d=\left\langle x^{n/d}\right\rangle,
\qquad |H_d|=d.
$$

这也解释了“唯一”：一个 order-$d$ subgroup 必须由对应的跳步长度产生。举例说，order 为 $12$ 的 cyclic group 的 subgroup orders 只能是 $1,2,3,4,6,12$；它们不是许多不同形状的 group，而是同一圆周上的不同等距跳法。

## 4. $\varphi$ 数的是 generator，也数 order 层

Euler’s totient function 为

$$
\varphi(n)=\bigl|\{k\in\{1,\ldots,n\}:\gcd(k,n)=1\}\bigr|.
$$

由上一节的 generator criterion，order 为 $n$ 的 cyclic group 恰有 $\varphi(n)$ 个 generators。更一般地，若 $C$ 是 order-$n$ cyclic group，且 $d\mid n$，它有唯一一个 order-$d$ subgroup；该 subgroup 内的 generators 也就是 $C$ 中所有 order 恰为 $d$ 的元素，所以数量为 $\varphi(d)$。

把 $C$ 的每个元素按自身 order 分层，这些层互不交叠且覆盖整个 group，因而

$$
\sum_{d\mid n}\varphi(d)=n.
$$

这不是孤立的 number-theory identity：它是在数一个 cyclic group 的每一种可能周期。特别地，

$$
\varphi(p^a)=p^a-p^{a-1}
$$

因为 $1$ 到 $p^a$ 中不与 $p^a$ 互素的恰好是 $p$ 的倍数，共 $p^{a-1}$ 个。

## 5. $S_n$：把所有可能的重排变成一个 group

令 $[n]=\{1,2,\ldots,n\}$。symmetric group 是

$$
S_n=\operatorname{Sym}([n])
=\{\sigma:[n]\to[n]:\sigma\text{ is bijective}\},
\qquad |S_n|=n!.
$$

它的 operation 是 function composition。写 $\sigma\tau$ 时，先执行 $\tau$、再执行 $\sigma$：

$$
(\sigma\tau)(a)=\sigma(\tau(a)).
$$

因此 permutation multiplication 不应依靠图形上“看起来像先转哪边”的感觉，而要逐个跟踪元素的 image。

![[MATH203-cyclic-symmetric-s3.png]]

图中的 $S_3$ 把三个点的全部六种重排列出来。cycle $(123)$ 表示 $1\mapsto2$、$2\mapsto3$、$3\mapsto1$；没有出现的元素固定不动，所以 identity 可写为 $()$。例如

$$
i_3r=(12)(123)=(23)=i_1,
$$

因为右边的 $r$ 先作用。这个计算同时说明 $i_3r\ne ri_3$，故 $S_3$ 非交换。对于 $n\ge3$，把 $S_3$ 固定在剩余元素上即可视为 $S_n$ 的 subgroup，所以 $S_n$ 也 nonabelian。

## 6. Cycle decomposition 把 permutation 的内部周期拆开

任何 finite permutation 都能写成一个 cycle 或若干个 disjoint cycles 的 product。disjoint 意味着 cycles 的 entries 没有重合；这时它们作用在互不干扰的轨道上，所以可以交换：

$$
\varepsilon\eta=\eta\varepsilon
\qquad\text{when }\varepsilon\text{ and }\eta\text{ are disjoint.}
$$

若 disjoint cycles 的 lengths 为 $m_1,\ldots,m_r$，每个 cycle 要在自己的长度倍数次后才回到 identity；所有 cycles 同时回到 identity 的最早时刻是

$$
|\sigma|=\operatorname{lcm}(m_1,\ldots,m_r).
$$

例如

$$
|(132)(45)|=\operatorname{lcm}(3,2)=6.
$$

这里与 cyclic group 的连接非常直接：$\langle\sigma\rangle$ 就是由重复执行同一个 permutation 得到的 cyclic subgroup，而 $|\sigma|$ 正是它的周期。差别在于 $\sigma$ 的周期可以通过 disjoint cycles 的多个局部周期取 lcm 求得。

注意非-disjoint cycles 不能直接照此处理。例如课件中的

$$
(123)(145)=(14523)
$$

左边两个 cycles 共用了 $1$，必须先完成 composition、改写成 disjoint cycle form，再读取 order。

## 7. Transpositions、parity 与 $A_n$

transposition 是形如 $(ab)$ 的 permutation，只交换两个不同元素。每个 $S_n$ 中的 permutation 都可写为 transpositions 的乘积；更关键的是，任何两种分解所含 transpositions 的个数同奇偶。这使得下列定义是良好的：

$$
\operatorname{sgn}(\sigma)=
\begin{cases}
1,&\sigma\text{ is even},\\
-1,&\sigma\text{ is odd}.
\end{cases}
$$

sign 把“用了多少次交换”压缩成一个乘法兼容的 $\{\pm1\}$ 值。所有 even permutations 组成 alternating group：

$$
A_n=\{\sigma\in S_n:\operatorname{sgn}(\sigma)=1\},
\qquad |A_n|=\frac{n!}{2}\quad(n>1).
$$

这里一半的来源是：固定一个 transposition 并把每个 permutation 与它相乘，会在 even 与 odd 之间两两配对。

## 8. 为什么 determinant 需要 symmetric group

Leibniz formula 为

$$
\det(A)=\sum_{\sigma\in S_n}\operatorname{sgn}(\sigma)
a_{1,\sigma(1)}\cdots a_{n,\sigma(n)}.
$$

每个 $\sigma$ 选择“第 $i$ 行取第 $\sigma(i)$ 列”，bijectivity 保证每一列恰用一次；于是 $S_n$ 正好枚举了 determinant 中所有合法的取列方式。$\operatorname{sgn}(\sigma)$ 则记录这一重排应带正号还是负号。换句话说，alternating 不是附加规则，而是 determinant 对交换两列会变号这一性质的 group-theoretic 编码。
