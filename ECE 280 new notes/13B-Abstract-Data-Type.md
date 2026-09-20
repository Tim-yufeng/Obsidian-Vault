# 13B Abstract Data Type (Part 2)

13A 讲的是 ADT 的想法和 class 的语法。这一节把同一套语法用在一个真实数据结构上：一个可变的整数集合 IntSet。重点在于 representation invariant 这个概念——它决定了每个 method 应该怎么写、什么时候必须"修复"状态，以及"换一种实现"到底意味着改哪些东西。

## 从 specification 出发：四个操作

我们想要一个 mutable set of integers，即数学意义上的 set：零个或多个整数的集合，元素不重复；"mutable" 指可以往集合里插入和删除元素。为它定义四个操作：

1. Insert a value into the set.
2. Remove a value from the set.
3. Query to see if a value is in the set.
4. Count the number of elements in the set.

对应的 class 定义（先只写接口）：

```cpp
class IntSet {
    // OVERVIEW: a mutable set of integers
  public:
    void insert(int v);
      // MODIFIES: this
      // EFFECTS: this = this + {v}
    void remove(int v);
      // MODIFIES: this
      // EFFECTS: this = this - {v}
    bool query(int v);
      // EFFECTS: returns true if v is in this, false otherwise
    int size();
      // EFFECTS: returns |this|.
};
```

这个 class 是不完整的，因为还没有为 set 选定 representation。选定 representation 包含两件事：决定用什么具体数据元素来表示集合的值；为每个 method 提供实现。

值得注意的是，尽管还没有 representation，上面这份（不完整的）定义已经是 IntSet 抽象的使用者所需要的全部信息，因为它已经给出了 ADT 的 general overview 与每个 method 的 specification。

## representation invariant

representation 本身这样选：用一个 array；大小为 $N$ 的集合表示成一个没有重复元素的 unordered 整数数组，存放在数组的前 $N$ 个槽位中；再用 `int numElts` 维护当前元素个数。

这两句话就是 <span class="red">representation invariant（rep invariant）</span>：它是一条 representation 必须遵守的规则，在任一 method 执行的**紧接之前**和**紧接之后**都必须成立。

![[Pasted image 20260809153003.png]]

图中左侧是合法状态（前 `numElts` 个槽位连续存放 5 个互不重复的元素），右侧两个状态分别违反了不同的部分：一个是 `numElts` 与实际存放的元素数目不符，一个是出现了重复元素。rep invariant 的价值就在于它把"哪些中间状态是允许的"说清楚，从而使每个 method 只需关心"我调用前后是否都满足它"。

用数组表示就必然有最大容量，因此要选定一个最大尺寸并修改 OVERVIEW。直接把 `100` 写进 specification 是任意的，更好的做法是用一个 global constant：

```cpp
const int MAXELTS = 100;
class IntSet {
    // OVERVIEW: a mutable set of integers, |set| <= MAXELTS
    int elts[MAXELTS];
    int numElts;
  public:
    void insert(int v);
      // MODIFIES: this
      // EFFECTS: this = this + {v} if room, throws int MAXELTS otherwise
    void remove(int v);
      // MODIFIES: this
      // EFFECTS: this = this - {v}
    bool query(int v);   // RME omitted for space
    int    size();       // RME omitted for space
};
```

注意 `insert` 的 EFFECTS 子句因为容量的限制被改写了：从"无条件加入"变成"有空间才加入，否则抛出一个 int 异常"。representation 的选择反过来会改变 specification，这是设计 ADT 时经常出现的反馈。

## 朴素实现的四个 method

有了 representation 和 rep invariant 就可以写 method 了。`size()` 最容易：

```cpp
int IntSet::size() {
    return numElts;
}
```

可以直接返回 `numElts`，正是因为 rep invariant 保证了 `numElts` 始终等于集合大小。

`query`、`remove`、`insert` 三者有一个共同点：都需要 search。一个自然的想法是把 `insert` 和 `remove` 都建立在 `query` 之上，但这行不通——`query` 只告诉你元素**是否存在**，不告诉你它**在哪里**，而 `remove` 必须知道位置才能删。因此需要一个额外的私有方法：

```cpp
const int MAXELTS = 100;
class IntSet { // OVERVIEW omitted for space
    int elts[MAXELTS];
    int numElts;

    int indexOf(int v);
      // EFFECTS: returns the index of v if it exists in the array,
      //          MAXELTS otherwise.
  public:
    void insert(int v);   void remove(int v); // RME omitted
    bool query(int v);    int   size();       // RME omitted
};
```

`indexOf` 必须是 private，因为它暴露了 concrete representation 的细节——把"元素存在数组的哪个位置"这件事暴露给使用者是不合适的。这里用 `MAXELTS` 同时承担两个含义：数组容量、以及"没找到"的指示值，因为合法下标永远小于 `MAXELTS`。

```cpp
int IntSet::indexOf(int v) {
    for (int i = 0; i < numElts; i++) {
        if (elts[i] == v) return i;
    }
    return MAXELTS;   // MAXELTS 是"不存在"的指示值
}

bool IntSet::query(int v) {
    return (indexOf(v) != MAXELTS);
}
```

有了 `indexOf`，`query` 和 `size` 都是平凡的，剩下 `insert` 与 `remove` 需要认真处理。

`insert` 的逻辑是：先看元素在不在；不在的话要把它加到数组"末尾"；当前末尾的下标就是 `numElts`；放入元素并更新 `numElts`；唯一的例外是 `numElts` 已经等于 `MAXELTS`。

```cpp
void IntSet::insert(int v) {
    if (indexOf(v) == MAXELTS) {
        if (numElts == MAXELTS) throw MAXELTS;
        elts[numElts++] = v;
    }
}
```

回答一道容易混淆的选择题时，注意"如果 v 不存在就把它加到 `elts[numElts-1]` 再自增 `numElts`"是错的——`numElts` 同时也是下一个空槽的下标，所以新元素应放在 `elts[numElts]`，然后 `numElts` 自增。加入后必须自增 `numElts`，这是修复 rep invariant 的必要动作。（选项里"不存在就加到数组里"这一句本身是对的，错的是"加到 `numElts-1` 位置"这一句。）

`remove` 要考虑删除后留下的"洞"（hole，其下标记作 victim）。最简单的修法不是把 victim 之后的每个元素都左移一格，而是把当前最后一个元素搬到洞里：

```cpp
void IntSet::remove(int v) {
    int victim = indexOf(v);
    if (victim != MAXELTS) {
        elts[victim] = elts[numElts-1];
        numElts--;
    }
}
```

例如 `3 2 1 4 5` 删除 `2`，结果是 `3 5 1 4`，`numElts` 从 5 变为 4。`numElts--` 同样是修复 invariant 的必要动作，因为删掉一个元素后集合大小变了。

## constructor：修复"未初始化"的问题

上面这份实现还有一个问题，`IntSet s;` 创建对象时 data members 是未初始化的，也就是说 `numElts` 可能是一个随机值，而 rep invariant 要求它必须是 0。修复方式是使用 constructor：

```cpp
class IntSet { // OVERVIEW omitted for space
    ...
  public:
    IntSet();
      // EFFECTS: creates an empty IntSet
    ...
};
```

constructor 的几条规则：函数名与 class 名相同；没有返回类型；这个例子中也不接受参数；它保证在对象创建之后**第一个**被调用；它构造出一个"空白"的未初始化 IntSet 并让它满足 rep invariant。

写法上使用 initialization syntax：

```cpp
IntSet::IntSet() : numElts(0)
{
}
```

多个 data member 时用逗号隔开，例如 `Class_T::Class_T() : anInt(0), aDouble(1.2), aString("Yes") { }`。<span class="red">成员的初始化顺序是它们在 class 定义中出现的顺序，而不是 initialization list 中的书写顺序</span>，所以最好让两者顺序一致以免误读。

另一种写法是在函数体内赋值：

```cpp
IntSet::IntSet() {
    numElts = 0;
}
```

这不是好的做法——它先默认构造再赋值，而 initialization list 是直接初始化。

## const member function

class 有一个额外收益：以前要写 `void add_one(int a[], int elts);` 并操心元素个数，现在只要写 `void add_one(IntSet &set);`，不再需要把数组和它的计数分开管理。

另一处细节是 const member function。class 定义可以改成：

```cpp
const int MAXELTS = 100;
class IntSet {
    int elts[MAXELTS];
    int numElts;
    int indexOf(int v) const;

  public:
    void insert(int v);
    void remove(int v);
    bool query(int v) const;
    int size() const;
};
```

每个 member function 都有一个隐式的额外参数 `this`，它是指向"调用该函数的当前实例"的 pointer。`const` 关键字修饰的就是这个隐式 `this`：`this` 现在成为指向 const 实例的 pointer，也就是说该 member function **不能修改**它被调用的那个对象。`size()` 按定义就不该修改对象，加上 `const` 只是防止意外修改，因此只要可能就应该加上。函数体本身不变：

```cpp
int IntSet::size() const {
    return numElts;
}
```

两条由它推出的规则：const object 只能调用它的 const member function——`const IntSet is; is.size();` 合法，而 `is.insert(2);` 不合法；如果一个 const member function 调用了其他 member function，那些函数也必须是 const。

## 小结：rep invariant 是 method 的编写依据

回看这一段实现，每个 method 的写法都可以从 rep invariant 反推出来：`size()` 直接返回 `numElts`，因为 invariant 保证了它就是集合大小；`insert` 和 `remove` 在改动数据后都必须显式恢复 `numElts` 与"紧凑存放"这两条；`indexOf` 必须 private，因为它的返回值直接暴露了存储位置。这套"先定 invariant，再写 method"的顺序，是后面所有数据结构实现都会反复使用的模式。

## 用有序数组提高效率

`indexOf` 的时间随集合大小线性增长：集合里有 $N$ 个元素时最坏情况要检查全部 $N$ 个。对元素很多、查询很多的使用场景来说这太贵了。好在可以替换实现而保持抽象完全不变——这正是 ADT 的 substitutable 性质在发挥作用。

新的 representation 仍然用数组、元素仍然占据前 `numElts` 个槽位，但这次**保持元素有序**。先判断哪些 method 需要改：constructor 与 `size` 只用 `numElts`，完全不用改；`query` 通过 `indexOf` 实现，也不用改；`indexOf` 本身也不用改。需要改的是 `insert` 与 `remove`。

`remove` 先用旧的思路试：把末尾元素搬到洞里会破坏"有序"这条新的 invariant（`1 2 3 4 5 6 7` 删 `3` 变成 `1 2 7 4 5 6`）。因此必须改成"把数组挤紧"：把洞右边的元素逐个左移，直到洞被挤出元素范围。循环变量沿用 `victim`，它的新 invariant 是"始终指向数组中的那个洞"：

```cpp
void IntSet::remove(int v) {
    int victim = indexOf(v);
    if (victim != MAXELTS) {
        numElts--;                  // 元素少了一个
        while (victim < numElts) {  // 洞仍在数组内
            elts[victim] = elts[victim+1];
            victim++;
        }
    }
}
```

`insert` 也不能再简单地放到末尾，否则同样破坏有序性（`1 2 4 5 6 7` 插入 `3` 变成 `1 2 4 5 6 7 3`）。做法是先检查是否存在；若不存在且还有空间，就从末尾元素开始逐个右移，直到找到新元素应插入的位置。循环变量 `cand` 的 invariant 是"始终指向下一个可能需要右移的元素"：

```cpp
void IntSet::insert(int v) {
    if (indexOf(v) == MAXELTS) {          // 没有找到重复元素
        if (numElts == MAXELTS) throw MAXELTS;   // 没有空间
        int cand = numElts-1;             // 最大的（最后一个）元素
        while ((cand >= 0) && elts[cand] > v) {
            elts[cand+1] = elts[cand];
            cand--;
        }
        // 此时 cand 指向"间隙"左侧的位置
        elts[cand+1] = v;
        numElts++;                        // 修复 invariant
    }
}
```

这里的条件 `(cand >= 0) && elts[cand] > v` 依赖 `&&` 的 short-circuit 性质：当 `cand` 已经小于 0 时，右边的 `elts[cand]` 根本不会被求值，因此不会发生越界访问。循环因 `cand < 0` 而结束时，说明新元素比数组中所有元素都小，它应当被放在 `elts[0]`，而 `cand+1` 正好是 0，所以实现是正确的——这正是把写入统一写成 `elts[cand+1] = v;` 的好处。

## 复杂度对比与选择

| | Unsorted | Sorted |
|---|---|---|
| query | $O(N)$ | $O(\log N)$ |
| insert | $O(N)$ | $O(N)$ |
| remove | $O(N)$ | $O(N)$ |

query 从 $O(N)$ 降为 $O(\log N)$，是因为数组有序后 `indexOf` 可以用 binary search。`indexOf` 本身不必修改（它仍然线性扫描且是正确的），只是可以借助新的 representation 变得更高效。而 `insert` 与 `remove` 仍然保持线性，因为它们可能需要把一个元素一路挪到数组开头或末尾。

于是选择变成一个有条件的结论：如果 search 比 insert/remove 多得多，就应该用 sorted array 版本，因为 query 更快；如果 query 相对很少，用 unsorted 版本即可——两者在 insert / remove 上"差不多"，而 unsorted 版本简单得多。

参考材料：Problem Solving with C++ (8th Edition) Chapter 10.3（Abstract Data Types）、Chapter 10.2（Classes and constructors）；C++ Primer, 4th Edition Chapter 7.7.1（const Member Function）。
