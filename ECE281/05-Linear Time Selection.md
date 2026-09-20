
selection problem 不要求把整个数组排好，只要求第 $i$ 小的元素。对含 $n$ 个互异数的数组 $A$，输入是 $A$ 和从 $1$ 开始计数的 $i$，输出第 $i$ 小项。$i=1$ 是最小值，$i=n$ 是最大值，$i=n/2$ 对应 median；这些特例都能线性扫描完成。

当然可以先排序再取第 $i$ 项，时间为 $O(n\log n)$。但这做了许多与目标无关的工作：selection 只需要确认一个元素的 rank，不需要确认所有元素彼此的顺序。partition 恰好提供了这种“只保留有用一边”的能力。

## 从 quick sort 的 partition 到选择

partition 后，pivot 位于最终 rank $j$：左侧全小于它，右侧全大于它。若要找第 $i$ 小项：

- 若 $j=i$，pivot 就是答案。
- 若 $j>i$，答案一定在左侧，继续找左侧的第 $i$ 小。
- 若 $j<i$，答案一定在右侧；右侧内部要找第 $i-j$ 小。

与 quick sort 的区别只有一句：quick sort 递归两边以完成排序，selection 只递归包含答案的一边。也就是说，partition 不仅放置 pivot，还一次排除了另一整个子数组。

## Randomized selection (Rselect)

Rselect 每轮均匀随机选择 pivot，再执行上述分支。它保留 partition 的线性本地代价，但输入规模只沿一条递归路径下降。

```text
Rselect(A, n, i)
  if n = 1: return A[1]
  随机选 pivot 并 partition，记 pivot 的 rank 为 j
  if j = i: return pivot
  if j > i: return Rselect(左侧, j-1, i)
  else: return Rselect(右侧, n-j, i-j)
```

对任意固定输入，Rselect 的 average runtime 是 $O(n)$。这里的平均只来自算法随机选择的 pivot，不依赖“输入数组随机”。worst case 仍可能连续选到极端 pivot，因此仍可退化；随机化是把这种坏递归形状变成低概率事件。

### 为什么期望是线性的

一次递归若选到中间一半的 pivot，即分割比例 $a\in[1/4,3/4]$，继续处理的数组最多为原来的 $3/4$，称其为 good pivot。这样的 pivot 占一半位置，概率至少为 $1/2$；等到一个 good pivot 的期望尝试次数至多为 $2$，就像不断抛公平硬币直到第一次正面。

把规模在 $((3/4)^{r+1}n,(3/4)^rn]$ 的调用归为 phase $r$，每次调用的 partition 至多花 $c(3/4)^rn$。每个 phase 的期望调用数至多为 $2$，所以

$$
\mathbb{E}[\text{runtime}]
\le 2cn\sum_{r\ge0}\left(\frac34\right)^r
=8cn=O(n).
$$

这里不是 Master Method：我们没有两条递归分支，而是在每一轮随机地保留一边；证明的关键是“每阶段的期望尝试次数有常数上界”。

## Deterministic selection (Dselect)

随机 pivot 实践中很好用，但如果需要对每个输入都保证线性 worst case，就要主动构造一个“足够好”的 pivot。median 本身最佳，却又是我们正在求的对象；median of medians 通过较小的同类问题打破这个循环。

ChoosePivot 的步骤确实是有限的，因此适合记成流程：

1. 把数组分为每组 $5$ 个元素的小组。
2. 排好每一组，取每组中位数，组成新数组 $C$。
3. 递归地找出 $C$ 的中位数，并把它作为 pivot。

Dselect 随后和 Rselect 一样 partition，并只递归答案所在的一边；不同之处是它为获得 pivot 先递归处理 $C$。小组排序一组只含 $5$ 个元素，单组代价是常数，全部 $n/5$ 组加起来仍为 $\Theta(n)$。

![[Pasted image 20260826105046-02.png]]

图把每组排序后排成列，圈出的各组 median 再选出新的 pivot。pivot 左右各至少能得到约 $30\%$ 的元素：一半组的 median 不大于 pivot，而每个这样的完整组至少有 $3$ 个元素不大于自己的 median；另一侧同理。因此 partition 后继续递归的那一边至多约为 $0.7n$。边界处的不完整组和取整只改常数，不改变这个保证。

### 递推式为何仍是线性

若把每层的分组、组内排序、复制中位数与 partition 合并为 $cn$，则

$$
T(n)\le cn+T(n/5)+T(7n/10).
$$

两个子问题大小不同，所以不能直接套 Master Method。课件采用“hope and check”：猜测 $T(n)\le an$，再用归纳验证。取 $a=10c$，有

$$
T(n)\le cn+10c\frac n5+10c\frac{7n}{10}=10cn.
$$

因此 Dselect 对每个输入都在 $O(n)$ 时间内完成。它的代价是常数更大、还要保存约 $n/5$ 个中位数，因而 not in place；课件也提醒它实践中通常不如 Rselect 快。

<span class="green">selection 的线性时间并不是“神奇地少比较”，而是每次 partition 都把一大块不可能含答案的元素永久丢出问题；随机算法期望做到这一点，median of medians 则保证做到这一点。</span>

## Rselect 的实际实现

下面把目标 rank 写成数组的零起点下标 `k`，并复用 quick sort 的 partition。随机 pivot 先换到末尾，再由 partition 放到最终位置。

```cpp
int partition(vector<int>& a, int left, int right, int pivotIndex) {
    int pivot = a[pivotIndex];
    swap(a[pivotIndex], a[right]);
    int boundary = left;

    for (int i = left; i < right; i++) {
        if (a[i] < pivot) {
            swap(a[i], a[boundary]);
            boundary++;
        }
    }
    swap(a[boundary], a[right]);
    return boundary;
}
```

`partition` 只负责一件事：把 pivot 放到最终位置，并返回这个位置。Rselect 再比较 `k` 与 `pivotPos`，决定下一轮保留哪一边：

```cpp
int rselect(vector<int>& a, int left, int right, int k) {
    while (left < right) {
        int pivotIndex = left + rand() % (right - left + 1);
        int pivotPos = partition(a, left, right, pivotIndex);

        if (k == pivotPos) {
            return a[pivotPos];
        }
        if (k < pivotPos) {
            right = pivotPos - 1;
        } else {
            left = pivotPos + 1;
        }
    }
    return a[left];
}
```

`rand() % 区间长度` 在当前范围内选出一个 pivot 下标；这不是高质量随机数写法，但足以展示算法步骤，而且不引入额外的 C++11 工具。while loop 表达的仍是“每轮只保留含 `k` 的一侧”。调用 `rselect(a, 0, a.size()-1, i-1)` 就是在找从 $1$ 开始计数的第 $i$ 小元素。

## Median of medians 的 pivot

每组最多只有 $5$ 个元素，直接用 insertion sort 即可；无论怎样排列，一组的工作量都视为常数：

```cpp
void sortSmallGroup(vector<int>& a, int left, int right) {
    for (int i = left + 1; i <= right; i++) {
        int key = a[i];
        int j = i;
        while (j > left && a[j - 1] > key) {
            a[j] = a[j - 1];
            j--;
        }
        a[j] = key;
    }
}
```

ChoosePivot 用这个 helper 排好各组，再把每组 median 搬到数组前方：

```cpp
int dselect(vector<int>& a, int left, int right, int k);

int choosePivot(vector<int>& a, int left, int right) {
    int count = right - left + 1;
    if (count <= 5) {
        sortSmallGroup(a, left, right);
        return left + count / 2;
    }

    int medians = 0;
    for (int start = left; start <= right; start = start + 5) {
        int end = min(start + 4, right);
        sortSmallGroup(a, start, end);
        int median = start + (end - start) / 2;
        swap(a[left + medians], a[median]);
        medians++;
    }

    int medianRank = left + medians / 2;
    dselect(a, left, left + medians - 1, medianRank);
    return medianRank;
}
```

循环每次只处理最多 $5$ 个元素，并把该组 median 换到数组前方。循环结束时，前 `medians` 个位置就组成了课件中的数组 $C$；递归的 `dselect` 会把 $C$ 的 median 放到 `medianRank`。

Dselect 的主体与 Rselect 几乎一样，唯一变化是 pivot 不再随机选择：

```cpp
int dselect(vector<int>& a, int left, int right, int k) {
    while (left < right) {
        int pivotIndex = choosePivot(a, left, right);
        int pivotPos = partition(a, left, right, pivotIndex);
        if (k == pivotPos) {
            return a[pivotPos];
        }
        if (k < pivotPos) {
            right = pivotPos - 1;
        } else {
            left = pivotPos + 1;
        }
    }
    return a[left];
}
```

`choosePivot` 负责保证 pivot 不会太极端，`partition` 负责确定它的 rank，最后只保留含 `k` 的一边。这三项职责分开后，median of medians 和普通 selection 的关系就清楚了。

这份实现假设 keys distinct，与课件设定一致。若允许大量 duplicate keys，最好改用 three-way partition，把 `< pivot`、`== pivot`、`> pivot` 分成三段，否则 rank 判断与性能分析都需要额外处理。
