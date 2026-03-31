### 1. I/O 流核心模型
 **单向性 (Unidirectional)**：C++ 中的流是单向的。如果需要对同一个文件进行读和写，必须分别建立两个流对象。
* **数据分类**：
    * **字符流 (Character)**：用于键盘/屏幕交互、读写文本文件，易于调试。
    * **二进制流 (Binary)**：存储效率高，但不易直接阅读和调试。

---

### 2. 标准输出流 (cout & cerr)
* **插入运算符 `<<`**：自动将各种标准数据类型转换为字符序列。
* **格式控制**：使用 `setw(n)` 设置字段宽度（需包含 `<iomanip>`），默认**右对齐**并补空格。
* **重定向**：在 Linux 环境下，可以使用 `./prog > foo` 将 `cout` 的输出从屏幕转向文件。
* **cerr (标准错误流)**：
    * 专门用于输出错误信息。
    * **核心区别**：`cout` 是**有缓冲的 (Buffered)**，而 `cerr` **没有缓冲**，确保程序崩溃前错误信息能即时显示。
**示例代码：**
```cpp
#include <iostream>
#include <iomanip>
using namespace std;

int main(int argc, char *argv[]) {
        for (int i = 1; i < argc; i++) {
                cout << right << setw(8) << argv[i] << endl;
                cout << left << setw(8) << argv[i] << endl;
        }
        return 0;
}
```
输出示例：
```shell
tim_yufeng@DESKTOP-TP5O3R6:~/280practice$ ./program Universe is so we are
Universe
Universe
      is
is
      so
so
      we
we
     are
are
```


3. 标准输入流 (cin)
* **提取运算符 `>>`**：从输入流中提取数据，遇到**空白字符**（空格、制表符、换行）会停止。
* **getline(cin, str)**：读取整行，包括空格，直到遇到换行符为止。换行符会被读取并丢弃。
* **cin.get(ch)**：读取**单个**字符，包括空格和换行符。常用于处理 `>>` 留下的残留空格。
* **输入缓冲**：输入的字符先存入缓冲区，直到按下 **Enter** 键，程序才开始批量读取。这允许用户在确认前通过退格键修正错误。
* **失败状态**：如果提取的数据类型不匹配（例如期望 `int` 却输入了 `abc`），流会进入 **Failed State**。此时：
    * 可以使用 `if(cin)` 或 `while(cin)` 检查流是否健康。
    * 一旦失败，流将拒绝执行后续的所有提取操作。

---

### 4. 文件流 (File Streams)
* **头文件**：`#include <fstream>`。
* **对象声明**：`ifstream`（输入）、`ofstream`（输出）。
* **文件操作步骤**：
    1.  **打开 (Open)**：`iFile.open("filename")`。在 C++98 中必须传 C 风格字符串（`.c_str()`），C++11 及以后支持 C++ `string`。
    2.  **读写**：用法与 `cin`/`cout` 完全一致。
    3.  **关闭 (Close)**：`iFile.close()`。
* **关闭的重要性**：减少文件损坏风险；确保数据从缓冲区完全写入磁盘；以便后续程序重新读取该文件。
* **安全读取技巧**：
    * 错误示例：`
    * 正确示例：**`while(getline(iFile, line))`**。将读取操作作为循环条件，利用其返回值判断是否到达文件末尾。

---
### 5. 字符串流 (String Streams)
* **头文件**：`#include <sstream>`。
* **用途**：实现字符串与其他数据类型的**内存中转换**。
* **istringstream (输入)**：从字符串中提取数据。
    * 例子：将一行包含 "42 3.14" 的字符串拆分为一个 `int` 和一个 `double`。
* **ostringstream (输出)**：将数据格式化写入字符串。
    * 用法：通过 `<<` 插入数据，最后调用 **`.str()`** 获取最终拼接成的字符串。
具体用法见：[[stringstream]]
---

### 易错点与避坑指南
* **残留字符**：`cin >> val;` 之后如果立刻接 `getline()`，会读到 `val` 后面的换行符导致结果为空。此时需先用 `cin.get()` 消耗掉换行符。
* **Failed State 陷阱**旦文件打开失败或输入格式错误，象会一直处于 False 状态。在重新使用前，通常需要手动重置（尽管本课件未深入此点）。**缓冲延迟**：调试程序时，如果 `cout` 的内容没出来，可能只是还待在缓冲区里。可以尝试添加 `endl` 或 `flush` 强制刷新
