hash table 的 exact lookup 平均更快，但它不保存 key 的顺序。BST 的价值在于顺序就在结构中，因此除了 search/insert/remove，还能有效完成 sorted output、min/max、predecessor/successor、rank search 与 range search。

## Sorted output 与 min/max

in-order traversal 按 left、node、right 访问，BST 的 invariant 立即保证输出递增，时间为 $O(n)$。

```cpp
void printSorted(Node* root) {
    if (root == NULL) {
        return;
    }
    printSorted(root->left);
    cout << root->key << ' ';
    printSorted(root->right);
}

Node* findMin(Node* root) {
    if (root == NULL) {
        return NULL;
    }
    while (root->left != NULL) {
        root = root->left;
    }
    return root;
}

Node* findMax(Node* root) {
    if (root == NULL) {
        return NULL;
    }
    while (root->right != NULL) {
        root = root->right;
    }
    return root;
}
```

min/max 沿单一路径走到底，因此为 $O(h)$，average $O(\log n)$。

## Successor 与 predecessor

节点 $x$ 的 successor 是比它大的最小 key。若 `x->right` 非空，答案就是 right subtree 的 minimum；否则向 parent 走，直到第一次从某个 parent 的 left subtree 返回，该 parent 才是答案。

下面假设节点结构在 `left`、`right` 之外还保存了 `Node* parent`：

```cpp
Node* successor(Node* x) {
    if (x->right != NULL) {
        return findMin(x->right);
    }

    Node* p = x->parent;
    while (p != NULL && x == p->right) {
        x = p;
        p = p->parent;
    }
    return p;
}
```

“一直从右边回来”表示沿途 ancestors 都比当前 key 小，不能成为 successor。predecessor 完全对称：先看 left subtree 的 maximum，否则向上找到第一次从 right child 返回的 parent。

## 用 leftSize 支持 rank search

为每个节点增加 `leftSize`，表示 left subtree 的节点数。那么当前 root 在自己的 subtree 中 rank 恰好为 `leftSize`，这里按 $0$ 开始计数。

```cpp
struct RankNode {
    int key;
    int leftSize;
    RankNode* left;
    RankNode* right;
};

RankNode* rankSearch(RankNode* root, int rank) {
    if (root == NULL) {
        return NULL;
    }
    if (rank == root->leftSize) {
        return root;
    }
    if (rank < root->leftSize) {
        return rankSearch(root->left, rank);
    }
    return rankSearch(root->right, rank - root->leftSize - 1);
}
```

进入 right subtree 时，要跳过 left subtree 的 `leftSize` 个节点和 root 自己，所以新 rank 是 `rank - leftSize - 1`。查找仍只走一条 path，为 $O(h)$。

这个速度不是免费的：insert/remove 若改变了某节点的 left subtree 大小，就必须同步更新 access path 上的 `leftSize`。额外字段让查询更快，也引入了必须维护的新 invariant。

## Range search：只进入可能相交的 subtree

寻找所有 $[low,high]$ 内的 keys 时，不必遍历整棵树：若 `root->key > low`，left subtree 才可能有答案；若 `root->key < high`，right subtree 才可能有答案。把当前节点放在两次递归之间还能保持递增输出。

```cpp
void rangeSearch(Node* root, int low, int high, vector<int>& out) {
    if (root == NULL) {
        return;
    }

    if (root->key > low) {
        rangeSearch(root->left, low, high, out);
    }

    if (low <= root->key && root->key <= high) {
        out.push_back(root->key);
    }

    if (root->key < high) {
        rangeSearch(root->right, low, high, out);
    }
}
```

worst case 仍可能访问 $n$ 个节点，例如范围覆盖整棵树。若树平衡且只输出 $k$ 个结果，典型复杂度可写成 $O(\log n+k)$：先用对数路径到达范围边界，再为每个输出元素付出常数工作。

## 为什么 BST 仍然值得用

| 操作 | Hash table average | Balanced BST |
|---|---:|---:|
| exact find/insert/remove | $O(1)$ | $O(\log n)$ |
| min/max | $O(n)$ | $O(\log n)$ |
| successor/predecessor | 不直接支持 | $O(\log n)$ |
| sorted output | 需另行排序 | $O(n)$ |
| range search | 通常需扫描 | $O(\log n+k)$ |

选择数据结构时要从需要支持的整组操作出发，不能只比较 `find` 的一项复杂度。
