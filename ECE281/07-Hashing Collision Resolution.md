collision resolution 有两条主路线：**separate chaining** 允许一个 bucket 保存多个元素；**open addressing** 仍把元素直接放在数组中，但碰撞后按固定 probe sequence 寻找其他 bucket。

## Separate chaining

每个 bucket 保存一条 linked list。为了突出碰撞后的动作，下面直接用 `Node* buckets[TABLE_SIZE]` 表示各条链；假设所有 bucket 开始时都被设为 `NULL`。

```cpp
const int TABLE_SIZE = 11;

struct Node {
    int key;
    string value;
    Node* next;
};

Node* buckets[TABLE_SIZE];

Node* find(int key) {
    int bucket = key % TABLE_SIZE;
    Node* current = buckets[bucket];

    while (current != NULL) {
        if (current->key == key) {
            return current;
        }
        current = current->next;
    }
    return NULL;
}
```

`find` 先定位一条链，再沿 `next` 检查。碰撞只会增加当前链的长度，不会让搜索跑到其他 bucket。

插入时先复用 `find` 检查 duplicate key；只有没找到时才建立新节点，并把它接到链头：

```cpp
void insert(int key, string value) {
    Node* old = find(key);
    if (old != NULL) {
        old->value = value;
        return;
    }

    int bucket = key % TABLE_SIZE;
    Node* newNode = new Node;
    newNode->key = key;
    newNode->value = value;
    newNode->next = buckets[bucket];
    buckets[bucket] = newNode;
}
```

这样，碰撞项不会互相覆盖，而是留在同一条链中。若 load factor $L=|S|/n$ 保持为常数且 hash 分布均匀，平均链长也是常数，所以操作的 average time 是 $O(1)$；链可以继续增长，因此 separate chaining 允许 $L>1$。

## Open addressing 与 probe sequence

open addressing 的每个 bucket 最多放一个元素。碰撞后尝试

$$
h_0(k),h_1(k),h_2(k),\ldots
$$

直到找到 key，或找到能停止搜索的 empty bucket。三种基本序列为

$$
\begin{aligned}
\text{linear: }&h_i(k)=(h(k)+i)\bmod n,\\
\text{quadratic: }&h_i(k)=(h(k)+i^2)\bmod n,\\
\text{double hashing: }&h_i(k)=(h(k)+i\,g(k))\bmod n.
\end{aligned}
$$

### Linear probing 的实现

```cpp
const int EMPTY = 0;
const int OCCUPIED = 1;
const int DELETED = 2;

struct Slot {
    int key;
    string value;
    int state;
};

Slot table[TABLE_SIZE];

int probe(int key, int step) {
    return (key % TABLE_SIZE + step) % TABLE_SIZE;
}
```

三个 state 的区别必须显式保存；`probe(key, step)` 则把课件中的 $h_i(k)$ 直接翻译成数组下标。

```cpp
int findPosition(int key) {
    for (int step = 0; step < TABLE_SIZE; step++) {
        int position = probe(key, step);
        if (table[position].state == EMPTY) {
            return -1;
        }
        if (table[position].state == OCCUPIED &&
            table[position].key == key) {
            return position;
        }
    }
    return -1;
}

void remove(int key) {
    int position = findPosition(key);
    if (position != -1) {
        table[position].state = DELETED;
    }
}
```

`step` 依次取 $0,1,2,\ldots$，正好实现 linear probing。查找遇到 `EMPTY` 可以停止，因为 insert 从不会越过一个从未使用的位置；但遇到 `DELETED` 必须继续。若删除时直接标成 `EMPTY`，更远处因碰撞而搬过去的 key 就会被漏掉。

插入同样沿 probe sequence 前进，遇到 `DELETED` 或 `EMPTY` 就可以放入：

```cpp
bool insert(int key, string value) {
    int oldPosition = findPosition(key);
    if (oldPosition != -1) {
        table[oldPosition].value = value;
        return true;
    }

    for (int step = 0; step < TABLE_SIZE; step++) {
        int position = probe(key, step);

        if (table[position].state != OCCUPIED) {
            table[position].key = key;
            table[position].value = value;
            table[position].state = OCCUPIED;
            return true;
        }
    }
    return false;  // 整张表都没有可用位置
}
```

开头先调用 `findPosition` 处理 duplicate key；只有确实是新 key 时，才寻找第一个 `DELETED` 或 `EMPTY` 位置。这样 insert 同时满足“旧 key 更新 value”和“新 key 占用新位置”两种情况。

## 三种 probing 的取舍

linear probing 连续访问内存，cache 表现好，但会形成 primary clustering：连续占用区越长，新元素越容易落入并把它继续拉长。

quadratic probing 用平方步长打散连续 cluster，但 probe sequence 不一定访问全部 bucket。课件给出的保证是：table size 选择合适且 $L\le0.5$ 时能够找到空位。

double hashing 让步长依 key 改变，因此不同 key 即使 home bucket 相同，也不必沿同一路线走。要让序列覆盖整个表，通常要求步长 $g(k)$ 与 table size 互质。

## Load factor 决定性能

open addressing 必须有 $L\le1$，而且当 $L$ 靠近 $1$ 时，查找空位会急剧变慢。对 linear probing，课件给出的期望比较次数为

$$
U(L)=\frac12\left(1+\frac1{(1-L)^2}\right),\qquad
S(L)=\frac12\left(1+\frac1{1-L}\right),
$$

其中 $U$ 是 unsuccessful search，$S$ 是 successful search。quadratic probing 与 double hashing 的近似为

$$
U(L)=\frac1{1-L},\qquad
S(L)=\frac1L\ln\frac1{1-L}.
$$

因此“平均 $O(1)$”隐含了 load factor 被控制在常数阈值之下。课件建议 linear probing 尽量保持 $L\le0.75$；频繁删除时，separate chaining 通常更直接。
