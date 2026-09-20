# 19 Linked List

上一节处理"让数组长大"这件事。但可扩展数组只是实现"能随时增长和收缩的存储"的一种办法，另一种是把数据分散在若干容器里，用 pointer 把它们串起来。这一节按时序搭建一个 singly-linked list：先写操作，再补三个维护方法，最后发现"从尾部插入"才是这个表示法的真正短板。

## linked structure 与 ADT 设定

<span class="red">linked structure 是由零个或多个 data container 组成的序列，它们通过 pointer 一个接一个连接起来</span>。一个直观的类比是货运列车：需要多运货就加一节车厢、接到列车上并装货；不再需要时就把那节车厢摘下来。

要实现的 ADT 是"可变的整数列表"，与项目二中的 `list_t` 类似，区别在于 `list_t` 是 **immutable** 的——`list_t` 对象一旦创建，任何操作都不会改变它。新的列表需要三个操作：

```cpp
bool isEmpty();
  // EFFECTS: returns true if list is empty, false otherwise

void insert(int v);
  // MODIFIES: this
  // EFFECTS: inserts v into the front of the list

class listIsEmpty {};   // An exception class
int remove();
  // MODIFIES: this
  // EFFECTS: if list is empty, throw listIsEmpty.
  //          Otherwise, remove and return the first element of the list
```

注意 `insert` 与 `remove` 都在**前端**操作：列表是 `(1 2 3)` 时 `remove()` 之后变成 `(2 3)` 并返回 `1`；接着 `insert(4)` 得到 `(4 2 3)`，而不是 `(2 3 4)`。

## node 的表示与 rep invariant

实现 linked list 需要先为列表中的 node 选定 concrete representation：

```cpp
struct node {
    node *next;
    int   value;
};
```

两个字段的 invariant 是：`value` 保存该元素的整数值；`next` 指向列表中的下一个 node，如果该 node 是最后一个，则 `next` 为 `nullptr`（nullptr 表示"指向空"）。列表 `(4 2 3)` 的具体表示就是三个 node，`next` 依次相连，最后一个的 `next` 为 `nullptr`。

![[Pasted image 20260809153007.png]]

图中每个 node 的 `value` 与 `next` 各自占据一格，箭头从 `next` 指出的方向就是遍历方向；最后一个 node 的 `next` 指向一个被划掉的记号，表示 `nullptr`。三个 node 在内存中的位置互不相邻，连接关系完全由 pointer 决定——这也解释了为什么"销毁"必须逐个 node 进行。

实现的基本想法是：每次插入一个 int，就创建一个新 node 来装它；每次从非空列表中删除一个 int，就保存第一个 node 的值、销毁那个 node、返回该值。

class 只用下面这个 private 数据成员：

```cpp
class IntList {
    node *first;
  public:
    ...
};
```

rep invariant 是：`first` 指向代表该 IntList 的 node 序列的第一个 node，如果列表为空则为 `nullptr`。

## 遍历

有了 `first` 就可以遍历整个列表：从 `first` 出发，每访问一个 node 就沿着它的 `next` 前进，直到 pointer 变成 `nullptr`。例如统计元素个数：

```cpp
int IntList::getSize() {
    // Effect: return # of items in this list
    int count = 0;
    node *current = first;
    while (current) {
        count++;
        current = current->next;
    }
    return count;
}
```

`while (current)` 依赖 pointer 在条件位置被当作 bool 使用：非 `nullptr` 为真。这个循环的结构此后会反复出现。

## 需要实现的全部方法

```cpp
class IntList {
    node *first;
  public:
    bool isEmpty();
    void insert(int v);
    int  remove();
    IntList();                          // default ctor
    IntList(const IntList &l);          // copy ctor
    ~IntList();                         // dtor
    IntList &operator=(const IntList &l);   // assignment
};
```

实现顺序上，先写"operational"方法（假定 rep invariant 成立），再回头写 default constructor 与 Big Three，以保证两件事：对象创建期间 invariant 成立；所有动态资源都被妥善处理。

`isEmpty` 直接看 `first`：

```cpp
bool IntList::isEmpty() {
    return !first;
}
```

## insert

插入时起点是"`first` 指向当前列表"——这个列表可能为空也可能不为空，但无论如何 `first` 都指向一个合法列表。第一步是创建一个新 node 来装新的首元素：

```cpp
void IntList::insert(int v) {
    node *np = new node;
    ...
}
```

这里有一个值得停下来想的点：能不能用局部对象 `node n;` 代替动态分配？不能——`np` 这个局部变量在函数结束时就会消失，而新 node 必须活得比函数调用更久，所以它必须来自 heap。

第二步是在新 node 上建立 invariant：把 `value` 设为 `v`，把 `next` 设为"列表的其余部分"，也就是当前列表的起始位置。第三步是重建 representation invariant：`first` 此前指向列表的第二个 node，现在必须指向新列表的第一个 node。

```cpp
void IntList::insert(int v) {
    node *np = new node;
    np->value = v;
    np->next = first;
    first = np;
}
```

`first = np;` 这一步对任何当前列表都成立，只要 invariant 本来成立：列表非空时，新 node 挂到旧的首 node 前面；列表为空时 `first` 本来是 `nullptr`，新 node 的 `next` 也就是 `nullptr`，成为唯一的 node。

## remove：三个必须先想清楚的顺序问题

删除比插入棘手，因为要做的事很多，而且必须按精确的顺序完成。

第一件事是修复 `first` 的 invariant：删掉首元素意味着 `first` 必须改为指向第二个 node。

```cpp
first = first->next;
```

但还要 `delete` 那个被删的 node，否则 memory leak。这里出现第一个顺序冲突：<span class="red">不能在推进 `first` 之前 delete，因为那样 `first->next` 就变成 undefined</span>；可是推进 `first` 之后，那个待删的 node 就成了孤儿，再也找不到它。解决办法是引入一个局部变量记住"旧的首 node"，称为 `victim`：

```cpp
node *victim = first;
...
first = victim->next;
...
delete victim;
```

第二件事是把 node 里存的值返回。这又是一个顺序冲突：如果先 `return` 值再 delete，那么 delete 永远不会执行；如果先 delete，节点里的值就丢了。因此再用一个局部变量 `result` 记住最终要返回的值：

```cpp
int IntList::remove() {
    node *victim = first;
    int result;
    ...
    first = victim->next;
    result = victim->value;
    delete victim;
    return result;
}
```

第三件事是处理空列表并抛异常：

```cpp
int IntList::remove() {
    node *victim = first;
    int result;
    if (isEmpty()) {
        listIsEmpty e;
        throw e;
    }
    first = victim->next;
    result = victim->value;
    delete victim;
    return result;
}
```

写完之后可以把顺序调整得更自然一些：`victim` 在声明时初始化，但 `result` 故意没有在声明处初始化为 `victim->value`。原因是那句初始化会放在空列表检查**之前**，而列表为空时 `victim` 是 `nullptr`，`victim->value` 就是非法访问；把它移到检查之后既安全，也少一次赋值（列表为空时一次赋值都省了）。

```cpp
int IntList::remove() {
    if (isEmpty()) {
        listIsEmpty e;
        throw e;
    }
    node *victim = first;
    first = victim->next;
    int result = victim->value;
    delete victim;
    return result;
}
```

## 维护方法：destructor 与 copy constructor

default constructor 只需为空列表建立 representation invariant：

```cpp
IntList::IntList() : first(nullptr)
{}
```

destructor 也不难：必须在列表本身被销毁之前销毁其中每个 node。而"销毁单个 node"的机制已经有了——它是 `remove()` 的副作用。所以只要反复调用 `remove()` 直到列表为空、忽略它的返回值即可。把这个功能放进另一个 private 方法 `removeAll()`：

```cpp
void IntList::removeAll() {
    while (!isEmpty()) {
        remove();
    }
}

IntList::~IntList() {
    removeAll();
}
```

copy constructor 才是真正 tricky 的地方。一个朴素做法是从前往后遍历源列表，把遇到的每个元素 `insert` 进新列表：

```cpp
IntList::IntList(const IntList &l): first(nullptr){
    node *current = l.first;
    while (current) {
        insert(current->value);
        current = current->next;
    }
}
```

它确实复制了全部值，但结果是**逆序**的——因为 `insert` 总是把新元素放到列表最前面，`(1 2 3)` 会被复制成 `(3 2 1)`。所以"是否所有值都被复制"这个问题的答案是"值都在，但顺序错了"，属于"即使所有值都被复制，仍然不对"这一类。

我们真正想做的是从后往前遍历，但 singly-linked list 没有方便的向后走法。于是改用 recursion：写一个 helper，递归地走到列表末尾，在**递归回溯**的过程中依次 `insert`，于是插入顺序自然是从后到前，得到正确的顺序。

```cpp
void IntList::copyList(node *list) {
    if (!list) return;      // Base case

    copyList(list->next);
    insert(list->value);
}
```

这个 helper 必须是 private method，因为它直接处理 concrete representation（node、`next`），而不是抽象层面的事情。

有了 `copyList`，copy constructor 与 assignment operator 都很简单。copy constructor 要先确保自己从空列表开始，再调用 `copyList`：

```cpp
IntList::IntList(const IntList &l)
: first(nullptr)
{
    copyList(l.first);
}
```

assignment operator 的顺序是：先确保不是自我赋值，销毁当前列表，再复制新的：

```cpp
IntList &IntList::operator=(const IntList &l) {
    if (this != &l) {
        removeAll();
        copyList(l.first);
    }
    return *this;
}
```

## Double-ended list：从尾部插入

如果要往列表**末尾**插入元素，用现有表示法就需要一路走到"最后一个元素"再插进去，每次都要经过所有元素，效率很低。改进办法是修改 concrete representation，同时跟踪列表的头部和尾部：

```cpp
class IntList {
    node *first;
    node *last;
  public:
    ...
};
```

`first` 的 invariant 不变；`last` 的 invariant 是：列表非空时 `last` 指向最后一个 node，否则为 `nullptr`。于是空列表中 `first` 与 `last` 都是 `nullptr`。

增加这个数据成员后，需要重写的是 `remove`、`insert` 以及 default / copy constructor（它们都会改变首尾指针）。这里只写新增的 `insertLast`：

```cpp
void IntList::insertLast(int v) {
    node *np = new node;
    np->next = nullptr;
    np->value = v;
    if (isEmpty()) {
        first = last = np;      // 新 node 同时是首 node 与尾 node
    }
    else {
        last->next = np;        // 修复"旧 last 的 next 错误地指向 nullptr"
        last = np;              // 修复 last 不再指向最后一个 node
    }
}
```

两个分支的区别正是"哪些 invariant 被破坏了"：空列表时破坏的是 `first` 与 `last` 两条；非空时破坏的是"旧 `last->next` 应指向新 node"和"`last` 应指向新 node"两条。

这个结构只让**插入**变高效，从尾部**删除**仍然不高效：即使有 `last`，要把它前移一位也必须知道倒数第二个 node，而 singly-linked list 无法从 `last` 往回走。要让尾部删除也高效，需要 **doubly-linked list**：node 增加一个 `prev` 字段。

```cpp
struct node {
    node *next;
    node *prev;
    int   value;
};
```

`next` 与 `value` 的含义不变；`prev` 的 invariant 是：指向列表中的前一个 node，如果不存在这样的 node（即当前是首 node）则为 `nullptr`。空列表仍然 `first` 与 `last` 都是 `nullptr`，而列表 `(2, 3)` 中三个 node 之间双向相连。

与 singly-linked list 相比，doubly-linked list 的取舍是：它让部分操作更高效（尤其是尾部删除、向后遍历），代价是每个 node 多一个 pointer，从而显著增加内存开销，同时插入和删除时要维护的 pointer 也更多——判据是"这些操作是否真的需要向后走"，而不是"多的总比少的好"。

参考材料：Problem Solving with C++ (8th Edition) Chapter 13.1（Nodes and Linked Lists）。
