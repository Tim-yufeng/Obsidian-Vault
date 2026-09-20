# L3 Embedded Programming

*ECE/VE 373 · Dr. An Zou · 2026*

这节课是编程课：先看语言分层和工具链，再看 C 在嵌入式里为什么这么用（const/volatile、按位访问），最后落到 super loop 那套骨架。
## 语言分层与工具链

课件把语言按层摆：application 层是 C/C++、Python、Java；system software 层（RTOS）用 C/C++；最底下 hardware 层是汇编和机器码。

同一句 `a = b + c` 在四层里的样子：Python 一行；C 要先声明类型；汇编四条（lw、lw、add、sw）；到机器码就是 `0x00010002` 这种。

两个 key difference：汇编知道自己用的是哪块具体硬件（所以不通用）；C 的可移植性更好；此外 C 相比 Python 还有一个优势，就是通过 C 代码可以直接估计出使用的总内存，而Python做不到 —— 嵌入式内存就那么点，能不能算清楚占用是硬指标。

![[Pasted image 20260916224036.png]]

这张图是整条工具链：`my_C.c` 先过 compiler 变 `my_C.s`，再过 assembler 变 `my_C.o`，最后由 linker 拼上 linker script、其他 `.o` 和库，产出 `my_proj.elf`，formatter 再转成目标机的机器码（`.hex`/`.abs`/`.exe`）。`.S` 汇编文件从 assembler 那一步直接进。

compiler 的好坏，课件用一个例子说明：算 `a=b+c`，好 compiler 四条指令，差的会多一条没用的 `mov Rb Rc`。

## 汇编：语法和 directive

PIC32 汇编一行是 `label: mnemonic operands #comment`，以 directive 开头的是另一类行。

directive 是给 assembler 的指令，不会变成可执行代码。常用的有：`.text`/`.data`/`.bss` 分节；`.ascii`/`.byte`/`.int`/`.long` 初始化常量；`.global` 让符号对其他模块可见；`.equ` 定义符号；`.if`/`.endif` 条件汇编；`.include`（和 `#include` 不是一回事）；`.ent`/`.end`。

课件还给了两张 PIC32 汇编速查卡（指令和格式），以后真要写汇编就从那里查。

## C 为什么适合嵌入式

C 是 1970 年代从 B 语言长出来的，和 UNIX 关系很近，作者是 Dennis Ritchie，本来就是为系统编程（OS、工具、compiler）设计的。

为了省内存，C 有几个特点：所有东西都要先声明；函数不能嵌套；指针可以直接访问内存（很强，也很危险）；可以按位访问。最后这条被框起来了 —— 操作硬件离不开按位读写寄存器。

标准只要记两个：C89（第一个标准）和 C99（最新，但它不是 C++）。

## 类型、变量与作用域

C 的组成：types/variables（数据在内存里的定义）、expressions、statements、functions。

C89 基本类型五个：char、int、float、double、void；C99 加了 `_Bool` 和 `_Complex`；嵌入式编译器还会自己定义 bit、SFR 这类类型。修饰符是 signed/unsigned/long/short。

![[Pasted image 20260916225641.png]]

这张表是各类型的典型位宽和范围。

变量按声明位置分：函数内的是局部变量（放 stack），函数外的是全局变量（固定区域，初值 0），还有参数里的。C89 要求局部变量声明在函数开头（C99 不要求）；在块 `{}` 里声明的只在本块有效，内层同名变量会把外层藏起来。

![[Pasted image 20260916224036-02.png]]

全局变量这页留了个问题：func1 和 func2 放在不同文件里怎么办？课件答案写 `static int count`。页面批注把 `int count; /* count is global */` 划了线，旁边写着：effective among this file；Add a "static", then effective all the project (across files)。

（按标准 C 补一句：跨文件共享全局变量一般是靠 extern 声明，`static` 的作用恰好相反——把可见范围限制在本文件。课件这一页的答案先按课上记着，自己写代码时按 extern 那套来。）

## const 与 volatile

![[Pasted image 20260916230103.png]]

const：不允许被 C 程序修改，但可以被硬件or汇编语言修改；同时也等于请求把它放进 ROM（程序存储器），这在嵌入式里是好习惯，因为 RAM 更紧张。

volatile：这个值可能被程序以外的东西改掉，所以每次用到都要重新去读，不能一直用寄存器里的旧值。下面两种写法取其一：

```c
int a;           a = 5;  a = 7;   /* 编译器可能把 a = 5 优化掉 */

volatile int a;  a = 5;  a = 7;   /* 加了 volatile，两次写都保留 */
```

课件还有个更直观的例子：用 `__asm` 从汇编改内存里的 i，不加 volatile 打印出 10（读的是寄存器里的旧值），加了就打印 32。

那么 const 和 volatile 一起出现是什么意思？对于那些可能被程序以外因素一直修改，但是绝对不允许程序去修改的变量，比如时间，就需要 const 和 volatile 一起约束；const 只管住"这个程序不改"，管不了硬件；volatile 负责每次用都重新读内存。

![[Pasted image 20260916224036-04.png]]

<span class="red">一句话区分：const 管的是"程序只能读"，volatile 管的是"每次都得重新读"。</span> （za甚至提了一嘴，这个点是嵌入式岗位面试的高频问题，因为只有和硬件打交道的嵌入式开发者的代码需要直面区分 const 和 volatile 的问题）
## PIC32 的 compiler 与寄存器访问

compiler 是 MPLAB C32 / HI-TECH C32，除了标准 C，还带一批自己的 directive：`#pragma`、`#define`、`#include`。

`#pragma` 三种：`interrupt func_name ipln` 把函数标成中断处理函数（ipl 0–7）；`vector func_name vec_num` 在指定异常向量处生成一条跳转；`config` 设置配置位（振荡器选择、PLL 倍频、看门狗这些）。

头文件分两级：`#include <P32xxxx.h>` 是通用入口，会自动挑具体芯片的头文件，并把 SFR、CP0 寄存器定义成常规名字；`<P32mx795f512l.h>` 才是具体芯片的，里面连每个 SFR 的单个 bit 都定义好了。

有了这层定义，就能直接按位点寄存器：

```c
PORTAbits.RA0 = 1;   /* PORTA 的 bit0 拉高 */
PORTAbits.RA1 = 0;   /* PORTA 的 bit1 拉低 */
WDTCONbits.ON = 1;   /* 打开 watchdog timer */
```

## 语言怎么选

课件的标准是：要够高层才扛得住复杂度；又要能直接碰硬件（某些内存地址）；要省，因为嵌入式资源少、还有实时要求；库要能复用和伸缩（普通库是帮忙也可能是累赘）；要好懂、用的人多；目标平台上得真能用。

- 汇编：代码可以最省、没有额外开销；但开发慢、几乎不可移植、难调试，assembler 也不做优化。
- C/C++：小心写就足够高效、有一定可移植性、好 compiler 多。
- Java：更可移植，但完整 Java 很吃 RAM、对实时不友好，很多嵌入式平台干脆没有。
- C 还是 C++/Java？课件结论是一般选 C：OOP 的高级特性容易把代码搞大，虚函数和多态会明显拖慢启动，实时性也难保证。

## 例程：从点灯到 super loop

第一个例程是让 PORTA 的 pin0–7 闪：

```c
#include <p32xxxx.h>

main()
{
    DDPCONbits.JTAGEN = 0;  /* 关掉 JTAG 口 */
    TRISA = 0xff00;         /* PORTA 的 pin0..7 当作输出 */

    while (1)
    {
        PORTA = 0xff;       /* pin0-7 全亮 */
        PORTA = 0;          /* 全灭 */
    }
}
```

课件在这一页留了个问题 "What will the hardware do?" —— 因为没有延时，两次赋值只隔几个时钟，肉眼基本看不出闪（真要看闪烁得加一个延时循环）。

嵌入式程序的结构就是反应式：读传感器 → 算 → 写到执行器，无限重复。最小骨架是 init 一次，然后 while(1) 里反复干活：

```c
void X_Init(void);
void X(void);

void main()
{
    X_Init();      /* 先准备 */
    while (1)      /* 所谓 super loop */
    {
        X();       /* 一直干 */
    }
}
```

super loop 为什么重要：嵌入式没有 OS 可以返回，程序必须一直活着。好处是简单、省资源、可移植；毛病是没接硬件 timer 时时间不好预测，而且 CPU 一直醒着费电。

对比着看，高级嵌入式系统是 user program 跑在 OS 上面，简单嵌入式系统就是 `main()` 里一个 while 循环直接对着硬件。
