
算法效率不是某次运行显示的秒数。编译器、机器性能和当时的 CPU 负载都会改变这个数；更稳定的问题是：当输入规模 $n$ 变大时，运行时间 $T(n)$ 如何增长。渐近分析刻意忽略这些环境差异，只保留增长趋势。

## 输入规模与三种情况

“输入规模”必须先说清楚：对数组通常是元素个数，对图通常是顶点数 $V$ 和边数 $E$。有些算法在相同规模下的耗时固定，例如遍历一个长度为 $n$ 的数组求和；有些则依赖输入内容，例如 linear search。

- **best case**：同一规模下步数最少的输入；例如要找的 key 恰好在数组第一个位置。
- **worst case**：同一规模下步数最多的输入；例如 key 不在数组中，或位于最后。
- **average case**：在明确的输入分布或算法随机性下的期望步数。它不等于“取一个随便的输入”。

实际分析常用 worst case，因为它给出可靠上界，且通常较容易证明；average case 也很有价值，但必须说明“平均”是对什么随机来源取的。

## 为什么只看大的 $n$

常数因子会随平台改变，而且对大输入的预测能力有限。比如 $1000\log_2 n$ 最终会比 $0.001n$ 小：开始时常数可能掩盖差异，增长率终会主导。因此我们允许把 $3n^2+10n$ 与 $n^2$ 看作同一增长级别，同时只要求结论从某个阈值 $n_0$ 之后成立。

## Big-Oh：一个最终的上界

<span class="red">Big-Oh 描述的是输入足够大后，运行时间不会超过某个函数的常数倍这一最终上界。</span>

形式上，存在正常数 $c$ 与 $n_0$，使得

$$
T(n)\le c f(n),\qquad \forall n>n_0.
$$

这里的 $c$ 吸收实现细节，$n_0$ 忽略小规模时的偶然波动；它们不必是最小值。图中蓝线 $2f(n)$ 从 $n_0$ 起盖住绿色的 $T(n)$，正是 Big-Oh 的图像含义。

![[Pasted image 20260826105045.png]]

所以 $T(n)=3n^2$ 当然属于 $O(n^3)$，但这个上界太松。描述算法时通常选择最紧、最有区分力的常见上界：$T(n)=3n^2$ 应写成 $O(n^2)$。

### 两个常用判断

对最高项系数为正的多项式

$$
T(n)=a_mn^m+a_{m-1}n^{m-1}+\cdots+a_0,
$$

有 $T(n)\in O(n^m)$。原因不是“低阶项消失了”，而是当 $n\ge1$ 时，每个低阶正幂都不超过 $n^m$，可以被同一个常数倍吸收。

另一个方便的充分条件是

$$
\lim_{n\to\infty}\frac{f(n)}{g(n)}=c<\infty
\quad\Longrightarrow\quad
f(n)\in O(g(n)).
$$

它适合快速确认主导项；不过定义本身才是根本依据。

Big-Oh 在加法、乘法和传递时可直接组合：若 $f_1\in O(g_1)$、$f_2\in O(g_2)$，则 $f_1+f_2\in O(\max\{g_1,g_2\})$，且 $f_1f_2\in O(g_1g_2)$。这解释了为什么顺序执行的两段代码通常由较慢的一段主导，而嵌套循环常把规模相乘。

### 增长率的直觉顺序

常见增长率从慢到快可记为

$$
1,\ \log n,\ \sqrt n,\ n,\ n\log n,\ n^2,\ n^3,\ n^k,\ a^n,\ n!.
$$

其中 $a>1$、$k\ge1$；课件默认 $\log n$ 指 $\log_2 n$。需要抓住的是“多项式最终胜过对数，而指数最终胜过任意固定次数多项式”，例如 $(\log n)^k\in O(n)$、$n^k\in O(2^n)$。

## 下界与紧确界

Big-Omega 写作 $T(n)\in\Omega(g(n))$，意思是存在常数 $c>0,n_0$，当 $n>n_0$ 时

$$
T(n)\ge cg(n).
$$

它给出“至少这么慢”的最终下界。若同一个函数既给出上界又给出下界，便写作 $T(n)\in\Theta(g(n))$：

$$
c_1g(n)\le T(n)\le c_2g(n),\qquad \forall n>n_0.
$$

此时 $g(n)$ 才是 $T(n)$ 的紧确增长级别。$\Theta$ 是对称的：$f(n)\in\Theta(g(n))$ 也表示 $g(n)\in\Theta(f(n))$。

## 从程序得到复杂度

先数最基本、会重复发生的操作，再把控制结构翻译成次数。

- 赋值、一次比较等 atomic statement 通常是 $\Theta(1)$。
- 分支的代价是条件判断加上最贵的分支；做 worst-case 分析时不能把昂贵分支忽略。
- 子程序调用的代价是该子程序自身的代价。
- 循环不能只看“有几层”。要看每层实际迭代次数，以及内层次数是否随外层变化。

例如双层循环若内层在第 $i$ 轮运行 $i$ 次，总次数不是 $n\cdot n$ 的凭空猜测，而是

$$
1+2+\cdots+n=\frac{n(n+1)}2=\Theta(n^2).
$$

若变量每轮翻倍，则它经历 $1,2,4,\ldots$，直到超过 $n$，因此约运行 $\log_2 n$ 轮；若每轮又扫描整个长度为 $n$ 的数组，总代价为 $\Theta(n\log n)$。反过来，内层长度若随外层按 $1,2,4,\ldots$ 增加，则总和是 $1+2+4+\cdots+n=\Theta(n)$，不能机械地把两层循环一律乘成 $n\log n$。

## 不止一个参数

当问题同时含有两个独立规模，不能把它们悄悄合并成一个 $n$。例如对 $P$ 个像素、$C$ 种像素值做计数再排序，代价可写为

$$
\Theta(P+C\log C).
$$

这会直接说明瓶颈随哪个量变化，也为后面 counting sort 的 $\Theta(N+k)$ 形式埋下伏笔。

## Space/Time trade-off

省时间常要多用空间。计算 $n!$ 时，逐次相乘只需 $\Theta(1)$ 额外空间、耗时 $\Theta(n)$；若预先把结果存成表，单次查询可降为 $\Theta(1)$，代价是表本身占用 $\Theta(n)$ 空间。之后遇到“更快”的算法，应该顺手问一句：它是不是把工作提前做了，或换成了额外存储？

## 把代码翻译成求和式

复杂度分析最好先写“第 $i$ 轮做多少工作”，再求总和，而不是只看循环层数。

```cpp
int countPairs(const vector<int>& a) {
    int count = 0;
    int n = a.size();

    for (int i = 0; i < n; i++) {
        for (int j = 0; j < i; j++) {
            if (a[j] < a[i]) {
                count++;
            }
        }
    }
    return count;
}
```

外层第 $i$ 轮，内层执行 $i$ 次，因此总比较次数为

$$
0+1+\cdots+(n-1)=\frac{n(n-1)}2=\Theta(n^2).
$$

下面虽然也有两层循环，却不是 $\Theta(n\log n)$：

```cpp
for (int block = 1; block < n; block = block * 2) {
    for (int i = 0; i < block; i++) {
        doConstantWork();
    }
}
```

各轮工作量是 $1,2,4,\ldots$，直到小于 $n$，所以总和小于 $2n$，整体是 $\Theta(n)$。真正决定复杂度的是所有执行次数的总和，不是代码在视觉上嵌套了几层。

### 递归代码先写 recurrence

```cpp
int binarySearch(const vector<int>& a, int key, int left, int right) {
    if (left > right) {
        return -1;
    }

    int middle = (left + right) / 2;
    if (a[middle] == key) {
        return middle;
    }
    if (key < a[middle]) {
        return binarySearch(a, key, left, middle - 1);
    }
    return binarySearch(a, key, middle + 1, right);
}
```

每次只递归一个大小约为 $n/2$ 的子问题，本层只做常数工作，所以

$$
T(n)=T(n/2)+\Theta(1)=\Theta(\log n).
$$

这里不能因为代码中出现两个 recursive-call 语句就写成 $2T(n/2)$：一次实际执行只会进入其中一个分支。
