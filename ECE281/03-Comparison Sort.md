
排序就是把大小为 $N$ 的数组按一个一致的比较规则重排；默认采用 ascending order。比较排序（comparison sort）只靠元素之间的比较来获得顺序信息，因此本章的快慢、稳定性和额外空间可以放在同一张地图里看。

## 评价排序算法时到底看什么

- **时间**：通常分别看 average case 与 worst case。
- **in place**：额外内存是否为 $O(1)$。递归调用栈也算额外空间，不能只盯着数组本身。
- **stable**：相等 key 的记录是否保持原来的先后顺序。

稳定性在多关键字排序时才显出价值。若要按 $(a,b)$ 排序，可以先稳定地按 $b$ 排，再稳定地按 $a$ 排；第二次排序碰到相同 $a$ 时，第一次建立的 $b$ 顺序才不会丢失。

## 三个简单比较排序

**Insertion sort** 维护左侧已排序区：每次取下一个元素，向右挪动所有比它大的已排序元素，再把它塞进空位。它 in place 且 stable；最坏和平均为 $O(N^2)$，但数组已经有序时只需线性扫描，因而是 $O(N)$。

**Selection sort** 每一轮从未排序部分找最小元素，放到当前位置。它能把元素直接放到最终位置，但每轮仍需线性扫描，故时间为 $O(N^2)$；交换可能打乱相等元素的相对顺序，所以不稳定。

**Bubble sort** 反复比较相邻元素并交换逆序对，每轮把当前最大的元素“冒”到末端。它 in place；由于相等元素不交换，所以稳定，但最坏和平均时间仍是 $O(N^2)$。

这类算法的问题不只是“循环多”：一次比较通常只得到很少的顺序信息，且元素常被一步一步搬动。merge sort 与 quick sort 的目标，是让一次结构性操作带来更多进展。

## Merge sort：分得简单，合得认真

merge sort 的主线是 divide-and-conquer：把数组切成两半，分别排好，再把两个有序结果合并。切分不需要聪明选择；真正利用“有序”信息的是 merge。

![[Pasted image 20260826105045-01.png]]

上图不是在展示完整递归树，而是在强调一个不变事实：递归返回时，两边已经各自有序。因此 merge 只需比较两边当前最小的未处理元素，把较小者写入结果；任一边耗尽后，把另一边剩余元素直接接上。用两个指针而不是物理删除元素，就能在线性时间内完成：

$$
T_{merge}(N)=\Theta(\text{sizeA}+\text{sizeB})=\Theta(N).
$$

若相等时优先取左侧元素，左侧相等项会先于右侧相等项写入，因而 merge sort stable。代价是辅助数组通常需要 $O(N)$ 空间；递归栈另需最多 $O(\log N)$，所以它不是 in place。

### 递推式与 Master Method

对 $N$ 个元素，merge sort 有两个大小近似为 $N/2$ 的子问题，外加一次线性合并：

$$
T(N)=2T(N/2)+O(N).
$$

Master Method 处理的通用形式为

$$
T(n)\le aT(n/b)+O(n^d),
$$

其中 $a$ 是递归调用数，$b$ 是规模缩小因子，$O(n^d)$ 是每层本地工作。它要求子问题规模大致相等；不平衡递归不能直接套用。比较 $a$ 与 $b^d$：

$$
T(n)=
\begin{cases}
O(n^d\log n),&a=b^d,\\
O(n^d),&a<b^d,\\
O(n^{\log_ba}),&a>b^d.
\end{cases}
$$

merge sort 中 $a=2,b=2,d=1$，恰好 $a=b^d$，所以为 $O(N\log N)$。

## Quick sort：分得关键，合得几乎免费

quick sort 先选一个 pivot，完成 partition 后让所有小于 pivot 的元素在左边、其余元素在右边，并把 pivot 放到自己的最终位置。pivot 不需要再参与递归；只递归两侧。与 merge sort 正好相反：merge sort 的分割简单、合并复杂；quick sort 的 partition 复杂、递归返回后不需显式合并。

当有一个额外数组时，可以把小于 pivot 的元素从左端写入、其余元素从右端写入，但这会使用额外空间。下面代码改用一个更容易实现的 in-place partition：先把最右端元素当作 pivot，再让 `boundary` 标记“小于 pivot 区”的下一个空位。扫描到较小元素时，就把它换到 `boundary`，最后再把 pivot 放进去。

整个数组只被扫描一次，所以 partition 是 $O(N)$。这也解释了 quick sort 每一层的“本地工作”是线性的；难点变成 pivot 把数组切得是否平衡。

### pivot 决定递归形状

一般递推式为

$$
T(N)=T(\text{LeftSz})+T(\text{RightSz})+O(N),
\qquad \text{LeftSz}+\text{RightSz}=N-1.
$$

若每次 pivot 都是最小或最大元素，递归会变成一边大小为 $N-1$ 的长链：

$$
T(N)=T(N-1)+T(0)+O(N)=O(N^2).
$$

若每次近似二分，则得到和 merge sort 相似的 $O(N\log N)$。随机选 pivot 的结论更重要：对任何固定输入，average runtime 为 $O(N\log N)$；这里的平均来自算法的随机 pivot 序列，而不是假设输入数组随机。

quick sort 的 partition 可以原地进行，但递归栈仍存在：worst case 为 $O(N)$，average case 为 $O(\log N)$。它通常不稳定；课件称其为“weakly” in place，正是因为栈空间不能完全忽略。

## 选择时的速查

| 算法 | worst case | average case | in place | stable |
|---|---:|---:|---|---|
| Insertion | $O(N^2)$ | $O(N^2)$ | 是 | 是 |
| Selection | $O(N^2)$ | $O(N^2)$ | 是 | 否 |
| Bubble | $O(N^2)$ | $O(N^2)$ | 是 | 是 |
| Merge | $O(N\log N)$ | $O(N\log N)$ | 否 | 是 |
| Quick | $O(N^2)$ | $O(N\log N)$ | 弱 in place | 否 |

<span class="green">比较排序的“快”不是每次比较突然知道更多数值，而是把比较结果组织成更好的结构：merge 利用两个有序区，quick sort 利用 pivot 一次固定一个元素的位置。</span>

## 五种比较排序的代码落地

### Insertion sort

```cpp
void insertionSort(vector<int>& a) {
    int n = a.size();

    for (int i = 1; i < n; i++) {
        int key = a[i];
        int j = i;

        while (j > 0 && a[j - 1] > key) {   // 0 ~ i-1 都已经从小到大排好
            a[j] = a[j - 1];
            j--;    // a[j]继续往前挪，寻找着可以插入的位置
        }
        a[j] = key;  // a[j - 1] <= key，这个位置原a[i]可以插入！
    }
}
```
1, 2, 4, 5,    3
`a[0..i-1]` 始终是已排序区。while loop 不是不断交换，而是先把较大元素整体右移，最后只写一次 `key`。条件使用 `>` 而不是 `>=`，因此相等元素不会越过彼此，算法保持 stable。

### Selection sort

```cpp
void selectionSort(vector<int>& a) {
    int n = a.size();

    for (int i = 0; i < n - 1; i++) {
        int minPos = i;
        for (int j = i + 1; j < n; j++) {
            if (a[j] < a[minPos]) {
                minPos = j;
            }
        }
        swap(a[i], a[minPos]);
    }
}
```

第 $i$ 轮结束后，`a[i]` 已是未排序区最小值并到达最终位置。无论输入是否已经有序，寻找 `minPos` 都要扫描剩余区，所以仍是 $\Theta(n^2)$。最后的跨距离 swap 可能越过相等元素，因此通常不 stable。

### Bubble sort

```cpp
void bubbleSort(vector<int>& a) {
    int n = a.size();

    for (int end = n - 1; end > 0; end--) {
        bool swapped = false;
        for (int i = 0; i < end; i++) {
            if (a[i] > a[i + 1]) {
                swap(a[i], a[i + 1]);
                swapped = true;
            }
        }
        if (!swapped) {
            break;
        }
    }
}
```

每轮把当前最大值推到 `a[end]`，所以下一轮不再检查已固定的尾部。`swapped` 让已经有序的输入在一轮后停止，得到 $O(n)$ best case；相等时不交换，所以 stable。

### Merge sort

先看 merge 本身。它假设 `[left, middle]` 与 `[middle+1, right]` 已分别有序：

```cpp
void merge(vector<int>& a, int left, int middle, int right) {
    vector<int> temp;
    int i = left;
    int j = middle + 1;

    while (i <= middle && j <= right) {
        if (a[i] <= a[j]) {
            temp.push_back(a[i]);
            i++;
        } else {
            temp.push_back(a[j]);
            j++;
        }
    }
    while (i <= middle) {
        temp.push_back(a[i]);
        i++;
    }
    while (j <= right) {
        temp.push_back(a[j]);
        j++;
    }

    for (int k = 0; k < temp.size(); k++) {
        a[left + k] = temp[k];
    }
}
```

两个指针 `i`、`j` 分别指向两段中尚未处理的最小元素；较小者进入 `temp`，对应指针再前进。某一段耗尽后，剩余元素已经有序，可以直接接到后面。

递归部分反而很短：分成两半、分别排序、最后 merge。

```cpp
void mergeSort(vector<int>& a, int left, int right) {
    if (left >= right) {
        return;
    }

    int middle = (left + right) / 2;
    mergeSort(a, left, middle);
    mergeSort(a, middle + 1, right);
    merge(a, left, middle, right);
}
```

代码使用闭区间 `[left, right]`；例如排序整个数组时调用 `mergeSort(a, 0, a.size() - 1)`。merge 中相等时先取左侧的 `a[i]`，正是 stability 在代码里的具体来源。这里为了让步骤清楚，直接在每次 merge 时建立临时数组；之后若要优化内存，再把 `temp` 提到函数外复用。

### Quick sort

```cpp
int partition(vector<int>& a, int left, int right) {
    int pivot = a[right];
    int boundary = left;

    for (int scan = left; scan < right; scan++) {
        if (a[scan] < pivot) {
            swap(a[boundary], a[scan]);
            boundary++;
        }
    }
    swap(a[boundary], a[right]);
    return boundary;
}

void quickSort(vector<int>& a, int left, int right) {
    if (left >= right) {
        return;
    }

    int pivotPos = partition(a, left, right);
    quickSort(a, left, pivotPos - 1);
    quickSort(a, pivotPos + 1, right);
}
```

`boundary` 左侧始终保存已经扫描过且小于 pivot 的元素；`scan` 与 `right-1` 之间是尚未检查的区域。最后把 pivot 交换到 `boundary`，它便到达最终位置。实际使用时可随机选择一个下标并先与 `a[right]` 交换，以避免固定末项 pivot 被有序输入稳定地触发 worst case。

最后还有一个下界：任何只根据两两比较进行排序的算法，在 worst case 都需要 $\Omega(N\log N)$ 次操作。要突破这个界，需要改变信息来源，而不是继续打磨 comparison sort；下一章的 counting、bucket 与 radix sort 正是这样做的。
