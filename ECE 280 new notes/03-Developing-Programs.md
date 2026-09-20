# 03 Developing and Compiling Programs on Linux

这一节把“源代码怎样变成可执行程序”拆开来看。单文件时一条 `g++` 命令似乎包办一切；多文件项目中，必须区分 preprocessing、compilation 与 linking，并用 header guard 和 Makefile 管理依赖关系。

## 从 source code 到 executable

C++ source file 是文本，CPU 真正执行的是 machine code。编译一个单文件程序：

```bash
g++ -Wall -g -o program source.cpp
./program
```

`-o program` 指定输出文件名，`-Wall` 打开常见 warning，`-g` 把 debugging information 放进 executable，便于之后用 debugger 检查。

一条完整命令内部可以拆成两步：

```bash
g++ -Wall -c source.cpp      # source.cpp -> source.o
g++ -Wall -o program source.o
```

`.o` 是 object code：已经包含某个 module 的 machine code，但还没有与其他 module / library 连接成完整程序。第二步 linking 才生成 executable。

## 为什么拆成多个 source files

大型项目拆成多个文件有四个直接收益：只重新编译改过的部分；结构更清楚；模块更容易复用；多人可以分工。通常文件职责是：

- `.h`：function declarations、class definitions 与对外 interface；
- `.cpp`：function definitions 与 class member-function definitions。

例如：

```cpp
// add.h
#ifndef ADD_H
#define ADD_H

int add(int a, int b);

#endif
```

```cpp
// add.cpp
#include "add.h"

int add(int a, int b) {
    return a + b;
}
```

```cpp
// run_add.cpp
#include "add.h"

int main() {
    return add(2, 3) == 5 ? 0 : 1;
}
```

Preprocessor 会把每条 `#include` 替换为对应文件的内容，因此调用 `add` 的 source file 必须 include declaration。定义普通函数时，课件指出 `add.cpp` 不一定非要 include `add.h`；实际开发仍通常这样做，让 compiler 检查 declaration 与 definition 是否一致。定义 class member function 时，`.cpp` 必须 include 对应 class definition。

## Header guard

Header 之间可能互相 include，同一个 header 因此会在一份 source file 中被展开多次，造成 repeated definition。Header guard 让内容只在第一次 include 时生效：

```cpp
#ifndef ADD_H
#define ADD_H

int add(int a, int b);

#endif
```

第一次遇到时 `ADD_H` 尚未定义，内容被处理并执行 `#define ADD_H`；以后再遇到同一 header，`#ifndef` 失败，中间内容被跳过。<span class="red">Header guard 防止的是同一 translation unit 中重复处理 header 内容。</span>

## 编译多个 source files

一次完成 compilation 与 linking：

```bash
g++ -Wall -o run_add run_add.cpp add.cpp
```

命令里列出所有 `.cpp`，不列 `.h`，因为 header 已由 `#include` 展开。也可以分别生成 object files：

```bash
g++ -Wall -c run_add.cpp
g++ -Wall -c add.cpp
g++ -Wall -o run_add run_add.o add.o
```

Separate compilation 的关键优点是：只要 `add.cpp` 没变，就可以继续使用原来的 `add.o`；缺点是手动判断哪些文件要重编、反复输入命令很麻烦。

## Makefile：把依赖关系写下来

Makefile 的一条 rule 包含 target、dependencies 与 command：

```make
all: run_add

run_add: run_add.o add.o
	g++ -o run_add run_add.o add.o

run_add.o: run_add.cpp add.h
	g++ -Wall -c run_add.cpp

add.o: add.cpp add.h
	g++ -Wall -c add.cpp

clean:
	rm -f run_add *.o
```

Command 前必须是 Tab。运行 `make` 默认构建第一项 `all`；运行 `make run_add` 构建指定 target；运行 `make clean` 执行 dummy target `clean`，删除生成文件。

`make` 的判断规则是：当 dependency 比 target 更新，或 target 不存在时，执行该 rule 的 command。依赖图中，`run_add` 依赖两个 `.o`，每个 `.o` 又依赖相应 `.cpp`（以及会影响它的 `.h`）。因此修改 `add.cpp` 后只需重编 `add.o`，再重新 link，不必重编 `run_add.cpp`。

## 复习检查

- Compile error 通常发生在某个 source file 变成 object file 的阶段；link error 常见于 declaration 存在但 definition 没有被链接进来。
- `#include` 解决“当前 source file 看得见哪些 declaration / definition”，linking 解决“各 object files 最终如何合成 executable”。
- 改 `.h` 往往会让所有 include 它的 `.cpp` 重新编译；Makefile 必须把这种依赖写出来。

参考材料：C++ Primer (4th Edition) Chapter 2.9；Makefile 教程（课件所列 Colby tutorial）。
