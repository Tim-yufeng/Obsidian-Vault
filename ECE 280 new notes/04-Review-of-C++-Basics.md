# 04 Review of C++ Basics

这一节是后续 abstraction、dynamic memory 与 data structure 的语法地基。基础的 variable、built-in type、I/O、operator、branch 与 loop 只需会用；真正需要重新分清的是 lvalue / rvalue、declaration / definition、value / reference semantics，以及 pointer、reference、array、struct 之间的关系。

## 基本控制结构

```cpp
#include <iostream>
using namespace std;

int main() {
    int length;
    cin >> length;
    if (length > 0) {
        int area = length * length;
        cout << "area is " << area << endl;
    }
    else {
        cout << "negative length!" << endl;
    }
    return 0;
}
```

需要熟悉 arithmetic / comparison operators、`if/else`、`switch/case`、`while`、`for`。`x++` 与 `++x` 都会让 `x` 增一，但整个 expression 的值不同：post-increment 先产生旧值，pre-increment 先增再产生新值。

## lvalue 与 rvalue

课件采用的操作性定义是：lvalue 可以出现在 assignment 左侧或右侧；rvalue 只能出现在右侧。非 const variable 通常是 lvalue，literal constant 通常是 rvalue。

```cpp
int a = 3;
int b = 4;
a = b + 1;       // a 是 lvalue；b + 1 是 rvalue
int c[8];
c[2 * 3] = 10;   // c[6] 是 lvalue
```

因此 `10 = a;` 与 `(a + b) = 3;` 都不合法。数组元素表达式虽然可以读取成一个值，但只要元素不是 const，它仍然可以作为 assignment target。

## Function declaration 与 definition

Function declaration（prototype）告诉 compiler 函数怎样被调用，必须在第一次调用前可见；它包含 return type、function name、argument 数量与类型，parameter names 主要用于可读性：

```cpp
double total_cost(int number, double price);
// EFFECTS: returns the total cost including 5% tax
```

Function definition 除了同样的 header，还提供 function body：

```cpp
double total_cost(int number, double price) {
    const double TAX_RATE = 0.05;
    double subtotal = number * price;
    return subtotal + subtotal * TAX_RATE;
}
```

可以把 declaration 理解为“what / type signature”，definition 则补上“how”。

## Pass by value 与 pass by reference

```cpp
void twice_value(int x) {
    x *= 2;
}

void twice_reference(int &x) {
    x *= 2;
}
```

`twice_value(a)` 只修改 formal parameter 的副本，caller 中的 `a` 不变；`twice_reference(a)` 让 formal parameter 成为 `a` 的 alias，因此会修改 `a`。是否产生 caller-visible side effect，是后面 specification 中 `MODIFIES` 条款的依据。

## Array 作为参数

Array 是 fixed-size、indexed、同一元素类型的集合：

```cpp
int values[4] = {7, 7, 3, 4};
```

把 array 传给函数时，函数实际通过其首元素地址访问原数组，所以对元素的修改会反映到 caller：

```cpp
void add_one(int a[], unsigned size) {
    for (unsigned i = 0; i < size; ++i) {
        ++a[i];
    }
}
```

调用 `add_one(values, 4)` 后，数组变成 `{8, 8, 4, 5}`。Array parameter 本身不携带长度，因此要另外传入 `size`，并保证访问范围合法。

## Pointer：显式保存地址

```cpp
int foo = 1;
int *bar = &foo;  // & 取得 foo 的地址
*bar = 2;         // * 解引用，修改地址指向的对象
```

`bar` 自己是一个 variable，存的是地址；`*bar` 才是被指向的 `int`。Pointer 可以在运行中改为指向另一个对象，也可以用于构造运行时大小的数据结构。

Array name 在多数 expression 中会转换为首元素地址，因此可以把关系记成：

$$
\texttt{array} = \&\texttt{array[0]}
$$

这里表达的是地址相同，不表示 array variable 可以像普通 pointer 一样被重新赋值。

## Reference：对象的别名

```cpp
int value = 1024;
int &alias = value;
alias = 5;              // value 也变成 5
```

Reference 必须在声明时绑定到同类型的 lvalue，之后不能 rebind：

```cpp
int x = 0;
int &r = x;
int y = 1;
r = y;       // 把 y 的值赋给 x，不是让 r 改绑到 y
```

Pointer 与 reference 都能实现 caller-visible 修改，但 pointer 需要显式取地址、解引用，并且可以改变所指对象；reference 语法更轻，绑定后固定。<span class="red">“reference 不能 rebind”是判断相关代码结果时最容易漏掉的一点。</span>

## Struct：组合多个字段

Struct 用来定义 compound type：

```cpp
struct Grades {
    char name[9];
    int midterm;
    int final;
};

Grades alice = {"Alice", 60, 85};
alice.midterm = 65;

Grades *gptr = &alice;
gptr->final = 90;
```

对 object 用 `.` 访问 field，对 pointer-to-struct 用 `->`。Struct 把多个值组合在一起，但 representation 对使用者完全可见；后面的 ADT / class 会专门解决这种实现细节暴露的问题。

参考材料：Problem Solving with C++ (8th Edition) Chapter 9.1；C++ Primer (4th Edition) Chapter 2.9。
