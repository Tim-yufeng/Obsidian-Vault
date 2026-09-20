# 19C Double-Ended Linked List and Template

这一节接着 19 的 singly-linked list 做两次推广：先增加 `last` 与 `prev`，让结构支持更高效的尾部操作；再把 element type 改成 template parameter，使同一份 list implementation 可以容纳不同类型。

## Double-ended list：同时记录 first 与 last

只有 `first` 的 singly-linked list 在头部插入很快，但要在尾部插入，必须从头遍历到最后一个 node。Double-ended representation 额外保存：

```cpp
class IntList {
    node *first;
    node *last;
    // ...
};
```

Invariants 是：empty list 中 `first == nullptr` 且 `last == nullptr`；non-empty list 中 `first` 指向首 node，`last` 指向尾 node，且 `last->next == nullptr`。增加 `last` 后，所有可能改变首尾的 methods 都要重新检查，包括 insert、remove、default constructor 与 copy constructor。

## insertLast 的两个 case

```cpp
void IntList::insertLast(int value) {
    node *np = new node;
    np->value = value;
    np->next = nullptr;

    if (isEmpty()) {
        first = last = np;
    }
    else {
        last->next = np;
        last = np;
    }
}
```

Empty case 中，新 node 同时是 first 与 last；non-empty case 中，先让旧 `last->next` 指向新 node，再更新 `last`。边界分支不是特殊补丁，而是由“哪些 invariants 被破坏”决定的。

## 为什么只有 last 仍不能高效删除尾部

`last` 能直接定位最后一个 node，却不知道倒数第二个 node。Singly-linked list 只能沿 `next` 向后走，因此把 `last` 前移仍需从 `first` 遍历。

要让 backward traversal 与 tail removal 也高效，需要 doubly-linked node：

```cpp
struct node {
    node *next;
    node *prev;
    int value;
};
```

![[Pasted image 20260917143444-01.png]]

图中 `next` 指向后一 node，`prev` 指向前一 node；首 node 的 `prev` 为 `nullptr`，尾 node 的 `next` 为 `nullptr`。Doubly-linked list 让部分 operations 更快，但每个 node 多一个 pointer，insert / remove 也必须维护更多 links。课件题目的准确判断是：它不一定提供更多“理论上可做”的 operations，却会提高部分 operations 的效率；memory 增量也不一定恰好翻倍，因为 node 还包含 value 与 padding。

## Container 与 polymorphic code

`IntList`、`CharList` 只有 element type 不同，复制整份 code 会让维护成本成倍增加。Template 把 type name 变成 compile-time parameter：

```cpp
template <class T>
class List {
public:
    bool isEmpty() const;
    void insert(const T &value);
    T remove();

    List();
    List(const List<T> &other);
    List<T> &operator=(const List<T> &other);
    ~List();

private:
    struct node {
        node *next;
        T value;
    };

    node *first;
    void removeAll();
    void copyList(node *source);
};
```

`class T` 里的 `class` 表示 type parameter，不要求 `T` 本身一定是 class；`int`、`double`、`string` 都可替换。也可以写 `template <typename T>`。

## Template member definitions

Class 外定义每个 member 时，要重复 template declaration，并把 class name 写成 `List<T>`：

```cpp
template <class T>
bool List<T>::isEmpty() const {
    return first == nullptr;
}

template <class T>
void List<T>::insert(const T &value) {
    node *np = new node;
    np->value = value;
    np->next = first;
    first = np;
}
```

Constructor / destructor 名字本身不加 `<T>`，但 scope 前的 class name 要加：

```cpp
template <class T>
List<T>::List() : first(nullptr) {}

template <class T>
List<T>::~List() {
    removeAll();
}

template <class T>
List<T> &List<T>::operator=(const List<T> &other) {
    // ...
    return *this;
}
```

<span class="red">Template implementation 通常也放在 header 中，因为 compiler 实例化 `List<int>` 时必须看见完整 member definitions；不能只给 declaration、把 definition 藏在普通 `.cpp` 中。</span>

## 使用 template

```cpp
List<int> integers;
List<string> words;
List<double> *measurements = new List<double>;

integers.insert(3);
words.insert("hello");

delete measurements;
```

每个 `List<T>` 是不同的 instantiated type，但共享同一份 source template。Template 提供 compile-time polymorphism：一个 implementation 适用于 many types，同时每个 concrete container 仍只装一种 type。

参考材料：Problem Solving with C++ (8th Edition) Chapter 13.1、Chapter 17。
