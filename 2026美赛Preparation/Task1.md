
# 3 Model Construction for Task 1: Discrete-Time Logistics Planning

## 3.1 框架概述

为解决月球定居点建设的大规模物流调度问题，建立离散时间混合整数规划模型。

- **时间设定**：$t_0 = 2050$，规划期 $H$ 年，时间集合 $\mathcal{T} = \{t_0, \dots, t_0+H\}$。
    
- **任务总量**：$M_{\text{tot}} = 10^8$ 吨。
    
- **完工时间**：引入二元变量 $z_t$（1表示活跃运输年），则完工时间 $T = \sum z_t$。
    

## 3.2 子模型 I：太空电梯系统 (SES) 与深空转运

太空电梯系统（SES）负责将物资从地面低成本提升至高空释放点，随后由轨道转移飞行器（OTV）接力运送至月球表面。

### 3.2.1 地面提升：运力增长模型

SES 由三个银河港口组成，其运力随技术成熟度呈 S 型增长。采用 Logistic 函数描述年运力 $C_{SE}(t)$：

$$C_{SE}(t) = \frac{K_{SE}}{1 + \left(\frac{K_{SE} - C_{SE,0}}{C_{SE,0}}\right) e^{-r (t - t_0)}}$$

其中，$C_{SE,0} = 5.37 \times 10^5$ 吨，$K_{SE}$ 为峰值运力上限，$r$ 为增长率。实际提升量 $m^{SE}_t$ 需满足：

$$0 \le m^{SE}_t \le C_{SE}(t)$$

### 3.2.2 空间段：深空转运物理模型 (Physics of OTLS)

当物资被提升至离地高度 $h_{\text{apex}} = 100,000$ km 的顶点锚点（Apex Anchor）时，它随地球同步旋转。我们需要计算从此处到月球着陆的速度增量（$\Delta v$）预算。

**1. 初始状态计算**

- **释放半径**：$r_{\text{rel}} = R_E + h_{\text{apex}} \approx 6,378 + 100,000 = 106,378 \text{ km}$。
    
- **地球自转角速度**：$\omega_E = 7.292 \times 10^{-5} \text{ rad/s}$。
    
- **释放初速度（切向）**：
    
    $$v_{\text{init}} = \omega_E \cdot r_{\text{rel}} \approx 7.292 \times 10^{-5} \times 1.064 \times 10^8 \approx 7,757 \text{ m/s} = 7.76 \text{ km/s}$$
    

**2. 速度增量 ($\Delta v$) 预算**

- **阶段一：地月转移 (TLI)**
    
    在此高度，地球的局部逃逸速度为 $v_{\text{esc}} = \sqrt{2\mu_E / r_{\text{rel}}} \approx 2.74 \text{ km/s}$。
    
    由于 $v_{\text{init}} (7.76) \gg v_{\text{esc}} (2.74)$，物体被释放时已具备极高的双曲线逃逸速度，无需火箭点火即可飞向月球（需精准控制释放相位）。
    
    因此，TLI 阶段仅需微小的轨道修正（MCC）：
    
    $$\Delta v_{\text{TLI}} \approx 50 \text{ m/s} = 0.05 \text{ km/s}$$
    
- **阶段二：月球轨道捕获 (LOI)**
    
    由于到达月球时相对速度较快，需要较大的制动速度来被月球引力捕获进入低月球轨道（LLO）：
    
    $$\Delta v_{\text{LOI}} \approx 0.85 \text{ km/s}$$
    
- **阶段三：动力下降与着陆 (Landing)**
    
    从低月球轨道下降至月面的理论霍曼转移 $\Delta v$ 加上重力损耗（Gravity Loss）：
    
    $$\Delta v_{\text{land}} \approx 1.90 \text{ km/s}$$
    
- **总速度增量**：
    
    $$\Delta v_{\text{tot}} = \Delta v_{\text{TLI}} + \Delta v_{\text{LOI}} + \Delta v_{\text{land}} \approx 2.80 \text{ km/s}$$
    

**3. 推进剂消耗与能耗**

假设使用高比冲推进系统（如核热推进或先进氢氧），比冲设为 $I_{sp}$。根据齐奥尔科夫斯基公式，运送质量 $m^{SE}_t$ 所需的推进剂质量 $M^{\text{prop}}_t$ 为：

设结构系数 $\sigma$（干重比），质量比 $\Lambda = \exp\left(\frac{\Delta v_{\text{tot}}}{I_{sp} g_0}\right)$，则：

$$M^{\text{prop}}_t = m^{SE}_t \cdot \left( \frac{\Lambda - 1}{1 - \sigma \Lambda} \right)$$

深空运输的能量消耗（用于评估综合能效）近似为排气动能：

$$E^{\text{OTLS}}_t = \frac{1}{2} M^{\text{prop}}_t (I_{sp} g_0)^2$$

### 3.2.3 太空电梯系统总成本

SES 的总成本由“提升成本”和“转运成本”两部分叠加而成：

$$C_{SE} = \sum_{t \in \mathcal{T}} \left[ \underbrace{f_{SE} z_t + c_{\text{lift}} m^{SE}_t}_{\text{Earth to Apex}} + \underbrace{\left( p_{\text{fuel}} \frac{M^{\text{prop}}_t}{m^{SE}_t} + c_{\text{ops}} \right) m^{SE}_t}_{\text{Apex to Moon}} \right]$$

为简化表达，令综合单位成本 $\hat{c}_{SE} = c_{\text{lift}} + c_{\text{ops}} + p_{\text{fuel}} \cdot (\text{FuelRatio})$，则：

$$C_{SE} = \sum_{t \in \mathcal{T}} (f_{SE} z_t + \hat{c}_{SE} m^{SE}_t)$$

## 3.3 子模型 II：火箭运输系统 (RTS)

### 3.3.1 载荷与运力

考虑地球自转对不同纬度 $\phi_i$ 发射场的影响，有效载荷修正为 $q_i^{\text{eff}} = \eta(\phi_i) \cdot q_{\text{nom}}$。

第 $i$ 个基地的年发射量 $m_{i,t}$ 约束：

$$m_{i,t} \le q_i^{\text{eff}} \cdot n_{i,t}, \quad n_{i,t} \le a_i L_i y_i$$

### 3.3.2 成本学习曲线

火箭技术成熟度高，成本随时间呈指数下降（学习率 $b$）：

$$C_R = \sum_{t,i} \left( C^{\text{fix}}_{i,0} e^{-b(t-t_0)} n_{i,t} + \alpha_{i,0} e^{-b(t-t_0)} m_{i,t} \right) + \sum_{i} F_i y_i$$

## 3.4 混合系统总成本与优化目标

### 3.4.1 总成本结构 (Cost Aggregation)

本模型假设混合系统为线性叠加，暂不考虑复杂的协同管理惩罚。总成本 $C_{\text{total}}$ 为：

$$C_{\text{total}} = C_{SE} \text{ (含深空转运)} + C_R \text{ (含发射与建设)}$$

展开后为：

$$C_{\text{total}} = \sum_{t \in \mathcal{T}} \left( f_{SE} z_t + \hat{c}_{SE} m^{SE}_t + \sum_{i \in \mathcal{I}} (C^{\text{fix}}_i(t) n_{i,t} + \alpha_i(t) m_{i,t}) \right) + \sum_{i \in \mathcal{I}} F_i y_i$$

### 3.4.2 目标函数

建立多目标加权函数，寻找成本与工期的最优平衡：

$$\min J = w_C \left( \frac{C_{\text{total}}}{C_{\text{ref}}} \right) + w_T \left( \frac{T}{T_{\text{ref}}} \right)$$

### 3.4.3 约束条件汇总

1. **总量满足**：$\sum_{t} (m^{SE}_t + \sum_{i} m_{i,t}) \ge M_{\text{tot}}$
    
2. **工期逻辑 (Big-M)**：$m^{SE}_t + \sum m_{i,t} \le \overline{M} z_t$
    
3. **连续性**：$z_t \ge z_{t+1}$
    
4. **变量域**：$n_{i,t} \in \mathbb{Z}^+,\; z_t, y_i \in \{0,1\},\; m \ge 0$