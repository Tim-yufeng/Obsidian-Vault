# 15 Interfaces and Invariants

前面的 ADT 已经把 data 与 operations 封装进 class，但 class definition 仍然暴露 private data members。这里继续把 abstraction 推到底：abstract base class 只留下 interface，derived class 承担具体 representation；representation invariant 则成为 implementation 内部维持正确性的共同约束。

## Interface 是使用 contract

对 caller 来说，ADT 应当只是 interface：它承诺有哪些 operations、各自满足什么 specification。只要 implementation 满足 contract，就可以替换具体 representation。

```cpp
class IntSet {
public:
    virtual void insert(int v) = 0;
    virtual void remove(int v) = 0;
    virtual bool query(int v) = 0;
    virtual int size() = 0;
};
```

普通 class 把 method declarations 与 data members 都放在 header 中。即使 data 是 private，client programmer 仍然看得到它采用 array、capacity 与 element count，这会让 interface 难读，也容易诱导 client 依赖 contract 没有保证的 implementation detail。

## Abstract base class

把 method 声明为 `virtual` 并写 `= 0`，得到 pure virtual function。至少含一个 pure virtual function 的 class 是 abstract class；它只描述 interface，没有完整 implementation，因此不能直接创建 object：

```cpp
IntSet set;      // Error: IntSet is abstract
```

但可以声明 pointer 或 reference，因为它们最终可以绑定到 concrete derived object：

```cpp
IntSet *set_ptr;
// IntSet &set_ref = some_concrete_set;
```

Concrete implementation 通过 public inheritance 实现全部 pure virtual functions，并自行加入 data members：

```cpp
const int MAXELTS = 100;

class IntSetImpl : public IntSet {
    int elts[MAXELTS];
    int numElts;
public:
    IntSetImpl();
    void insert(int v);
    void remove(int v);
    bool query(int v);
    int size();
};
```

`IntSetImpl` 可以采用 sorted 或 unsorted array，client 只通过 `IntSet` interface 调用，因此不依赖这项选择。若漏掉任何 pure virtual function 的 implementation，derived class 仍然 abstract，不能实例化。

## 隐藏 concrete implementation

Interface 通常放在 public `.h`，client include 该 header；implementation class 与 method definitions 放在 `.cpp`，client 只链接 object code。若只需要一个 instance，可以公开 access function：

```cpp
// intset.h
IntSet *get_int_set();
// EFFECTS: returns a pointer to the shared IntSet
```

```cpp
// intset.cpp
static IntSetImpl implementation;

IntSet *get_int_set() {
    return &implementation;
}
```

`static` object 只在该 source file 内可见，client 得到的是 base-class pointer。若需要多个 instances，则要由 implementation side 提供动态创建机制，不能让 client 直接写一个它看不见定义的 `IntSetImpl`。

## Representation invariant

Invariant 是一组必须在明确 program points 为真的 conditions。对 ADT，representation invariant 约束 private data members，使它们确实表示所声称的 abstract value。

例如用 array 表示 `IntSet`：

- unsorted representation：前 `numElts` 个槽位恰好存放 set 中所有 integers，且无 duplicates；
- sorted representation：除上述条件外，还严格从小到大排列。

<span class="red">每个 method 可以在 entry 假定 invariant 成立，但在 return 前必须重新建立 invariant；constructor 也必须建立它。</span>这一推理依赖 data members 真正 private，因为只有 class methods 能修改 representation。

写 method 时可以按“完成操作，再修复被破坏的 invariant”思考。以 unsorted insertion 为例，写入 `elts[numElts]` 后，暂时出现“新 value 已在 array，但计数没包含它”的中间状态；执行 `++numElts` 后 invariant 才恢复。Intermediate state 可以暂时破坏 invariant，但不能从 method 泄露出去。

## 用 repOK 做 defensive programming

复杂 structure 值得写 private checker：

```cpp
bool strict_sorted(const int a[], int size) {
    // REQUIRES: a has at least size elements
    // EFFECTS: returns true if a[0..size-1] is strictly increasing
    if (size <= 1) return true;

    for (int i = 0; i < size - 1; ++i) {
        if (a[i] >= a[i + 1]) return false;
    }
    return true;
}

bool IntSetImpl::repOK() const {
    return numElts >= 0
        && numElts <= MAXELTS
        && strict_sorted(elts, numElts);
}
```

每个修改 representation 的 method 返回前执行：

```cpp
assert(repOK());
```

也可以在 entry 检查，确认 caller 交回的 object 没有在此前被破坏。`repOK` 不替代 specification tests：它只判断 representation 是否自洽，不判断 method 是否完成了 caller 想要的 abstract operation。

## 复习检查

- Interface 规定 client 可以依赖什么；implementation details 不属于保证。
- Pure virtual function 写作 `virtual ... = 0;`；含它的 class 不能实例化，但可以有 pointer / reference。
- Derived implementation 必须实现全部 pure virtual methods，才能成为 concrete class。
- Rep invariant 应在写 method 前明确；constructor 与每个 method return 前都要保证它成立。
- Private data + method exit 建立 invariant，才让下一个 method 有资格在 entry 假定 invariant。

参考材料：Problem Solving with C++ (8th Edition) Chapter 10.4；Chapter 15.1、15.3。
