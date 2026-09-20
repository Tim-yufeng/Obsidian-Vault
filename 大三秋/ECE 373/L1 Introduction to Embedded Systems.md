
这一讲没有电路推导也没有代码，它的任务是把整门课要用的词汇、器件层级和系统视角先钉住。其中真正需要在这里辨析清楚的是 microprocessor、microcontroller 与 SoC 三个词：日常语境里它们经常被混用，但区分的依据并不在名字里。

## Computer Organization：先钉住硬件词汇

课件的起点是一张 computer organization 方块图。计算机是 hardware 与 software 的组合，硬件侧被拆成 processor、memory 与 I/O units 三块，用一条 common bus（address、data、control）连起来。

![[Pasted image 20260914192737.png]]

processor 内部按职责分成两半：control unit 发出控制信号、决定下一步做什么；datapath 承担实际的数据搬运和运算，其中装着 arithmetic logic unit (ALU) 与 registers。memory 里 program storage 与 data storage 是并排的两块（属于Harvard 结构）。片外的世界全部通过 I/O units 进出，I/O 与 bus 之间通常还有一个 I/O controller（interface）做适配。

课件在 Key Components 那几页把 processor 的实现形态直接写成 uProcessor 与 uController，（分别代表微处理器和微控制器，$u=\mu=\text{micro}$），并列出了 registers、ALU、control unit、program counter (PC) 和 status register。PC 保存下一条要执行指令的地址，status register 用标志位记录上一条指令的执行结果。三根 bus 的分工是固定的：address bus 送设备编号与片内位置，data bus 送数据值，control bus 送控制信号。

## Microprocessor 与 Microcontroller：差别在片上集成了什么

课件对两个词的定义是并排给出的。microprocessor (MPU) 指用 very large scale integration (VLSI) 实现在一块芯片上的 processor，要构成产品还必须在片外接上 peripheral chips；microcontroller (MCU) 把 processor 与 peripheral functions 一起实现在一块 VLSI 芯片上。

![[Pasted image 20260914192737-01.png]]

图上的差别很直白：左侧只有 CPU 是芯片，RAM、ROM、I/O、Timer、Serial Port 各自独立地挂在 data bus 与 address bus 上；右侧 CPU、RAM、ROM、I/O、Timer、Serial Port 全部收进同一个方块。课件还配了 microprocessor 的 die 照片和一张母板照片——北桥、南桥、DRAM 插槽、PCI 插槽都在芯片之外——用来坐实 “peripheral chips are needed to construct a product”这句话。

<span class="red">两者的区分判据是单芯片内集成了什么，而不是运算能力、字长或指令集。</span> 顺着这个判据往下推，就能理解课件那张逐条对照表为什么写成那样。

![[Pasted image 20260914192737-02.png]]

表的前几行是定义的直接推论：存储器与 I/O 在片外，电路板就变大、整个系统成本变高、每次访存都要走片外操作所以更慢、功耗也更高；把它们收进片内，就得到紧凑、便宜、低功耗、内部操作更快的形态。后面几行给的是存储器组织、寄存器数量和应用场合上的差别。

<span class="blue"> 这张表要分两层读。属于定义或定义直接推论的是前几行；而“microprocessor 大多没有低功耗模式”“microcontroller 寄存器更多”“一个是 von Neumann、一个是 Harvard”描述的是当年典型产品的常见做法，不是定义的必然——低功耗模式在今天的处理器上早已普遍，指令通路与数据通路是否分开（包括只在 cache 层分开）也更多是设计取舍。这份对照表沿用的是较早期的教学材料，把它当成“MCU 一定如此”的判据，会在读现代芯片时出错。表中 MCU 一侧的 “external processor” 是笔误，原意应为 internal。 </span>


## SoC：把“单芯片”里塞进更多东西

如果判据是芯片里集成了什么，下一个问题自然是还能集成多少。课件把这条路线的新一代称为 system on chip (SoC)，并把 MCU 与 SoC 的差别整理成九条对照：

| 对比维度   | Microcontroller (MCU) | SoC                                        |
| ------ | --------------------- | ------------------------------------------ |
| 片上集成   | 单芯片，集成较少、较通用的外设       | 单芯片，集成更多、更专用的外设                            |
| 设计目标   | 把成本压到最低               | 把功能做到最大                                    |
| 成本     | 低                     | 高                                          |
| 功耗     | 低                     | 取决于具体应用                                    |
| 操作系统   | 课件口径：MCU 上没有 OS       | 可以是 MPU-based 或 MCU-based；有 OS 时更可能是精简的 OS |
| 片上存储器  | 常在 KB 量级，有时到低 MB      | 常在 MB 到 GB 量级                              |
| 典型外部存储 | KB 到 MB，Flash、EEPROM  | MB 到 TB，Flash、SSD、HDD                      |

![[Pasted image 20260914192737-03.png]]

插图上这块标为 System-on-Chip 的芯片，片内标出的是 ARM Cortex-M3 内核、8–64 KB SRAM、32–256 KB Flash，典型 microcontroller 量级；而表格给 SoC 的存储数字是 MB 到 GB。两者并不冲突，只是同一个词在不同集成规模上的用法。<span class="green">SoC 描述的是集成度这个维度——一个系统的主要部分被放进了单芯片；至于这个系统的算力和存储落在 MCU 量级还是应用处理器量级，是另一个维度的问题。</span>课件在 SoC 一栏里专门写了 “SOCs can be MPU or MCU based”，说的正是这件事。表中“MCU 上没有 OS”指的是典型裸机用法；在 MCU 上跑 FreeRTOS 一类实时内核在今天是常规做法，这一条同样是典型形态而不是能力边界。

于是三个词的判断顺序是：芯片内没有片上存储与常用外设、必须外挂 RAM/ROM 才能运行程序的是 microprocessor；单芯片即可构成最小系统（片上 Flash/SRAM 加 GPIO、timer、串口一类外设）的是 microcontroller；片上还集成 GPU、DSP、无线基带或多个处理核这类专用子系统的，就落在 SoC 的范围里，而它的核心既可以是 MPU 也可以是 MCU。

## 嵌入式系统的应用范围

课件用一页列领域、用六页举具体产品。领域那一页的收尾是 “Almost or to be anywhere”，列出的方向是：

- Automotive：automatic ignition、cruise、ABS
- Consumer electronics：电视、家电、玩具、手机、相机
- Industrial control：机器人、控制系统
- Medical：infusion pump、dialysis machine、prosthetic device、cardiac monitor
- Networking：router、hub
- Office automation：传真机、复印机、打印机、扫描仪

更有信息量的是后面六页产品，它们把“嵌入式”从领域名落成了具体的器件：

- Hunter programmable digital thermostat → 4-bit microprocessor
- Vendo V-MAX 720 售货机 → 8-bit Motorola 68HC11
- Sonicare Plus 电动牙刷 → 8-bit Zilog Z8
- Miele 洗碗机 → 8-bit Motorola 68HC05
- NASA 的 Mars Sojourner Rover → 8-bit Intel 80C85
- Nintendo Wii 手柄 → 32-bit IBM Power RISC

共同的信息是：连火星车都在用 8-bit 器件，算力在这个领域通常不是主要矛盾，成本、功耗和可靠性才是。

## 为什么要用 uP + 软件

课件的答案是一组成本与灵活性的权衡：低端产品的 uP/uC 成本能压到 1 美元以下；世界在被持续数字化；现成的 uP + software 组合正在替代 ASIC；用软件实现功能灵活、能做到复杂特性，代价是速度；软件开发的成本相对低，但 FPGA 技术仍在挑战这条路线。这不是一份最优解清单，而是在成本、速度与开发周期之间挑平衡点。

## 系统结构：CPS 视角与三层划分

从外部看，嵌入式系统是嵌在物理环境中的计算：传感器把环境状态读进来，经 A/D 转换进入 peripheral；processor 与 memory 处理之后，再由 D/A 与 actuators 把结果写回环境；人通过 I/O 与 USER 交互，整个系统被包在 ENVIRONMENT 里。课件把这类系统称为 cyber-physical system (CPS)，并把它内部划成 memory、processor、peripheral 三块，其中 peripheral 负责 application-specific logic、timers、A/D 与 D/A conversion——这正是前面 MCU 与 SoC 讨论里所说的“片上外设”。

![[Pasted image 20260914192737-04.png]]

从软硬件分层看，课件把系统分成 application layer（user interface、video/audio application、data processing）、system software layer（USB、interrupt、memory management 等 drivers）与 hardware layer（processor、timer、memory）。这一页直接标出了课程分工：VE 473 更偏 software，VE 373 更偏 hardware，本课程落在 hardware layer。后面反复出现的 timer 与 memory，就是从这里第一次进入视野的。

## 技术路线与处理器家族

课件把当前实现嵌入式系统的技术路线列为四条：uP/uC-based systems、DSP processor-based systems、ASIC 与 FPGA。课程会接触到的处理器家族包括 MIPS/ARM（VE 373）、ARM（VE 473）、68K、X86、PowerPC、SuperH、SPARC，以及大量 8-bit 与 16-bit 器件；对这门课来说，值得先记住的是 MIPS/ARM 这一支。
