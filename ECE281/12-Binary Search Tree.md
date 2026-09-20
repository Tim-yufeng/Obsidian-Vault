binary search tree（BST）在 binary tree 上加入全局顺序：对任意节点，left subtree 的所有 keys 都更小，right subtree 的所有 keys 都更大。课件假设 keys distinct；因此一次比较不仅检查当前节点，也能排除整棵不可能包含答案的 subtree。

## Search

```cpp
struct Node {
    int key;
    string value;
    Node* left;
    Node* right;
};

Node* search(Node* root, int key) {
    if (root == NULL || root->key == key) {
        return root;
    }
    if (key < root->key) {
        return search(root->left, key);
    }
    return search(root->right, key);
}
```

每层只进入一个 child，所以时间为 $O(h)$。若树形状近似平衡，$h=O(\log n)$；若退化成长链，$h=O(n)$。

## Insert：把搜索失败的位置变成新 leaf

```cpp
void insert(Node*& root, int key, string value) {
    if (root == NULL) {
        root = new Node;
        root->key = key;
        root->value = value;
        root->left = NULL;
        root->right = NULL;
        return;
    }

    if (key < root->key) {
        insert(root->left, key, value);
    } else if (key > root->key) {
        insert(root->right, key, value);
    } else {
        root->value = value;  // duplicate key：更新原 value
    }
}
```

`Node*&` 是 reference-to-pointer。递归进入 `root->left` 时，参数实际上别名到 parent 的 left pointer；于是找到空位后给 `root` 赋新地址，就真的改动了 parent 的连接，而不是只修改一个局部副本。

## Remove 的三个结构情况

要删除的 key 仍先按 BST search 找到。找到后按 degree 分类：

1. leaf：直接删除并把 parent link 设为 `NULL`。
2. degree one：让 parent link 绕过该节点，直接指向唯一 child。
3. degree two：用 left subtree 的 maximum，或 right subtree 的 minimum 替换当前内容，再删除那个替代节点。

![[Pasted image 20260904120104.png]]

替代者不可能有两个 children：例如 left subtree 的 maximum 若还有 right child，就不可能是 maximum。因此最后会回到前两个简单情况。

```cpp
Node*& findMax(Node*& root) {
    if (root->right == NULL) {
        return root;
    }
    return findMax(root->right);
}
```

`findMax` 一直向 right child 前进，返回的不是节点地址的副本，而是 parent 中那条 pointer 本身。这样删除替代节点时，可以直接修改它原来的连接。

```cpp
void remove(Node*& root, int key) {
    if (root == NULL) {
        return;
    }

    if (key < root->key) {
        remove(root->left, key);
    } else if (key > root->key) {
        remove(root->right, key);
    } else if (root->right == NULL) {
        Node* old = root;
        root = root->left;
        delete old;
    } else if (root->left == NULL) {
        Node* old = root;
        root = root->right;
        delete old;
    } else {
        Node*& replacement = findMax(root->left);
        root->key = replacement->key;
        root->value = replacement->value;

        Node* old = replacement;
        replacement = replacement->left;
        delete old;
    }
}
```

`remove` 的前两个分支仍在执行普通 search；后三个分支才分别处理“没有 right child”“没有 left child”和“两个 children”。degree-one 情况必须先保存旧地址，再把 link 接到 child，最后 delete 旧节点；若先 delete，再读取 child pointer，就会访问已经释放的内存。

## Heap 与 BST 不要混淆

min heap 只保证 parent 不大于 descendants，因而 root 是最小值，但不能从左右方向判断一个任意 key 在哪里。BST 的 left/right 表示全局小/大关系，能做定向搜索，却不保证 root 是最小值。两者都可能画成 binary tree，但维护的是不同 invariant。
