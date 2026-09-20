# 16 Dynamic Memory Allocation, Overloading, Destructor

到目前为止所有数据结构都有"最多 N 个元素"的限制，而这个 N 是编译期就固定下来的。这一节引入第三类对象——dynamic object：编译器既不需要知道它多大，也不需要知道它活多久。代价是它的生命周期完全由程序自己负责，于是有了 `new` / `delete`、dynamic array、以及 destructor 这一整套配对机制。

## 两类已知的变量

先看已有的两类变量。Global variable 定义在任何函数定义之外，空间在程序开始执行之前就划好，一直保留到程序结束；这块空间是在 compile time 保留的。Local variable 定义在某个 block 内（函数参数也算），空间在进入相应 block 时划出、离开 block 时释放；这块空间是在 run time 保留的，但大小是编译器已知的。

两类变量的共同点是编译器必须知道它们有多大，也就是这些信息是 static 的，必须由程序员声明出来。这带来一个具体问题：可以把一个 fixed-size 结构做得很大，但"整数集合"在数学上并没有某个特定大小上限——无论把容量做得多大，需求更大的应用总会到来。

## dynamic object：编译器不需要知道大小和寿命

第三类对象是 dynamic 的，意思是编译器不需要知道它有多大，也不需要知道它活多久。对 IntSet 来说，这意味着它应当能按使用者的需要增长（在物理机器允许的范围内），并且应当存在到使用者不再需要它为止，之后由使用者负责销毁它。

动态对象通过语言的 dynamic storage management 设施创建，这套设施只有两个操作：

- `new`：为某类型的对象保留空间、初始化该对象、返回指向它的 pointer。
- `delete`：给定一个由 `new` 创建的对象 pointer，销毁该对象并释放它此前占用的空间。

```cpp
int *ip = new int;      // 划出一块 int 空间，返回指向它的 pointer 并赋给 ip
int *ip2 = new int(5);  // 用 initializer 把初值设为 5
```

注意第一行没有对那个整数做任何初始化，它可能是任意随机值。也可以 `new` 一个 class 类型：`IntSet *isp = new IntSet;`，此时 constructor 会被调用，`isp` 指向一个元素个数为 0 的空 IntSet。

```cpp
delete ip;
```

这把空间释放掉。有一条必须记住的限制：<span class="red">不能 delete 一个不是由 new 创建的对象</span>。

```cpp
int a = 5;
int *ip = &a;
delete ip;   // Error
```

对由 `new` 创建的 class 实例也可以 `delete isp;`。就 IntSet 这个例子而言，它只由"普通"类型（int、int 数组）组成，所以销毁它不需要做额外的事情；<span class="red">但并非所有 class 的销毁都如此</span>。既然有 constructor 来创建对象，有时也需要 destructor 来正确地销毁它们。

## 生命周期、memory leak 与 double deletion

动态对象的寿命完全由程序控制：<span class="red">它会一直存在，直到被显式销毁——即使你已经"忘记"了指向它的 pointer</span>。

```cpp
int *p1 = new int(1);
int *p2 = new int(2);
p1 = p2;
```

执行后有两个 pointer 指向对象 `2`，而没有任何 pointer 指向对象 `1`，于是对象 `1` 占用的内存再也无法释放，这就是 memory leakage。更糟的是

```cpp
delete p1;
delete p2;
```

会把为 `2` 保留的内存释放两次。而如果只是让局部 pointer 走出作用域，动态对象并不会随之消失：

```cpp
void f() {
    int *p = new int(42);
}   // p 消失，但堆上的那块空间仍然存在，且无法回收
```

这里要区分两个寿命：pointer 变量本身的寿命，和它所指对象的寿命。局部 pointer 随 block 退出而消失，而它指向的动态对象还在，于是留下一个无法回收的已分配对象，这同样称为 memory leak。leak 频繁发生时，程序最终会达到再也无法分配新动态对象的状态。

检查 memory leak 用的工具是 valgrind：

```text
valgrind --leak-check=full ./program <args>
```

它搜索内存泄漏并给出每一处泄漏的细节；用 `sudo apt-get install valgrind` 安装。

## heap 与 stack

由 `new` 创建的对象，其空间来自一块称为 heap 的内存区域。整个进程的内存布局自上而下是：

![[Pasted image 20260809153005.png]]

高地址处是 stack，它随函数调用向下增长；低地址处依次是 text（程序本身）、globals（固定大小）与 heap，其中 heap 向上增长。中间的空白区域常被称为 "THE BIG VOID"，它是 heap 与 stack 之间尚未使用的空间。这张图解释了为什么递归太深（stack 用尽）和动态分配太多（heap 用尽）是两类不同的失败，也说明了 stack 上放的都是大小在编译期确定的对象。

## Dynamic array

上面的动态对象大小都还是编译器已知的（`int`、`IntSet`）。真正让编译器无法知道大小的是 dynamic array：

```cpp
int *ia = new int[5];      // 在 heap 上建 5 个 int 的数组，把首元素 pointer 存入 ia
int n = 20;
int *ia2 = new int[n];     // 大小放在 [] 里，可以是变量
```

释放数组与释放单个对象的写法不同：

```cpp
delete[] ia;
```

<span class="red">如果分配的是 array-of-T，就必须用 `delete[]`，不能用普通的 `delete`</span>，两者是完全不同的操作，混用会导致 undefined behavior。原因和 `new` 的内部实现有关：当 `new` 发现自己在分配数组时，会把数组的元素个数连同数组一起存下来——它在数组前面多划一小块空间记录元素个数（本例中是 5），然后返回指向数组开头（即记录区之后）的 pointer。如果写 `delete ia;`，`delete` 会以为只需归还"一个 int"那么大的空间；而 `delete[]` 知道要往 pointer 之前看那个记录，从而知道该归还多少个元素的空间。

## 用 dynamic array 重建 IntSet

新的 IntSet 允许使用者指定集合容量，data members 从"定长数组"改成"指向动态数组的 pointer"：

```cpp
class IntSet {
    int *elts;    // pointer to dynamic array
    int sizeElts; // capacity of array
    int numElts;  // current occupancy
  public:
    ...
};
```

`sizeElts` 告诉我们已分配数组的大小（不再一定是 `MAXELTS`），`numElts` 仍然表示实际有多少个元素。这一改动基于前面 unsorted 的实现，多数 method 不变，需要新增的是 constructor：

```cpp
IntSet::IntSet() {
    elts = new int[MAXELTS];   // 分配默认大小的数组
    sizeElts = MAXELTS;
    numElts = 0;
}
```

用 initialization syntax 写同样可以：

```cpp
IntSet::IntSet() : elts(new int[MAXELTS]), sizeElts(MAXELTS), numElts(0)
{
}
```

## Overloaded constructor 与 default argument

除了默认 constructor，还可以写一个"alternate constructor"——名字相同但 type signature 不同：

```cpp
class IntSet {
    int *elts; int sizeElts; int numElts;
  public:
    IntSet();          // default constructor
      // EFFECTS: create a MAXELTS capacity set
    IntSet(int size);  // constructor with explicit capacity
      // REQUIRES: size > 0
      // EFFECTS: create a size capacity set
};
```

这就是 function overloading：两个名字完全相同、但参数个数和/或参数类型不同的函数。例如 `int average(int a, int b);`、`double average(double a, double b);`、`int average(int a, int b, int c);` 可以共存，编译器根据实际参数的个数与类型决定调用哪一个（`average(2, 3)`、`average(2, 3, 5)`、`average(2.0, 3.0)` 分别命中上面三个）。

alternate constructor 按指定大小建立数组：

```cpp
IntSet::IntSet(int size) : elts(new int[size]), sizeElts(size), numElts(0)
{
}
```

创建对象时编译器同样能挑对 constructor：`IntSet is1;` 无参数，调用 default constructor；`IntSet is2(200);` 有整数参数，调用 alternate constructor。

不过这两个 constructor 几乎一模一样，唯一差别是用 `size` 还是 `MAXELTS`，其余代码完全重复。遇到反复书写同一段代码时应当做 parametric generalization，这里的手段是 default argument——只定义一个 constructor，但让它的参数可选：

```cpp
class IntSet {
    ...
  public:
    IntSet(int size = MAXELTS);
      // EFFECTS: create a set with specified capacity.
      //          It defaults to MAXELTS if not supplied.
};
```

实现时按普通方式写，<span class="red">不要在函数定义处再写一遍 `= MAXELTS`</span>：

```cpp
IntSet::IntSet(int size) : elts(new int[size]), sizeElts(size), numElts(0)
{
}
```

default argument 的一般规则：`int add(int a, int b, int c = 1)` 中 `c` 的默认值是 1，于是 `add(1, 2)` 等价于 `add(1, 2, 1)`，而 `add(1, 2, 3)` 覆盖默认值。一个函数可以有多个 default argument，但它们必须是最后的那些参数：`int add(int a, int b = 0, int c = 1)` 合法，`int add(int a, int b = 1, int c)` 不合法。

## Destructor：修掉 local IntSet 的泄漏

新的 IntSet 有一个问题：如果函数内有一个局部 IntSet，函数返回时会怎样？答案是 memory leak——IntSet 中的 `elts` 数组的链接丢失了。原因很直接：对象本身（pointer 与两个 int）在 stack 上，随 block 退出而被回收；但它指向的、在 heap 上的数组没有任何人再去释放。

对照"static"版本的 IntSet 就不会有这个问题：它的 `int elts[MAXELTS]` 是对象的一部分，随对象一起被回收。这也说明泄漏的根源不是"用了数组"，而是"对象里的某个成员拥有堆上的空间，而对象被销毁时没有把它交还"。

修法是让 enclosing IntSet 被销毁时同时释放那块整数数组，这正是 destructor 的职责——它是 constructor 的反面：constructor 保证对象成为其 class 的一个合法实例，destructor 的工作则是销毁该对象。<span class="red">如果一个 class 的 method（包括 constructor）分配了动态存储，那么 destructor 就负责把它释放掉</span>。

```cpp
class IntSet {
    int *elts; int sizeElts; int numElts;
  public:
    IntSet(int size = MAXELTS);
      // EFFECTS: create a set with size capacity;
      //          capacity is MAXELTS by default.
    ~IntSet();   // Destroy this IntSet
    ...
};

IntSet::~IntSet() {
    delete[] elts;   // 必须用 array-based delete，而不是普通的 delete
}
```

destructor 的名字是 `~` 加 class 名，没有返回类型也没有参数。还有一条使用上的事实：block 内声明的 ADT，其 destructor 会在 block 结束时自动被调用，不需要手动触发。

## 动态创建与销毁 IntSet

新的 IntSet 也可以像别的东西一样被动态创建和销毁：

```cpp
IntSet *ip = new IntSet(50);   // 非标准大小
// ... do stuff
delete ip;                     // 销毁这个 IntSet
```

`IntSet *ip = new IntSet(50);` 之后发生两件事：为 IntSet 对象本身（一个 pointer 加两个 int）分配空间；在该对象上调用 constructor，而 constructor 又为 50 个 int 的数组分配空间——所以栈上只有 `ip`，堆上是对象本身加上它内部的数组。

对带 destructor 的 class 实例调用 `delete` 时，顺序是：先调用 destructor（释放它内部的数组），然后才删除对象本身。

判断相关说法的对错：任何对象都该用 `delete` 销毁（错，只有 `new` 出来的才该）；任何 `new` 出来的对象都该用 `delete` 销毁（对）；含动态数组的 class 应该有 destructor（对）；destructor 只在成员变量是动态数组时才需要（错，判据是"这个 class 有没有 method 分配了动态存储"，而分配者可以是任何 method 而不只是 constructor）。

参考材料：Problem Solving with C++ (8th Edition) Chapter 9.1（Pointers）、Chapter 9.2（Dynamic Arrays）、Chapter 11.4（Classes and Dynamic Arrays）、Chapter 10.2（Constructors for Initialization, pp. 560-570）、Chapter 6.3（Default Arguments for Functions, pp. 344-345）。
