# 24 STL Sequential Container

前面几节都是自己动手写 container：IntSet、IntList、Stack、Queue。这一节转向标准库：STL 把常见数据结构和算法做成 template-based、可复用的组件。学习重点从"怎么实现"变成"选哪一个、以及为什么"——三个 sequential container 的接口几乎一样，区别全部落在随机访问与中间插入的代价上。

## STL 的三个组成部分

C++ 的 standard template library (STL) 提供了一种方便定义 container 的方式：它定义了强大、基于 template、可复用的组件，实现了常见的数据结构与算法。它分为三个部分：

- Containers：持有指定类型对象集合的数据结构。
- Iterators：用于查看和遍历 container 中的元素。
- Algorithms：searching、sorting 等。

## 三类 container

STL 提供三种 container：

- **Sequential Containers**：由程序员控制元素存放与访问的顺序，顺序不依赖于元素的值。
- **Associative Containers**：按元素的值存放元素，顺序依赖于元素的值。
- **Container Adapters**：拿一个已有的 container 类型，让它表现得像另一种类型。

三个 sequential container 的对比是全章的主线：

| container | 底层 | 随机访问 | 插入/删除 |
|---|---|---|---|
| `vector` | arrays | 快 | 末端快，其他位置慢 |
| `deque` | arrays | 快 | 首端或末端都快 |
| `list` | doubly-linked lists | 只有 bidirectional sequential access | 任意位置都快 |

关于"还要不要自己写"的判断：STL 已经提供了 sequential container 的实现，但并不意味着完全没有必要再提供新的实现（例如需要特殊性能特征或特殊语义时）；不过原则是能用 STL container 就用；而"container 不一定是 sequential 的"也是对的，因为有 associative container 与 container adapter。

## vector：初始化

`vector` 是最常用的 STL container：一组单一类型的对象，每个对象有一个关联的整数下标。可以创建 `vector<int>`、`vector<string>` 等。使用前要包含头文件与 namespace：

```cpp
#include <vector>
using namespace std;
```

`vector` 是一个 template，必须指定它所含对象的类型：

```cpp
vector<int> ivec;      // holds ints
vector<IntSet> isvec;  // holds IntSets
```

三种常见初始化形式：

```cpp
vector<T> v1;         // 构造空的 v1，用来装 T 类型对象
vector<T> v2(v1);     // copy constructor
vector<T> v3(n, t);   // 构造有 n 个值为 t 的元素的 v3
```

例如 `vector<int> v3(10, -1);` 得到 10 个 `-1`，`vector<string> v4(2, "abc");` 得到两个 `"abc"`。

## size() 与 companion type

`v.size()` 返回 `v` 中元素个数。它的返回类型是 `size_type`，这个类型与 vector 的具体类型对应，写作 `vector<int>::size_type`——是 vector 的 companion type，本质上是一个 unsigned 类型（`unsigned int` 或 `unsigned long`）。注意不能写成 `vector::size_type`。

为什么要引入 companion type？为了让类型与机器无关。使用上一般可以把 `size_type` 转成 `unsigned int`（`unsigned int s = v.size();`），但不推荐用 `int`（`int s = v.size();` 不好）。如果只想知道 vector 是否为空，用 `v.empty()` 更直接。

## 增删元素

```cpp
v.push_back(t);   // 在 v 末尾加入值为 t 的元素
v.pop_back();     // 删除 v 中最后一个元素；无参数、返回 void，v 必须非空
```

```cpp
vector<int> v;
for (int i = 0; i < 5; i++)
    v.push_back(i);
// v is 0,1,2,3,4
```

### container 中的元素是副本

这里有一条容易忽略但很重要的规则：container 中的元素与当初被复制进来的那个值**没有关系**。

```cpp
vector<int> v;
int a = 3;
v.push_back(a);   // v[0] 现在是 3
a = 5;            // v[0] 现在是多少？
```

答案仍然是 3。此后对原值的任何修改都不会影响 container 中的元素，反之亦然。

## 下标访问

`v[n]` 返回 `v` 中位置 `n` 的元素：

```cpp
vector<int>::size_type ix;
for (ix = 0; ix != ivec.size(); ++ix)
    ivec[ix] = 0;
```

要特别注意：<span class="red">下标访问不会增加元素</span>。

```cpp
vector<int> ivec;   // 空 vector
for (vector<int>::size_type ix = 0; ix != 10; ++ix)
    ivec[ix] = 0;   // Error!
```

元素必须已经存在才能对它取下标，空 vector 上任何下标都是越界。

### 循环条件里的 size()

上面那个 for 循环把 `size()` 写在循环条件里，而不是在循环之前调用一次并记住它的值。这样做的理由：vector 可以通过添加新元素动态增长，把 `size()` 放在 for 中就能每次检查最新的 size，因而更安全。会不会因此变慢？不会，因为 `size()` 是 inline function——它被"就地展开"，避免了函数调用的开销。

## vector 的其他基本操作

```cpp
v1 = v2       // 用 v2 元素的一份副本替换 v1 中的元素
v.clear()     // 使 vector v 变空
v.front()     // 返回 v 中第一个元素的 reference；v 必须非空
v.back()      // 返回 v 中最后一个元素的 reference；v 必须非空
```

## Iterator

每个 container 类型都有一个 companion iterator type，用来查看元素并在 container 中移动。iterator 比下标更通用：所有库 container 都定义了 iterator 类型，但只有少数支持下标访问。为 vector 声明 iterator：

```cpp
vector<int>::iterator it;
```

<span class="red">iterator 是 pointer 的推广</span>——它们是指向 container 元素的 pointer。

### begin() 与 end()

用 vector 的两个成员函数把 iterator 与 vector 关联起来：`v.begin()` 返回指向 vector 第一个元素的 iterator；`v.end()` 返回指向 vector "末尾之后一位"（one-past-the-end）的 iterator，它不表示 vector 中任何实际元素。

`end()` 的作用是标记"所有元素都已处理完"的时刻。如果 vector 为空，`begin()` 返回的 iterator 与 `end()` 返回的相同。

### iterator 上的操作

- 解引用 `*iter`：访问该 iterator 所指的元素，可以透过 `*iter` 读，也可以写。
- 自增与自减：`++iter`、`iter++` 前进到下一个元素；`--iter`、`iter--` 回到上一个元素。注意不能对 `end()` 返回的 iterator 解引用或自增。
- 比较：`iter == iter2` 与 `iter != iter2` 判断两个 iterator 是否指向同一个数据项。

求和例子：

```cpp
int sum = 0;
vector<int>::iterator it;
for (it = ivec.begin(); it != ivec.end(); ++it)
    sum += *it;
```

若 `ivec` 为空，循环条件一开始就是 `begin() == end()`，循环体一次都不执行，`sum` 为 0。

既然 vector 支持下标，为什么还要用 iterator？因为所有 container 类型都有对应的 iterator 类型，但并非所有 container 都支持下标访问——用 iterator 写的循环可以直接搬到 `list` 上，用下标写的不能。

### const_iterator

用 `iterator` 可能改变 vector 中的值；`const_iterator` 是另一种 iterator 类型，不能用来改值——它只能读 container 元素，不能写，因为解引用一个 `const_iterator` 得到的是 const 对象。要注意它**自身**的值仍可以改变，例如可以自增。

```cpp
vector<string>::const_iterator it;
for (it = text.begin(); it != text.end(); ++it) {
    cout << *it << endl;   // fine
    *it = " ";             // error: *it is const
}
```

这与 `const T *p` 和 `T *const p` 的区别同构：`const_iterator` 相当于 pointer to const。

### iterator arithmetic 与关系运算

vector 支持 iterator arithmetic——注意不是所有 container 都支持。`iter+n`、`iter-n` 中 `n` 是整数值，得到一个向前（向后）移动 $n$ 位的 iterator。可以用它把 iterator 直接移到某个元素，例如移到中间：

```cpp
vector<int>::iterator mid;
mid = vi.begin() + vi.size()/2;
```

关系运算 `>`、`>=`、`<`、`<=` 在 vector 上也受支持（同样不是所有 container 都支持）。一个 iterator 小于另一个，是指它所指元素在 container 中的位置更靠前。做比较时两个 iterator 必须指向同一个 container 中的元素，或该 container 末尾之后一位（即 `c.end()`）。

### insert() 与 erase()

```cpp
v.insert(p, t);   // 在 iterator p 所指元素之前插入值为 t 的元素，
                  // 返回指向被插入元素的 iterator
v.erase(p);       // 删除 iterator p 所指元素，
                  // 返回指向被删元素之后那个元素的 iterator，
                  // 若 p 指向最后一个元素则返回 off-the-end iterator；
                  // p 不能是 off-the-end iterator
```

`insert` 也可以用来在 vector 开头插入：

```cpp
vector<int> iv(2, 1);
iv.insert(iv.begin(), -1);   // 在开头插入
iv.insert(iv.end(), 3);      // 在末尾插入
```

## deque

deque 读作 "deck"，意思是 double-ended queue，底层也是 arrays：支持快速随机访问，且在**首端或末端**插入/删除都快。使用时 `#include <deque>`。

它与 vector 的共同点很多：初始化方式（`deque<T> d;`、`deque<T> d(d1);`、`deque<T> d(n,t);`）、`size()` 与 `empty()`、`push_back()` 与 `pop_back()`、通过下标随机访问 `d[k]`、`begin()` / `end()` / `insert(p, t)` / `erase(p)`，以及 iterator 上的 `*iter`、`++iter`、`--iter`、`==`、`!=` 等操作。

比 vector 多出来的能力只有一项：在开头插入与删除。

```cpp
d.push_front(t);   // 在 d 开头加入值为 t 的元素
d.pop_front();     // 删除 d 中第一个元素
```

## list

`list` 基于 doubly-linked lists：只支持 bidirectional sequential access——想访问第 15 个元素，就必须从开头依次访问第 1 到第 15 个；但它在**任意位置**插入/删除都快。使用时 `#include <list>`。

与 vector 的共同点是初始化方式（`list<T> l;`、`list<T> l(li);`、`list<T> l(n,t);`）、`size()` 与 `empty()`、`push_back()` 与 `pop_back()`、`begin()` 与 `end()`、iterator 上的 `*iter`、`++iter`、`--iter`、`==`、`!=`，以及 `insert(p, t)` 与 `erase(p)`。

差异集中在一组"不支持"上：

```cpp
list<string> li(10, "abc");
li[1] = "def";        // Error! 不支持下标访问

list<int>::iterator it;
it + 3;               // Error! 没有 iterator arithmetic，移动要用 ++/--
list<int>::iterator it1, it2;
it1 < it2;            // Error! 没有 < <= > >=，比较只能用 == 或 !=
```

而它比 vector 多出来的能力是首端插入删除：

```cpp
l.push_front(t);
l.pop_front();
```

## 如何选择 sequential container

vector 与 deque 随机访问快，但在中间插入/删除效率低——删除会留下空洞，需要把空洞右侧所有元素整体左移。两者的区别是：vector 只有后端插入/删除快，deque 前后两端都快。list 在中间插入/删除效率高，但随机访问效率低，因为它基于 linked list，访问一个元素必须遍历。

由此得到几条通用判据：

- 除非有充分理由偏好别的 container，否则用 `vector`。
- 如果程序需要随机访问元素，用 `vector` 或 `deque`。
- 如果程序需要在中间插入或删除元素，用 `list`。
- 如果程序需要在首端和末端（但不在中间）插入或删除，用 `deque`。
- 如果同时需要随机访问和中间插入/删除，选择取决于占主导的操作——哪种做得更多。

参考材料：C++ Primer (4th Edition) Chapter 3.3（Library vector Type）、Chapter 9（Sequential Containers）。
