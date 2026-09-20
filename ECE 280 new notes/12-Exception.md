# 12 Exception

Exception 解决的是 runtime 中出现了异常条件，而当前 function 无法正常继续的问题。它把 normal-case code 与 error-handling code 分开，并让错误沿 call stack 自动传播到有能力处理它的 caller。

## 从 partial function 到 runtime checking

`REQUIRES` 可以规定合法输入，但它只是 contract，不能在运行时强制 caller 遵守。要主动检查 illegal input，就必须决定错误发生后怎么办。课件给出三类策略：

1. “It's my problem”：callee 修正 input 或返回有意义的 default。只有 specification 能明确规定合理 fallback 时才适用；例如 empty list 的 `rest` 可以约定仍为空。对 division by zero 这类没有合理值的情况，强行默认会改变问题本身。
2. “I give up”：用 `assert` 等 hard exit 直接停止。适合检查不应发生的 internal bug，但深层 function 直接终止会跳过更高层的清理与恢复决定。
3. “It's your problem”：把 failure 编进 return value，让 caller 处理。问题是某些 function 的全部 return values 都可能是合法结果，找不到 sentinel；而且每层 caller 都必须检查并继续转发，normal code 很快被 error plumbing 淹没。

Exception handling 保留第三种策略“交给更合适的 caller”，但自动完成传播，而且不必占用正常 return value。

## Throw、try 与 catch

Exception 是有 type 的 object。`throw` 报告异常并携带信息，`try` 标出受保护的 normal code，`catch` 是匹配的 handler：

```cpp
int factorial(int n) {
    // EFFECTS: returns n! if n >= 0;
    //          throws int n if n < 0
    if (n < 0) {
        throw n;
    }

    int result = 1;
    for (; n != 0; --n) {
        result *= n;
    }
    return result;
}

void print_factorial(int n) {
    try {
        cout << factorial(n) << endl;
    }
    catch (int value) {
        cout << "Error: negative input: " << value << endl;
    }
}
```

`catch (int value)` 只匹配 `int` exception，并把 thrown object 复制进 `value`。Handler 成功结束后，execution 从整组 catch blocks 之后的第一条 statement 继续，而不是回到 throw point。

## 自定义 exception type

用任意 `int` 表示错误不够清楚，可以定义专门的 type：

```cpp
struct NegativeInteger {
    int value;
};

if (n < 0) {
    NegativeInteger error;
    error.value = n;
    throw error;
}
```

Exception object 像 parameter 一样，把错误上下文传给 handler。Specification 的 `EFFECTS` 必须说明可能 throw 什么以及在什么条件下 throw。

## Exception propagation

发生 throw 后，程序寻找第一个 type matching handler：先看当前 function 对应的 try/catch；没有则退出当前 frame，去 caller 中找；仍没有就继续沿 call chain 向上。若直到 `main` 之外都无人处理，program 终止。

<span class="red">Propagation 的本质是自动沿 call stack 传递 exceptional condition，直到遇到第一个匹配的 catch。</span>中间 functions 不需要用 return value 手动逐层搬运错误。

如果当前 handler 只能记录信息、不能最终解决，可以 rethrow：

```cpp
try {
    use_value();
}
catch (const NegativeInteger &error) {
    cerr << "negative: " << error.value << endl;
    throw;   // 继续传播当前 exception
}
```

## 多个 handlers 与匹配顺序

```cpp
try {
    // code that may throw
}
catch (int n) {
    // handles int
}
catch (double d) {
    // handles double
}
catch (char c) {
    // handles char
}
catch (...) {
    // catch-all
}
```

Handlers 按顺序检查，第一个 matching catch 执行；`catch (...)` 能匹配任何 type，应放在最后。Catch 必须跟在 try block 后，但 throw 可以出现在任何 function 中，只要上层 call chain 可能提供 handler。

## Exception、assert 与 return code 怎么选

- Caller 违反了明确 `REQUIRES`，且项目把它视为 programmer bug：可以用 assertion 检查。
- 当前层能给出 specification 允许的合理 fallback：直接处理并继续。
- 失败是 runtime 中可能发生、当前层无法处理、上层可能恢复的情况：throw exception。
- Return status 能自然表达且每层都应立即处理的简单错误：return code 仍然可用。

异常机制本身不会决定“怎样修复错误”；它只把错误从发现者传到负责决策的 handler，同时保持 normal path 清楚。

一个适合练习的完整检查是 probability distribution：长度为 `5` 的 `double` array 中，每个值都应落在 $[0,1]$，且总和应为 $1$。Implementation 应分别检查 element range 与 total；若课程 specification 要求通过 exception 报告失败，应为不同失败条件选择清楚的 exception type 或携带足够信息的 exception object。

参考材料：Problem Solving with C++ (8th Edition) Chapter 16。
