# 5 Model Construction for Task 3: Water Supply Sustainability & Logistics Integration

## 5.1 框架概述：水资源动态平衡系统

在殖民地达到 10 万人规模并进入稳定运营期（$t \ge t_{occ}$）后，水资源的保障成为生命维持的关键。与 Task 1 的一次性建设物资不同，水资源具有**连续消耗**与**循环再生**的特性。

我们建立一个**运输-生产-库存耦合模型（Transport-Production-Inventory Coupled Model）**，旨在以最小化全生命周期成本（LCC）为目标，确定最优的补给策略与月球原位资源利用（ISRU）比例。

## 5.2 子模型 I：净需水量估算 (Net Makeup Water Estimation)

在闭环环境控制与生命保障系统（ECLSS）中，总用水需求并非补给需求。补给需求取决于系统的循环效率。

### 5.2.1 循环损耗机制

设人均日系统吞吐量为 $q_{th}$（含饮用、卫生、制氧电解等），系统水回收效率为 $\eta_w$。则 10 万人口在第 $t$ 年的总补给需求 $D_{req}(t)$ 为：

$$D_{req}(t) = 365 \cdot P \cdot q_{th} \cdot (1 - \eta_w) + \epsilon_{loss}$$

其中 $\epsilon_{loss}$ 代表EVA活动、气闸泄漏及工业过程中的不可回收损耗。

> **[Insert Table 6: ECLSS Parameters based on ISS Data]**
> 
> _(注：此处需插入表格，列出 $q_{th} \approx 50$ L/person/day, $\eta_w \approx 0.98$ 等参数来源)_

## 5.3 子模型 II：多源供给与库存动力学 (Multi-source Supply & Inventory Dynamics)

为了应对 Task 2 识别的运输中断风险，并平滑运输负荷，我们引入库存缓冲池。

### 5.3.1 供给来源

水的来源分为两部分：

1. **地球补给 ($m_{trans, t}$)**：通过太空电梯或火箭运输，占用 Task 1 的通用运力。
    
2. **原位资源利用 ($m_{ISRU, t}$)**：从月球极地永久阴影区开采并净化的水冰。
    

### 5.3.2 库存状态方程

将入住后的第一年细分为月度时间步 $k \in \{1, \dots, 12\}$。库存水平 $I_k$ 的演变遵循质量守恒：

$$I_{k+1} = I_k + m_{trans, k} + m_{ISRU, k} - D_{req, k}$$

### 5.3.3 安全库存约束 (Strategy B: Pre-stocking)

为了确保供水安全，库存量必须始终高于最低安全水位 $I_{min}$（由 Task 2 的最大中断时间决定）。同时，为了实施**Strategy B（提前储备策略）**，初始库存 $I_0$ 必须在入住前（$t < t_{occ}$）通过提前运输累积完成：

$$I_k \ge I_{min}, \quad \forall k$$

$$I_0 = \sum_{t=t_0}^{t_{occ}-1} x_{pre, t}$$

其中 $x_{pre, t}$ 为建设期内利用剩余运力提前运送的水量。

> **[Insert Figure 7: Schematic of Inventory Flows]**
> 
> _(注：此处插入示意图。左侧输入箭头：Earth Transport, ISRU；中间方框：Storage Tank (Level $I_k$)；下方流出箭头：Consumption $D_{req}$；虚线阈值：Safety Stock $I_{min}$)_

## 5.4 成本模型与目标函数

Task 3 的目标是计算相比于纯干货运输的**额外成本 ($\Delta Cost$)**。

### 5.4.1 储水设施 CAPEX (Storage Construction)

储水设施的建设成本取决于**最大库存峰值**。为了容纳 Strategy B 带来的提前储备量，必须建设足够的储罐：

$$V_{max} = \max_{k} (I_k)$$

$$C_{store} = c_{tank} \cdot V_{max}$$

其中 $c_{tank}$ 为单位容积的储罐造价（USD/$m^3$）。

### 5.4.2 ISRU 生产成本

根据假设，ISRU 的运营成本（含开采耗能、设备磨损）设定为与产量成正比的线性函数：

$$C_{ISRU} = c_{extract} \cdot \sum_{k} m_{ISRU, k}$$

### 5.4.3 运输与持有成本

$$C_{logistics} = \sum_{t} c_{trans}(t) \cdot (m_{trans, t} + x_{pre, t}) + \sum_{k} h \cdot I_k$$

- 第一项：运输费用（调用 Task 1 计算出的当年单位运价 $c_{trans}(t)$）。
    
- 第二项：**持有惩罚 (Holding Cost)**。$h$ 为极小的库存管理系数。虽然我们倾向于 Strategy B，但 $h$ 的存在防止了过早（如 2050 年）就开始运水导致的资金积压，引导模型在接近入住期时利用空闲运力。
    

### 5.4.4 总优化目标

$$\min \Delta Cost = C_{store} + C_{ISRU} + C_{logistics}$$

## 5.5 模型整合与求解逻辑

将上述模块并入 Task 1 的 MILP 框架中：

1. **运力共享**：水的运输量 ($m_{trans} + x_{pre}$) 与建设物资 ($m_{mat}$) 共同竞争年度总运力上限。
    
2. **决策变量**：
    
    - $x_{pre, t}$: 入住前每年的预运水量。
        
    - $m_{trans, k}$: 入住后每月的补给量。
        
    - $m_{ISRU, k}$: 每月的开采量。
        

通过求解该模型，我们将获得最优的**提前囤水时间表**以及**ISRU 与地球补给的最佳配比**。

---

# 符号定义表 (Symbol Definition for Task 3)

以下表格整理了 Task 3 水资源模型中新引入的符号。

|**Symbol**|**Definition**|**Unit**|**Description**|
|---|---|---|---|
|**Parameters**||||
|$q_{th}$|Throughput Rate|L/person/day|Average daily water circulation per capita.|
|$\eta_w$|Recovery Efficiency|% (0-1)|Efficiency of the ECLSS water recycling system.|
|$\epsilon_{loss}$|Unrecoverable Loss|tons/year|Water loss from EVA, leakage, and brine waste.|
|$D_{req, k}$|Net Demand|tons/month|Net external water required after recycling.|
|$I_{min}$|Safety Stock|tons|Minimum inventory buffer (derived from Task 2 risks).|
|$c_{tank}$|Storage Unit Cost|USD/$m^3$|CAPEX for constructing water storage capacity.|
|$c_{extract}$|ISRU Unit Cost|USD/ton|OPEX for extracting 1 ton of water on the Moon.|
|$h$|Holding Cost|USD/ton/month|Marginal cost for inventory maintenance.|
|**Decision Variables**||||
|$m_{trans, k}$|Monthly Transport|tons/month|Water shipped from Earth during operational phase.|
|$m_{ISRU, k}$|Monthly Extraction|tons/month|Water produced via ISRU during operational phase.|
|$x_{pre, t}$|Pre-stocking Amount|tons/year|Water shipped _before_ colony occupation (Strategy B).|
|**State Variables**||||
|$I_k$|Inventory Level|tons|Water stock level at the beginning of month $k$.|
|$V_{max}$|Max Capacity|$m^3$|Required peak volume of storage tanks.|
|$\Delta Cost$|Extra Cost|USD|Total additional cost for water sustainability.|