# 11 Testing

Testing 的目标不是证明程序没有 bug，而是主动寻找与 specification 不一致的行为。它和 debugging 不同：testing 负责发现“坏了”，debugging 在已经知道坏了之后定位并修复原因。一个好的测试者要以 adversarial mindset 对待自己的代码，而不是只找能让它顺利通过的输入。

## Incremental testing

等整个程序“写完”再做 end-to-end testing 通常代价很高：早期 component 的错误会扩散，失败时也难判断来源。Incremental testing 是每写完一个小 unit（如 function）就测试它。

它的优势是 unit 更小、更容易理解，而且刚写完时对预期行为仍然清楚。代价是可能需要额外写 driver program，但这通常远低于最后重写大段程序的成本。

## Five steps in testing

1. Understand the specification：先离开代码，逐条确认任务要求；如果把 specification 理解错，程序即使符合自己的预期也仍然错误。
2. Identify required behaviors：把 specification 转成一组 observable behaviors，正确 implementation 必须全部满足。
3. Write specific tests：每个 behavior 至少有一个 test，尽量让一个 test 只检查一件事，失败时才容易定位。
4. Know answers in advance：运行前写下 expected output，再与 actual output 比较；不要只“看起来差不多”。
5. Include stress tests：在各 behavior 单独正确后，用大规模、长时间组合输入检查 resource limit、round-off accumulation 与 memory leak 等问题。

<span class="red">Test case 必须从 specification 推导，而不是从当前 implementation 推导。</span>否则很容易只测试自己已经写出的路径，遗漏应有但尚未实现的行为。

## 三类 test cases

- Simple inputs：正常、典型、容易手算的输入，用于确认基本功能。
- Boundary conditions：合法范围边缘，或专门触发 implementation 边界的输入，例如空集合、单元素、容量刚好用满、`0`。
- Nonsense：明显不符合预期格式或 domain 的输入，例如要求非负整数却给负数或非整数。

以 command-line factorial program 为例，required behaviors 可以包括：缺参数时报错；参数过多时只处理第一个；非整数时报错；负数时报错；`0` 输出 `1`；正整数 $n$ 输出 $n!$。注意同一个 input 的分类依赖 specification：若 specification 只接受 positive integer，`0` 可能是 boundary 或 illegal case；不能脱离要求机械贴标签。

## 自动化与 regression testing

测试规模变大后应自动运行：

```text
for each test case:
    run program with the test input
    compare actual output with expected output
```

每次修改代码后重新跑全部旧 tests，叫 regression testing。它检查新改动有没有破坏原本已经工作的 behavior。自动化的价值不只是省时间，也避免人疲劳后漏看差异。

## Assert 与 defensive checks

`assert` 定义在 `<cassert>`，用来检查程序内部“这里本应成立”的 condition：

```cpp
#include <cassert>

int smaller = min_value(a, b);
assert(smaller == a || smaller == b);
assert(smaller <= a && smaller <= b);
```

只检查 `smaller <= a && smaller <= b` 还不够，因为一个错误实现可能返回一个比二者都小、但根本不是输入的值；第二条 membership check 补上了这一点。若 condition 为 false，program 会停止并向 `cerr` 输出 diagnostic。

Assert 适合检查 internal invariant，不适合作为所有 user-input error 的最终处理方式。某些 check 很昂贵时，可以在 production build 禁用：

```cpp
#define NDEBUG
#include <cassert>
```

或编译时：

```bash
g++ -DNDEBUG -o program program.cpp
```

因此不能把会改变必要程序状态的 expression 放进 `assert`，因为禁用后该 expression 不会执行。

## Testing checklist

- 每条 specification 是否至少对应一个 test？
- Empty、single-element、first / last、minimum / maximum、刚好越界前后的 case 是否覆盖？
- 每个 test 是否有事先确定的 expected result？
- 修改后是否重跑了 regression suite？
- Stress test 是否覆盖 memory、time 与长时间累计问题？

参考材料：课件所列 C++ testing / unit testing 资料。
