# 20 Template and Container

19C 的 templated list 按 value 存储 element；这一节继续追问两个问题：如果 object 很大，复制太贵怎么办？如果一个 container 需要同时容纳多个 derived types，又怎样在复制时保留各自的 actual type？答案依次是 pointer container、ownership rules 与 polymorphic `clone()`。

## Template recap

Template 把 type 变成 compile-time parameter：

```cpp
template <class T>
class List {
public:
    void insert(T value);
    T remove();
    // ...
};
```

`List<int>` 与 `List<BigThing>` 会产生针对各自 type 的 code。Member definitions 仍需写 `template <class T>` 与 `List<T>::`，并放在 header 中让 compiler 看见。

## By-value container 的复制成本

若 `insert` 接受 `BigThing` by value：

```cpp
void ListBigThing::insert(BigThing value) {
    node *np = new node;
    np->value = value;
    np->next = first;
    first = np;
}
```

典型语义下至少会发生两次 copy-related operations：actual object 复制进 parameter，再从 parameter 复制进 node。对 built-in type 代价很小，对 large struct / class 可能很贵。

Pointer container 改为保存地址：

```cpp
template <class T>
class PtrList {
public:
    void insert(T *value);
    T *remove();
private:
    struct node {
        node *next;
        T *value;
    };
    node *first;
};
```

这里 template parameter 仍是 pointed-to type：声明 `PtrList<BigThing>`，而不是把普通 value template 写成 `List<BigThing*>` 后假装 ownership 自动解决。两种设计的 destructor、copy semantics 完全不同，最好用不同 class 明确表达。

## Pointer container 的 ownership contract

只保存 pointer 会引入 use-after-free 与 memory leak。课件规定一个 invariant 与三条规则：

1. At-most-once invariant：同一 object 在同一时刻最多通过 pointer 链接到一个 container。
2. Existence：插入前 object 必须 dynamically allocated，不能把 local stack object 的地址交给会长期保存它的 container。
3. Ownership：插入后 object 归 container 所有，只通过 container methods 修改，避免外部破坏 representation invariant。
4. Conservation：remove 后，要么把 pointer 转交给另一个 container，要么使用完后 delete referent，不能让它成为 orphan。

<span class="red">把 pointer 放入 owning container 等于转移 ownership；remove 则把 ownership 交回 caller。</span>

```cpp
void transfer(PtrList<BigThing> &list) {
    BigThing *object = new BigThing;
    list.insert(object);          // ownership -> list

    BigThing *out = list.remove(); // ownership -> caller
    // use out
    delete out;
}
```

## Destructor 与 deep copy

Owning pointer container 的 destructor 不只删除 nodes，还要删除 node 指向的 objects：

```cpp
template <class T>
PtrList<T>::~PtrList() {
    while (!isEmpty()) {
        T *object = remove();
        delete object;
    }
}
```

Copy constructor 若只复制 pointer，会让两个 containers 同时认为自己拥有同一 objects，违反 at-most-once invariant；任一方 delete 后，另一方留下 dangling pointers。正确做法是同时复制 nodes 与 referents：

```cpp
template <class T>
void PtrList<T>::copyList(node *source) {
    if (source == nullptr) return;

    copyList(source->next);
    T *copy = new T(*source->value);
    insert(copy);
}
```

`new T(*source->value)` 调用 `T` 的 copy constructor，得到独立 object。Assignment operator 同样要先处理自己原有的 owned objects，再完成 deep copy，并防止 self-assignment。

## Value list 与 pointer list 必须分开

```cpp
template <class T>
class ValList { /* stores T */ };

template <class T>
class PtrList { /* owns T* */ };
```

`ValList<T>` 不应 delete values，`PtrList<T>` 必须按 ownership policy delete referents。仅靠一个普通 template 无法自动判断“这个 instantiation 是借用 pointer、拥有 pointer，还是按值存储”，因此 interface 必须把语义说清楚。

## Polymorphic container

普通 template container 的一个 instance 只容纳一个 static type。若需要同一 container 存放多种 related derived objects，可以制造共同 base type：

```cpp
class Object {
public:
    virtual ~Object() {}
};

class BigThing : public Object {
    // ...
};
```

Container 保存 `Object*`；根据 substitution principle，`BigThing*` 可以在需要 `Object*` 的地方使用：

```cpp
BigThing *big = new BigThing;
objects.insert(big);
```

Base class 必须有 virtual destructor，这样通过 `Object*` delete 一个 derived object 时，会调用 actual derived destructor，完整释放 derived resources。

## 取回 actual type：dynamic_cast

`remove()` 返回 `Object*`，不能直接赋给 `BigThing*`。当 caller 确实需要某个 derived interface 时：

```cpp
Object *object = objects.remove();
BigThing *big = dynamic_cast<BigThing *>(object);
assert(big != nullptr);
```

若 actual object 是 `BigThing` 或其 derived type，cast 返回有效 pointer；否则返回 `nullptr`。这种 pointer-form `dynamic_cast` 要求 source type 是 polymorphic type，也就是至少有一个 virtual function；这里 virtual destructor 已满足。

## 多态 deep copy 的难点

只复制 `Object*` 会得到 shallow copy。直接写 `new Object(*pointer)` 也不行：它只知道 apparent base type，无法按 actual derived type 选择正确 copy constructor，甚至 `Object` 可能是 abstract。

![[Pasted image 20260917143444-02.png]]

图中 orig 与 new 两组 nodes 指向同一批 objects；new 中删除一个 object 后，orig 的对应 pointer 立刻悬空。这说明“nodes 已 deep copy”仍不够，referents 也必须按 actual type 复制。

## Named constructor idiom：clone()

把“复制我自己”变成 virtual operation：

```cpp
class Object {
public:
    virtual Object *clone() const = 0;
    virtual ~Object() {}
};

class BigThing : public Object {
public:
    BigThing(const BigThing &other);

    Object *clone() const {
        return new BigThing(*this);
    }
};
```

每个 derived class 的 `clone()` 知道自己的 actual type，因此会调用正确 copy constructor，却统一返回 `Object*`。Container 的 copy helper 就可以动态分派：

```cpp
void List::copyList(node *source) {
    if (source == nullptr) return;

    copyList(source->next);
    Object *copy = source->value->clone();
    insert(copy);
}
```

这条链把三种机制接在一起：inheritance 提供共同 interface，virtual dispatch 选择 actual `clone()`，copy constructor 复制 derived state。最终得到真正的 polymorphic deep copy。

## 复习对比

| Container | 存储内容 | Copy 时做什么 | Destruction 时做什么 |
|---|---|---|---|
| `ValList<T>` | `T` values | 复制 values | values 随 nodes 正常销毁 |
| `PtrList<T>` | owned `T*` | `new T(*old)` | delete referents 与 nodes |
| polymorphic list | owned `Object*` | virtual `clone()` | 通过 virtual destructor delete actual objects |

参考材料：Problem Solving with C++ (8th Edition) Chapter 17、Chapter 18.2。
