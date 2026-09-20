普通 BST 只按一个 key 排序；现实查询常同时含多个维度，例如经纬度、姓名的多个字段，或价格与面积。$k$-d tree 仍是一棵 binary search tree，但每一层使用不同 dimension 作 discriminator，并随 depth 循环。

## 二维例子：切分平面就是生成树

在二维点集中，depth $0$ 比较 $x$，depth $1$ 比较 $y$，depth $2$ 又比较 $x$。每个节点对应一条只作用于当前区域的切分线；左 subtree 保存当前维度更小的点，右 subtree 保存其余点。

![[Pasted image 20260904120105.png]]

图左的区域切分和图右的树是同一信息的两种表示。为了先看清算法，下面只写二维版本：even depth 比较 $x$，odd depth 比较 $y$。

```cpp
struct Point {
    double x;
    double y;
};

struct KDNode {
    Point point;
    KDNode* left;
    KDNode* right;
};

double coordinate(Point p, int dimension) {
    if (dimension == 0) {
        return p.x;
    }
    return p.y;
}

bool samePoint(Point a, Point b) {
    return a.x == b.x && a.y == b.y;
}
```

`coordinate` 把“根据当前层选择 $x$ 或 $y$”集中在一个地方：dimension 为 $0$ 时返回 $x$，为 $1$ 时返回 $y$。有了这两个小工具，insert 才能只保留树的主要逻辑。

```cpp
void insert(KDNode*& root, Point p, int depth) {
    if (root == NULL) {
        root = new KDNode;
        root->point = p;
        root->left = NULL;
        root->right = NULL;
        return;
    }
    if (samePoint(p, root->point)) {
        return;
    }

    int dimension = depth % 2;
    if (coordinate(p, dimension) < coordinate(root->point, dimension)) {
        insert(root->left, p, depth + 1);
    } else {
        insert(root->right, p, depth + 1);
    }
}
```

第一次调用写 `insert(root, newPoint, 0)`，从 $x$ dimension 开始。普通 BST 每层比较同一个 key；这里由 `depth % 2` 让比较顺序在 $x,y,x,y,\ldots$ 之间循环，但判断完全相同的点仍要同时比较两个 coordinates。

## Exact search

```cpp
KDNode* search(KDNode* root, Point p, int depth) {
    if (root == NULL || samePoint(root->point, p)) {
        return root;
    }

    int dimension = depth % 2;
    if (coordinate(p, dimension) < coordinate(root->point, dimension)) {
        return search(root->left, p, depth + 1);
    }
    return search(root->right, p, depth + 1);
}
```

第一次调用写 `search(root, target, 0)`。exact search 每层仍只需进入一侧，复杂度是 $O(h)$；若树形状良好则接近 $O(\log n)$，退化时仍为 $O(n)$。

## 删除为什么比普通 BST 麻烦

普通 BST 的 degree-one node 可以直接用唯一 child 替换，但 $k$-d tree 不行：child subtree 的下一层使用的是另一个 discriminator，直接上移会改变整棵 subtree 各层的比较维度。

删除当前节点 $R$ 时：

- 若 right subtree 存在，找出其中在当前 dimension 上的 minimum $M$，用 $M$ 替换 $R$，再从 right subtree 递归删除 $M$。
- 若只有 left subtree，可找 left subtree 在当前 dimension 上的 maximum；或按课件做法找 minimum 后调整到 right side，关键是替换后仍满足当前切分关系。
- leaf 可直接删除。

寻找某一维的 minimum 也不能总沿 left pointer。只有当当前层 discriminator 恰好就是目标维度时，right subtree 才必然不可能更小；否则左右两边都要检查。

```cpp
KDNode* smaller(KDNode* a, KDNode* b, int targetDimension) {
    if (a == NULL) return b;
    if (b == NULL) return a;

    if (coordinate(a->point, targetDimension) <
        coordinate(b->point, targetDimension)) {
        return a;
    }
    return b;
}
```

`smaller` 只负责从两个候选节点中选出目标 coordinate 更小的一个。findMin 再决定到底需要产生哪些候选：

```cpp
KDNode* findMin(KDNode* root, int targetDimension, int depth) {
    if (root == NULL) {
        return NULL;
    }

    int currentDimension = depth % 2;

    if (currentDimension == targetDimension) {
        if (root->left == NULL) {
            return root;
        }
        return findMin(root->left, targetDimension, depth + 1);
    }

    KDNode* leftMin = findMin(root->left, targetDimension, depth + 1);
    KDNode* rightMin = findMin(root->right, targetDimension, depth + 1);
    return smaller(root, smaller(leftMin, rightMin, targetDimension),
                   targetDimension);
}
```

若当前层正按目标 dimension 切分，minimum 只可能在 root 或 left subtree；否则本层的左右关系不能排除任何一边，所以代码递归检查两边，再用 `smaller` 比较三个候选。

## Multidimensional range search

查询矩形或高维 box 时，节点本身若落在每个维度的区间内就输出；递归方向则只看当前 discriminator：查询下界小于切分值时 left side 可能相交，查询上界大于切分值时 right side 可能相交。

```cpp
void rangeSearch(KDNode* root, Point low, Point high,
                 vector<Point>& answer, int depth) {
    if (root == NULL) {
        return;
    }

    Point p = root->point;
    if (low.x <= p.x && p.x <= high.x &&
        low.y <= p.y && p.y <= high.y) {
        answer.push_back(p);
    }

    int dimension = depth % 2;
    if (coordinate(low, dimension) < coordinate(p, dimension)) {
        rangeSearch(root->left, low, high, answer, depth + 1);
    }
    if (coordinate(p, dimension) <= coordinate(high, dimension)) {
        rangeSearch(root->right, low, high, answer, depth + 1);
    }
}
```

节点落在矩形中时才加入 `answer`；两个递归条件则判断查询矩形是否跨过当前切分线。代码只进入可能相交的 subtree，这就是 range search 的剪枝。维度很高或数据分布很差时，剪枝效果会减弱，最坏情况仍可能接近扫描全部节点。
