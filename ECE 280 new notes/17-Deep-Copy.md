# 17 Deep Copy

上一节给 IntSet 加了 destructor，让对象销毁时能归还堆上的数组。但"销毁"只解决了问题的一半：一旦 class 里出现指向动态存储的 pointer，**复制**这个对象就变得危险，因为编译器默认只会把 pointer 的值抄一份。这一节把 shallow copy 与 deep copy 的区别讲清楚，并给出两个必须自己重写的机制：copy constructor 与 assignment operator。

## 问题的来源：pass by value

看一段看起来毫无问题的代码：

```cpp
void foo(IntSet x) {
    // do something
}
void main() {
    IntSet s;
    s.insert(5);
    foo(s);
    s.query(5);
}
```

提示是：class 和 struct 一样是 pass by value，也一样是按 bit 复制的。结果就是 **只有 pointer `elts` 的值被复制，数组 `elts[]` 本身没有被复制**，于是两个对象共享同一个 `elts[]` 数组。

![[Pasted image 20260809153006.png]]

图中 `s` 与 `x` 的 `elts:` 框里是同一个箭头，指向同一块数组；`sizeElts`、`numElts` 则各自独立。由此产生两个后果：`foo` 结束时 `x` 走出作用域并被销毁，它内部的 destructor 会 `delete[] elts`，于是 `s.elts` 成为 dangling pointer；`main` 结束时 `s` 的 destructor 再次 `delete[]`，造成对同一块内存的 double-deletion。

完全同样的事情也发生在看起来与函数无关的赋值上：

```cpp
void foo() {
    IntSet s(5);
    s.insert(7);
    {
        IntSet x;
        x = s;      // shallow copy
    }
    s.query(7);     // Undefined!
}
```

赋值语句把 `s` 的各成员复制到 `x`，但两者最终共享 `elts` 数组；`x` 走出局部 block 被销毁后，`s.elts` 就 dangling 了。所以问题不在于"传参"这个动作，而在于 <span class="red">"复制一个含 pointer 的 class 对象时，默认行为是 shallow copy"</span>。

## deep copy

我们真正想要的是把整个数组也复制过去：`s` 与 `x` 各有自己的数组，内容相同。

当一个 class 含有指向动态元素的 pointer 时，复制它是 tricky 的。只复制"class 的各成员"得到的是 shallow copy；通常我们需要把一切完整复制一份，这叫 <span class="red">deep copy</span>。

C++ 的 class 机制提供了两个关系非常密切的机制来复制 class 对象：copy constructor 与 assignment operator。

- Copy constructor：通过复制本 class 的另一个对象来创建本 class 的一个对象。换句话说，给定一块"空白"内存和一个"样本"实例，把这块空白变成样本的副本。
- Assignment operator：把一个对象（source）的内容复制到另一个**已经存在**的对象（target）上。两者的区别在于对象是否已经存在。

## copy constructor

```cpp
class IntSet {
    int *elts;    // array of elements
    int numElts;  // number of elements in array
    int sizeElts; // capacity of array
  public:
    IntSet(int size = MAXELTS);  // client optionally names size
    IntSet(const IntSet &is);    // copy constructor
    ...
};
```

它和别的 constructor 走的是同一个 overloading 机制——参数类型不同，所以可以共存。当按值向函数传递参数时，copy constructor 被调用：它在一个"空白"的 IntSet 实例上被调用，必须让这个空白版本看起来与实参完全一样。

```cpp
foo(s);   // s 是 IntSet

void foo(IntSet x) {
    // copy constructor copies s to x
    // do something
}
```

签名为什么必须是 `const IntSet &is`：参数必须按 reference 传递，否则会造成 infinite recursion（按值传参本身又要调用 copy constructor）；参数必须是 const，理由有两个——避免意外修改实参；保证任何实例（例如 const 对象）都能充当 source，而不只是 lvalue。

copy constructor 需要完成三件事：

1. 分配一个与源集合同样大小的数组。
2. 把源数组的每个元素复制到新数组。
3. 复制 `numElts` / `sizeElts` 字段。

第 2 步的逻辑在 copy constructor 与 assignment operator 里都要用，所以把它抽成一个 utility function，作为 private method 加入 ADT：

```cpp
class IntSet {
    int *elts; int numElts; int sizeElts;
    void copyFrom(const IntSet &is);
      // MODIFIES: this
      // EFFECTS: copies is' contents to this
  public:
    IntSet(int size = MAXELTS);
    IntSet(const IntSet &is);
    ...
};
```

写 `copyFrom` 之前要想清楚它**一般**情况下要做什么，而不只是"在 copy constructor 里要做什么"，因为它还会被 assignment operator 调用。作为 method，它必须维护 representation invariant：

1. 必须假设 source 与 destination 的大小可能不同，若不同就适当地 resize 数组——销毁再重新分配。
2. 把源数组复制到目标数组。
3. 复制 `sizeElts` 与 `numElts`。

```cpp
void IntSet::copyFrom(const IntSet &is) {
    if (is.sizeElts != sizeElts) {   // Resize array
        delete[] elts;
        sizeElts = is.sizeElts;
        elts = new int[sizeElts];
    }
    // Copy array
    for (int i = 0; i < is.sizeElts; i++) {
        elts[i] = is.elts[i];
    }
    // Establish numElts invariant
    numElts = is.numElts;
}
```

在 `copyFrom` 里可以直接访问 `is.sizeElts`、`is.elts[i]`，因为 `copyFrom` 是 IntSet 的 member function，private 成员对同一 class 的成员可见。

有了 `copyFrom`，copy constructor 就很简单了：先建立它自己的 invariant，再调用 `copyFrom`。

```cpp
IntSet::IntSet(const IntSet &is) : elts(nullptr), sizeElts(0), numElts(0) {
    copyFrom(is);
}
```

这里 `elts(nullptr), sizeElts(0)` 的初始化是必要的：`copyFrom` 会先比较 `is.sizeElts != sizeElts`，如果不先把 `sizeElts` 置为 0，它拿到的是未初始化值，可能恰好等于 `is.sizeElts` 从而跳过 resize，随后对未初始化的 `elts` 写入，后果不可预测。

把它和"默认"的复制方式对比一下：默认方式只做几件事——复制 `elts` / `numElts` / `sizeElts` 三个字段。而我们写的 copy constructor 会**顺着 pointer 追下去，复制它们指向的东西**，而不只是复制 pointer 本身，这就是 deep copy。

## assignment operator

赋值语句本身是有返回值的：这个值是指向左侧对象的 reference。例如

```cpp
x = 4;
(y = x) += 2;   // 合法，先返回 y 的 reference，然后 y += 2
```

上面这段是合法的，执行后 `x = 4`、`y = 6`。赋值还可以链式书写：`x = y = z;` 也是合法的复合表达式，因为 assignment operator 是右结合的——先把 `z` 赋给 `y`，这个表达式产生（新的）`y`，再把它赋给 `x`。

现在考虑

```cpp
IntSet s1(5);
IntSet s2(10);
s1 = s2;   // assignment of s2 to s1
```

默认情况下编译器会用 shallow copy 处理它。和 copy constructor 一样，赋值也必须把右侧 deep copy 到左侧，实现手段是 operator overloading——重新定义 IntSet 的"赋值运算符"：

```cpp
class IntSet {
    // data elements
    ...
  public:
    // Constructors
    ...
    IntSet &operator= (const IntSet &is);   // "operator" 是关键字
    ...
};
```

`operator` 是关键字，同样的写法也可以用来重载 `+`、`*` 等运算符。

签名值得逐项读：和 copy constructor 一样，它接受一个 const 实例的 reference 作为复制来源；不同的是它还返回**被复制到**的那个对象的 reference。调用 `a = b;` 时，本质上是在调用对象 `a` 的赋值运算符，`b` 是这个 `operator=()` 函数的实参，因此可以把它读作 `a.operator=(b)`。

因为 `copyFrom` 已经写好，赋值运算符几乎是平凡的：

```cpp
IntSet &IntSet::operator= (const IntSet &is) {
    copyFrom(is);
    return *this;
}
```

三处细节。每个 method 都有一个隐式的局部变量 `this`，它是指向"该方法所操作的当前实例"的 pointer；`return *this;` 先解引用这个 pointer 再返回它的 reference——不能直接返回 `this`，因为 `this` 只是 pointer，不能当作 reference 使用；必须返回被赋值对象的 reference，而不是赋值来源的 reference，也就是不能写 `return is;`。

还有一个自我赋值的问题：

```cpp
IntSet s(50);
s = s;
```

这里恰好没问题，因为两边的 `sizeElts` 相等，不需要销毁并重新分配。但更好的做法是显式判断：

```cpp
IntSet &IntSet::operator= (const IntSet &is) {
    if (this != &is)
        copyFrom(is);
    return *this;
}
```

## Rule of the Big Three

以上内容可以压缩成一条规则：<span class="red">如果 class 中含有任何动态分配的存储，就必须提供 destructor、copy constructor 与 assignment operator 三者</span>——这就是 Rule of the Big Three。而且实践上的判据更简单：如果你发现自己正在写其中一个，几乎可以肯定三个都需要。原因是这三种操作关心的是同一件事——"这份动态存储归谁所有、什么时候该被复制、什么时候该被释放"，只处理其中一面必然留下不一致。

## 练习

设计一个 Matrix class，包含：`Constructor(int num_row, int num_column)`（默认大小 0×0）；`void Set(int r, int c, int value);` 设置 $(r,c)$ 处的值；`int Get(int r, int c);` 返回 $(r,c)$ 处的值；`Matrix Plus(Matrix another_mat);` 矩阵求和；`void Print();` 打印矩阵内容。这个练习里 `Plus` 按值接受参数、又返回 Matrix 对象，正好会把 copy constructor 与 assignment operator 的作用完整地暴露出来。

参考材料：Problem Solving with C++ (8th Edition) Chapter 11.4（Classes and Dynamic Arrays）。
