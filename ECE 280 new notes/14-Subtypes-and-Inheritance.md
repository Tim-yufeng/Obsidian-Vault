# 14 Subtypes, Inheritance, Virtual Functions

这一节把 ADT 从"一个类型"扩展到"类型之间的关系"。subtype 的定义完全用 specification 写成，而不是用语法：看一个类型能否替代另一个，看的是它的 REQUIRES / EFFECTS 有没有变得更强或更弱。C++ 的 inheritance 只是实现这种关系的一种机制，而且它允许你写出**不是** subtype 的 subclass——这正是 virtual function 存在的原因。

## subtype 与 substitution principle

设 S 与 T 是两个类型，<span class="red">若任何期待 T 类型对象的地方都可以用 S 类型对象提供而不改变原计算的正确性，则称 S 是 T 的 subtype，记作 S <: T</span>。换句话说：为正确使用 T 而写的代码，改用 S 之后仍然正确。这条性质称为 substitution principle。当 S <: T 时，也称 T 是 S 的 supertype。

标准库里的例子最能说明问题：

```cpp
void add(istream &source) {
    int n1, n2;
    source >> n1 >> n2;
    cout << n1+n2;
}

add(inFile);   // inFile 已声明为 ifstream 并已打开
```

`add(inFile)` 合法且能正常工作，因为 `ifstream` 是 `istream` 的 subtype：`ifstream` 可以被提供给 `istream` 的位置而不改变正确性。

subtype 与"type-convertible"是两件不同的事。在任何期待 `double` 的计算里都可以用 `int`，但此时对象不再是 `int`——它先被转换成 `double`，物理表示也变了。而用 subtype 替代 supertype 时不会发生转换：<span class="red">对象直接以其本来面目被使用</span>。正因为不需要转换，subtyping 最直接的收益是 code reuse：一份为 `istream` 写的读取函数可以服务所有输入流类型。

## 创建 subtype 的三种方式

在一个 ADT 上，有三种方式从 supertype 造出 subtype：

1. Add one or more operations.
2. Strengthen the postcondition of one or more operations.
3. Weaken the precondition of one or more operations.

### 方式一：增加操作

给 subtype 增加新方法不影响替代性：使用原 supertype 的代码只期待"旧"方法，而这些方法仍然存在，"新"方法对它没有任何影响。例如给 `IntSet` 增加一个返回最大元素的 `max()`，得到 `MaxIntSet`：

```cpp
class MaxIntSet : public IntSet {
    // OVERVIEW: a set of integers, where |set| <= 100
  public:
    int max();
      // REQUIRES: set is non-empty
      // EFFECTS: returns largest element in set.
};

void foo(IntSet &is) { ... }
void main() {
    MaxIntSet ms;
    foo(ms);   // 合法：foo 不会去调用 MaxIntSet 的 max()
}
```

`MaxIntSet` 的对象里有 `IntSet` 的全部成员（`elts[]`、`numElts`、`insert()`、`remove()`……）加上新增的 `MaxIntSet::max()`。

### 方式二：强化 postcondition

一个 method 的 postcondition 由两部分构成：EFFECTS 子句和它的返回类型。强化 postcondition 的一种做法是把 EFFECTS 子句加强——承诺原来承诺的一切，外加额外的东西。例如

```cpp
int A::f(int arg);
  // REQUIRES: arg is positive and even.
  // EFFECTS: returns arg/2.
```

可以造出 A 的 subtype B，只改 `f`：除了计算 `arg/2` 之外，每次调用还向屏幕打印一条消息。

```cpp
int g(A &a) { int arg = 2; return a.f(arg); }
void main() { B b; int c = g(b); ... }   // g 内部调用的是 B::f(arg)
```

当期待 `A::f()` 时可以用 `B::f()` 替代，因为 `B::f()` 做了 `A::f()` 做的所有事，另外多打了一条消息；使用者的期待依然被满足，所以 B 可以替代 A。

### 方式三：弱化 precondition

一个 method 的 precondition 由 REQUIRES 子句和它的参数类型构成。弱化 precondition 的一种做法是放松 REQUIRES 子句。上面那个 `f` 的 REQUIRES 是 "positive and even"，可以放宽为允许负偶数、允许正奇数、允许所有整数等等。

这样做的合理性在于集合的包含关系：`A::f()` 允许的实参集合（正偶数）是 `B::f()` 允许的实参集合（所有整数）的子集，因此任何对 `A::f()` 合法的调用对 `B::f()` 也一定合法。所以把 B 对象传给为 A 写的函数 `g` 是安全的。

把三种方式合起来记：<span class="red">subtype 的 method 必须至少做到旧 method 所做的一切（强化 postcondition），并且不能比旧 method 要求调用者更多（弱化 precondition）</span>。

## 用 inheritance 实现 subtyping

C++ 通过 subclassing（也叫 inheritance）提供 subtyping 机制。若已有 ADT class `foo`，想造 subtype class `bar`：

```cpp
class bar : public foo {
    ...
};
```

这句话读作"bar 是一个 foo，可能带有额外的状态，也可能带有新的或重新定义的 member function"；bar 称为 derived class，它 derived from foo。

`public` 表示 public inheritance：base 的所有 public 成员在 derived class 中仍然 public 的，base 的所有 private 成员在 derived class 中仍然 private。也可以写 private inheritance（`class bar : private foo`），此时 base class 的所有成员在 derived class 中都是 private。通常使用 public inheritance，这样原有 public member function 都保持 public。

### protected：让 derived class 看见 representation

把 `MaxIntSet` 真正写出来时会撞到一个问题：`IntSet` 的数据成员默认是 private，而 private 的含义是"只能被本 class 的其他成员看见"，所以 `MaxIntSet` 的新成员（尤其是 `max()`）无法访问它们。只能用 public 的 access function 迂回：

```cpp
int MaxIntSet::max() {
    int i;
    for (i = INT_MAX; i >= INT_MIN; i--) {
        if (query(i)) return i;
    }
}
```

这个实现效率极差：在一个随机构造的集合中，平均要查询 $2^{31}$（即 $2^{32}$ 的一半）个数才能找到最大元素。

C++ 用 `protected` storage class 解决这个问题：被声明为 protected 的成员"可以被本 class 以及任何 derived class 的所有成员看见"。

```cpp
class IntSet {
  protected:
    // all of the data members plus indexOf
  public:
    // the public interface to the class.
};
```

由于 `MaxIntSet` derived from `IntSet`，`IntSet` 的 protected 成员对 `MaxIntSet` 可见；`IntSet` 的其他使用者仍然看不见它们。于是 `max()` 可以写得很高效，且写法取决于 representation：

```cpp
int MaxIntSet::max() {              // Unsorted Array
    int so_far = elts[0];
    for (int i = 1; i < numElts; i++) {
        if (elts[i] > so_far) so_far = elts[i];
    }
    return so_far;
}

int MaxIntSet::max() {              // Sorted Array
    return elts[numElts-1];
}
```

### protected 的代价

`protected` 不是免费的。<span class="red">把 IntSet 的实现暴露给 MaxIntSet，就意味着修改那个实现会破坏 MaxIntSet</span>。例如把 `IntSet` 从 sorted 实现换成 unsorted 实现，第二个版本的 `MaxIntSet::max()` 就会返回错误的值；更糟的是它仍然能编译通过，你根本不会发现。这正说明暴露实现细节的坏处：protected data members 让 derived class 变得极其脆弱，是否值得这样做取决于取舍。

### override 与调用哪一个

除了增加 method，也可以在 subclass 中改写某个已有的 method。但改写不能任意进行，必须仍然满足 substitution principle——这正是前面三种方式的另一种表述。

```cpp
class SafeMaxIntSet : public MaxIntSet {
    // OVERVIEW: a mutable set of integers, where |set| <= 100
  public:
    int max();
    // EFFECTS: if set is non-empty, returns largest element in set
    //          otherwise, returns INT_MIN.
};
```

与 `MaxIntSet::max` 相比，它同时弱化了 precondition（旧版要求集合非空，新版不要求）并强化了 postcondition（旧版对非空集返回最大元素，新版除此之外还对空集返回 `INT_MIN`）。因此它正确满足 substitution principle：为使用 `MaxIntSet` 而正确编写的代码换成 `SafeMaxIntSet` 后无需任何改动。

它定义了"与 MaxIntSet 完全相同、只是替换（override）了 max"的新 class。在默认情况下，编译器**根据调用 max 的对象的类型**决定调用哪一个：

```cpp
MaxIntSet ms;
SafeMaxIntSet ss;

ss.max();   // 调用 SafeMaxIntSet::max()，空集返回 INT_MIN
ms.max();   // 调用 MaxIntSet::max()，空集时行为未定义
```

实现本身很短，大部分工作交给旧实现：

```cpp
int SafeMaxIntSet::max() {
    if (size())
        return MaxIntSet::max();
    else
        return INT_MIN;
}
```

顺带回答两个判断题：ADT 可以用 C++ class 实现（对）；subtype 可以用 C++ subclass 实现（对）；但"class 一定是 ADT"（错，如果所有成员都 public 就没有抽象可言）、"subclass 一定是 ADT subtype"（错，下一节就是反例）。

## subclass 不一定是 subtype

完全可能造出违反 substitution principle 的 subclass：

```cpp
class PosIntSet : public IntSet {
    // OVERVIEW: a mutable set of positive integers
  public:
    void insert(int v);
      // EFFECTS: if v is positive and s has room to include it, s = s + {v}.
      //          if v <= 0, throw int -1
      //          if s is full, throw int MAXELTS
};
void PosIntSet::insert(int v) {
    if (v <= 0) throw -1;
    IntSet::insert(v);
}
```

`PosIntSet` 不是 `IntSet` 的 subtype，因为为使用 `IntSet` 而正确编写的代码在改用 `PosIntSet` 时可能失败——例如插入一个负数时它抛异常。它违反了 substitution principle：`insert` 的 precondition 被**加强**了。

更麻烦的是 C++ 的规则允许 subclass 出现在期待 superclass 的位置，所以下面这些赋值完全合法：

```cpp
PosIntSet s;
IntSet *p = &s;
IntSet &r = s;
```

现在 `s` 是 `PosIntSet`，`p` 是指向这个 `PosIntSet` 的 pointer，`r` 是这个 `PosIntSet` 的 reference。三种调用方式的区别就在这里：

```cpp
try { s.insert(-1); }              // 抛异常，输出 "Exception thrown"，符合预期
catch (int i) { cout << "Exception thrown\n"; }

try { r.insert(-1); }              // 这里会怎样？
catch (int i) { cout << "Exception thrown\n"; }
```

要回答它必须区分两个概念。reference `r` 的**声明**类型是 "reference to an IntSet"，但它实际指向一个 `PosIntSet`：apparent type 是引用被声明的类型（`IntSet`），actual type 是被引用对象的真实类型（`PosIntSet`）。<span class="red">在默认情况下，C++ 根据 apparent type 选择要运行的 method</span>。因此 `r.insert(-1);` 调用的是 `IntSet::insert()`，它会"愉快地"把 `-1` 插进去，什么异常都不抛；使用 pointer `p` 时结果相同。这破坏了对象 `s` 的抽象，是 Very Bad 的情况。

## virtual function：让选择发生在运行时

要告诉 C++ 选择 actual type，只需在 class 定义中给 `insert` 的声明加上 `virtual`：

```cpp
class IntSet {
    ...
  public:
    ...
    virtual void insert(int v);
    ...
};
```

这等于告诉编译器："有人可能 override 我的实现，永远在 run-time 检查该调用哪个版本。"

`virtual` 关键字不必在函数定义处重复，`void IntSet::insert(int v) { ... }` 是合法的；`PosIntSet` 中的 `insert` 也不必重复书写，因为 virtualness 会像其他性质一样被继承。

加上之后：

```cpp
PosIntSet s;
IntSet *p = &s;
IntSet &r = s;

p->insert(-1);   // 现在检查对象的实际类型，调用 PosIntSet::insert
```

`p` 被声明为 pointer-to-IntSet，但它真正指向的可能是某个 derived class 类型；编译器生成的代码会检查对象的实际类型并在运行期调用正确的函数。

## vtable 机制

带 virtual function 的 class 需要携带足够信息以判断"我是什么类型"。编译器为每个含 virtual function 的 class 创建一张 vtable（virtual table），其中为每个 virtual function 放一个 function pointer，指向合适的实现；每个该类型实例中除了 class 的 state 之外，还多存一个指向相应 vtable 的 pointer。

![[Pasted image 20260809153004.png]]

图中 `IntSet` 的 vtable 里 `insert` 指向 `IntSet::insert`，`PosIntSet` 的 vtable 里 `insert` 指向 `PosIntSet::insert`；`foo` 与 `bar` 两个对象的状态部分相同，差别在于各自对象末尾的 vtable pointer 分别指向哪张表。因此 `IntSet &r = bar; r.insert(-1);` 的执行路径是：读取 `bar` 的 vtable，检查其中的 `insert` 条目，调用 `PosIntSet::insert` 而不是 `IntSet::insert`。要注意的是，<span class="red">如果没有 `virtual` 关键字，vtable 里根本不会有 `insert` 这个条目</span>——这正是默认静态绑定与 virtual 动态绑定的分界。

参考材料：Problem Solving with C++ (8th Edition) Chapter 10.4（Introduction to Inheritance）、Chapter 15.1（Inheritance Basics）、Chapter 15.3（Virtual Functions in C++）。
