# L2 MCU architecture

*ECE/VE 373 · Dr. An Zou · 2026*

这一讲拿 8051 当标本，把一颗 MCU 里到底有什么拆开看，然后沿 8-bit → 16-bit → 32-bit 走到本课要用的那颗 MIPS 核。开头两页是上一讲的复习（microprocessor 与 microcontroller 的差别），这里不再重复。

## 看一颗 MCU 先问哪几件事

- 多少位：data/address bus 的宽度，4/8/16/32/64 bits
- 多快：clock frequency
- 多大容量：memory size
- 是否低功耗、可扩展性
- I/O 外设够不够，有没有其他专用功能

这一页被划线的只有第一条（总线位宽）。三个练习题也很直白：算得快不快 (speed) 看 clock frequency，算得细不细 (computation resolution) 看 data bits，装得多不多 (storage size) 看 data bits 加 memory size。

## 8051：1970 年代的标本

课件把进化线摆成 8051 8-bit → STM/PIC18 8-bit → STM/PIC24 16-bit → STM/PIC32 32-bit（本课用）。

8051 的规格：8-bit data bus；最高 12 MHz；16-bit address bus，对应 64K ROM 空间；128 bytes RAM；低电压低功耗；四个 8-bit I/O 口；64K 外部 code/data 寻址能力；两个 16-bit timer；七种中断源；一个串口。这一页划的是 “128 bytes RAM”，旁边补了一句 “64 B for data only”。

## 片内有什么

![[Pasted image 20260916222823.png]]

从框图看：片内 ROM 放 program code，片内 RAM 放数据；外面挂着 4 个 I/O 口（P0–P3）、BUS CONTROL、SERIAL PORT、两个 timer 和中断控制。CPU 内部则是 instruction register (IR)、program counter (PC)、registers、instruction decode and control unit 和 ALU —— 后面 32 位的 CPU 就是这套部件的放大版。

注意：<span class="red">程序放 ROM (Read Only Mem)，掉电不会没；变量放 RAM (Random Access Mem)，掉电就没了。</span> 

## 内存空间：两个 64K 加 256 B

![[Pasted image 20260916222823-01.png]]

8051 的内存分三块：internal RAM、external data memory、code memory (ROM)。后两块各自从 0000H 排到 FFFFH，也就是各自 64K —— **程序和数据分开寻址，这就是 Harvard**。

![[Pasted image 20260916222823-02.png]]

片上 RAM 总共 256 B，一分为二：一半是 general purpose register，给程序员放数据；另一半是 SFR (**Special Function Register**，记住他很重要的，用于 configure the MCU)。
## SFR：真正配置这颗芯片的地方

SFR 一共 21 个，地址从 80H 到 FFH，其他地址没有定义，其中一部分可以按位寻址。标题里的 SFR 被圈了起来，整句 “Very important! (It configures the microprocessor)” 被划了线。

![[Pasted image 20260916222823-03.png]]


接外部存储器时端口会换用途：P0 变成低 8 位 address/data 复用口，P2 变成高 8 位地址口；16 位地址线能访 64K；再配合 EA、PSEN、RD、WR 这几个控制信号，才能分别访问 64K 程序存储器和 64K 数据存储器。

## 8-bit 与 16-bit：同一套思路的放大版

8-bit 那一代（PIC18）：8-bit data bus，但地址总线分成 21-bit code 和 12-bit data 两条，频率到几十 MHz；外设多了并行 I/O、timer/counter、中断、IC/OC/PWM、USART、SPI 与 I²C、A/D、CAN；存储器是 SRAM (data) + flash (program)。程序与数据分开寻址，所以可以 concurrent 和 pipelined：program 32K/16K flash（21-bit 地址最多管 2M），data 1.5K SRAM，EEPROM 256 B，返回地址栈 31 word × 21 bit。

16-bit 那一代是 modified Harvard，20–40 MHz，24-bit 地址总线，最多 12 Mb program、几十 Kb data，另外塞进了 17×17 乘法器和 32×16 除法器。

## 32-bit：本课用的这颗

![[Pasted image 20260916222823-04.png]]

规格：MIPS 架构、M4K core、RISC、5 级流水线；32-bit 地址与数据总线；最高 80 MHz；32 个 32-bit general purpose register (GPR)；片上 flash 64K–512K；片上 SRAM 16K–128K；4 GB 虚拟空间；SFR 分布在 CPU 和 coprocessor0 (CP0) 里；7 组 I/O 口。

CPU 里的部件：execution unit（ALU、PC 计算、分支判断、zero/one 检测、forwarding）、乘除单元 MDU、system control coprocessor (CP0)、FMT、双内部总线接口、电源管理、EJTAG。寄存器是 32 个 GPR（r0–r31）加 3 个特殊寄存器 PC、HI、LO。

execution unit 里还有一个 shadow register file（同样 32×32-bit），专门用来减少中断/异常时的上下文切换开销。CP0 则单独管异常控制、user/kernel/debug 模式、中断基址与向量间隔、外设配置寄存器。

## 32-bit 的 memory map

物理 flash 上是 Harvard，虚拟地址层和 SRAM 上是 von Neumann，所以问 PIC32 属于哪种，答案是两者结合。4 GB 虚拟空间里同时装着 program memory、data memory、device configuration registers、SFR 和 boot code；能有 4 GB 的原因很简单 —— 地址总线是 32 位。

SFR 的名单基本就是这颗芯片的外设清单：BMX（memory 配置）、中断、timer、input capture、output compare、I²C、UART、SPI、ADC、DMA、GPIO (PORTA–PORTG)、USB、CAN、Ethernet……

<span class="green">回头对照 8051 会发现，这套结构几乎原样留到了 32 位：片上 ROM/flash 存程序、片上 RAM 存数据、SFR 负责配置、端口按需要复用成地址线。变的只是位宽、频率和 SFR 的数量。</span>
