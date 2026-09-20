# 05 const Qualifier

这一节围绕一个 quailfier 展开：`const` 在变量、reference 和 pointer 三种语境下分别"锁住"了什么。真正需要分清的不是语法，而是**到底哪一块内存被声明为不可修改**——是 pointer 指向的对象，还是 pointer 自身。

## 为什么需要 const

程序里很多数值都有固定含义，比如 `char name[256];` 中的 `256` 表示 name 字符串的最大长度；同一个含义的数值还可能在程序里反复出现，例如 `for (i = 0; i < 256; i++)`。直接散用 `256` 有两个缺点：readability 差；如果要把最大长度从 256 改成 512，就必须逐个检查每一个 `256`（其中一些可能表示别的含义）并只改该改的那些，既费时又容易出错。

更稳妥的写法是先定义常量再使用它：

```cpp
const int MAXSIZE = 256;
char name[MAXSIZE];
```

常量通常定义成 global variable（局部常量也存在）。它的两条 property 是：之后不能被修改；<span class="red">定义时必须初始化</span>。

```cpp
const int a = 10;
a = 11;      // Error: 不能修改

const int i; // Error: 必须初始化
```

## const reference

const reference 可以绑定到已经存在的对象上：

```cpp
const int iVal = 10;
const int &rVal = iVal;
```

更值得注意的是，const reference 还能用 rvalue 初始化，而非 const reference 不行：

```cpp
const int &ref = 10;        // OK
const int &ref2 = iVal + 10; // OK

int &bad = 10;              // ERROR
int &bad2 = iVal + 10;      // ERROR
```

这条差异的来源是：reference 本身要求绑定到一个有地址的对象，而 `10`、`iVal + 10` 这类表达式只是临时值。const reference 允许编译器为这个临时值安排存储并延长其生命周期，普通 reference 没有这个许可。

## const reference 作为函数参数

const reference 最常见的用途是把 struct / class 作为函数参数传入：

```cpp
int avg_exam(const struct Grades &gr) {
    return (gr.midterm + gr.final) / 2;
}
```

把它和另外两种写法对照，就能看出它同时解决了两个问题。写成按值传递 `int avg_exam(struct Grades gr)`，问题在于 pass-by-value 对大型结构来说开销很大；写成普通引用 `int avg_exam(struct Grades &gr)`，虽然避免了拷贝，却让函数**有可能**（哪怕只是误操作）改动调用者传进来的 `gr`。const reference 同时做到"没有拷贝开销"和"函数无法改变调用者的状态"。

const reference 还带来第三个好处：调用处可以传常量或表达式。`void foo(const string &str)` 能够接受 `foo("Hello world!")`，而 `void foo(string &str)` 不能，原因正是上一段那条 rvalue 规则。

## const pointer 与 pointer to const

有了 pointer 之后，"可以改的东西"变成两样：pointer 自身的值（它指向哪里），以及 pointer 所指对象的值。`const` 放在类型前还是变量名前，决定的正是锁住哪一个。

```cpp
const T *p;         // pointer to const: 不能用 p 修改所指对象
T *const p;         // const pointer: p 本身不能被改成指向别处
const T *const p;   // 两者都不能改
```

读法是看 `const` 相对 `*` 的位置——`const` 在 `*` 左边修饰的是所指对象，在 `*` 右边修饰的是 pointer 自己。用两个例子把这四种权限的差别走一遍：

```cpp
// pointer to const
int a = 53;
const int *cptr = &a;  // OK: 可以用非 const 对象的地址初始化 pointer to const
*cptr = 42;            // ERROR: 不能通过它改动底层对象
a = 28;                // OK: a 本身不是 const，可以直接赋值
int b = 39;
cptr = &b;             // OK: pointer 的值可以改

// const pointer
int a2 = 53;
int *const cptr2 = &a2; // OK: 初始化
*cptr2 = 42;            // OK: 可以通过 const pointer 改动底层对象
int b2 = 39;
cptr2 = &b2;            // ERROR: const pointer 的值不能改
```

要注意 `const int *cptr = &a` 这一段并不矛盾：`a` 是普通 `int`，但通过 `cptr` 这个视角看它时，编译器只允许读。

## 用 typedef 命名 const 类型

`typedef` 给已有类型起别名，形式是 `typedef existing_type alias_name;`。例如 `typedef int *intptr_t;` 之后就可以直接写 `intptr_t ip;`。它在 const pointer 语境下很有用，因为指针类型的别名可以避免把 `const` 的修饰位置写错：

```cpp
typedef const T constT_t;
typedef constT_t *ptr_constT_t;  // ptr_constT_t 等价于 const T *
```

如果反过来要命名 `T *const` 这种 "const pointer" 类型，思路是先给 `T *` 起别名，再让别名整体成为 const：

```cpp
typedef T *ptrT_t;
typedef const ptrT_t constptrT_t;   // 等价于 T *const
```

关键在于 typedef 的别名在后续声明中被当作一个整体类型看待，所以 `const ptrT_t` 锁住的是 pointer 本身，而不是它指向的 `T`。

## pointer to const 的实际用途

标准库风格的 `strcpy` 声明是这样的：

```cpp
void strcpy(char *dest, const char *src)
// REQUIRES: src is a NULL-terminated string.
//           dest is big enough to hold a copy of src.
// EFFECTS:  places a copy of src in dest.
//           src is not changed.
{ ... }
```

严格来说，因为注释已经承诺不会修改源字符串，`const` 似乎可以省掉。仍然要写它的理由是：一旦加上 `const`，<span class="red">即使你误操作去改 `src` 也会编译不通过</span>。编译器能发现的 bug 是最好修的一类 bug，而 `const` 正是把"这是一个不该改的参数"从注释里的口头承诺变成编译器强制执行的约束。由此得到一条一般准则：对通过 reference 传入、但不会修改的东西使用 `const`。

## pointer to const 与普通 pointer 的赋值方向

`const T *` 与 `T *` 是两种不同的类型，它们之间的转换是单向的：可以用 `T *` 的地方都能用 `const T *`，反过来不成立。

```cpp
int const_ptr(const int *ptr) { ... }   // 接受 const int *
int nonconst_ptr(int *ptr) { ... }      // 接受 int *

int a = 0;
int *b = &a;
const_ptr(b);        // OK

const int *cptr3 = &a;
nonconst_ptr(cptr3); // ERROR
```

原因和两个函数的契约有关：期待 `const T *` 的代码只会读，那么传给它一个 `T *` 完全安全，只是被额外保证不会改；而期待 `T *` 的代码可能尝试写，把 `const T *` 交给它就会让"不可修改"的承诺失效，因此编译器必须拒绝。把这条方向记成"非 const 可以变成 const，const 不能变成非 const"最省事，但要知道它描述的是指针类型权限的收窄，而不是某种隐式类型转换技巧。

## 常见判断练习

几个容易出错的声明放在一起对比。`const int a;` 错在没初始化。`const int *p;` 合法：pointer to const 不需要立即指向某个对象，它只是"暂时不指向任何地方"。`int &ref = 10;` 错在非 const reference 不能绑定 rvalue。`int *const c;` 错在 const pointer 定义时必须初始化，因为它本身的值之后不能再改——把它和下面两行对照就清楚了：

```cpp
int *const c = &a;   // OK: 定义时初始化
*c = 42;             // OK: 可以改所指对象
c = &b;              // ERROR: 不能改 pointer 自身
```

参考材料：C++ Primer, 4th Edition 的 Chapter 2.4（const Qualifier）、Chapter 4.2.5（const Pointers）、Chapter 2.5（const References）。
