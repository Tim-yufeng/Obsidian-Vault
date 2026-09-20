普通 queue 按到达顺序服务；priority queue 按 key 表示的优先级服务。min priority queue 需要支持 `getMin`、`enqueue` 与 `dequeueMin`。binary min heap 同时利用 complete tree 的紧凑形状与 heap-order property，使前者为 $O(1)$，后两者为 $O(\log n)$。

## Min heap 的两个约束

1. **shape**：它必须是 complete binary tree，因此可以紧凑地存入数组。
2. **order**：任意节点的 key 不大于它所有 descendants 的 key。

第二条只约束 ancestor-descendant。左右 subtree 之间没有全局大小关系，所以 heap 不是 binary search tree；但每棵 subtree 的 root 一定是该 subtree 的最小值。

数组从下标 $1$ 开始时，`parent=i/2`、`left=2*i`、`right=2*i+1`。complete tree 的高度为 $\lfloor\log_2n\rfloor$，因此沿 parent 或 child 移动最多只有对数步。

## Enqueue：先保形状，再恢复顺序

新元素必须先放在数组末尾，这保证树仍 complete。若它小于 parent，就不断向上交换。

![[Pasted image 20260904120102.png]]

```cpp
const int MAX_SIZE = 101; // 下标 0 不使用，可保存 100 个元素
int heap[MAX_SIZE];
int heapSize = 0;

void percolateUp(int position) {
    while (position > 1 &&
           heap[position] < heap[position / 2]) {
        swap(heap[position], heap[position / 2]);
        position = position / 2;
    }
}

void enqueue(int value) {
    heapSize++;
    heap[heapSize] = value;  // 先放到最右边的新 leaf
    percolateUp(heapSize);
}
```

`enqueue` 先把新值放在 `heap[heapSize]`，所以 complete-tree shape 没有改变；`percolateUp` 只修复新节点到 root 的路径。每次 `position = position / 2` 都移动到 parent，故 worst case 是 $O(\log n)$。

## DequeueMin：拿走 root，让最后元素补位

最小值在 root。直接删除 root 会破坏 complete shape，因此先保存它，把最后一个元素移到 root，再让这个元素向下移动。每次必须和 **较小的 child** 交换，才能让新 parent 同时不大于两个 children。

![[Pasted image 20260904120103.png]]

```cpp
void percolateDown(int position) {
    while (2 * position <= heapSize) {
        int smallerChild = 2 * position;

        if (smallerChild + 1 <= heapSize &&
            heap[smallerChild + 1] < heap[smallerChild]) {
            smallerChild++;
        }
        if (heap[position] <= heap[smallerChild]) {
            break;
        }

        swap(heap[position], heap[smallerChild]);
        position = smallerChild;
    }
}

int dequeueMin() {
    int answer = heap[1];
    heap[1] = heap[heapSize];
    heapSize--;

    if (heapSize > 0) {
        percolateDown(1);
    }
    return answer;
}
```

`dequeueMin` 保存 root 后，用最后一个 leaf 补到 root，因此数组仍对应 complete tree。`percolateDown` 先找两个 children 中较小的一个，再决定是否交换；若和较大的 child 交换，较小的 child 仍可能违反 min-heap order。这里假设调用前 heap 非空。

## Bottom-up heap construction

逐个 enqueue 会花 $O(n\log n)$。更好的方法是先把所有元素按原顺序放入 complete tree，然后从最后一个非 leaf `n/2` 开始，逆序执行 `percolateDown`：

```cpp
void buildHeap(int values[], int n) {
    heapSize = n;
    for (int i = 0; i < n; i++) {
        heap[i + 1] = values[i];
    }

    for (int i = heapSize / 2; i >= 1; i--) {
        percolateDown(i);
    }
}
```

第一个 loop 只是把输入按 level order 放入数组；第二个 loop 从最后一个有 child 的位置 `heapSize / 2` 向 root 修复。它是 $O(n)$，并非 $O(n\log n)$，因为绝大多数节点靠近 leaf，能下沉的距离很短。

## Heap sort 与 median maintenance

先用 $O(n)$ build heap，再调用 $n$ 次 `dequeueMin`，便得到 $O(n\log n)$ 的排序。

在线维护 median 时，可用 max heap 保存较小的一半、min heap 保存较大的一半，并始终维持两边 size 最多相差 $1$。新元素先按边界值进入一侧，再把较大一侧的 root 搬到另一侧恢复平衡；每次更新只做常数次 heap 操作，因此为 $O(\log n)$。

```cpp
// smallHalf 是 max heap，largeHalf 是 min heap。
MaxHeap smallHalf;
MinHeap largeHalf;

void addNumber(int x) {
    if (smallHalf.isEmpty() || x <= smallHalf.getMax()) {
        smallHalf.enqueue(x);
    } else {
        largeHalf.enqueue(x);
    }

    if (smallHalf.size() > largeHalf.size() + 1) {
        largeHalf.enqueue(smallHalf.dequeueMax());
    } else if (largeHalf.size() > smallHalf.size()) {
        smallHalf.enqueue(largeHalf.dequeueMin());
    }
}
```

这里暂时把上一节已经掌握的 heap 操作当作接口，代码只展示“两边放置”和“数量再平衡”。它维护两个 invariant：`smallHalf` 中所有值不大于 `largeHalf` 中所有值，而且前者的元素数等于或比后者多一个。因此奇数个元素时 median 就是 `smallHalf.getMax()`。
