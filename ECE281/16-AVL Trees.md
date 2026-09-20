普通 BST 的 average time 是 $O(\log n)$，但有序插入会让它退化成长链。balanced search tree 的目标不是要求 perfect 或 complete，而是维护一个足够宽松、又能高效修复的条件，使高度始终为 $O(\log n)$。

## AVL balance condition

AVL tree 首先是 BST，并要求每个节点的左右 subtrees 都是 AVL balanced，且高度差至多 $1$。定义 balance factor

$$
B(T)=h(left)-h(right).
$$

所以合法值只有 $-1,0,1$。AVL tree 的高度满足

$$
\log_2(n+1)-1\le h\le1.44\log_2(n+2),
$$

因此 search、insert、remove 的 worst-case 路径长度都为 $O(\log n)$。

## Rotation 在保持什么

![[Pasted image 20260910223558.png]]


rotation 交换 parent 与一个 child 的角色，但**必须保持 BST ordering**。可以发现规律：左旋和右旋法都是最上面的父子位置互换（P和A），让根茎更深的“子”翻上来，从而实现平衡，翻上来之后为了满足 BST ordering的大小关系，A 不得不把自己的一个儿子送给被掀下去的爹，右旋送右儿子到爹的左侧，左旋送左儿子到爹的右侧，嗯很容易理解吧

<p align="center">
  <img src="Pasted image 20260910223416.png" width="320"/>
  <img src="Pasted image 20260910223434.png" width="320"/>
</p>

```cpp
struct AVLNode {
    int key;
    int height;
    AVLNode* left;
    AVLNode* right;
};

int height(AVLNode* node) {
    if (node == NULL) {
        return 0;
    }
    return node->height;
}

void updateHeight(AVLNode* node) {
    node->height = 1 + max(height(node->left), height(node->right));
}

int balanceFactor(AVLNode* node) {
    return height(node->left) - height(node->right);
}
```

节点把自己的 height 存下来，`updateHeight` 用两个 children 的 height 重新计算它。balance factor 的代码正好对应定义，不需要额外技巧。

right rotation 只改变三条连接。先把中间 subtree 暂存起来，再提升 `x`：

```cpp
AVLNode* rotateRight(AVLNode* y) {
    AVLNode* x = y->left;
    AVLNode* middle = x->right;

    x->right = y;
    y->left = middle;

    updateHeight(y); // 先更新下沉节点
    updateHeight(x);
    return x;
}
```

left rotation 完全对称：

```cpp
AVLNode* rotateLeft(AVLNode* x) {
    AVLNode* y = x->right;
    AVLNode* middle = y->left;

    y->left = x;
    x->right = middle;

    updateHeight(x);
    updateHeight(y);
    return y;
}
```

`middle` 的 keys 原本在 `x` 与 `y` 之间，所以转接后仍满足 BST ordering。高度更新必须先处理下沉的旧 root，再处理新 root。

## LL、RR、LR、RL 四种情况

插入后从 leaf 沿 access path 向上，找到第一个不平衡节点。观察从它出发的前两条 path directions：

![[Pasted image 20260904120106.png]]

- LL：对不平衡节点做一次 right rotation。
- RR：做一次 left rotation。
- LR：先对 left child 做 left rotation，再对不平衡节点做 right rotation。
- RL：先对 right child 做 right rotation，再对不平衡节点做 left rotation。

单看不平衡节点的 factor 只能知道“哪边太高”；child 的 factor 才告诉我们外侧还是内侧变高，从而决定 single 或 double rotation。

```cpp
AVLNode* rebalance(AVLNode* root) {
    updateHeight(root);
    int bf = balanceFactor(root);

    if (bf > 1) {                       // left heavy
        if (balanceFactor(root->left) < 0) {
            root->left = rotateLeft(root->left); // LR 的第一步
        }
        return rotateRight(root);              // LL 或 LR 的第二步
    }
    if (bf < -1) {                      // right heavy
        if (balanceFactor(root->right) > 0) {
            root->right = rotateRight(root->right); // RL 的第一步
        }
        return rotateLeft(root);                    // RR 或 RL 的第二步
    }
    return root;
}
```

外层 balance factor 先判断哪一边过高；同侧 child 的 balance factor 再判断是不是内侧弯折。若是 LR 或 RL，代码先把内侧情况转成外侧，再做第二次 rotation。

## AVL insertion

先按普通 BST 插入。递归返回时，每一层都更新 height 并 rebalance，因此自然沿 access path 从下向上检查。

```cpp
AVLNode* insert(AVLNode* root, int key) {
    if (root == NULL) {
        AVLNode* newNode = new AVLNode;
        newNode->key = key;
        newNode->height = 1;
        newNode->left = NULL;
        newNode->right = NULL;
        return newNode;
    }

    if (key < root->key) {
        root->left = insert(root->left, key);
    } else if (key > root->key) {
        root->right = insert(root->right, key);
    } else {
        return root; // 本实现忽略 duplicate key
    }

    return rebalance(root);
}
```

在 insertion 中，修复从 leaf 往上遇到的第一个不平衡节点后，该 subtree 的高度恢复到插入前，因此一次 single 或 double rotation 就够。整个过程先花 $O(\log n)$ 找位置，再在 access path 上做常数工作，总计 $O(\log n)$。

## Removal 的差别

AVL removal 先完全按 BST 的三种情况删除，再沿 access path 更新 heights 并调用 `rebalance`。与 insertion 不同，删除并旋转后 subtree 仍可能比删除前更矮，使更高的 ancestor 继续失衡，因此一路向 root 可能需要多次 rotation；worst case 仍是 $O(\log n)$。

<span class="green">AVL tree 没有改变 BST 的搜索规则。它只是用额外的 height 信息和局部 rotation，持续阻止 access path 变成长链，从而把原本只有 average 的对数时间变成 worst-case 保证。</span>
