# 07 Recursion and Function Pointers

这一节用一个很典型的重复代码问题引出 function pointer：`smallest` 与 `largest` 的遍历结构完全一样，唯一真正变化的是“两个候选值怎样合并”。把这条变化规则当作函数参数传进去，就能把 traversal 写一次、策略自由替换。

## Recursion recap

Recursive solution 必须有 base case，并把其余 case 化为一个更小的同类问题。若一个 list 递归定义为“empty list，或一个 integer 加上另一个 valid list”，那么处理 list 的函数也自然按 first / rest 分解。

课程提供的 `list_t` 有三个基本操作：

- `list_isEmpty(list)`：判断是否为空；
- `list_first(list)`：返回首元素，要求 list 非空；
- `list_rest(list)`：返回除首元素外的 rest，要求 list 非空。

寻找最小值：

```cpp
int smallest(list_t list) {
    // REQUIRES: list is not empty
    // EFFECTS: returns the smallest element in list
    int first = list_first(list);
    list_t rest = list_rest(list);

    if (list_isEmpty(rest)) {
        return first;
    }

    int candidate = smallest(rest);
    return first <= candidate ? first : candidate;
}
```

Base case 不是 empty list，因为 function specification 不允许 empty input；它是“rest 已空”，即原 list 只剩一个元素。`largest` 的结构几乎完全相同，只把 comparison 从 `<=` 换成 `>=`。

## 重复代码的问题

为 sum / product、smallest / largest 分别复制一份 traversal 会带来两个问题：修改共同算法时要改很多处，而且这些副本很容易逐渐不一致。真正应该抽象出来的是“遍历骨架”，而把“如何合并两个值”作为参数。

## Function pointer 的 type

函数不只可以被调用，也可以被 variable 指向并作为 argument 传递。若目标函数接收两个 `int` 并返回一个 `int`，pointer type 写作：

```cpp
int (*operation)(int, int);
```

从 identifier 向外读：`operation` 是 pointer，指向 function；该 function 接收两个 `int`，返回 `int`。括号不能省略，因为 `int *operation(int, int)` 会被解析成“返回 `int*` 的 function”。

```cpp
int smaller_of(int a, int b) {
    return a < b ? a : b;
}

int larger_of(int a, int b) {
    return a > b ? a : b;
}

int (*operation)(int, int) = smaller_of;
int result = operation(3, 5);   // 3
```

对 function pointer，compiler 允许省略显式 address-of 与 dereference，因此通常写 `operation = smaller_of;` 和 `operation(3, 5)`，而不必写 `&smaller_of` 或 `(*operation)(3, 5)`。

## 把遍历与策略分开

```cpp
int compare_help(list_t list, int (*combine)(int, int)) {
    // REQUIRES: list is not empty
    int first = list_first(list);
    list_t rest = list_rest(list);

    if (list_isEmpty(rest)) {
        return first;
    }

    int candidate = compare_help(rest, combine);
    return combine(first, candidate);
}

int smallest(list_t list) {
    // REQUIRES: list is not empty
    // EFFECTS: returns the smallest element in list
    return compare_help(list, smaller_of);
}

int largest(list_t list) {
    // REQUIRES: list is not empty
    // EFFECTS: returns the largest element in list
    return compare_help(list, larger_of);
}
```

`compare_help` 决定 traversal；`combine` 决定每一层如何把 `first` 与 rest 的答案合并。<span class="red">Function pointer 抽象的是 behavior：type signature 相同的不同算法，可以作为数据一样传给同一段框架代码。</span>

同样的结构也可用于 array 的 sum / product：

```cpp
int add(int a, int b) { return a + b; }
int multiply(int a, int b) { return a * b; }

int fold(const int a[], unsigned size,
         int initial, int (*combine)(int, int)) {
    int result = initial;
    for (unsigned i = 0; i < size; ++i) {
        result = combine(result, a[i]);
    }
    return result;
}

// sum:     fold(a, size, 0, add)
// product: fold(a, size, 1, multiply)
```

`initial` 必须与 operation 匹配：addition 的 identity 是 $0$，multiplication 的 identity 是 $1$。

参考材料：Problem Solving with C++ (8th Edition) Chapter 14；C++ Primer (4th Edition) Chapter 7.9。
