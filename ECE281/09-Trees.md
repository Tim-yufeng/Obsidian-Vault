tree 把 linked list 的“一条后继”推广为“多个 children”，因此天然适合表示文件目录、组织结构和递归拆分的问题。它的关键不是画成上下形状，而是节点之间存在唯一的 parent-child 路径。

## 基本术语

- **root** 没有 parent；其他节点恰好有一个 parent。
- 没有 children 的节点叫 **leaf**；共享 parent 的节点互为 siblings。
- 从 $A$ 到 $B$ 的 path 是一串连续 parent-child 关系；若存在这样的路径，$A$ 是 $B$ 的 ancestor，$B$ 是 $A$ 的 descendant。
- 节点的 depth/level 是 root 到该节点的 path length；节点的 height 是它到最远 leaf 的 path length。
- tree height 是 root 的 height；levels 数量等于 height $+1$。
- 节点 degree 是 children 数，tree degree 是所有节点 degree 的最大值。

depth 是“从上往下走了多远”，height 是“从这里还能往下走多远”。所有 leaf 的 height 都是 $0$，但它们的 depth 不一定相同。

## 一般树的 first-child/next-sibling 表示

一个节点可以有不定数量的 children。若直接为每个 child 留一个指针，节点大小无法固定；课件使用 `firstChild` 指向第一个孩子，再用 `nextSibling` 把同层孩子串起来：

```cpp
struct TreeNode {
    int item;
    TreeNode* firstChild;
    TreeNode* nextSibling;
};

int countNodes(TreeNode* root) {
    if (root == NULL) {
        return 0;
    }

    int total = 1;
    TreeNode* child = root->firstChild;

    while (child != NULL) {
        total = total + countNodes(child);
        child = child->nextSibling;
    }
    return total;
}
```

`countNodes(root)` 先数当前节点，所以 `total` 从 $1$ 开始。随后递归数每个 child 的 subtree，`child = child->nextSibling` 则横向移动到下一个孩子。这个表示只用两个指针就能容纳任意 degree。

## Binary tree

binary tree 的每个节点最多有 left child 和 right child，empty tree 也被视为合法 binary tree。若高度为 $h$，则节点数 $n$ 满足

$$
h+1\le n\le2^{h+1}-1.
$$

反过来，给定 $n$ 个节点，可能的高度范围为

$$
\log_2(n+1)-1\le h\le n-1.
$$

左端对应尽量饱满的树，右端对应完全偏向一侧的长链。这解释了为什么后续树操作的复杂度常写成 $O(h)$：同样的 $n$，形状会让 $h$ 从对数级一直变化到线性级。

### proper、complete 与 perfect

- proper：每个节点要么没有 child，要么恰好有两个。
- complete：除最低层外全部填满，最低层从左向右连续填充。
- perfect：每一层都完全填满。

perfect 一定 complete，complete 不一定 perfect；proper 描述每个节点的 child 数，与是否从左到右填满不是同一件事。

## Array representation

把 root 放在下标 $1$，按 level order 编号，则 index $i$ 的关系为

$$
parent(i)=\left\lfloor\frac i2\right\rfloor,
\quad left(i)=2i,
\quad right(i)=2i+1.
$$

![[Pasted image 20260904120101.png]]

```cpp
int parent(int i)     { return i / 2; }
int leftChild(int i)  { return 2 * i; }
int rightChild(int i) { return 2 * i + 1; }
```

complete tree 几乎不浪费数组位置，因此 heap 很适合这样保存；skewed tree 会留下大量空洞，更适合 linked structure。

```cpp
struct BinaryNode {
    int item;
    BinaryNode* left;
    BinaryNode* right;
};
```

linked representation 不要求树完整，空 subtree 直接用 `NULL` 表示。建立新节点时要主动把 `left` 和 `right` 设为 `NULL`；代价是每个节点需要保存指针，也失去了数组下标的直接关系。
