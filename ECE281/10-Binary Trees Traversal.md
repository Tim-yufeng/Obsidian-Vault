traversal 的目标是让每个节点恰好被 visit 一次。真正区分几种方法的只有一件事：**当前节点的 visit 被放在左右 subtree 的前、中还是后**。

下面统一使用：

```cpp
struct Node {
    char value;
    Node* left;
    Node* right;
};
```

三种 depth-first traversal 都使用同一个 `Node`，差别不在节点结构，而只在 `cout` 相对两个 recursive calls 的位置。

## 三种 depth-first traversal

### Pre-order：node, left, right

```cpp
void preOrder(Node* root) {
    if (root == NULL) {
        return;
    }

    cout << root->value << ' ';
    preOrder(root->left);
    preOrder(root->right);
}
```

先处理 root，再递归两棵 subtree。它适合在进入 subtree 前就要建立父节点的任务，例如复制树的结构或输出带有前缀含义的表达式。

### In-order：left, node, right

```cpp
void inOrder(Node* root) {
    if (root == NULL) {
        return;
    }

    inOrder(root->left);
    cout << root->value << ' ';
    inOrder(root->right);
}
```

对普通 binary tree，in-order 只是一个固定访问顺序；对 binary search tree，它会按 key 从小到大输出。表达式树使用 in-order 时会得到常见的中缀顺序，但若要完全保留结构，还需要加括号。

### Post-order：left, right, node

```cpp
void postOrder(Node* root) {
    if (root == NULL) {
        return;
    }

    postOrder(root->left);
    postOrder(root->right);
    cout << root->value << ' ';
}
```

父节点最后处理，因此适合必须先完成 children 的任务，例如计算 subtree 信息、释放整棵树，或把表达式树输出为 Reverse Polish Notation。

```cpp
void destroy(Node*& root) {
    if (root == NULL) {
        return;
    }

    destroy(root->left);
    destroy(root->right);
    delete root;
    root = NULL;
}
```

`delete` 必须放在两个递归调用之后；若先释放 root，就再也不能安全读取它的 child pointers。

## Level-order：用 queue 保存“之后要访问谁”

depth-first 的递归栈让程序先一路向深处走；level-order 则要把同层节点的 children 依次留到队尾，因此需要 FIFO queue。

```cpp
void levelOrder(Node* root) {
    if (root == NULL) {
        return;
    }

    queue<Node*> q;
    q.push(root);
    while (!q.empty()) {
        Node* cur = q.front();
        q.pop();
        cout << cur->value << ' ';

        if (cur->left != NULL) {
            q.push(cur->left);
        }
        if (cur->right != NULL) {
            q.push(cur->right);
        }
    }
}
```

当一个节点出队时，它的 children 才入队；所以 queue 中较早层的节点总在较深层之前。四种 traversal 都访问 $n$ 个节点一次，时间是 $O(n)$。递归 DFS 的额外空间是 $O(h)$，BFS 的 queue 在最宽一层可能存到 $O(n)$ 个节点。

## 用一个三节点树记顺序

若 `a` 的左右 children 分别是 `b`、`c`：

| 方法 | 输出 |
|---|---|
| pre-order | `a b c` |
| in-order | `b a c` |
| post-order | `b c a` |
| level-order | `a b c` |

不要只背名称。把 `visit(root)` 在递归模板中移动到两个调用的前、中、后，就能重新写出三种 DFS。
