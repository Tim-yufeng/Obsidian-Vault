# 08 Function Call Mechanism

Recursion、pass by value、pointer parameter 为什么会表现不同，答案都在 function call 的底层模型里：每次调用都有自己独立的 activation record，多次调用按 last-in-first-out 放在 call stack 上。理解这个模型后，scope、递归展开与返回过程就不再靠死记。

## 一次 function call 做了什么

调用 function 时，程序按概念顺序完成：

1. Evaluate actual arguments；其求值顺序不保证。
2. 创建 activation record（stack frame），为 formal parameters、local variables 与 return information 留空间。
3. 把 actual values 复制到 formal parameters 的 storage。
4. 在该 function 的 local scope 中执行 body。
5. 用 return value 替换原来的 call expression。
6. 销毁 activation record。

例如 `y = add(4 - 1, 5);` 会先得到 actual values `3` 与 `5`，再创建属于 `add` 的 frame，把它们复制给 formals，求出 `8`，最后销毁 frame 并把 `y` 设为 `8`。

## Activation records 为什么形成 stack

Function 在返回前可以继续调用其他 function；内层调用必须先结束，外层才能继续，因此 frames 自然遵守 last in, first out (LIFO)。调用时 push 一个 frame，返回时 pop 最上面的 frame。

![[Pasted image 20260917143444.png]]

图中 `main`、`plus_two` 与 `plus_one` 同时存在三个 frames。两个 function 都有名为 `x` 的 formal parameter，但它们位于不同 memory locations；`plus_one` 不能直接看见 `plus_two` 的 `x`，只能接收复制过来的 value。随后 `plus_one` 先返回并销毁，`plus_two` 才能完成自己的 expression。

<span class="red">同名 local variables 不会冲突，因为每次 function invocation 都拥有独立的 activation record。</span>

## Pointer parameter 为什么能修改 caller 的对象

```cpp
void add_one(int *x) {
    *x = *x + 1;
}

int main() {
    int foo = 2;
    int *bar = &foo;
    add_one(bar);
    return 0;
}
```

`bar` 的 value（地址）仍然是 pass by value，复制进 `add_one` 的 formal `x`。但是 `bar` 与 `x` 保存了同一个地址，所以 `*x` 与 `*bar` 访问同一个 `foo`。`add_one` 返回后，自己的 pointer variable `x` 被销毁，`foo` 已经被改成 `3`。

这也解释了一个常见误区：pass a pointer by value 不会让 callee 改变 caller 的 pointer variable 本身，但可以让 callee 修改该地址指向的 object。

## Recursion 在 stack 上怎样展开

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

调用 `factorial(3)` 时，stack 依次出现参数为 `3`、`2`、`1`、`0` 的四个 frames。每个 frame 还要记住 return address，也就是内层调用结束后应回到哪一条指令。到 `n == 0` 返回 `1` 后，stack 反向展开：

$$
\operatorname{factorial}(0)=1,
\quad \operatorname{factorial}(1)=1\cdot1,
\quad \operatorname{factorial}(2)=2\cdot1,
\quad \operatorname{factorial}(3)=3\cdot2=6.
$$

Base case 的意义不只是“让算法有答案”，也是停止继续创建 frames。递归深度受 stack 空间限制，因此实际执行时 calls 不可能无限增长；对 `factorial(0)`，只会有一次 `factorial` invocation。若把 base case 写成 `n <= 1`，则对正整数输入可少创建一层 `factorial(0)` frame，同时结果不变。

## Fibonacci：正确但昂贵的递归

```cpp
int fib(int n) {
    // REQUIRES: n >= 0
    // EFFECTS: returns the n-th Fibonacci number
    if (n == 0) return 0;
    if (n == 1) return 1;
    return fib(n - 1) + fib(n - 2);
}
```

它忠实对应定义，但会重复计算大量相同 subproblems。Call stack 模型不仅解释程序“能不能算”，也提醒我们每一次 recursive call 都有时间与 frame 开销。

## 复习检查

- Actual argument 与 formal parameter 是两处 storage；pass by value 会复制 value。
- Pointer 本身可以被复制，但复制后的 pointers 仍可指向同一 object。
- Caller frame 在 callee 执行期间仍存在；callee 返回后才继续。
- Recursion 的向下阶段不断 push frames，base case 后的回溯阶段逐个 pop 并完成尚未算完的 expressions。
