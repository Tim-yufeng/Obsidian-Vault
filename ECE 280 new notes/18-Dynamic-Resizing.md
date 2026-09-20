# 18 Dynamic Resizing

固定容量的 dynamic array 仍然要求 caller 提前猜测最大 size。Dynamic resizing 把这项责任收回 class 内部：容量用完时自己申请更大的 array、复制内容、释放旧空间。真正的重点不是“能变大”，而是增长策略如何把反复复制从 quadratic 降到 linear total cost。

## Rule of the Big Three recap

拥有 dynamically allocated storage 的 class 必须自行管理 ownership，因此通常同时需要 destructor、copy constructor 与 assignment operator。只写 destructor 会让默认 copy 仍然复制 pointer，产生 shallow copy、double deletion 或 dangling pointer。

若 derived class 没有增加自己的 resource，base-class 部分会由 base constructor / destructor / copy logic 处理；一旦 derived class 自己也拥有 resource，就要为新增 ownership 设计相应的 copy 与 destruction。

## 从 fixed capacity 到 grow()

原来的 `insert` 在 array full 时 throw；dynamic version 改为调用 private `grow()`：

```cpp
void IntSet::insert(int value) {
    if (indexOf(value) == sizeElts) {
        if (numElts == sizeElts) {
            grow();
        }
        elts[numElts++] = value;
    }
}
```

`grow()` 的 contract 是扩大 `elts`，同时保留所有现有 elements。它必须按以下顺序工作：

1. Allocate a bigger array.
2. Copy old elements into it.
3. Delete the old array.
4. Update `elts` 与 `sizeElts`。

不能先 delete 再 copy，因为旧 values 会立刻丢失；也不能忘记 delete，否则每次 grow 都 memory leak。

## 每次只增加一个 slot

```cpp
void IntSet::grow() {
    int *tmp = new int[sizeElts + 1];
    for (int i = 0; i < numElts; ++i) {
        tmp[i] = elts[i];
    }
    delete[] elts;
    elts = tmp;
    sizeElts += 1;
}
```

若初始 capacity 为 $1$，依次插入 $N$ 个互不相同的 elements，每次 array full 都要 grow。Copy count 是：

$$
T(N)=1+2+\cdots+(N-1)=\frac{N(N-1)}{2}.
$$

因此总复制量是 quadratic。问题在于每复制 $k$ 个 elements，只买到一个额外 slot，很快又要把同一批 data 复制一遍。

## Capacity doubling

```cpp
void IntSet::grow() {
    int new_capacity = sizeElts == 0 ? 1 : sizeElts * 2;
    int *tmp = new int[new_capacity];

    for (int i = 0; i < numElts; ++i) {
        tmp[i] = elts[i];
    }

    delete[] elts;
    elts = tmp;
    sizeElts = new_capacity;
}
```

若 capacities 依次是 $1,2,4,8,\ldots$，每次 grow 的 copy count 形成 geometric series。设 $2^m < N \le 2^{m+1}$，最多复制：

$$
T(N)=1+2+4+\cdots+2^m=2^{m+1}-1<2N.
$$

<span class="red">Doubling 不是让某一次 grow 变便宜，而是让昂贵 grow 发生得越来越稀疏，使一连串插入中的总复制数保持线性。</span>对前 $N$ 次插入，总复制数为 $O(N)$；单次触发 grow 的 insertion 仍是 $O(N)$，但平均到整串 append / insert 上，resize 部分的 amortized cost 是 $O(1)$。

## Representation invariant 与 exception boundary

Dynamic representation 至少应保证：

- `0 <= numElts <= sizeElts`；
- `elts` 指向一个具有 `sizeElts` 个 slots 的 owned array；
- 前 `numElts` 个 slots 表示 set 的 elements，且无 duplicates；
- object 独占自己负责 delete 的 array。

先成功 allocate 和 copy，再改变 object 的 fields，可以让失败边界更清楚：在 `new` 抛出异常前，旧 object 仍保持原状。更新 `elts` 后必须同步更新 capacity，避免 pointer 与 metadata 指向不同版本。

## 复杂度对比

| Growth policy | 前 $N$ 个不同元素触发的总 copies | 特征 |
|---|---:|---|
| 每次 `+1` | $N(N-1)/2$ | 浪费少量空 slot，但复制极频繁 |
| 每次 `*2` | $<2N$ | 保留额外 capacity，换取更少复制 |

这是一种 time-space tradeoff：doubling 会暂时留出未使用空间，但显著降低反复搬运的时间。

参考材料：Problem Solving with C++ (8th Edition) Chapter 11.4。
