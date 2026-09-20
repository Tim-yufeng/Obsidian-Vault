# 01 Introduction

这份导论真正要留下的不是教室与联系方式，而是整门课的主线：把“会写一些 C++”推进到“能按 specification 写出正确、可测试、可维护的程序”。课程重点放在 implementation 与 correctness，数据结构只讲最基础的一组，为后续 ECE2810J 的算法与效率分析打底。

## 编程任务的两阶段

一个 programming task 从 problem specification 开始，随后分成两个阶段：

1. Problem solving：设计满足 specification 的 algorithm，通常先把大任务分解成若干 sub-tasks，并考虑 time 与 space 的使用。
2. Implementation：把 algorithm 正确地实现出来，再追求速度、简洁和可读性。

<span class="red">Correctness is never negotiable：程序必须对所有合法输入和所有规定情形都表现正确。</span>“样例能过”只说明碰巧覆盖了几个输入，不能替代 specification 与系统测试。

层次化分解的典型形式是先把主流程写清楚：

```text
int main() {
    Graph map = readGraph(filename);
    Path path = shortestPath(map, home, school);
    printPath(path);
    return 0;
}
```

此时 `main` 只表达任务的结构，读取、求解、输出的细节分别藏在函数内部。这就是后面反复出现的 abstraction。

## 本课程的四条主线

### Abstraction

Abstraction 只暴露当前使用者真正需要的细节，把其余实现隐藏起来，从而降低复杂度。课程会依次讨论：

- procedural abstraction：用 function 描述“做什么”，隐藏“怎么做”；
- data abstraction：用 class / ADT 同时组织数据与操作；
- abstract base class：把 interface 与 implementation 进一步分离。

### Code reuse

Function 与 class 是最基础的复用机制；inheritance、virtual function、template 与 polymorphism 则让同一套代码适用于相关类型或不同类型。Template 的目标可以先记成一句话：write once, use for many types。

### Memory management

当所需空间直到运行时才知道时，预先开一个“足够大”的 array 会浪费空间，也可能仍然不够。课程会学习 dynamic memory allocation / deallocation，以及拥有动态资源的 class 如何正确复制与销毁。

### Elementary data structures

Data structure 研究数据如何表示和操作。本课程覆盖 linked list、linear list、stack、queue，并把重点放在 representation、invariant 与正确实现；更系统的算法效率留到 ECE2810J。

其他必备主题包括 program arguments、I/O stream、file I/O、error handling、testing 与 Linux。

## 开发与提交环境

课程要求程序在 Linux 上用 `g++` 编译，允许 C++17：

```bash
g++ -std=c++17 -Wall -o program source.cpp
```

最终评分环境也是 Linux，因此“在另一套系统上能运行”不能保证提交有效。Project 与 coding exercise 会同时看 correctness 和 implementation 是否满足要求、是否简洁；pre-test 只覆盖 final tests 的一部分，所以仍需自己设计测试。

## 课程评价与工作习惯

课件给出的成绩构成为 attendance 5%、coding exercises 10%、projects 40%、midterm 20%、final 25%。Coding exercise 不接受迟交；project 在截止后 72 小时内按区间扣分，超过 72 小时不接收。具体安排可能随学期公告变化，复习时以 Canvas / 飞书的最新通知为准。

更重要的是工作方式：尽早开始；主动尝试错误输入；记录并复盘错误；频繁备份，最好使用 private version-control repository。Project 的完整流程应是：读懂 specification，设计 solution，实现得简单清楚，再通过自己设计的 tests 说服自己它是正确的。

## Academic integrity 与材料边界

课件允许口头讨论，但 assignment 必须独立完成；不得阅读、保存或复制其他学生（包括往届）的答案与代码，也不得共享测试用例或用他人账户测试。提交什么就对什么负责，即使误传了他人的文件也会按违规处理。Slides、assignment、solution、quiz 等课程材料不得未经允许公开；用 GitHub 备份时 repository 必须设为 private。课件还明确写明不得使用 LLM-based service，实际作业应遵守当前学期课程政策与教师说明。

## Good programming style

Good style 不是装饰，而是让实现可检查、可维护：使用 meaningful names、必要的 comments、统一 indentation 与一致的写法。下面的代码之所以容易读，是因为变量名直接暴露了每个量的职责：

```cpp
// Evaluate a polynomial at x.
int poly_eval(int x, const int *coef, unsigned degree) {
    int result = 0;
    int x_power = 1;
    for (unsigned i = 0; i <= degree; ++i) {
        result += coef[i] * x_power;
        x_power *= x;
    }
    return result;
}
```

课程的最终目标可以压成一句话：<span class="red">从 specification 出发，用 abstraction 管理复杂度，用 testing 保证 correctness，再用合适的数据结构与内存策略完成实现。</span>
