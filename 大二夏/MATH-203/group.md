# Cyclic Groups and Symmetric Groups

这一章先问：一个 group 能不能只靠一个元素不断重复运算生成？若可以，它的全部结构会被整数的整除关系控制。随后把视角换到 permutation：$S_n$ 把“重排 $n$ 个对象”的所有可能都收进同一个 group，而 cycle notation 把每个重排压缩成可计算的结构。

## Cyclic group：一个 generator 产生的世界

若存在 $x\in G$ 使得 $G=\langle x\rangle$，则称 $G$ 是 **cyclic**。这里

$$
\langle x\rangle=\{x^m:m\in\mathbb Z\}
$$

是由 $x$ 生成的 cyclic subgroup；它也是包含 $x$ 的最小 subgroup。指数取负数不是额外的对象：$x^{-m}$ 就是在反复使用 inverse。

元素的 **order** 是最小的正整数 $n$，使得 $x^n=e$；若不存在这样的 $n$，则 $|x|=\infty$。group 的 order $|G|$ 则是元素个数。不要把两者混在一起：$|x|$ 描述一个元素绕多少次回到 identity，$|G|$ 描述整个 group 有多大。

若 $|x|=n<\infty$，那么 powers 并不是无限展开，而是每 $n$ 步循环一次：

$$
x^r=x^s\iff r\equiv s\pmod n.
$$

所以

$$
\langle x\rangle=\{e,x,x^2,\ldots,x^{n-1}\},\qquad |\langle x\rangle|=|x|=n.
$$

例如 $(\mathbb Z,+)=\langle 1\rangle$；在加法 notation 下，$k$ 的 order 是最小的正整数 $m$ 使得 $mk=0$。而旋转正 $n$ 边形的 group 由一次旋转 $r$ 生成，满足 $r^n=e$。

### 从 $x^k$ 能看出什么

在有限 cyclic group $\langle x\rangle$ 中，$x^k$ 不一定仍是 generator。真正决定它能走遍多少元素的是 $k$ 和 $n=|x|$ 的公因子：

$$
\langle x^k\rangle=\langle x^{\gcd(n,k)}\rangle,
\qquad
|x^k|=\frac{n}{\gcd(n,k)}.
$$

因此 $x^k$ 生成整个 group 当且仅当 $\gcd(n,k)=1$。在 $(\mathbb Z/n\mathbb Z,+)$ 中，$[k]$ 是 generator 当且仅当 $k$ 与 $n$ 互素。这个判断之后会自然连到 Euler $\varphi$ function。

## 子群结构：整除关系就是地图

<span class="red">Fundamental Theorem of Cyclic Groups</span>：每个 cyclic group 的 subgroup 仍然是 cyclic；若 $|G|=n$，则每个 subgroup 的 order 都整除 $n$，并且每个正因子 $d\mid n$ 恰对应一个 order 为 $d$ 的 subgroup。

若 $G=\langle x\rangle$ 且 $|G|=n$，这个唯一的 order-$d$ subgroup 是

$$
\left\langle x^{n/d}\right\rangle.
$$

这条定理把“找 subgroup”从枚举元素变成了看 divisors。比如 order 为 $12$ 的 cyclic group 只会有 order $1,2,3,4,6,12$ 的 subgroup，并且各有一个。

## Euler $\varphi$ function：数有多少个 generator

Euler’s totient function 定义为

$$
\varphi(n)=\bigl|\{k\in\{1,\ldots,n\}:\gcd(k,n)=1\}\bigr|.
$$

它数的正是 order 为 $n$ 的 cyclic group 中 generator 的数量。更一般地，若 cyclic group $C$ 的 order 为 $n$，且 $d\mid n$，则 $C$ 中 order 恰为 $d$ 的元素有 $\varphi(d)$ 个。由所有元素按自身 order 分组可得

$$
\sum_{d\mid n}\varphi(d)=n.
$$

对于 prime power，课件给出

$$
\varphi(p^a)=p^a-p^{a-1}.
$$

理由很直接：从 $1$ 到 $p^a$ 中，恰有 $p^{a-1}$ 个数是 $p$ 的倍数，剩下的才与 $p^a$ 互素。

## Symmetric group：所有重排放在一起

$S_n$ 是集合 $[n]=\{1,2,\ldots,n\}$ 的全部 bijective maps 所组成的 group：

$$
S_n=\operatorname{Sym}([n]),\qquad |S_n|=n!.
$$

group operation 是 function composition，因此读 $\sigma\tau$ 时要先做右边的 $\tau$，再做左边的 $\sigma$。这不是 notation 小事：它决定了每一次 permutation multiplication 的结果。

![[MATH203-cyclic-symmetric-s3.png]]

上图把 $S_3$ 的六个元素写成 cycle notation。cycle $(123)$ 表示 $1\mapsto2\mapsto3\mapsto1$；没有写出的元素保持不动，所以 identity 可以简写成 $()$。例如图中的 $i_3r=i_1$ 意味着先用 $r=(123)$，再用 $i_3=(12)$。跟踪 $1,2,3$ 各自的去向，比凭图形直觉交换顺序可靠得多。

因为 $i_3r\ne ri_3$，$S_3$ 非交换；而 $S_3\le S_n$，所以当 $n\ge3$ 时，$S_n$ 也是 nonabelian。

### Cycle、order 与 parity

任何有限集合上的 permutation 都能写成一个 cycle 或若干个 **disjoint cycles** 的乘积。disjoint 的含义是两个 cycle 没有共用元素；只有在这个条件下，它们才可以交换次序。

若 disjoint cycle lengths 为 $m_1,\ldots,m_r$，则 permutation 的 order 是

$$
\operatorname{lcm}(m_1,\ldots,m_r).
$$

例如 $|(132)(45)|=\operatorname{lcm}(3,2)=6$。若 cycles 不 disjoint，就不能直接取 lcm；应先把 composition 化成 disjoint cycle form。

形如 $(ab)$、只交换两个元素的 permutation 称为 **transposition**。每个 $S_n$ 中的 permutation 都能写成 transpositions 的乘积，而且无论怎样拆，transpositions 的数量的奇偶性不变。因此可以定义 even/odd permutation 与 sign：

$$
\operatorname{sgn}(\sigma)=
\begin{cases}
1,&\sigma\text{ is even},\\
-1,&\sigma\text{ is odd}.
\end{cases}
$$

所有 even permutations 构成 alternating group $A_n$。当 $n>1$ 时，正好一半 permutations 是 even：

$$
|A_n|=\frac{n!}{2}.
$$

最后，Leibniz formula 用 $\operatorname{sgn}(\sigma)$ 给 determinant 的每一项定符号：

$$
\det(A)=\sum_{\sigma\in S_n}\operatorname{sgn}(\sigma)\,a_{1,\sigma(1)}\cdots a_{n,\sigma(n)}.
$$

这里的 permutation 不再只是“重排下标”的记号；它通过 parity 决定每一项是加还是减。
