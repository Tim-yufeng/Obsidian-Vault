# 22 Linear List and Stack

IntSet 是"按值"组织的集合。这一节引入一个相关的 ADT——linear list，它改成"按位置"组织，因而允许重复元素；随后把它的操作限制在一端，就得到 stack。stack 的价值不在数据组织本身，而在于它天然匹配一类"后进先出"的过程，其中最重要的一个是函数调用。

## Linear list ADT

回忆 IntSet：零个或多个整数的集合，不允许重复；它支持按**值**插入和删除。linear list 是相关的 ADT：零个或多个整数的集合，**允许重复**，记作

$$L = (l_0, l_1, \dots, l_{N-1})$$

它支持按**位置**插入和删除。

```cpp
void insert(int i, int v)   // if 0 <= i <= N (N is the size of the list),
                            // insert v at position i;
                            // otherwise, throws BoundsError exception.

void remove(int i)          // if 0 <= i < N (N is the size of the list),
                            // remove the i-th element;
                            // otherwise, throws BoundsError exception.
```

注意两个操作的合法范围不同：`insert` 允许 $i$ 取到 $N$（即插到末尾之后的位置），而 `remove` 只能取 $0 \le i < N$，因为不存在第 $N$ 个元素可以删。用 `L1 = (1, 2, 3)` 走一遍：

```text
L1.insert(0, 5) = (5, 1, 2, 3);
L1.insert(1, 4) = (1, 4, 2, 3);
L1.insert(3, 6) = (1, 2, 3, 6);
L1.insert(4, 0) throws BoundsError
```

用 `L2 = (1, 2, 3)` 走一遍删除：

```text
L2.remove(0) = (2, 3);
L2.remove(1) = (1, 3);
L2.remove(2) = (1, 2);
L2.remove(3) throws BoundsError
```

如果要实现一个"能按用户需要无限增长"的 linear list，可用的表示有 dynamic array、singly-linked list、doubly-linked list，唯独不能用 static array——它的容量在编译期就固定了。

## Stack：受限制的 linear list

stack 是一"摞"对象：新对象放在最上面，取出的也是最上面的那个。它是 linear list 的受限形式——<span class="red">只允许在列表末端插入和删除</span>。这种访问方式称为 LIFO access，即 last in, first out。

它的方法集合是：

- `size()`：stack 中元素个数。
- `isEmpty()`：检查 stack 是否为空。
- `push(Object o)`：把 `o` 加到 stack 顶部。
- `pop()`：若 stack 非空则删除顶部对象，否则抛出 `stackEmpty`。
- `Object &top()`：返回顶部元素的 reference。

## 用数组实现 Stack

数组表示维持一个整数 `size` 记录 stack 大小：

- `size()`：返回 `size`。
- `isEmpty()`：返回 `size == 0`。
- `push(Object o)`：把 `o` 放在数组下标 `size` 处并让 `size` 自增；必要时分配更多空间。
- `pop()`：若 `isEmpty()` 则抛 `stackEmpty`，否则让 `size` 自减。
- `Object &top()`：返回数组元素 `Array[size-1]` 的 reference。

这里 `size` 和 IntSet 里 `numElts` 扮演的是同一个角色：它同时是"元素个数"和"下一个空位的下标"。

## 用 Linked List 实现 Stack

链表表示下的对应关系非常直接：

- `size()` → `LinkedList::size()`
- `isEmpty()` → `LinkedList::isEmpty()`
- `push(Object o)` → `LinkedList::insertFirst(Object o)`，在开头插入
- `pop()` → `LinkedList::removeFirst()`，删除第一个 node
- `Object &top()` → 返回第一个 node 中所存对象的 reference

对单端链表来说，选择哪一端作为"栈顶"是必须回答的问题：<span class="red">应该选 `first` 那一端</span>，因为我们已经有了高效的首端插入与删除（`insertFirst` / `removeFirst`），而从尾端插入或删除都需要先走到末尾。

`size()` 可以直接遍历得到：

```cpp
int LinkedList::size() {
    int count = 0;
    node *current = first;
    while (current) {
        count++;
        current = current->next;
    }
    return count;
}
```

但这需要 $O(N)$。更快的做法是增加一个 size 数据成员：

```cpp
class LinkedList {
    node *first;
    int size;
  public:
    ...
};

int LinkedList::size() {
    return size;
}
```

多加一个字段就意味着要在别处维护它——插入和删除 node 时必须相应地增加/减少 `size`。这是"用空间与维护成本换查询速度"的又一例。

## Array 与 Linked List 的比较

在这个应用里，带 size 数据成员的 linked list 更好。array 的缺点是不省内存——必须一次分配足够大的数组，而实际用到多少事先不知道。带 size 成员的 linked list 则省内存：每新增一个元素只需要额外的固定量内存；同时所有操作的运行时都是常数，与 array 相同。这个对比之所以成立，关键在于"带 size 成员"这个前提——没有它，`size()` 就要退化成 $O(N)$。

## Stack 的应用

### 函数调用

C++ 中函数调用本身就由 stack 支持，这是 stack 这个概念在系统层面最重要的用途。

### 浏览器的 "back"

浏览器的后退功能是一个天然的后进先出过程。依次访问 Web A → Web B1 → Web C，stack 中自上而下是 `Web C, Web B1, Web A`；点两次 back 依次弹出 `Web C`、`Web B1`，回到 Web A；接着访问 Web B2、Web D，stack 变成 `Web D, Web B2, Web A`。"当前页面"始终是栈顶。

### 括号匹配

给一个表达式，输出所有匹配的左右括号位置对 $(u, v)$，表示位置 $u$ 的左括号与位置 $v$ 的右括号配对。

```text
( ( a + b ) * c + d – e ) / ( f + g )
0 1 2 3 4 5 6 7 8 9 10 12 14 16 18
```

输出是 `(1, 5); (0, 12); (14, 18);`。若表达式本身不合法，例如

```text
( a + b ) ) * ( ( c + d )
0 1 2 3 4 5 6 7 8 9 10 12
```

输出是 `(0, 4);`，并额外报告：位置 5 的右括号没有匹配的左括号；位置 7 的左括号没有匹配的右括号。

算法只有三句话：从左到右扫描表达式；遇到左括号就把它的位置 push 进 stack；遇到右括号就 pop 出栈顶位置，那就是与它匹配的左括号位置。

<span class="red">两种失败情形各自对应一种栈状态</span>：pop 时如果 stack 已空，说明这个右括号没有匹配的左括号；扫描结束后如果 stack 非空，说明还有未匹配的左括号。对上面那个合法表达式，扫描到位置 5 时栈中弹出 1 得到 `(1, 5)`，位置 12 时弹出 0 得到 `(0, 12)`，位置 18 时弹出 14 得到 `(14, 18)`，最后栈空。

参考材料：Problem Solving with C++ (8th Edition) Chapter 13.2（Stack）。
