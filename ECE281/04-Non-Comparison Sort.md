
comparison sort 的 $\Omega(N\log N)$ 下界只约束“通过两两比较确定顺序”的算法。若 key 本身提供了可直接利用的结构，例如小范围整数、均匀分布区间或固定进制的数字，我们可以不问“谁比谁大”，而改问“它属于哪个位置或桶”。这就是 non-comparison sort 的入口。

## Counting sort：先数位置，再放记录

设数组中的整数 key 都在已知范围 $[0,k]$。最简单版本开一个长度为 $k+1$ 的计数数组，扫描输入并令 $C[x]$ 记录 key 为 $x$ 的数量；随后按 $0$ 到 $k$ 输出每个值 $C[x]$ 次。它的时间为

$$
O(N+k).
$$

这个版本只能输出整数 key，本身不能保留与 key 绑定的记录。通用版本的关键变化是把 $C$ 从“出现次数”变成“最终位置的边界”：先累加得到

$$
C[i]=\#\{x\mid x\le i\}.
$$

于是 $C[i]$ 指向 key 为 $i$ 的记录在输出数组中的最后一个可用位置。把输入从右向左扫描，每次将 $A[i]$ 放到 $C[A[i]]$，再让该位置减一。倒序扫描不是随意的实现细节：相同 key 中，原数组更靠右的项先占据更靠右的位置，因而最终保留原有相对顺序，算法 stable。

![[Pasted image 20260826105046.png]]

图中四个阶段把同一个数组转成三种信息：原数组 $A$、频数表 $C$、累加后的“位置表”，最后才写入输出。真正要记住的是 $C[i]$ 的含义变化；若仍把它当作普通计数，最后一步就会不知该往哪里放。

counting sort 需要额外的计数数组和输出数组，空间也为 $O(N+k)$。它只在 key 范围 $k$ 相对可控时有优势；如果 $N$ 很小而 $k$ 极大，扫描一整张计数表反而不划算。

## Bucket sort：让局部比较取代全局比较

bucket sort 不要求 key 是简单整数。先把整个 key 范围划分为若干 bucket，再把每条记录 scatter 到对应 bucket；分别对非空 bucket 使用 comparison sort，最后按 bucket 顺序 gather 回原数组。

1. 建立一组空 bucket。
2. 扫描输入，把每个对象分发到相应 bucket。
3. 分别排序非空 bucket。
4. 按 bucket 编号依次收集结果。

它的线性 average time 不是无条件的。设有 $M$ 个元素、$N$ 个 bucket，且 $M/N=c>1$ 为常数；只有当元素在范围内近似均匀分布时，每个 bucket 的负担才保持常数级，整体 average time 才为 $O(M)$。若所有元素挤到一个 bucket，局部 comparison sort 会重新变慢。

## Radix sort：从最低位逐步固定顺序

对于使用 positional notation 的 key，例如十进制数、二进制数或定长字符串，radix sort 按位处理。LSD radix sort 从 least significant digit/bit (LSD) 到 most significant digit/bit (MSD)，每一轮都依据当前位做一次 **stable** bucket sort。

![[Pasted image 20260826105046-01.png]]

第一轮只按最低位分桶；同一桶里的顺序不能打乱，因为它已经携带了更低位建立的顺序。第二轮按下一位稳定排序后，较高位决定主要顺序，相同较高位时仍保留低位顺序。继续到最高位，整个数字自然有序。

形式化地说：完成第 $i$ 个低位的稳定 bucket sort 后，元素已经按最后 $i$ 位有序。$i=1$ 时直接成立；若第 $i+1$ 位不同，新一轮按该位决定先后；若相同，stability 保留原本按最后 $i$ 位的顺序。这就是课件的归纳证明。

若最大位数为 $k$、每轮 bucket sort 的代价为 $O(N)$，则

$$
T(N)=O(kN).
$$

这里通常把进制视为固定常数；若进制本身随问题增长，bucket 数也需要进入复杂度讨论。radix sort 可用于十进制和二进制表示，也可用于字符串或多关键字记录，只要每个位置都共享一套符号、而位置权重从低到高明确。

<span class="red">non-comparison sort 的速度来自 key 的额外结构；一旦这种结构或分布假设不成立，线性时间的结论也就没有理由成立。</span>

## 三种方法的代码落地

### Stable counting sort

```cpp
struct Record {
    int key;
    string data;
};

vector<Record> countingSort(const vector<Record>& a, int maxKey) {
    vector<int> count(maxKey + 1, 0);
    int n = a.size();

    for (int i = 0; i < n; i++) {
        count[a[i].key]++;
    }

    for (int key = 1; key <= maxKey; key++) {
        count[key] += count[key - 1];
    }

    vector<Record> out(n);
    for (int i = n - 1; i >= 0; i--) {
        int key = a[i].key;
        count[key]--;
        out[count[key]] = a[i];
    }
    return out;
}
```

累加后 `count[key]` 表示 key 不大于它的元素数，也是这类元素右边界的后一格。先 `--count[key]` 再作为零起点下标，正好得到最后一个空位；从右向左读取输入使相同 key 的相对顺序保持不变。

### Bucket sort

假设输入均在 $[0,1)$ 且近似均匀，可按数值范围映射到 $n$ 个 buckets：

```cpp
void bucketSort(vector<double>& a) {
    int n = a.size();
    vector< vector<double> > buckets(n);

    for (int i = 0; i < n; i++) {
        int bucketNumber = int(a[i] * n);
        buckets[bucketNumber].push_back(a[i]);
    }

    int next = 0;
    for (int i = 0; i < n; i++) {
        insertionSort(buckets[i]);
        for (int j = 0; j < buckets[i].size(); j++) {
            a[next] = buckets[i][j];
            next++;
        }
    }
}
```

`bucketNumber = int(a[i] * n)` 把 $[0,1)$ 切成 $n$ 个等宽区间。这里直接复用上一章的 `insertionSort` 排每个小 bucket；只需把参数类型从 `vector<int>` 改成 `vector<double>`，算法本身不变。这个映射公式依赖输入严格小于 $1$；若输入可能等于 $1$，必须另外处理边界。线性 average time 还依赖每个 bucket 平均只有常数个元素；若数据集中在一个小区间，局部排序仍可能承担接近全部工作。

### LSD radix sort

对非负十进制整数，每一位都用 stable counting sort。先把“按照某一位稳定排序”单独写成 helper：

```cpp
void sortByDigit(vector<int>& a, int place) {
    int count[10] = {0};
    int n = a.size();
    vector<int> out(a.size());

    for (int i = 0; i < n; i++) {
        int digit = (a[i] / place) % 10;
        count[digit]++;
    }
    for (int digit = 1; digit < 10; digit++) {
        count[digit] += count[digit - 1];
    }

    for (int i = n - 1; i >= 0; i--) {
        int digit = (a[i] / place) % 10;
        count[digit]--;
        out[count[digit]] = a[i];
    }
    a = out;
}
```

`place` 为 $1$、$10$、$100$ 时，`(a[i] / place) % 10` 分别取出个位、十位、百位。最后从右向左写入 `out`，使这一轮保持 stable。

主函数只负责从低位到高位反复调用这个 helper：

```cpp
void radixSort(vector<int>& a) {
    if (a.empty()) {
        return;
    }

    int maxValue = a[0];
    for (int i = 1; i < a.size(); i++) {
        if (a[i] > maxValue) {
            maxValue = a[i];
        }
    }

    for (int place = 1; maxValue / place > 0; place = place * 10) {
        sortByDigit(a, place);
    }
}
```

每轮 stable，才能保留之前较低位建立的顺序。这里假设数组只含非负整数；实际程序还要避免 `place = place * 10` 发生整数溢出。
