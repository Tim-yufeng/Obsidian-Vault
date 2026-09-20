BST 的 `search`、`insert`、`remove` 都沿一条 access path 前进，因此对一棵确定的树，成功查找深度为 $d$ 的节点需要访问 $d+1$ 个节点，时间是 $\Theta(d+1)$，整体 worst case 是 $O(h)$。

真正的问题不是递归代码有几行，而是插入顺序把树塑造成什么形状。同一组 keys 若按中间值优先插入，可能得到较矮的树；若按递增顺序插入，就会变成 right-skewed chain。

## Internal path length

若 $n$ 个节点的 depths 为 $d_1,\ldots,d_n$，定义 internal path length

$$
I(T)=\sum_{i=1}^{n}d_i.
$$

假设一次成功搜索等概率落到任意节点，平均访问代价为

$$
\Theta\left(1+\frac{I(T)}n\right).
$$

这把“平均搜索多深”变成了“所有节点总深度有多大”。代码上可以直接递归计算这个量：

```cpp
int internalPathLength(Node* root, int depth) {
    if (root == NULL) {
        return 0;
    }

    return depth
         + internalPathLength(root->left, depth + 1)
         + internalPathLength(root->right, depth + 1);
}

double averageSuccessfulDepth(Node* root, int nodeCount) {
    int totalDepth = internalPathLength(root, 0);
    return double(totalDepth) / nodeCount;
}
```

第一次调用使用 `internalPathLength(root, 0)`，因为 root 的 depth 是 $0$。递归中的 `depth + 1` 正是在说：进入下一层后，节点离整棵树的 root 又远了一条 edge。

## 对随机插入顺序取平均

课件假设固定 keys $k_1<\cdots<k_n$ 的所有 insertion sequences 等可能。第一个插入的 key 成为 root；若它是第 $l+1$ 小，则 left subtree 有 $l$ 个节点，right subtree 有 $n-l-1$ 个节点，而且每种 $l$ 出现概率都是 $1/n$。

把 $I(n)$ 记为所有随机插入顺序下的 average internal path length。两棵 subtree 挂到 root 下时，除自身 internal path length 外，其余 $n-1$ 个节点的 depth 都多 $1$，所以

$$
I(n)=\frac1n\sum_{l=0}^{n-1}\bigl(I(l)+I(n-l-1)\bigr)+(n-1)
=\frac2n\sum_{l=0}^{n-1}I(l)+(n-1).
$$

课件通过相邻规模递推，把它化到 harmonic sum，并得到

$$
\frac{I(n)}{n+1}<2\sum_{k=2}^{n}\frac1k<2\ln n.
$$

因此 $I(n)=O(n\log n)$，成功搜索的 average time 为

$$
O\left(\frac{I(n)}n+1\right)=O(\log n).
$$

unsuccessful search、insert 和 remove 也都沿一条随机树中的 search path，因此 average time 同样是 $O(\log n)$。

## “Average” 到底平均什么

这里不是说任何实际 BST 都自动拥有 $O(\log n)$。结论平均的是同一组 distinct keys 的所有 insertion sequences，也就是假设插入次序随机。若输入长期有序，普通 BST 仍可能稳定地产生 $O(n)$ 高度。

```cpp
for (int x = 1; x <= n; ++x) insert(root, x, "");
```

这段代码会让每个新节点都进入 right subtree，最后搜索最大 key 要走过全部 $n$ 个节点。若需要 worst-case $O(\log n)$，必须主动维护 balance；AVL tree 会在第 16 章处理这个问题。
