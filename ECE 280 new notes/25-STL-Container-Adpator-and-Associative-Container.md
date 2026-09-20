# 25 STL Container Adaptor and Associative Container

sequential container 用位置存取元素。这一节换成用 **key** 存取：ADT 层面是 dictionary，STL 层面是 `map`。真正需要小心的是 `map` 的下标运算符——它和 vector 的下标看起来一样，语义却完全不同，一次"只想查一下"的访问就可能改变容器。

## ADT: Dictionary

dictionary 的日常用法是"查一个词，找到它的含义"。作为 ADT，它是**pair 的集合，每个 pair 包含一个 key 和一个 value**，记作 `(key, value)`；<span class="red">不同的 pair 有不同的 key</span>。

它存在的理由在于 key 空间通常比 value 空间更有规律、更有结构，因而更容易搜索。dictionary 被优化来快速完成两件事：加入一个 `(key, value)` pair，以及按 key 取出 value。

它的方法集合是：

- `Value find(Key k)`：返回 key 为 `k` 的 value；若没有则返回 `Null`。
- `void insert(Key k, Value v)`：把 pair `(k, v)` 插入 dictionary；如果 key 为 `k` 的 pair 已经存在，则更新它的 value。
- `Value remove(Key k)`：从 dictionary 中删除 key 为 `k` 的 pair 并返回它的 value；若没有则返回 `Null`。
- `int size()`：返回 dictionary 中 pair 的个数。

一个典型例子是班级学生记录集合：`(key, value) = (student name, linear list of assignment and exam scores)`，所有 key 互不相同。对应的操作就是"取得 key 为 John Adams 的 value"和"为名为 Diana Ross 的学生插入一条记录"。

## Associative container：associative array

associative container 中的元素按 key 存放和取出，而 sequential container 中的元素按**位置**存放和访问。两者主要的容器类型是 `map` 与 `set`：`map` 中的元素是 `(key, value)` pair；`set` 只含一个 key，支持高效查询某个 key 是否存在。应用上，`map` 用于 dictionary，`set` 用于高效存放一组互不相同的值——例如一篇文章中所有不同的英文单词。

associative container 与 sequential container 共享很多但不是全部操作。它们**没有** `front()`、`push_front()`、`pop_front()`、`back()`、`push_back()`、`pop_back()` 这些按位置操作的方法——这一点很容易搞混，因为它们共享的操作名字看起来很像。共同的操作包括：

```cpp
C<T> c;        // 创建空 container
C<T> c1(c2);   // 把 c2 的元素复制进 c1；c2 必须与 c1 类型相同
begin(), end(), size(), empty(), clear(), operator=
```

最大的差别在于：对 associative container 来说，<span class="red">元素的顺序与插入顺序无关</span>；对其中某些类型，元素按 key 排序。

## map

`map` 也叫 associative array，存放 `(key, value)` pair，使用时 `#include <map>`。两种 constructor：

```cpp
map<k, v> m;       // 创建空的 map m，key 与 value 类型分别是 k 和 v
map<k, v> m(m2);   // 把 m 创建为 m2 的副本；m 与 m2 的 key/value 类型必须相同
```

例如 `map<string,int> word_count`。

### 对 key 类型的约束

因为 map 中的元素**按 key 排序**，key 类型必须额外支持一种操作：strict weak ordering。可以把它理解成"小于"（`<`），例如 `int` 的 `<`、`string` 的字母序。技术上的要求是：

- 一个 key 与自身比较时结果为 false；
- 给定两个 key，它们不能同时"小于"对方；
- 满足传递性：若 $k_1 < k_2$ 且 $k_2 < k_3$，则 $k_1 < k_3$；
- 若两个 key 谁都不"小于"对方，则它们被视为相等。

### pair 类型

`pair` 是一个简单的 companion type，持有两个数据值；它是 template，需要提供两个类型名：

```cpp
pair<string,string> spair;   // 持有两个 string
```

两种构造方式：

```cpp
pair<T1, T2> p1;            // 两个元素分别 value-initialized
                            // （class 类型用 default constructor，内置类型为 0）
pair<T1, T2> p1(v1, v2);    // 第一个成员由 v1 初始化，第二个由 v2 初始化
```

例如 `pair<string, int> count("blue", 2);`。

两个数据成员是 public，用 `p.first` 与 `p.second` 访问，它们返回对应成员的 reference。还有一个便利函数 `make_pair(v1, v2)`：从 `v1` 与 `v2` 创建新的 pair，pair 的类型由 `v1`、`v2` 的类型推断，例如 `pair<string,string> name = make_pair("John", "Adams");`。

### map 的 iterator

解引用一个 map 的 iterator 得到一个 pair：`first` 成员持有 **const key**，`second` 成员持有 value。

```cpp
map<string, int>::iterator it = word_count.begin();
```

`*it` 是一个 `pair<const string, int>` 对象的 reference——它既不单指 key 也不单指 value。访问 key 用 `it->first`（例如 `cout << it->first;`）；但 `first` 成员是 const key，不能修改：

```cpp
it->first = "new key";   // Error!
```

访问 value 用 `it->second`（例如 `cout << it->second;`），<span class="red">并且可以通过 iterator 修改 value</span>：

```cpp
it->second = 2;
```

### 添加元素：下标版本

往 map 中添加元素有两种方式：使用下标运算符，或者使用 `insert` member。下标写法是 `m[k] = v;`：

```cpp
map <string, int> word_count;   // empty map
word_count["Anna"] = 1;         // 插入 key 为 "Anna" 的元素，然后把 1 赋给它的 value
```

这一行真正发生的是：先在 `word_count` 中查找 key 为 `Anna` 的元素，没有找到；于是插入一个新的 `(key, value)` pair，key 是 `"Anna"`，value 被 value-initialized 为 0（class 类型用 default constructor，内置类型为 0）；最后取出这个新插入的元素，把值设为 1。

### 下标 map 与下标 array 的区别

<span class="red">对 map 取下标的行为与对 array 或 vector 取下标相当不同：用一个不存在的 key 取下标会往 map 里添加一个该 key 的元素</span>。若 key 已存在，则返回与该 key 关联的 value 的引用，可以读写：

```cpp
cout << word_count["Anna"];
++word_count["Anna"];   // 取出该元素并把它的值加一
```

一句话概括这组关系：对 vector 取下标等价于解引用 vector 的 iterator，而对 map 取下标**不**等价于解引用 map 的 iterator。

### find 与 erase

下标运算符给出了取 value 的最简方式，但它有副作用——key 不在 map 中时会插入元素。要在**不引起插入**的前提下判断某个 key 是否存在，用 `m.find(k)`：若存在则返回指向该 key 元素的 iterator，否则返回 off-the-end iterator（即 `end()`）。

```cpp
int occurs = 0;
map<string,int>::iterator it = word_count.find("abc");
if (it != word_count.end())
    occurs = it->second;
```

删除有两种形式。`m.erase(iter)` 删除 iterator `iter` 所指元素，`iter` 必须指向 map 中实际存在的元素，不能等于 `m.end()`，返回 void。`m.erase(k)` 在 key `k` 存在时删除该元素，不存在则什么也不做，返回被删除的元素个数——对 map 来说只会是 0 或 1，因此可以直接拿返回值当条件用：

```cpp
if (word_count.erase(rm_word))   // rm_word 是一个 key
    cout << "ok: " << rm_word << " removed\n";
else
    cout << rm_word << " not found!\n";
```

### 遍历 map

map 有 `begin()` 与 `end()`，因此可以遍历：

```cpp
map<string, int>::iterator it;
for (it = word_count.begin(); it != word_count.end(); ++it)
    cout << it->first << " occurs " << it->second << " times";
```

有一点与 vector 不同：<span class="red">用 iterator 遍历 map 时，元素按 key 升序产出</span>，所以上面这段输出是按字母序打印单词的——这不是巧合，而是 map 按 key 排序的直接结果。

## 判断练习

关于 dictionary 的几个说法：dictionary 可以看作 array 的推广（对，key 从整数下标推广为任意可用类型）；key 必须是 string（错，只需支持 strict weak ordering）；同一个 key 可以关联多个不同的 value（错，不同 pair 的 key 必须不同）；同一个 value 可以关联多个不同的 key（对，约束只在 key 一侧）。

参考材料：C++ Primer (4th Edition) Chapter 10（Associative Containers）。
