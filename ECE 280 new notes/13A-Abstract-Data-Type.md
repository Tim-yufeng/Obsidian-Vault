# 13A Abstract Data Type (Part 1)

这一节回答一个问题：函数早就做到了"只告诉别人做什么、不告诉怎么做"，为什么类型做不到？ADT 就是把这个已经成功的思路从函数搬到类型上，而 C++ 里实现它的机制是 class。

## type 的两个组成部分

一个 type 由两件事定义：<span class="red">这个类型的元素能表示哪些值（values），以及能对它做哪些操作（operations）</span>。例如 C++ 的 `string`，它的 values 是所有字符序列，operations 是拼接、取长度、比较等。后面所有的讨论都围绕这两件事展开——ADT 的本质就是"值集合与操作集合的抽象描述"。

## struct type 的问题

struct type 的特点是：<span class="red">类型的每一个细节对所有使用者都是已知的，这就是所谓的 concrete implementation</span>。例如之前见过的

```cpp
struct Grades {
    char name[9];
    int midterm;
    int final;
};
```

每个函数都知道 Grades 究竟是怎么表示的。后果是：一旦修改 Grades 的定义（比如把 `name` 从 C-string 改成 C++ string），就必须在整个程序里找出所有相关位置一起改，并重新编译所有使用这个 struct 的代码。

把这件事和函数对照一下就很清楚。别人写的函数只展示它做什么，不展示它怎么做；因此如果找到了一种更快的实现方式，直接替换旧的实现即可，调用它的其他组件一行都不用改。struct 缺少的正是这种"可以随时换实现"的自由。

## ADT 的定义与两个优点

ADT 提供 values 与 operations 的抽象描述，它的定义必须同时包含"这个类型表示什么值"和"它支持哪些操作"，但可以把 how 的部分留空。幻灯片给的类比是手机：type 是"一部能拨打和接听电话的便携电话"，operations 是开机/关机、拨打/接听、发短信——使用者完全不需要知道内部的实现细节。

<span class="red">ADT 带来两个优点：information hiding 与 encapsulation</span>。

1. Information hiding：使用者不需要知道对象是如何表示的，也不需要知道操作是如何实现的。
2. Encapsulation：对象与它的操作定义在同一处，ADT 把 data 与 operation 合并成一个实体。

以前用过的 `list_t` 同时体现了这两点：使用 `list_t` 时你从来不知道这个结构的具体实现（除非去翻 `recursive.cpp`），这是 information hiding；而 `list_print`、`list_make` 等操作的定义与 `list_t` 的类型定义放在同一个 header file 里，这是 encapsulation。

和 functional abstraction 一样，ADT 也带来两个性质：ADTs are local——程序其他组件的实现不依赖于 ADT 的实现，实现其他组件时只需局部关注；ADTs are substitutable——可以更换实现，而该类型的所有使用者都察觉不到。

用这几条性质可以排除一类错误说法：函数实现变化后需要修改所有调用处（错，正好相反）；ADT 实现变化后需要修改所有使用者（错，substitutable）；删除 ADT 的某个操作后不必检查其他使用处（错，被删掉的操作可能正被别人调用）。而"一个 type 是 values 的集合加上 operations 的集合"正是 type 的定义。

## concrete representation 归谁管

抽象不等于没有人需要知道细节。值的表示方式与操作的实现方式总要有地方写下来，这被称为 concrete representation（或简称 representation）。问题是：谁能访问 representation？

<span class="red">答案是只有为该类型定义的操作才能访问 representation</span>，其他所有人都只能通过 operations 来读取或修改对象的状态。这条规则是 class 中 private 机制存在的理由。

## class：一个最简单的例子

C++ 的 `class` 提供了真正的 encapsulation。它的基本想法是提供一个单一实体，同时定义对象的值和可用的操作（这些操作也叫 member functions 或 methods）：

```cpp
class anInt {
    // OVERVIEW: a trivial class to get/set a single integer value
    int v;
  public:
    int get_value();
        // EFFECTS: returns the current value
    void set_value(int newValue);
        // MODIFIES: this
        // EFFECTS: sets the current value equal to newValue
};
```

这个定义里有四点值得注意。整个 class 只有一份 `OVERVIEW` specification 描述类整体；定义中同时包含 data elements（`int v`）与 member functions（`get_value`、`set_value`）；每个被声明的函数都必须有对应的 specification；`set_value` 的注释里写了 `MODIFIES: this`，`this` 是"这个对象本身"的通用称呼。RME 是 REQUIRES / MODIFIES / EFFECTS 三件套的缩写，其中 MODIFIES 只在函数会改变对象时出现。

## private 与 public

class 中默认所有成员都是 private，成员包括 data members 与 function members。private member 只对同一个 class 的其他成员可见——上面例子中的 `int v` 就是 private，private 的作用是把类型的实现对使用者隐藏起来。

但如果一切都 private，这个 class 就没有用了，所以用 `public` 关键字标明某些成员对任何看得到 class 定义的人都可见：`public` 之后的所有成员都是对外开放的。

## member function 的定义位置

上面的 class 定义本身是不完整的，因为还没有写出 member function 的函数体。可以在 class 内部直接定义，但那样会"暴露"信息，而这些信息最好隐藏起来。常规做法是把定义放在 `.cpp` 文件中：

```cpp
int anInt::get_value() {
    return v;
}
void anInt::set_value(int newValue) {
    v = newValue;
}
```

`anInt::` 这种写法指明函数属于哪个 class；`.cpp` 文件里应当 `#include` 对应的 `.h`。

## 创建对象与设置初值

```cpp
anInt foo;
anInt bar;
```

这会创建两个对象 `foo` 与 `bar`，但它们的 `v` 还没有初始值，仍然 undefined；给 data members 设置初始值有几种办法，后面会看到。要设置值就调用 member function：

```cpp
foo.set_value(1);   // 调用 foo 的 set_value()，之后 foo 的 v 变成 1
```

member function 调用和普通函数调用有一个非常重要的区别：<span class="red">对象中的其他成员对 member function 也是可见的</span>。所以 `set_value` 的函数体里可以直接写 `v = newValue;`，不需要把 `v` 当作参数传进去——被调用的那个对象的 `v` 就是它要改的 `v`。

读取值时不能直接访问：`cout << foo.v;` 会在编译期报错，因为 `v` 是 private 的。改用 public 的 `get_value()` 即可：`cout << foo.get_value();`。

## 对象作为参数：按值传递的陷阱

class object 可以像其他东西一样传递，而且和数组以外的其他一切一样是 pass by value。这一点很容易被忽略，看一个例子：

```cpp
void add_one(anInt i) {
    i.set_value(i.get_value() + 1);
}
int main() {
    anInt foo;
    foo.set_value(0);
    add_one(foo);
    cout << foo.get_value() << endl;   // 输出 0
    return 0;
}
```

`foo` 的值得以保留为 0，是因为 `add_one` 拿到的是 `foo` 的一份拷贝，函数里改的是那份拷贝。要真正改动传入的对象，必须用 pointer 或 reference 参数：

```cpp
void add_one(anInt *ip) {
    ip->set_value(ip->get_value() + 1);
}
```

这个版本会改变传给它的对象。这里也顺带固定了 `->` 的用法：对 pointer 调 member function 用 `->`，对对象或 reference 用 `.`。

## 练习：Interval class

一个 closed interval $[a,b]$ 表示一组数，基本操作包括：设置 $a,b$；读取 $a$、读取 $b$；判断两个 interval 是否 overlap；求两个 interval 的交集；求两个相交 interval 的并集。要求分别建立 header file、source file，以及一个使用该 interval class 的 main function。

参考材料：Problem Solving with C++ (8th Edition) Chapter 10.3（Abstract Data Types）、Chapter 10.2（Classes）。
