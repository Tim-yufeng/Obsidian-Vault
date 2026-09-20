# 23 Queue

stack 把 linear list 限制成"只在一端进出"。这一节看另一种限制方式：在一端插入、在另一端删除。由此得到的 FIFO 行为对应的是排队过程，而它的两种实现各自暴露出一个典型问题——数组版本会遇到"空间还在但用不上"，链表版本则要求我们同时能高效访问两端。

## Queue 的设定

queue 是一"列"元素，最先插入的元素最先离开。它是 linear list 的受限形式——只允许在一端插入、在另一端删除——这种访问方式称为 FIFO access，即 first in, first out。

它的方法集合是：

- `size()`：queue 中元素个数。
- `isEmpty()`：检查 queue 是否为空。
- `enqueue(Object o)`：把 `o` 加到 queue 的 rear。
- `dequeue()`：若 queue 非空则删除 front 对象，否则抛出 `queueEmpty`。
- `Object &front()`：返回 front 元素的 reference。
- `Object &rear()`：返回 rear 元素的 reference。

## 用 Linked List 实现 Queue

因为需要快速的 `enqueue` 与 `dequeue`，要同时高效地访问两端，所以选择 <span class="red">double-ended singly-linked list 就够了</span>——不需要 doubly-linked，因为两个操作都只在两端进行，不需要从尾往前走。

对应关系：`enqueue(Object o)` 就是 `LinkedList::insertLast(Object o)`，在末尾追加；`dequeue()` 就是 `LinkedList::removeFirst()`，删除第一个 node；`size()` 与 `isEmpty()` 直接委托给链表；`front()` 返回第一个 node 中所存对象的 reference，`rear()` 返回最后一个 node 中所存对象的 reference。这里 `first` 端就是 queue 的 front，`last` 端就是 rear，这也解释了为什么上一节需要 `last` 这个额外的数据成员。

## 用数组实现 Queue：drift 问题

先用最自然的规定试一次：queue 的 $n$ 个元素就是数组的前 $n$ 个元素，用一个 `front` 与一个 `rear` 标记区间（例如 `Array[MAXSIZE]: 2 3 1 4`，`front` 指向 2，`rear` 指向 4）。

在这个规定下，`enqueue` 在 `rear` 之后追加，运行时间与 $n$ 无关；而 `dequeue` 必须删除第一个元素，删除之后为了维持"元素占据数组开头"这条规定，后面所有元素都要整体左移，因此运行时间与 $n$ 成正比。所以正确的判断是：enqueue 独立于 $n$，dequeue 正比于 $n$。

更好的办法是让元素在数组里"漂移"：不要求它们占据开头，而是用两个整数分别指示 queue 的 front 与 rear。连续执行 `enqueue(6); dequeue(); dequeue();` 之后，元素在数组中整体向右移动，而 front / rear 标记随之移动。

![[Pasted image 20260809153008.png]]

但漂移会带来新问题：随着元素不断加入和移除，queue 会逐渐向数组末端移动，最终右边没有空间了，而数组左边明明还有空位——这就是内存浪费。因此 <span class="red">数组实现必须使用 circular array</span>。

## Circular array

circular array 可以就用一个普通的线性数组实现：当 `front` / `rear` 等于最后一个下标（`MAXSIZE-1`）时，再把它们加一就回到下标 0。实现这个"环绕式自增"的手段是取模：

```cpp
front = (front+1) % MAXSIZE;
rear  = (rear+1) % MAXSIZE;
```

当 `front`（或 `rear`）等于 `MAXSIZE-1` 时，这两条语句把它置为 0。

### 边界条件

设 `front` 指向 queue 中第一个元素，`rear` 指向最后一个元素。逐个看几种极端状态。只有一个元素时，`front` 与 `rear` 指向同一个位置。空 queue 时，`front` 与 `rear` 也需要有个约定位置。只剩一个空槽时，有效元素仍占据其余位置。

真正的麻烦在最后一种情形：**满队列与空队列的 front / rear 相对位置可能完全一样**。因为一个容量为 `MAXSIZE` 的数组如果允许存满 `MAXSIZE` 个元素，那么"已满"与"全空"两种情况都会表现为 `front` 与 `rear` 处于同一种相邻关系，仅凭这两个下标无法区分。

![[Pasted image 20260809153009.png]]

图中左边是存满的数组，右边是全空的数组，两种情况下 `rear` 都紧邻 `front`，唯一的差别是数组里有没有内容——所以下标本身不携带"满/空"的信息。<span class="red">解决办法是额外维护一个表示 empty 或 full 的 flag，或者维护一个队列元素个数计数器</span>。

### 带计数器的版本

```text
enqueue(Object o): 若已满则重新分配数组；
                   让 rear 自增，到达数组末尾时回绕到开头；
                   把 o 放到 rear 的位置。
dequeue():         若为空则抛出 queueEmpty；
                   否则让 front 自增，到达数组末尾时回绕到开头。
isEmpty():         return (count == 0);
size():            return count;
```

`count` 同时解决了"区分满与空"和"快速取得元素个数"两件事，代价是每次插入删除都要维护它。

## Queue 的应用

一个标准例子是 Web 服务器的请求队列：每个用户可以发送请求，到达的请求被存入 queue，由计算机按先到先服务的方式依次处理。

由此可以判断哪些场景适合用 queue：处理打印机的打印任务（是，任务按到达顺序处理）；翻转一个字符串（不是，那是 stack 的 LIFO 行为）；实现 waiting list（是）；在多个进程之间共享 CPU（是，进程轮流获得时间片）。

## Deque

deque 不是一个正经的英文单词，读作 "deck"，意思是 double-ended queue。它是 <span class="red">stack 与 queue 的结合</span>：元素可以从列表的**两端**插入和删除。它支持的方法是 `push_front(Object o)`、`push_back(Object o)`、`pop_front()`、`pop_back()`。

两种实现都要相应加强。链表方面，要同时支持两端快速插入与删除，需要 **double-ended doubly-linked list**。circular array 方面，`front` 与 `rear` 不再只是自增（`push_back`、`pop_front` 对应自增），还需要自减（`push_front`、`pop_back` 对应自减）——这也是 deque 实现比 queue 更容易出错的原因。

参考材料：Problem Solving with C++ (8th Edition) Chapter 13.2（Queue）。
