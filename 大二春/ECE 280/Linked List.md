### **1. 链表的本质
* **定义**：一种由节点（Node）通过指针连接而成的动态数据结构。
* **对比可扩容数组**：数组扩容需要整体搬迁（$O(N)$），链表新增节点只需改变指针指向（$O(1)$）。

---

### **2. C++ 类的封装实现**
* **结构分离**：通常使用 `struct Node` 定义节点（私有或在类内），使用 `class LinkedList` 管理整体操作。
* **私有成员**：`Node *first`。它是进入链表的唯一入口（火车头）。
* **初始化**：构造函数必须将 `first` 初始化为 `nullptr`，表示**空链表**。

```cpp
struct node {
	node *next;
	int value;
};

class IntList {
	node *first;
	public:
	bool isEmpty();
	void insert(int v);
	int remove();
	IntList();     // default constructor
	IntList(const IntList& l); // copy constructor
	~IntList();
	IntList &operator=(const IntList &l);
	...
};
```


---

### **3. 高阶实现：递归视角下的链表**
* **递归定义**：一个链表要么是**空的**，要么是一个**节点指向另一个链表**。
* **递归操作示例**：
    * **size()**：若为空则返回 0；否则返回 `1 + size(rest)`。
    * **query(v)**：若为空则返回 false；若当前节点值等于 v 则返回 true；否则递归查找剩余部分。
* **易错点**：递归实现虽然优雅，但在超长链表中可能导致**栈溢出**，生产环境常改用迭代。

---

### **4. 核心操作逻辑与易错点**
* **插入 (Insert)**：
    * 通常插入头部（最快，$O(1)$）。
    * 步骤：新节点 `next` 指向原 `first` $\rightarrow$ 更新 `first` 指向新节点。

```cpp
void IntList::insert(int v) {
// MODIFIES: this
// EFFECTS: inserts v into the front of the list
	node *np = new node;   
	np->value = v;
	np->next = first;
	first = np;
}
```
![[Pasted image 20260415162304.png]]


* **删除 (Remove)**：
    * **逻辑**：需要找到目标节点的前驱（Previous）。
    * **特殊情况**：如果要删除的是第一个节点，直接更新 `first`。
    * **普通情况**：`prev->next = victim->next`。
    * **易错点**：删除节点后必须手动 `delete` 释放内存，否则会导致**内存泄漏**。

```cpp
int IntList::remove(){
// MODIFIES: this 
// EFFECTS: if list is empty, throw listIsEmpty. 
// Otherwise, remove and return the first element of the list
	node *victim = first;
	int result;
	if (isEmpty()) {
		listIsEmpty e;
		throw e
	}
	first = victim->next;
	result = victim->value;   // return the deleted value
	delete victim;
	return result;
}
```

> 其中 `listIsEmpty` 是链表为空时抛出的 Exception class

---

### **5. 内存管理：析构函数与拷贝构造函数**
* **必要性**：由于链表节点是动态分配的（`new`），类销毁时必须手动清理。
* **实现逻辑**：从 `first` 开始，循环使用临时指针暂存下一个节点，逐个 `delete` 当前节点。
* **易错点**：严禁在 `delete` 当前节点后再访问其 `next` 指针。
一个很简便的方式是，直接利用之前实现的 `remove()` 函数，逐个删除头节点，实现如下：
![[Pasted image 20260415164153.png]]

至于为什么要另外定义一个功能一模一样的辅助函数，是为了应对其他需要清空链表的情形，毕竟析构函数是不能手动调用的

---

拷贝函数的实现可以通过 recursion 非常优雅的实现：

```cpp
void IntList::copyList(node *list) {   
	if(list == nullptr) return;  // base case
	copyList(list->next);
	insert(list->value);
}
// With copyList(), the copy constructor and assignment operator are pretty easy
```
### **6. 高阶优化：双端链表 (Double-Ended List)**
* **动机**：普通链表在尾部插入需要遍历全表（$O(N)$），效率低。
* **改进**：增加一个 `Node *last` 指针，始终指向最后一个节点。
* **性能提升**：
    * `insert_back`（尾部插入）降至 **$O(1)$**。
* **致命局限**：**删除末尾节点**依然是 **$O(N)$**。因为即使有 `last` 指针，你也无法在常数时间内找到它的“前驱”节点来更新 `last`。

> **[建议配合课件第 42-43 页：带有 last 指针的链表结构图]**

---

### **7. 终极方案：双向链表 (Doubly-Linked List)**
* **结构改进**：节点增加 `Node *prev` 指针。
    * `next`：指向后一个。
    * `prev`：指向前一个。
* **核心优势**：
    * **真正实现尾部删除 $O(1)$**：通过 `last->prev` 直接定位倒数第二个节点。
    * 支持双向遍历。
* **代价**：
    * 每个节点多占一个指针的内存。
    * 插入/删除操作需要维护更多的指针（通常是 4 个），逻辑更复杂。

> **[建议配合课件第 52-53 页：双向链表节点连接及 prev 指针的对应关系图]**

---

### **8. 复杂度总结表**

| 操作 | 数组 (固定/动态) | 单向链表 | 双端链表 (带 tail) | 双向链表 |
| :--- | :--- | :--- | :--- | :--- |
| **首部插入/删除** | $O(N)$ | $O(1)$ | $O(1)$ | $O(1)$ |
| **尾部插入** | $O(1)$* | $O(N)$ | $O(1)$ | $O(1)$ |
| **尾部删除** | $O(1)$ | $O(N)$ | $O(N)$ | $O(1)$ |
| **随机访问 [i]** | $O(1)$ | $O(N)$ | $O(N)$ | $O(N)$ |

*\* 动态数组平摊复杂度为 $O(1)$*