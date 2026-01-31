# 5 Model Construction for Task 3: Water Supply Sustainability & Logistics Integration

## 5.1 框架概述：水资源动态平衡系统

在殖民地达到 10 万人规模并进入稳定运营期（$t \ge t_{occ}$）后，水资源的保障成为生命维持的关键。根据 Task 2 的风险评估及新获取的 ISRU 技术参数，我们建立一个**运输-生产-库存耦合模型（Transport-Production-Inventory Coupled Model）**。

本模型旨在以最小化全生命周期成本（LCC）为目标，确定最优的补给策略、ISRU 建设规模以及库存水平。

## 5.2 子模型 I：净需水量估算 (Net Makeup Water Estimation)

在闭环环境控制与生命保障系统（ECLSS）中，总用水需求并非补给需求。补给需求取决于系统的循环效率。

### 5.2.1 循环损耗机制

设人均日系统吞吐量为 $q_{th}$（含饮用、卫生、制氧电解等），系统水回收效率为 $\eta_w$。则 10 万人口在第 $t$ 年的总补给需求 $D_{req}(t)$ 为：

$$D_{req}(t) = \frac{365 \cdot P \cdot q_{th} \cdot (1 - \eta_w)}{1000} + \epsilon_{loss}$$

其中 $\epsilon_{loss}$ 代表EVA活动、气闸泄漏及工业过程中的不可回收损耗。依据 2050 年技术预期，取 $\eta_w = 0.98$ 。

## 5.3 子模型 II：多源供给与库存动力学

### 5.3.1 供给来源

水的来源分为两部分：

1. **地球补给 ($m_{trans, t}$)**：通过太空电梯或火箭运输。
    
2. **原位资源利用 ($m_{ISRU, t}$)**：利用月球极地水冰生产。
    

### 5.3.2 库存状态方程
假设入住后首年各月需求均匀分布，即 $D_{req, k} = D_{req}(t_{occ}) / 12$。
将入住后的第一年细分为月度时间步 $k \in \{1, \dots, 12\}$。库存水平 $I_k$ 的演变遵循质量守恒：

$$I_{k+1} = I_k + m_{trans, k} + m_{ISRU, k} - D_{req, k}$$

### 5.3.3 安全库存约束 (Strategy B: Pre-stocking)

根据 **Strategy B（提前储备策略）**，我们需要在入住前利用剩余运力建立初始库存。库存约束如下：

1. **安全底线**：库存必须高于由 Task 2 确定的最小安全水位 $I_{min}$。
    
    $$I_k \ge I_{min}, \quad \forall k$$
    
2. **提前屯水**：初始库存 $I_0$ 来自建设期（$t_0$ 到 $t_{occ}-1$）的积累。
    
    $$I_0 = \sum_{t=t_0}^{t_{occ}-1} x_{pre, t}$$
    

> **[Insert Figure 7: Schematic of Inventory Flows and Buffer Logic]**
> 
> _(注：此处插入示意图。展示 Earth Inflow 和 ISRU Inflow 同时注入 Storage Tank，从中流出 Consumption。并在时间轴左侧展示建设期的 Pre-stocking 积累过程)_

## 5.4 成本模型与目标函数 (基于 ISRU 新参数修正)

Task 3 的目标是计算相比于纯干货运输的**额外成本 ($\Delta Cost$)**。

### 5.4.1 储水设施 CAPEX (Storage Construction)

根据文献评估，大规模柔性储罐成本约为 $300/$m^3$ ，刚性罐为 $800/$m^3$ 。建设成本取决于**最大库存峰值**：

$$V_{max} = \max_{k} (I_k)$$

$$C_{store} = c_{tank} \cdot V_{max}$$

### 5.4.2 ISRU 成本模型 (基于能耗与功率约束)

根据文献 ，ISRU 的经济性由**单位能耗 ($SEC$)** 和 **功率基础设施建设** 决定。

**1. 能源与设施建设成本 (Capacity CAPEX):** 生产水需要消耗电力（$SEC = 3.0 \text{ kWh/kg}$ ）。系统建设成本并非取决于总产量，而是取决于**设计产能（即峰值月产量）**，因为这决定了需要部署多少兆瓦（MW）的发电设施（核堆或太阳能阵列）以及挖掘机群规模。

设 $K_{ISRU}$ (tons/month) 为规划的 ISRU 系统最大月产能（决策变量），则建设成本为：

$$C_{ISRU}^{cap} = c_{infra} \cdot K_{ISRU}$$

其中 $c_{infra}$ 为构建每吨/月产能所需的硬件与能源设施成本。

_约束条件_：每月实际产量不能超过设计产能。

$$m_{ISRU, k} \le K_{ISRU}, \quad \forall k$$

**2. 运营能耗成本 (Variable OPEX):** 运营成本与实际产量成正比，主要包含设备磨损、耗材和废料处理。文献指出每生产 1 吨水产生约 17 吨废渣 ，这增加了机械磨损。

$$C_{ISRU}^{op} = c_{var} \cdot \sum_{k=1}^{12} m_{ISRU, k}$$

**3. ISRU 总成本:**

$$C_{ISRU} = C_{ISRU}^{cap} + C_{ISRU}^{op}$$

### 5.4.3 运输与持有成本 (Logistics & Holding)

文献强调水资源的**持有成本极高**（含资本占用、维护、温控），约为 $1,500/ton/year 。这意味着过早的大规模屯水在经济上是不划算的。

$$C_{logistics} = \sum_{t} c_{trans}(t) \cdot (m_{trans, t} + x_{pre, t}) + \sum_{k} h \cdot I_k$$

其中 $h \approx 125 \text{ USD/ton/month}$。这一高昂参数将与 Strategy B 形成博弈，引导模型寻找“即时生产 (JIT)”与“提前屯水”的最佳平衡点。

### 5.4.4 总优化目标

$$\min \Delta Cost = C_{store} + C_{ISRU} + C_{logistics}$$

## 5.5 模型整合与求解

将上述模块并入 Task 1 的 MILP 框架：

- **决策变量**：
    
    - $x_{pre, t}$: 入住前每年的预运水量。
        
    - $K_{ISRU}$: ISRU 系统的建设规模（产能上限）。
        
    - $m_{ISRU, k}$: 入住后每月的实际开采量。
        
    - $m_{trans, k}$: 入住后每月的地球补给量。
        
- **关键参数输入**：
    
    - $SEC = 3.0$ kWh/kg 。
        
    - $\eta_{capture} = 0.70$ 。
        
    - $c_{tank} \in [300, 800]$ USD/$m^3$ 。
        

通过求解，我们将得到：在满足安全库存 $I_{min}$ 的前提下，是否应该建设 ISRU？如果建，规模 $K_{ISRU}$ 是多少？提前屯水应该从哪一年开始？

---

# 符号定义表 (Symbol Definition for Task 3)

以下表格整理了 Task 3 水资源模型中新引入及基于文献更新的符号。

|**Symbol**|**Definition**|**Unit**|**Description**|
|---|---|---|---|
|**Parameters**||||
|$q_{th}$|Throughput Rate|L/person/day|System circulation: ~50 L/day.|
|$\eta_w$|Recovery Efficiency|% (0-1)|ECLSS efficiency: 0.98 for 2050 baseline.|
|$SEC$|Specific Energy Consumption|kWh/kg|Total energy to produce 1 kg water: 3.0.|
|$\eta_{capture}$|Capture Efficiency|%|ISRU capture rate: 0.70.|
|$c_{tank}$|Storage CAPEX|USD/$m^3$|Cost of tanks: 300 (flexible) - 800 (rigid).|
|$c_{infra}$|ISRU Capacity Cost|USD/(t/mo)|Capital cost for power/rigs per unit capacity.|
|$c_{var}$|ISRU Variable Cost|USD/ton|O&M cost including tailings handling (~17t waste/t water).|
|$h$|Holding Cost|USD/ton/mo|Inventory cost: ~125 (derived from 1500/yr).|
|$I_{min}$|Safety Stock|tons|Minimum buffer determined by Task 2 risk analysis.|
|**Decision Variables**||||
|$K_{ISRU}$|ISRU Capacity|tons/month|**Design capacity** of the ISRU plant (determines CAPEX).|
|$m_{ISRU, k}$|Monthly Extraction|tons/month|Actual production (must be $\le K_{ISRU}$).|
|$m_{trans, k}$|Monthly Transport|tons/month|Water shipped from Earth during operations.|
|$x_{pre, t}$|Pre-stocking Amount|tons/year|Water shipped _before_ occupation (Strategy B).|
|**State Variables**||||
|$I_k$|Inventory Level|tons|Water stock level at month $k$.|
|$V_{max}$|Max Storage Vol|$m^3$|Required peak volume of storage tanks.|
|$\Delta Cost$|Extra Cost|USD|Total cost for water system (CAPEX + OPEX).|