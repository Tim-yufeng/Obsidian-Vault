# 06 Procedural Abstraction and Recursion

这一节先把 function 从“代码块”提升为 procedural abstraction：client 依赖的是 specification，而不是 implementation。随后 recursion 把同样的思想用在问题规模上——只说明“当前问题怎样依赖一个更小的同类问题”，让 call mechanism 负责层层展开。

## Abstraction：隐藏不相关细节

Abstraction 只提供使用者当前需要的 details，消除其余细节以降低复杂度。Multiplication 可以由 table lookup、repeated addition 或其他算法实现，但 client 只关心输入两个数后得到乘积。

课程区分两种 abstraction：procedural abstraction 由 function 实现，data abstraction 由后面的 ADT / class 实现。

## Author 与 client

每个 function 都有两个角色：author 负责决定函数做什么并写出实现；client 只按照公开的 abstraction 使用它。即使在个人项目里两个角色是同一个人，写 client code 时也应主动“忘掉 how”。

```cpp
int multiply(int a, int b);
// EFFECTS: returns the product of a and b

int square(int a) {
    return multiply(a, a);
}
```

只要 `multiply` 仍满足 specification，换成另一种正确 implementation 不需要修改 `square`。

正确的 procedural abstraction 有两个性质：

1. Local：实现一个 abstraction 时，只需局部关注它依赖的公开 abstraction，不依赖其他实现细节。
2. Substitutable：一个正确 implementation 可以被另一个正确 implementation 替换，caller 无需修改。

<span class="red">Locality 与 substitutability 保护的是 implementation 的替换，不保护 abstraction 本身的改变。</span>如果把 `multiply` 的含义、type signature 或使用条件改掉，所有 callers 都可能受影响，因此 abstraction 必须在写代码前先设计好。

## 用 specification 描述 what

Type signature 说明 return type 与 parameters，但不足以完整描述行为。课程用 specification comment 回答三个问题：

- `REQUIRES`：调用前必须满足哪些 preconditions；没有则省略。
- `MODIFIES`：函数可能修改哪些显式参数或 global state；没有则省略。
- `EFFECTS`：对合法输入，函数产生什么结果或行为。

```cpp
bool is_even(int n);
// EFFECTS: returns true if n is even, false otherwise

int factorial(int n);
// REQUIRES: n >= 0
// EFFECTS: returns n!

void swap_values(int &x, int &y);
// MODIFIES: x, y
// EFFECTS: exchanges the values of x and y
```

没有 `REQUIRES` 的 function 是 complete function，对其参数类型中的所有输入都有定义；有 `REQUIRES` 的是 partial function，某些类型上合法的值不属于该函数的合法 domain。对于 `factorial`，implementation 可以假定 `n >= 0`，因为 caller 承担满足 precondition 的责任。后面的 exception mechanism 会提供一种把部分函数改成运行时可报告错误的 complete interface 的办法。

## Recursion 的结构

Recursive function 引用自身，但必须具备两部分：

1. Base case：一个无需继续递归即可直接求解的 stopping case。
2. Recursive step：把当前问题缩小成严格更小的同类问题，再把较小问题的结果与当前一步组合。

```cpp
int factorial(int n) {
    // REQUIRES: n >= 0
    // EFFECTS: returns n!
    if (n == 0) {
        return 1;
    }
    return n * factorial(n - 1);
}
```

正确性检查要问三件事：base case 是否覆盖停止位置；recursive call 的规模是否真的变小；较小问题的答案是否足以构造当前答案。缺任一项都可能导致 infinite recursion 或错误结果。

## Recursive helper

原问题的 interface 有时不携带 recursion 所需的状态，此时让 public function 保持简单，把额外参数交给 private / local helper。下面用 helper 求数组最大值：

```cpp
int max_from(const int a[], unsigned size, unsigned index) {
    // REQUIRES: index < size
    // EFFECTS: returns the largest value in a[index..size-1]
    if (index + 1 == size) {
        return a[index];
    }

    int rest_max = max_from(a, size, index + 1);
    return a[index] > rest_max ? a[index] : rest_max;
}

int array_max(const int a[], unsigned size) {
    // REQUIRES: size > 0
    // EFFECTS: returns the largest element in a
    return max_from(a, size, 0);
}
```

Helper 把递归子问题明确成“从 `index` 开始的 suffix 的最大值”。`array_max` 则保留 caller 真正需要的 interface，不把实现细节 `index` 暴露出去。

## 复习判断

- Abstraction 是 specification / what；implementation 是 how，同一 abstraction 可以有多个实现。
- 修改 implementation 通常是 local 的；修改 abstraction 会传播到 callers。
- Reference parameter 只要“可能被改”，就应写进 `MODIFIES`。
- Recursion 不是简单地“函数里调用自己”，而是 base case 加上朝 base case 收敛的 smaller case。

参考材料：Problem Solving with C++ (8th Edition) Chapters 4.4、5.3、14。
