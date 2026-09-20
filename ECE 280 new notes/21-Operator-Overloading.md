# 21 Operator Overloading

`=` 的重载在 deep copy 里已经用过。这一节把同一套机制铺开：运算符重载本质上是"函数名特殊"的普通函数，因此真正需要判断的只有两件事——它该写成 member 还是 nonmember，以及参数和返回类型必须遵守什么约定。`friend` 则是为了在不破坏 encapsulation 的前提下让 nonmember 版本能被写出来。

## 基本想法

C++ 允许我们为 class 类型的对象重新定义运算符的含义，这就是 operator overloading。它让程序更易写也更易读：

```cpp
IntSet is;
int x = is[5];        // 重载 []，按索引访问 IntSet 的元素
cout << is << endl;   // 重载 <<，打印 IntSet 的所有元素
```

重载后的运算符是"名字特殊"的函数：关键字 `operator` 后面跟被重定义运算符的符号（如 `+`、`-`）。和任何函数一样，它有返回类型和参数列表。

```cpp
A operator+(const A &l, const A &r);
```

这里两个参数都加 `const` 是必要的：<span class="red">没有 `const` 时无法把 rvalue 传给它</span>——这与 const reference 才能绑定 rvalue 是同一条规则。

## member 还是 nonmember

大多数重载运算符既可以定义为普通的 nonmember function，也可以定义为 class 的 member function：

```cpp
A operator+(const A &l, const A &r);   // 返回 l "+" r
A A::operator+(const A &r);             // 返回 *this "+" r
```

作为 class member 的重载运算符，其参数个数看起来比操作数个数少一个，因为 member function 有一个隐式的 `this` 参数，它被绑定到第一个操作数上。由此得到两条计数规则：重载的一元运算符作为 member 时没有（显式）参数，作为 nonmember 时有一个参数；重载的二元运算符作为 member 时有一个参数，作为 nonmember 时有两个参数。判断一个运算符"能不能写成 member"的关键在于它的第一个操作数是不是本 class 的对象。

## operator+= 与 operator+

用一个复数 class 看这两种写法：

```cpp
class Complex {
    // OVERVIEW: a complex number class
    double real;
    double imag;
  public:
    Complex(double r = 0, double i = 0);   // Constructor
    Complex &operator += (const Complex &o);
    // MODIFIES: this
    // EFFECTS: adds this complex number with the complex number o
    //          and return a reference to the current object.
};
```

`+=` 是 member，函数体直接修改自己并返回自己的 reference：

```cpp
Complex &Complex::operator += (const Complex &o) {
    real += o.real;
    imag += o.imag;
    return *this;
}
```

`+` 也可以写成 nonmember：

```cpp
Complex operator + (const Complex &o1, const Complex &o2) {
    Complex rst;
    rst.real = o1.real + o2.real;
    rst.imag = o1.imag + o2.imag;
    return rst;
}
```

这段代码的问题在于：它是 nonmember function，<span class="red">无法访问 class 的 private 成员</span>，因此 `o1.real` 这类写法根本编译不过。（顺带排除一个干扰项：`operator` 与 `+` 之间的空格不影响编译，`const` 也是该加的。）

## friend

解决办法是声明"友元"：

```cpp
class foo {
    friend void baz();   // 这条声明写在 foo 内部，表示 foo 把友元关系给函数 baz()
    int f;
};
void baz() { ... }
```

friend 声明允许你把一个 class 的 private 状态显式地暴露给另一个函数（而且只给那一个函数）。几条容易混淆的性质：<span class="red">friend function 不是 member function，它是普通函数</span>，因此定义时写 `void baz() { ... }` 而不是 `void foo::baz() { ... }`；friend 声明虽然写在 `foo` 里面，但 `bar` 与 `baz()` 都不是 `foo` 的成员；friend 声明可以出现在 class 中的任何位置，但把 friend 声明集中放在 class 定义的开头或结尾是好习惯。

除了函数，也可以把整个 class 声明为 friend：

```cpp
class foo {
    friend class bar;
    int f;
};
class bar { ... };
```

这样 `bar` 的对象才能访问 `foo` 的 private 成员 `f`。两种 friend 当然可以同时存在。

把 `operator+` 声明成 friend 之后，实现和原来完全一样，只是现在有权限访问 private 成员了：

```cpp
class Complex {
    // OVERVIEW: a complex number class
    double real;
    double imag;
  public:
    Complex(double r = 0, double i = 0);
    Complex &operator += (const Complex &o);
    friend Complex operator+(const Complex &o1, const Complex &o2);
};
```

## operator[]

我们希望像访问普通数组那样访问 IntSet 中的单个元素，例如 `is[5]` 访问 `is` 的第 6 个元素。需要重载 `operator[]`，它是一个二元运算符：第一个操作数是 IntSet 对象，第二个是索引。做法是写两个版本，都带边界检查：

```cpp
const int &IntSet::operator[](int i) const {
    if (i >= 0 && i < numElts) return elts[i];
    else throw -1;
}

int &IntSet::operator[](int i) {
    if (i >= 0 && i < numElts) return elts[i];
    else throw -1;
}
```

两个版本各自的理由不同。需要返回 `int&` 的非 const 版本，是因为要通过下标赋值：

```cpp
is[5] = 2;
```

需要返回 `const int&` 的 const 版本，是因为可能对 const IntSet 对象调用下标运算符，或在某个 const member function 内部调用它——const 对象与 const member function 只能调用自己的 const member function。而返回类型必须是 const reference，因为不能用一个 const 对象（此处 `elts[i]` 是 const int）去初始化非 const reference。

## operator<<

我们希望为 IntSet 重定义 `operator<<`，让它按顺序打印集合中的所有元素。IO 库的约定是：

- `operator<<` 的第一个参数应是 `ostream&`，第二个应是 class 类型对象的 const reference，用法写作 `os << obj;`。
- `operator<<` 应返回它的 `ostream` 参数的 reference。

```cpp
ostream &operator<<(ostream &os, const IntSet &is) {
    ...
    return os;
}
```

为什么要返回 reference？因为 `<<` 可以链式书写：

```cpp
cout << "hello " << "world!" << endl;
```

它等价于依次执行 `cout << "hello ";`、`cout << "world!";`、`cout << endl;`——每一段的返回值都成为下一段的左侧操作数，所以必须把同一个 stream 继续交出去。

`operator<<` <span class="red">必须是 nonmember function</span>，因为它的第一个操作数不是本 class 类型（而是 `ostream`），写成 member 就没有对象可以绑定 `this`。实现如下：

```cpp
ostream &operator<<(ostream &os, const IntSet &is) {
    for (int i = 0; i < is.size(); i++)
        os << is[i] << " ";
    return os;
}
```

之后就可以写 `cout << is << endl;`。这段实现里还有一个细节：`is` 是 const reference，所以 `is[i]` 调用的是 const 版本的 `operator[]`；而它不需要与 IntSet 建立 friend 关系，因为它只用到了 public 的 `size()` 与 `operator[]`——只有需要触碰 private 成员时 friend 才是必要的。

## operator>>

输入运算符的约定与此对应：

```cpp
istream &operator>>(istream &is, foo &obj) {
    ...
    return is;
}
```

用法写作 `is >> obj;`。第一个参数是 `istream&`，第二个是 class 类型对象的**非 const** reference——因为读取的目的就是修改这个对象；返回 `istream` 的 reference，理由和 `<<` 完全相同：支持 `cin >> a >> b;` 这样的链式书写。

## 练习

为自己写的 List（`IntList`、`ValList` 等任选）类添加两个运算符。`List + int` 表示把一个整数插入列表，把它定义在 class 内部作为 method。`List + List` 表示把两个列表拼接起来，把它定义在 class 外部，必要时使用 friend。

参考材料：C++ Primer (4th Edition) Chapter 12.5（Friends）、Chapter 14（Overloaded Operations and Conversions）。
