# 3 Model Construction for Task 1: Comparative Logistics Planning

## 3.1 框架概述：离散时间混合整数规划

为了在宏观层面权衡三种运输策略（纯电梯、纯火箭、混合模式）的成本与工期，我们建立了一个离散时间混合整数线性规划（MILP）模型。

### 3.1.1 规划周期与完工时间

项目自 $t_0 = 2050$ 年启动，规划期设为 $H$ 年。时间集合记为 $\mathcal{T} = \{t_0, t_0+1, \dots, t_0+H\}$。

为了内生化“完工时间”，引入二元决策变量 $z_t \in \{0,1\}$，表示第 $t$ 年项目是否仍处于活跃运输状态（1为活跃，0为结束）。

完工时间（Time to Completion）$T$ 定义为活跃年份的总和：

$$T = \sum_{t \in \mathcal{T}} z_t$$

为保证时间连续性（即不能中断后又重启），引入约束：

$$z_t \ge z_{t+1}, \quad \forall t \in \mathcal{T} \setminus \{t_0+H\}$$

### 3.1.2 需求与逻辑约束

项目总运输需求为 $M_{\text{tot}} = 10^8$ 吨。设第 $t$ 年到达月球的总物资为 $m_t$，则必须满足总量约束：

$$\sum_{t \in \mathcal{T}} m_t \ge M_{\text{tot}}$$

利用“大 M 法”（Big-M Method）建立运输量与活跃状态的逻辑关联：若项目已结束（$z_t=0$），则当年运输量必须为 0。

$$m_t \le \overline{M} \cdot z_t$$

其中 $\overline{M}$ 为足够大的常数（可取 $M_{\text{tot}}$）。

### 3.1.3 目标函数

任务 1 暂不考虑环境影响（$w_E=0$），仅权衡总成本（Cost）与工期（Time）。建立加权目标函数：

$$\min J = w_C \cdot \frac{C_{\text{total}}}{C_{\text{ref}}} + w_T \cdot \frac{T}{T_{\text{ref}}}$$

- $C_{\text{total}}$：系统总现值成本。
    
- $C_{\text{ref}}, T_{\text{ref}}$：归一化参考值（例如纯火箭方案的预估成本与纯电梯方案的预估工期）。
    
- $w_C, w_T$：决策权重，满足 $w_C + w_T = 1$。
    

---

## 3.2 子模型 I：太空电梯系统 (SES)

太空电梯的物流链分为两段：**段A（地面 $\to$ 顶点锚点）** 与 **段B（顶点锚点 $\to$ 近月轨道）**。

### 3.2.1 动态运力约束（段A）

太空电梯的基建运力随技术成熟呈 S 型增长。采用 Logistic 函数描述第 $t$ 年的可用运力上限 $C_{SE}(t)$：

$$C_{SE}(t) = \frac{K_{SE}}{1 + \left(\frac{K_{SE} - C_{SE,0}}{C_{SE,0}}\right) e^{-r(t - t_0)}}$$

其中 $C_{SE,0} = 5.37 \times 10^5$ 吨/年，$K_{SE}$ 为设计峰值运力，根据ISCE（国际太空电梯协会）预测，技术成熟后的太空电梯运力可提高20倍，因此假设$K_{SE}=20C_{{SE,0}}\approx1.0\times 10^7$，$r$ 为扩容速率，代表技术迭代的速率，在我们的模型中被假设为0.2。

设 $m^{SE}_t$ 为第 $t$ 年通过电梯运输的质量，需满足：

$$0 \le m^{SE}_t \le C_{SE}(t)$$

### 3.2.2 深空转运瓶颈（段B）

物资到达顶点锚点（Apex Anchor）后，需由“地月转运船”（Space Tug）接力运送至近月轨道（LLO）。这是一个离散的物流过程。

定义决策变量 $n^{EM}_t \in \mathbb{Z}_{\ge 0}$ 为第 $t$ 年执行的转运任务次数。

- **载荷匹配**：设单次转运标准载荷为 $q^{EM}$，则：
    
    $$m^{SE}_t \le q^{EM} \cdot n^{EM}_t$$
    
- **频次上限**：受限于船队规模与周转周期，年最大转运次数受限：
    
    $$n^{EM}_t \le L^{EM}$$
    

### 3.2.3 两段式成本结构

SES 总成本 $C_{SE}$ 由爬升成本与转运成本组成。

1. **爬升成本（段A）**：
    
    主要为电力消耗与运维。设单位质量能耗为 $e_{\text{GEO}}$，综合电价为 $p_e$，固定运维费为 $f_{SE}$：
    
    $$c_{\text{climb}} = p_e \cdot e_{\text{GEO}} + c_{\text{O\&M}}$$
    
2. **转运成本（段B）**：
    
    该段成本与转运的总质量（含推进剂与结构）成正比。我们将复杂的火箭方程线性化为“固定+变动”模式：
    
    - $C^{EM}_{\text{fix}}$：单次转运的固定任务成本。
        
    - $\alpha_{EM}(t)$：单位载荷的动态成本系数（隐含了 $\Delta v$ 带来的燃料消耗比率）。
        
    $$C_{\text{trans}}(t) = C^{EM}_{\text{fix}} \cdot n^{EM}_t + \alpha_{EM}(t) \cdot m^{SE}_t$$

综上，SES 的总成本为：

$$C_{SE} = \sum_{t \in \mathcal{T}} \left[ \left( c_{\text{climb}} \cdot m^{SE}_t + f_{SE} \cdot z_t \right) + \left( C^{EM}_{\text{fix}} \cdot n^{EM}_t + \alpha_{EM}(t) \cdot m^{SE}_t \right) \right]$$

---

## 3.3 子模型 II：火箭运输系统 (RTS)

### 3.3.1 基地选择与发射约束

考虑 $i \in \mathcal{I} = \{1, \dots, 10\}$ 个候选发射基地。

引入二元变量 $y_i \in \{0,1\}$ 表示是否启用基地 $i$。

定义 $n_{i,t} \in \mathbb{Z}_{\ge 0}$ 为基地 $i$ 在第 $t$ 年的发射次数，$m_{i,t}$ 为该基地的年运输量。

1. **纬度惩罚修正**：
    
    由于地球自转速度差异，高纬度基地的有效载荷 $q_i^{\text{eff}}$ 低于名义载荷 $q$。引入折减系数 $\eta_i(\phi_i) \in (0,1]$：
    
    $$q_i^{\text{eff}} = \eta_i \cdot q$$
    
    运输量约束：
    
    $$m_{i,t} \le q_i^{\text{eff}} \cdot n_{i,t}$$
    
2. **基地容量限制**：
    
    受限于天气可用率 $a_i$ 和基础设施上限 $L_i$，年发射次数需满足：
    
    $$n_{i,t} \le a_i L_i \cdot y_i$$
    
    （注：若 $y_i=0$，则该基地发射能力强制为 0）。
    

### 3.3.2 学习曲线与成本模型

火箭成本具有显著的技术学习效应（Learning Curve）。我们采用按时间指数下降的简化模型。

设 $b$ 为成本下降速率，$t_0$ 为基准年：

- **单次发射固定成本**：$C^{\text{fix}}_{i}(t) = C^{\text{fix}}_{i,0} \cdot e^{-b(t-t_0)}$
    
- **单位质量动态成本**：$\alpha_i(t) = \alpha_{i,0} \cdot e^{-b(t-t_0)}$
    

火箭系统总成本 $C_R$ 包括发射运营成本与基地启用成本 $F_i$：

$$C_R = \sum_{t \in \mathcal{T}} \sum_{i \in \mathcal{I}} \left( C^{\text{fix}}_{i}(t) \cdot n_{i,t} + \alpha_i(t) \cdot m_{i,t} \right) + \sum_{i \in \mathcal{I}} F_i \cdot y_i$$

---

## 3.4 综合混合优化模型 (The Hybrid Model)

将上述子系统整合，得到最终的优化模型。

### 3.4.1 决策变量汇总

- $z_t, y_i \in \{0,1\}$：时序控制与选址决策。
    
- $m^{SE}_t, m_{i,t} \ge 0$：各渠道物资流量。
    
- $n^{EM}_t, n_{i,t} \in \mathbb{Z}_{\ge 0}$：各段运输任务频次。
    

### 3.4.2 最终优化问题

$$\begin{aligned} \min \quad & J = w_C \frac{C_{SE} + C_R}{C_{\text{ref}}} + w_T \frac{\sum z_t}{T_{\text{ref}}} \\ \text{s.t.} \quad & \\ \text{(1) 总需求:} & \quad \sum_{t \in \mathcal{T}} \left( m^{SE}_t + \sum_{i \in \mathcal{I}} m_{i,t} \right) \ge M_{\text{tot}} \\ \text{(2) 完工逻辑:} & \quad m^{SE}_t + \sum_{i \in \mathcal{I}} m_{i,t} \le \overline{M} \cdot z_t, \quad z_t \ge z_{t+1} \\ \text{(3) 电梯约束:} & \quad m^{SE}_t \le C_{SE}(t) \\ & \quad m^{SE}_t \le q^{EM} n^{EM}_t, \quad n^{EM}_t \le L^{EM} \\ \text{(4) 火箭约束:} & \quad m_{i,t} \le \eta_i q \cdot n_{i,t} \\ & \quad n_{i,t} \le a_i L_i \cdot y_i \end{aligned}$$

该模型为一个标准的混合整数线性规划（MILP），可通过商业求解器（如 Gurobi, CPLEX）或开源求解器（如 CBC, SCIP）在多项式时间内求得全局最优解。