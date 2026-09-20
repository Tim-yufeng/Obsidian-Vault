哈希表的平均常数时间不是建表后永久成立的保证。随着元素增加，load factor $L=|S|/n$ 上升，probe 或链表都会变长；因此 table size 必须从性能要求反推，并在越过阈值时 rehash。

## 从性能要求决定表长

设计顺序是：先规定可接受的平均查找代价，由上一章的公式得到最大 load factor，再估计最大元素数 $N$。若要求 $L\le4/5$，且预计最多保存 $1000$ 个元素，则

$$
n\ge\frac{1000}{4/5}=1250.
$$

最后在这个下界附近选择合适的 prime number 作为 table size，以减弱 key 模式与取模周期的关系。

## Rehashing

rehash 不是把旧下标原样复制到更长数组。因为 table size 改变后，`hashCode % tableSize` 的结果也会改变；正确步骤是新建更大的表，扫描旧表，并用新 hash function 逐项重新插入。

```cpp
void rehash() {
    Slot oldTable[MAX_SIZE];
    int oldSize = tableSize;

    for (int i = 0; i < oldSize; i++) {
        oldTable[i] = table[i];
    }

    tableSize = nextPrime(oldSize * 2);
    for (int i = 0; i < tableSize; i++) {
        table[i].state = EMPTY;
    }
    itemCount = 0;

    for (int i = 0; i < oldSize; i++) {
        if (oldTable[i].state == OCCUPIED) {
            insertWithoutResize(oldTable[i].key, oldTable[i].value);
        }
    }
}
```

`rehash` 的三个 loops 分别“保存旧表”“清空新表”和“把旧元素重新插入”。这里假设 `table`、`tableSize`、`itemCount`、`maxLoad` 属于前一章的 hash table，`insertWithoutResize` 表示只插入但不再次触发扩容。

普通 insert 只需在插入前检查下一步的 load factor：

```cpp
void insert(int key, string value) {
    double nextLoad = double(itemCount + 1) / tableSize;
    if (nextLoad > maxLoad) {
        rehash();
    }
    insertWithoutResize(key, value);
}
```

重新插入时必须计算新 bucket，不能把旧下标照搬过来。代码先判断插入后的 load factor，避免刚完成插入就越界；`DELETED` slot 也不应搬入新表。

## 为什么偶尔的 $O(n)$ 不会毁掉平均插入

单次 rehash 要扫描旧表，确实是 $O(n)$。但它不会每次插入都发生。若每次达到阈值后把容量翻倍，连续扩容搬运的元素数形成几何级数：

$$
1+2+4+\cdots+M<2M.
$$

再加上 $M$ 次普通插入，完成整段操作的总成本仍是 $O(M)$，所以每次插入的 **amortized cost** 是 $O(1)$。amortized analysis 不是概率平均；它考察任意一长串操作，把少数昂贵操作分摊到许多便宜操作上。

## 应用一：de-duplication

维护一个 `seen` hash set。下面把上一章已经实现的哈希操作写成 `seen.hasKey(x)` 与 `seen.insert(x)`，只突出 de-duplication 的思路：

```cpp
vector<int> uniqueValues(const vector<int>& input) {
    HashSet seen;
    vector<int> result;

    for (int i = 0; i < input.size(); i++) {
        int value = input[i];
        if (!seen.hasKey(value)) {
            seen.insert(value);
            result.push_back(value);
        }
    }
    return result;
}
```

第一次看见一个 value 时才同时登记和输出，因此 `result` 会保留各个不同 value 首次出现的顺序。若哈希操作平均为 $O(1)$，整个过程平均为 $O(n)$，代价是额外 $O(n)$ 空间。

## 应用二：2-SUM

要判断数组中是否有两个不同位置的数之和为 target，扫描到 $x$ 时只需询问补数 `target - x` 是否已经出现：

```cpp
bool hasTwoSum(const vector<int>& a, int target) {
    HashSet seen;

    for (int i = 0; i < a.size(); i++) {
        int needed = target - a[i];
        if (seen.hasKey(needed)) {
            return true;
        }
        seen.insert(a[i]);
    }
    return false;
}
```

变量 `needed` 明确表示“当前值还差多少才能得到 target”。先查再插保证 `a[i]` 只能和之前的元素配对，不会把同一个数组位置使用两次。哈希表把“在先前元素中找 needed”降为 average $O(1)$，所以整体 average time 为 $O(n)$。

## 什么时候不要用 hash table

hash table 擅长 exact key lookup，却不维护顺序。若任务需要 sorted output、min/max、predecessor/successor、rank 或 range search，hash table 往往要额外扫描或排序；后面的 binary search tree 正是为了同时保留可搜索的顺序结构。
