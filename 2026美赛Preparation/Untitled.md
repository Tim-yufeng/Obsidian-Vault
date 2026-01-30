
# 3 Model Construction for Task 1

## 3.1 框架概述：离散时间物流规划

为解决月球定居点建设的大规模物流调度问题，我们建立了一个离散时间混合整数规划模型（MILP）。项目自 $t_0 = 2050$ 年启动，规划期设为 $H$ 年（例如 50 年），时间集合记为 $\mathcal{T} = \{t_0, \dots, t_0+H\}$。

### 3.1.1 全局参数设定

项目总运输需求设定为 $M_{\text{tot}} = 10^8$ 吨。为了量化完工时间 $T$，引入二元变量 $z_t$ 表示第 $t$ 年是否处于活跃运输期：

$$T = \sum_{t \in \mathcal{T}} z_t$$

并通过约束 $z_t \ge z_{t+1}$ 保证运输期的连续性。

## 3.2 子模型 I：太空电梯系统 (SES)

太空电梯系统由三个“银河港口”组成，初始总运力为 $C_{SE,0} = 537,000$ 吨/年。

### 3.2.1 运力增长模型

SES 的年运力 $C_{SE}(t)$ 随技术成熟呈 S 型增长，我们采用 Logistic 函数描述这一过程：

$$C_{SE}(t) = \frac{K_{SE}}{1 + A e^{-r (t - t_0)}}$$

其中 $K_{SE}$ 为系统成熟期的运力上限，$r$ 为技术增长率，$A$ 为形状参数。每年的实际运输量 $m^{SE}_t$ 需满足：

$$0 \le m^{SE}_t \le C_{SE}(t), \quad \forall t \in \mathcal{T}$$

> **Table 1: Parameters for Space Elevator System**
> 
> _(在此处插入表格，列出电梯相关参数的假设值)_
> 
> | Parameter | Symbol | Value | Unit | Source/Assumption |
> 
> | :--- | :--- | :--- | :--- | :--- |
> 
> | Initial Capacity | $C_{SE,0}$ | 537,000 | tons/year | Derived from Problem |
> 
> | Max Capacity | $K_{SE}$ | 3,000,000 | tons/year | Estimated Cap based on... |
> 
> | Growth Rate | $r$ | 0.15 | - | Assumption of tech maturity |

> **Figure 1: Predicted Capacity Growth Curve of SES (2050-2100)**
> 
> _(在此处插入Python生成的Logistic曲线图：横轴年份，纵轴运力。展示运力如何随时间爬升)_

### 3.2.2 成本结构

SES 的成本包括年度固定运维费 $f_{SE}$ 和单位运输成本 $c_{SE}$。其中 $c_{SE}$ 综合了电力消耗及其他可变运维费。总成本表示为：

$$C_{SE} = \sum_{t \in \mathcal{T}} \left( f_{SE} \cdot z_t + c_{SE} \cdot m^{SE}_t \right)$$

## 3.3 子模型 II：火箭运输系统 (RTS)

### 3.3.1 载荷修正与基地参数

考虑 $i \in \mathcal{I}$ 个候选发射基地。由于地球自转速度随纬度变化，高纬度基地的有效载荷 $q_i^{\text{eff}}$ 会低于名义载荷 $q$。我们引入纬度折减系数 $\eta_i$（由纬度 $\phi_i$ 对应的速度增量损失计算得出）：

$$q_i^{\text{eff}} = \eta_i \cdot q$$

> **Table 2: Global Launch Site Specifications**
> 
> _(在此处插入10个基地的详细数据表)_
> 
> | Site ID | Location | Latitude ($\phi$) | Efficiency ($\eta_i$) | Max Launch ($L_i$) | Weather ($a_i$) |
> 
> | :--- | :--- | :--- | :--- | :--- | :--- |
> 
> | 1 | Kourou, French Guiana | 5.2° N | 1.00 | 200 | 0.95 |
> 
> | 2 | Kennedy Space Center, USA | 28.5° N | 0.92 | 180 | 0.90 |
> 
> | ... | ... | ... | ... | ... | ... |

设 $n_{i,t}$ 为年发射次数，则该基地的年运输质量 $m_{i,t}$ 满足：

$$0 \le m_{i,t} \le q_i^{\text{eff}} \cdot n_{i,t}$$

同时，受限于基础设施和天气可用率 $a_i$，年发射次数受最大容量 $L_i$ 限制。引入二元变量 $y_i$ 表示是否启用该基地：

$$n_{i,t} \le a_i L_i \cdot y_i$$

### 3.3.2 成本与学习效应

火箭运输成本随技术积累呈指数下降。设 $b$ 为成本下降速率，则第 $t$ 年的单次发射固定成本 $C^{\text{fix}}_i(t)$ 和单位质量动态成本系数 $\alpha_i(t)$ 分别为：

$$C^{\text{fix}}_i(t) = C^{\text{fix}}_{i,0} \cdot e^{-b (t - t_0)}, \qquad \alpha_i(t) = \alpha_{i,0} \cdot e^{-b (t - t_0)}$$

> **Table 3: Rocket System Economic Parameters (2050 Baseline)**
> 
> _(在此处插入火箭成本参数表)_
> 
> | Parameter | Symbol | Value | Unit | Note |
> 
> | :--- | :--- | :--- | :--- | :--- |
> 
> | Nominal Payload | $q$ | 120 | tons | Avg of 100-150 tons |
> 
> | Base Fixed Cost | $C^{fix}_{i,0}$ | 10 | $M | Per launch |
> 
> | Cost Decay Rate | $b$ | 0.02 | - | 2% reduction per year |

火箭系统总成本 $C_R$ 由发射运营成本和基地启用成本 $F_i$ 构成：

$$C_R = \sum_{t \in \mathcal{T}} \sum_{i \in \mathcal{I}} \left( C^{\text{fix}}_i(t) \cdot n_{i,t} + \alpha_i(t) \cdot m_{i,t} \right) + \sum_{i \in \mathcal{I}} F_i \cdot y_i$$

## 3.4 综合混合优化模型

### 3.4.1 目标函数

任务 1 旨在权衡总成本与完工时间，建立加权目标函数：

$$\min J = w_C \frac{C_{SE} + C_R}{C_{\text{ref}}} + w_T \frac{T}{T_{\text{ref}}}$$

其中 $C_{\text{ref}}$ 和 $T_{\text{ref}}$ 为用于无量纲化的参考值。

### 3.4.2 约束条件

1. **总需求约束**：所有年份、所有方式的运输总量必须满足建设需求。
    
    $$\sum_{t \in \mathcal{T}} \left( m^{SE}_t + \sum_{i \in \mathcal{I}} m_{i,t} \right) \ge M_{\text{tot}}$$
    
2. **完工时间关联约束**：若 $z_t=0$（项目已结束），则当年的运输量必须为 0。利用大 M 法（Big-M）：
    
    $$m^{SE}_t + \sum_{i \in \mathcal{I}} m_{i,t} \le \overline{M} \cdot z_t, \quad \forall t$$
    
3. **变量域约束**：$n_{i,t} \in \mathbb{Z}_{\ge 0}, \quad z_t, y_i \in \{0,1\}$。
    

## 3.5 Model Solution & Result Visualization

利用 Gurobi 求解器对上述 MILP 模型进行求解。我们针对三种不同场景（纯电梯、纯火箭、混合模式）进行了仿真分析。

### 3.5.1 帕累托前沿分析 (Trade-off Analysis)

通过调整权重 $w_C$ 和 $w_T$，我们获得了成本与时间的帕累托最优前沿。

> **Figure 2: Pareto Frontier of Total Cost vs. Completion Time**
> 
> _(在此处插入帕累托图：X轴为Time，Y轴为Cost。展示不同方案在成本和时间上的权衡关系)_

### 3.5.2 混合策略的运输调度

在混合模式下（Scenario 3），模型自动规划了最优的运输接力方案。

> **Figure 3: Stacked Area Chart of Annual Material Transport**
> 
> _(在此处插入堆叠面积图：X轴为年份，Y轴为年运输量，不同颜色代表电梯和火箭。展示前期火箭主导、后期电梯主导的趋势)_

> **Table 4: Optimal Results Comparison for Three Scenarios**
> 
> _(在此处插入最终结果对比表，这是第一问的核心结论)_
> 
> | Scenario | Completion Time (Years) | Total Cost ($B) | Avg Cost ($/kg) | Note |
> 
> | :--- | :--- | :--- | :--- | :--- |
> 
> | Only SES | 45 | 500 | 5 | Low cost, slow |
> 
> | Only Rocket | 15 | 8000 | 80 | Fast, expensive |
> 
> | Hybrid | 22 | 1200 | 12 | **Balanced & Recommended** |