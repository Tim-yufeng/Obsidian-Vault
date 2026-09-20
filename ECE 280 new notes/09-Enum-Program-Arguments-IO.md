# 09 Enum, Program Arguments, I/O

这一节把"常数"升级成"类型"：先用 `enum` 把一组互斥取值封成一个类型，让编译器替我们检查参数合法性；再让程序从命令行接收参数；最后建立 I/O stream 的基本模型，为下一节的输入输出细节打底。

## 为什么需要 enum

除了单个常量，程序还经常需要给数据分类。例如扑克牌有四种花色 Clubs、Diamonds、Hearts、Spades，最直接的做法是用一组常量给它们编号：

```cpp
const int CLUBS = 0;
const int DIAMONDS = 1;
// and so on...
```

这样编码信息很不方便。考虑一个判断花色是否为红色的函数：

```cpp
bool isRed(int suit);
// REQUIRES: suit is one of Clubs, Diamonds, Hearts, or Spades
// EFFECTS:  returns true if the color of this suit is red.
```

麻烦的地方在 REQUIRES 子句：因为 `int` 的取值范围远大于四种花色，并不是每个整数都能编码一个花色，所以必须靠注释额外约定调用者只能传什么。<span class="red">更好的做法是用 enumeration（enum）type</span>。

## 定义与使用 enum

```cpp
enum Suit_t {CLUBS, DIAMONDS, HEARTS, SPADES};
```

这里 `Suit_t` 是新的类型名，花括号里是 enum 的取值（enumerator）。定义该类型的变量、初始化、作为参数传递的写法与普通类型一致：

```cpp
Suit_t suit;
Suit_t suit2 = DIAMONDS;
```

enum 是 pass-by-value，也可以赋值。它最大的收益是类型本身携带了合法取值集合，因此 `isRed` 的 specification 可以去掉了 REQUIRES 子句：

```cpp
bool isRed(Suit_t s);
// EFFECTS: returns true if the color of this suit is red.

bool isRed(Suit_t s) {
    switch (s) {
        case DIAMONDS:
        case HEARTS:
            return true;
            break;
        case CLUBS:
        case SPADES:
            return false;
            break;
        default:
            assert(0);
            break;
    }
}
```

注意这里 `default` 分支写的是 `assert(0)` 而不是返回某个默认值——它的作用是显式声明"枚举取值已经被穷尽，走到这里说明有 bug"，这和上一段 REQUIRES 子句想表达的约束是同一件事，只是改由类型系统承担。

## enum 的数值性质

对上面那个 `Suit_t`，数值上 `CLUBS = 0, DIAMONDS = 1, HEARTS = 2, SPADES = 3`。利用这个性质可以简化一些代码，例如用一个字符串数组做名字映射：

```cpp
Suit_t s = CLUBS;
const string suitname[] = {"clubs", "diamonds", "hearts", "spades"};
cout << "suit s is " << suitname[s];
```

这里能直接拿 `s` 当下标，前提正是 enumerator 从 0 开始连续编号。

几条容易考的规则：不同 enum 类型之间即使出现同名的 enumerator（例如 `COLOR1` 与 `COLOR2` 都含 `yellow`）也是合法的，它们是各自类型作用域内的名字；没有指定数值时，第一个 enumerator 按 0、1、2 依次分配；一旦显式指定，后续未指定的 enumerator 就从上一个指定值继续递增，例如

```cpp
enum COLOR1 { red = -1, blue = 1, yellow };
// yellow == 2
```

这里 `yellow` 的取值是 `2`，因为它只跟随紧邻的 `blue = 1` 递增，与更早的 `red = -1` 无关。

## 程序接收命令行参数

到目前为止程序都是无参数运行的，写法是 `./program`。但程序可以接收参数，Linux 上很多命令本身就是程序：`diff file1 file2`、`rm file` 等。以 `diff file1 file2` 为例，第一个词 `diff` 是要运行的程序名，后面两个词是传给它的参数，参数像函数的实参一样被传给程序——收集参数并交给被执行的程序，是 operating system 的工作。

参数通过 `main()` 函数的参数列表传入：

```cpp
int main(int argc, char *argv[])
```

`argc` 是数组中的字符串个数，名字取自 "argument count"。每个参数都只是一串字符，所有参数（包括程序名）构成一个 C-string 数组。`argv` 存放这个数组，因为 C-string 本身是 char 数组、可以看作指向 char 的指针，所以"C-string 的数组"就是"char 指针的数组"，写作 `char *argv[]`；名字取自 "argument vector"（argument values）。在内存中它的结构是：`argv` 指向一组指针，每个指针指向以 `\0` 结尾的字符序列。

`argv[0]` 是你输入的第一个字符串，包含正在执行的程序名以及可选路径（比如 `./`），这就是遍历参数时通常从 `i = 1` 开始的原因。

要给命令行上的数字做算术，需要把 C-string 转成整数，标准库提供了 `atoi`（需要 `#include <cstdlib>`）：

```cpp
int atoi(const char *s);
// EFFECTS: parses s as a number and returns its int value
```

一个完整例子是把所有参数求和：

```cpp
int main(int argc, char *argv[]) {
    int sum = 0;
    for (int i = 1; i < argc; i++) {
        sum += atoi(argv[i]);
    }
    cout << "sum is " << sum;
    return 0;
}
```

保存为 `sumIt.cpp` 后编译运行：

```text
$ g++ -o sumIt sumIt.cpp
$ ./sumIt 3 10 11 12 19
```

对这条命令，`argc` 等于 6（程序名 `./sumIt` 加五个参数），`argv[0]` 是 `"./sumIt"` 而不是 `"sumIt"`，输出是 `"sum is 55"`。注意课程选择题里"`argc` equals 5"、"`argv[0]` equals `sumIt`"这两种说法都忽略了程序名本身也占一个位置、且带 `./` 前缀，属于容易踩的细节。同理，如果要写一个对命令行浮点数求和的程序，结构完全相同，只需把解析函数换成 `atof`。

参考材料：Absolute C++, 4th Edition, Page 373（Command-Line Arguments）。

## I/O streams 概览

计算机系统中处理输入输出的一个流行模型以 stream 为中心。<span class="red">stream 就是一段数据序列，一端提供放入数据的函数，另一端提供取出数据的函数</span>。典型 stream 有六种方向组合：键盘→程序、程序→显示器、文件→程序、程序→文件、string→程序、程序→string。

C++ 的 stream 是 unidirectional 的，数据只沿一个方向通过。因此如果既要读又要写同一个文件或设备，就需要两个 stream。

stream 数据一般分两类：character 与 binary。字符数据常用于程序与键盘/屏幕之间的通信，以及读写文件；文件里也可以存放任意 binary data，它通常比字符表示高效得多，但难以理解和调试。这里讨论的是 character stream。

## Output stream: cout

```cpp
cout << "Hello, world!\n";
```

输出到屏幕。`<<` 称为 insertion operator，把东西插入 output stream；它知道如何把所有其他标准数据类型先转成字符再插入。`int foo = 42; cout << foo << endl;` 就是这条转换规则的直接体现。插入可以级联：`cout << foo << " " << bar << endl;`。

要用固定列宽打印，用 `setw()` manipulator：

```cpp
cout << foo << setw(4) << bar << endl;
```

`setw()` 设定紧随其后的那个数值占多少个位置，并在该列宽内右对齐，不足处用空格填充；使用它需要 `#include <iomanip>`。

除了 cout，还可以用 Linux 的 I/O redirection 把这个 stream 的输出端从屏幕移到文件：`$ ./hello > foo` 把 cout 的输出端接到文件 `foo`。iostream 库还定义了另一个 output stream 对象 `cerr`，它与 cout 在多数方面相同（默认输出也是屏幕），按惯例程序用它输出错误信息。

### 输出缓冲

C++ 的 I/O 是 buffered 的：插入 output stream 的内容先被底层 operating system 保存在一块称为 buffer 的内存区域里，只有发生特定动作时才真正写到输出端。触发写出的情形有：向 stream 插入换行（`endl` 或 `'\n'`）、显式 flush（`cout << "ok" << flush;`）、buffer 变满、程序决定从 cin 读取、程序退出。一旦 buffer 内容被写出，buffer 就被清空；如果有些内容没有打印出来，它可能仍然留在 buffer 里。作为对照，送到 `cerr` 的输出不做缓冲。

## Input stream: cin

```cpp
cin >> foo;
```

从键盘读入。`>>` 称为 extraction operator，从 input stream 中提取内容，并知道如何把你输入的字符转换成简单类型与 string 的值。

一个关键行为是 `>>` 按空白分隔。给定输入 `42 3.14 four score\n` 与

```cpp
int foo; double bar; string baz;
cin >> foo >> bar >> baz;
```

结果是 `foo` 得到 `42`（不是字符串 `"42"`）、`bar` 得到 `3.14`（不是 `3`）、`baz` 只得到 `"four"`，因为 `>>` 读到空白就停止。

### getline() 与 get()

如果字符串本身要包含空格或 tab，用 `getline()`：

```cpp
cin >> foo >> bar;
getline(cin, baz);
```

`getline()` 读入直到（但不包括）下一个换行符的所有字符放进 string，然后丢弃换行符。不过在上面这个例子里 `baz` 得到的是 `" four score"`——因为 `>>` 读 `3.14` 时停留在它后面的空格之前，`getline()` 从这个空格开始读，所以保留了前导空格。

`get()` 读单个字符，空白和换行都读：

```cpp
char ch;
cin.get(ch);
```

把两者组合就能得到想要的结果：`cin >> foo >> bar;` 之后先 `cin.get(ch);` 吃掉那个残留空格，再 `getline(cin, baz);`，此时 `baz` 才是 `"four score"`。这三种读法的语法差别很大，但它们可以自由混用在同一段输入代码里。

### 输入缓冲

cin 和 cout 一样是 buffered 的：你输入的字符先存进 buffer，直到按下 enter 键，这些字符才作为一个整体提供给程序。缓冲一方面提高效率，另一方面让你在程序看到输入之前还有机会回头改正打错的内容。

想把输入端从键盘换成文件，同样用 Linux 的 I/O redirection：`$ prog < foo`。此时要记得输入不会出现在屏幕上（因为不是从键盘敲的），输出里看不到回显，看起来会有点怪。

### 失败的输入

extraction operator 遇到不合适的数据会失败。若 `int foo; cin >> foo;` 遇到 `42abc\n`，转换会在 `a` 处停止，`foo = 42`，stream 里剩下 `"abc\n"`。若遇到根本不以数字开头的内容如 `abc`，stream 会进入 failed state。

可以像使用 `bool` 一样检验 stream 的状态：`if (cin) { ... }` 或 `while (cin) { ... }`，状态良好返回 `true`，否则返回 `false`。要注意的是，<span class="red">处于 failed state 的 input stream 会拒绝之后所有继续提取数据的尝试</span>——它不是"这一项读失败、下一项继续"，而是整个 stream 卡住，这也是后面写读循环时必须先检查状态的原因。

参考材料：C++ Primer (4th Edition) Chapter 8。
