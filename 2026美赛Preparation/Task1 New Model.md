# 3 Model Construction for Task 1: Comparative Logistics Planning

  

## 3.1 框架概述：离散时间混合整数规划

  

为了在宏观层面权衡三种运输策略（纯电梯、纯火箭、混合模式）的成本与工期，我们建立了一个离散时间混合整数线性规划（MILP）模型。

  

### 3.1.1 规划周期与完工时间

  

项目自 $t_0 = 2050$ 年启动，规划期设为 $H$ 年。时间集合记为 $\mathcal{T} = \{t_0, t_0+1, \dots, t_0+H\}$。

  

为了内生化“完工时间”，引入二元决策变量 $z_t \in \{0,1\}$，表示第 $t$ 年项目是否仍处于活跃运输状态（1为活跃，0为结束）。

  

完工时间（Time to Completion）$T_{\text{comp}}$ 定义为活跃年份的总和：

  

$$T_{\text{comp}} = \sum_{t \in \mathcal{T}} z_t$$

  

为保证时间连续性（即不能中断后又重启），引入约束：

  

$$z_t \ge z_{t+1}, \quad \forall t \in \mathcal{T} \setminus \{t_0+H\}$$

  

### 3.1.2 需求与逻辑约束

  

项目总运输需求为 $M_{\text{tot}} = 10^8$ 吨。设第 $t$ 年到达月球的总物资为 $m_t$，则必须满足总量约束：

  

$$\sum_{t \in \mathcal{T}} m_t \ge M_{\text{tot}}$$

  

利用“大 M 法”（Big-M Method）建立运输量与活跃状态的逻辑关联：若项目已结束（$z_t=0$），则当年运输量必须为 0。

  

$$m_t \le \overline{M} \cdot z_t$$

  

其中 $\overline{M}$ 为足够大的常数（可取 $M_{\text{tot}}$）。

  

### 3.1.3 目标函数

  

任务 1 暂不考虑环境影响（令 $w_E=0$），仅权衡总成本（Cost）与时间（Time）。

  

一个常见的病态是：当火箭运输成本被建模为“随时间外生下降”（技术进步）时，优化器会倾向于把运输活动尽量推迟到后期（“等技术更成熟再运”），形成不现实的“曲棍球棒式”运输曲线。为避免这一问题，我们把时间指标从“只看完工年数”升级为 **平均到货时间**（Backlog-time），既能反映最终完工，又能惩罚长时间不运输。

  

定义年末欠交量（Backlog）：

  

$$

B_t \;\ge\; M_{\text{tot}}-\sum_{\tau=t_0}^{t} m_\tau,\qquad B_t\ge 0

$$

  

并定义平均到货时间（单位：年）：

  

$$

T_{\text{avg}}=\frac{1}{M_{\text{tot}}}\sum_{t\in\mathcal{T}} B_t

$$

  

最终采用归一化加权目标：

  

$$

\min J = w_C \cdot \frac{C_{\text{total}}}{C_{\text{ref}}} + w_T \cdot \frac{T_{\text{avg}}}{T_{\text{ref}}},

\qquad w_C+w_T=1

$$

  

> 注：论文结果部分仍会报告评委更直观的 **完工时间** $T_{\text{comp}}$（第一个累计交付 $\ge M_{\text{tot}}$ 的年份对应的年数）。  

> 若需要画帕累托前沿，可改用 $\varepsilon$-约束：$\min C_{\text{total}}\ \text{s.t.}\ T_{\text{comp}}\le \bar T$ 或 $T_{\text{avg}}\le \bar T$。

  

### 3.1.4 反拖延机制：S0（你的现有滚动规划）+ S1/S2/S3（综述补充方案）

  

你综述（`优化模型中的延期与权重.pdf` 第 2 章）指出：当“火箭成本随时间外生下降”时，混合模型会出现典型的 **Wait‑for‑Technology Paradox** ——为了等到后期更低的火箭成本，解会倾向于前期只用电梯、把火箭留到后期才使用，从而形成不现实的“曲棍球棒式”建设曲线。

  

为解决这一病态，你的现有方案本身就是一种“规划-执行层”的反拖延设计（S0）；综述还给出三类“模型结构层”的补充机制（S1/S2/S3）。下面给出**适用性评估**（优点/缺点/实现难度/对你当前任务的适配度）：

  

- **(S0) 五年滚动规划（5‑year rolling horizon, technology freezing）—你的现有主方案**  

  - **核心思想**：以 5 年为一个规划周期。对第 \(p\) 个周期，设起始年为

    \[

    t_p=t_0+5p

    \]

    在 \(t_p\) 观测（或估计）当期的技术水平，并在该周期内将关键技术参数“冻结”为 \(t_p\) 的水平（尤其是火箭单位成本、固定成本、可用发射能力等），求解一个覆盖 \(\{t_p,\dots,t_p+4\}\) 的确定性调度计划；实际执行 5 年后，在 \(t_{p+1}\) 重新更新技术水平并再次规划。

  - **对你问题的直接效果**：在每个 5 年窗口内，“等待到窗口末尾更便宜”不再成立（成本在窗口内不随时间下降），因此会显著削弱“曲棍球棒式”后期集中；同时它与真实工程的预算/采购周期一致（更像 MCM Agency 的决策方式）。

  - **优点**：不改变 MILP 的线性结构；能自然吸收长期预测误差（每 5 年校正一次）；写作上可解释为“滚动决策/模型预测控制（MPC）”。

  - **缺点**：它是“执行策略”，不保证全局最优；若仍存在强烈的长期外生降本预期，极端情况下可能出现“每个周期都想再等等”的现象，因此通常需要配合**硬截止/阶段目标**（或在目标中显式体现时间价值）。

  - **结论**：作为你的主方案非常合理；并且可以把 S1/S2/S3 作为“若评委质疑拖延/权重”的增强论证与对照方案。

  

- **(S1) 内生学习曲线（Wright’s law / Learning‑by‑Doing）—最根本，但最难**  

  - **核心思想**：火箭（或电梯）的降本来自“干中学”，成本不再是时间函数，而是累计运输量/累计发射次数的函数 \(C_t=C_1(K_t)^{-b}\)。  

  - **对你问题的直接效果**：想获得后期低成本，必须在前期启动一定规模的火箭发射来积累 \(K_t\)，因此“等待”不再有利。  

  - **优点**：机制最真实、最能解释“为什么要尽早开始火箭/规模化运输”。  

  - **缺点**：严格写进 MILP 会引入非线性（成本与决策量耦合），需要分段线性 + SOS2（综述也强调这一点），代码/篇幅成本高；学习率参数也需要敏感性。  

  - **结论**：若你想把论文做得“更高级”，S1 最加分；但实现复杂度最高。

  

- **(S2) 延期惩罚与机会成本（Opportunity Cost of Delay）—最实用，推荐主用**  

  - **核心思想**：把“晚建成导致的生态/战略损失”货币化，显式加到目标函数里，让“等待”付出代价。  

  - **推荐形式（综述主推）**：二次惩罚形成 Soft Deadline（随时间推移惩罚加速上升）：  

    \[

    \text{Penalty}_t=\theta\,(t-2050)^2\,(1-\text{CompletionRatio}_t)

    \]

    其中 \(1-\text{CompletionRatio}_t\) 可以用欠交比例 \(B_t/M_{\text{tot}}\) 表示。  

  - **优点**：完全线性、易实现、非常契合题目“尽快减轻地球生态压力”的叙事；也最容易把“混合前期只用电梯”纠偏到更平滑的 S 型曲线。  

  - **缺点**：需要选择 \(\theta\) 的量纲与数值（因此必须做敏感性分析）。  

  - **结论**：你目前的工程目标与论文可写性，最适合用 S2 作为主机制（并用 \(\theta\) 做情景扫描）。

  

- **(S3) 社会折现率（Social Discount Rate, SDR）—只在你用 NPV 时有效**  

  - **核心思想**：如果目标函数用净现值（NPV）折现成本/收益，高折现率会让“未来的完工”在今天几乎不重要，从而鼓励拖延；应采用 1%–3% 的社会折现率（综述给出 Ramsey/ Stern 的论证）。  

  - **优点**：理论非常正统，适合写“代际公平”；作为参数设定理由很强。  

  - **缺点**：它只能削弱“折现导致的拖延”，但**无法单独消除**“火箭成本外生下降导致的等待”（仍需 S1 或 S2）。  

  - **结论**：若你论文里采用 NPV，S3 必须写；若不采用 NPV，可作为讨论与敏感性扩展。

  

> 推荐写作策略：正文把 **S0（五年滚动规划）** 作为你的主方案；S1/S2/S3 作为“如果不采用滚动规划，如何从模型结构上消除拖延”的补充对照。这样既符合你的任务逻辑，也能回应评委对拖延病态的质疑。

  

---

  

## 3.2 子模型 I：太空电梯系统 (SES)

  

太空电梯的物流链分为两段：**段A（地面 $\to$ 顶点锚点）** 与 **段B（顶点锚点 $\to$ 近月轨道）**。

  

### 3.2.1 动态运力约束（段A）

  

太空电梯的基建运力随技术成熟呈 S 型增长。采用 Logistic 函数描述第 $t$ 年的可用运力上限 $C_{SE}(t)$：

  

$$C_{SE}(t) = \frac{K_{SE}}{1 + \left(\frac{K_{SE} - C_{SE,0}}{C_{SE,0}}\right) e^{-r(t - t_0)}}$$

  

其中 $C_{SE,0} = 5.37 \times 10^5$ 吨/年，$K_{SE}$ 为设计峰值运力（假设 $K_{SE} \approx 20 C_{SE,0}$），$r$ 为扩容速率（假设为 0.2）。

  

设 $m^{SE}_t$ 为第 $t$ 年通过电梯运输的质量，需满足：

  

$$0 \le m^{SE}_t \le C_{SE}(t)$$

  

### 3.2.2 深空转运假设（段B：Apex → LLO）

  

物资到达顶点锚点（Apex Anchor）后，需要额外的推进与制动才能交付到近月轨道（LLO）。题面并未给出“转运器数量/周转窗口”之类的运力上限，因此在**基线模型**中我们采用如下假设：

  

- **段B不构成运力瓶颈**：不对“转运器任务次数”设置上限，也不引入任何限制电梯年度运量的段B约束；段A 的 \(C_{SE}(t)\) 作为电梯链路的唯一运力上限。

- **段B只体现成本**：段B 的推进剂/机动需求（尤其你强调的制动/捕获）被折算进一个单位吨位变动成本系数 \(\alpha_{EM}\)（USD/t），直接与 \(m_t^{SE}\) 相乘计入成本。

  

> 备注：如果你希望在附录中展示“转运班次”的物理含义，可把班次数作为**派生量**计算（如 \(n_t^{EM}\approx m_t^{SE}/q^{EM}\)），但不把它作为约束或决策变量写进 MILP。

  

### 3.2.3 两段式成本结构

  

SES 总成本 $C_{SE}$ 由爬升成本与转运成本组成。

  

1. **爬升成本（段A）**：

    主要为电力消耗与运维。设单位质量能耗为 $e_{\text{GEO}}$，综合电价为 $p_e$，固定运维费为 $f_{SE}$：

    $$c_{\text{climb}} = p_e \cdot e_{\text{GEO}} + c_{\text{O\&M}}$$

2. **转运成本（段B）**：

  

    段B 的复杂动力学与推进剂需求被折算为“单位吨位变动成本”：

  

    $$

    C_{\text{trans}}(t) = \alpha_{EM} \cdot m^{SE}_t

    $$

  

综上，SES 的总成本为：

  

$$

C_{SE} = \sum_{t \in \mathcal{T}} \left[ \left( c_{\text{climb}} \cdot m^{SE}_t + f_{SE} \cdot z_t \right) + \left( \alpha_{EM} \cdot m^{SE}_t \right) \right]

$$

  

### 3.2.4 （更细节但仍可线性）如何把“制动/捕获成本”计入 $\alpha_{EM}$（来自旧稿的物理口径）

  

旧稿中你强调：从 Apex 释放到月球并非“免费”，尤其需要计入 **到月球后的制动/捕获**（LOI）等机动成本。为了既保留物理含义、又不破坏 MILP 的线性可解性，我们把动力学影响压缩进一个“有效载荷占比/质量比”参数，再映射到线性的 $\alpha_{EM}$。

  

1) 设段B（Apex $\to$ LLO）的 $\Delta v$ 预算为：

  

$$

\Delta v_{EM}=\Delta v_{\text{corr}}+\Delta v_{\text{brake}}+\Delta v_{\text{LOI}}(+\Delta v_{\text{plane}})

$$

  

其中 $\Delta v_{\text{brake}}$ 表示把“过剩能量”调整到可被月球捕获的主动制动（你希望显式计入的关键项）。

  

2) 用火箭方程把 $\Delta v_{EM}$ 映射为“载荷占比”（payload fraction）：

  

$$

\lambda_{EM}=\frac{m_{\text{payload}}}{m_0}=\exp\!\left(-\frac{\Delta v_{EM}}{I_{sp}g_0}\right),

\qquad

R_{EM}=\frac{m_0}{m_{\text{payload}}}=\frac{1}{\lambda_{EM}}

$$

  

3) 若把“每吨总初始质量 $m_0$ 对应的综合成本”（推进剂+结构+保障等）写为 $c^{EM,\text{gross}}$（USD/t），则把 1 吨载荷送达 LLO 的线性变动成本系数可写为：

  

$$

\alpha_{EM}=\frac{c^{EM,\text{gross}}}{\lambda_{EM}}=c^{EM,\text{gross}}\cdot R_{EM}

$$

  

这样：$\Delta v_{\text{brake}}$ 越大 $\Rightarrow \lambda_{EM}$ 越小 $\Rightarrow \alpha_{EM}$ 越大，从而“制动成本”被自然计入段B的线性成本中。

  

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

2. **基地有效容量限制**：

    综合考虑基础设施规模与当地天气条件，定义 $L_i$ 为基地 $i$ 的**年度有效最大发射次数**（Effective Annual Launch Cap）。若基地启用，则发射次数不能超过此上限：

    $$n_{i,t} \le L_i \cdot y_i$$

    （注：若 $y_i=0$，则 $n_{i,t}$ 强制为 0）。

  

### 3.3.2 学习曲线与成本模型

  

火箭成本具有显著的技术学习效应（Learning Curve）。我们采用按时间指数下降的简化模型。

  

设 $b$ 为成本下降速率，$t_0$ 为基准年：

  

- **单次发射固定成本**：$C^{\text{fix}}_{i}(t) = C^{\text{fix}}_{i,0} \cdot e^{-b(t-t_0)}$

- **单位质量动态成本**：$\alpha_i(t) = \alpha_{i,0} \cdot e^{-b(t-t_0)}$

  

火箭系统总成本 $C_R$ 包括发射运营成本与基地启用成本 $F_i$：

  

$$C_R = \sum_{t \in \mathcal{T}} \sum_{i \in \mathcal{I}} \left( C^{\text{fix}}_{i}(t) \cdot n_{i,t} + \alpha_i(t) \cdot m_{i,t} \right) + \sum_{i \in \mathcal{I}} F_i \cdot y_i$$

  

---

  

## 3.4 综合混合优化模型 (The Simplified Hybrid Model)

  

将上述子系统整合，得到最终的优化模型。

  

### 3.4.1 决策变量汇总

  

- $z_t, y_i \in \{0,1\}$：时序控制与选址决策。

- $m^{SE}_t, m_{i,t} \ge 0$：各渠道物资流量。

- $n_{i,t} \in \mathbb{Z}_{\ge 0}$：火箭年度发射次数（整数）。

  

### 3.4.2 最终优化问题

  

$$

\begin{aligned}

\min \quad

& J = w_C \frac{C_{SE} + C_R}{C_{\text{ref}}} + w_T \frac{T_{\text{avg}}}{T_{\text{ref}}}

\\

\text{s.t.}\quad

& \text{(1) 总需求:}\quad \sum_{t \in \mathcal{T}} \left( m^{SE}_t + \sum_{i \in \mathcal{I}} m_{i,t} \right) \ge M_{\text{tot}}

\\

& \text{(2) 完工逻辑:}\quad m^{SE}_t + \sum_{i \in \mathcal{I}} m_{i,t} \le \overline{M} \cdot z_t,\quad z_t \ge z_{t+1}

\\

& \text{(3) 电梯约束:}\quad m^{SE}_t \le C_{SE}(t)

\\

& \text{(4) 火箭约束:}\quad m_{i,t} \le \eta_i q \cdot n_{i,t},\quad n_{i,t} \le L_i \cdot y_i

\\

& \text{(5) Backlog 定义:}\quad

B_t \ge M_{\text{tot}}-\sum_{\tau=t_0}^{t}\left(m_\tau^{SE}+\sum_{i\in\mathcal{I}} m_{i,\tau}\right),\quad B_t\ge 0

\\

& \text{(6) 平均到货时间:}\quad

T_{\text{avg}}=\frac{1}{M_{\text{tot}}}\sum_{t\in\mathcal{T}} B_t

\end{aligned}

$$# 3 Model Construction for Task 1: Comparative Logistics Planning

## 3.1 框架概述：离散时间混合整数规划

为了在宏观层面权衡三种运输策略（纯电梯、纯火箭、混合模式）的成本与工期，我们建立了一个离散时间混合整数线性规划（MILP）模型。

### 3.1.1 规划周期与完工时间

项目自 $t_0 = 2050$ 年启动，规划期设为 $H$ 年。时间集合记为 $\mathcal{T} = \{t_0, t_0+1, \dots, t_0+H\}$。

为了内生化“完工时间”，引入二元决策变量 $z_t \in \{0,1\}$，表示第 $t$ 年项目是否仍处于活跃运输状态（1为活跃，0为结束）。

完工时间（Time to Completion）$T_{\text{comp}}$ 定义为活跃年份的总和：

$$T_{\text{comp}} = \sum_{t \in \mathcal{T}} z_t$$

为保证时间连续性（即不能中断后又重启），引入约束：

$$z_t \ge z_{t+1}, \quad \forall t \in \mathcal{T} \setminus \{t_0+H\}$$

### 3.1.2 需求与逻辑约束

项目总运输需求为 $M_{\text{tot}} = 10^8$ 吨。设第 $t$ 年到达月球的总物资为 $m_t$，则必须满足总量约束：

$$\sum_{t \in \mathcal{T}} m_t \ge M_{\text{tot}}$$

利用“大 M 法”（Big-M Method）建立运输量与活跃状态的逻辑关联：若项目已结束（$z_t=0$），则当年运输量必须为 0。

$$m_t \le \overline{M} \cdot z_t$$

其中 $\overline{M}$ 为足够大的常数（可取 $M_{\text{tot}}$）。

### 3.1.3 目标函数

任务 1 暂不考虑环境影响（令 $w_E=0$），仅权衡总成本（Cost）与时间（Time）。

一个常见的病态是：当火箭运输成本被建模为“随时间外生下降”（技术进步）时，优化器会倾向于把运输活动尽量推迟到后期（“等技术更成熟再运”），形成不现实的“曲棍球棒式”运输曲线。为避免这一问题，我们把时间指标从“只看完工年数”升级为 **平均到货时间**（Backlog-time），既能反映最终完工，又能惩罚长时间不运输。

定义年末欠交量（Backlog）：

$$
B_t \;\ge\; M_{\text{tot}}-\sum_{\tau=t_0}^{t} m_\tau,\qquad B_t\ge 0
$$

并定义平均到货时间（单位：年）：

$$
T_{\text{avg}}=\frac{1}{M_{\text{tot}}}\sum_{t\in\mathcal{T}} B_t
$$

最终采用归一化加权目标：

$$
\min J = w_C \cdot \frac{C_{\text{total}}}{C_{\text{ref}}} + w_T \cdot \frac{T_{\text{avg}}}{T_{\text{ref}}},
\qquad w_C+w_T=1
$$

> 注：论文结果部分仍会报告评委更直观的 **完工时间** $T_{\text{comp}}$（第一个累计交付 $\ge M_{\text{tot}}$ 的年份对应的年数）。  
> 若需要画帕累托前沿，可改用 $\varepsilon$-约束：$\min C_{\text{total}}\ \text{s.t.}\ T_{\text{comp}}\le \bar T$ 或 $T_{\text{avg}}\le \bar T$。

### 3.1.4 反拖延机制：S0（你的现有滚动规划）+ S1/S2/S3（综述补充方案）

你综述（`优化模型中的延期与权重.pdf` 第 2 章）指出：当“火箭成本随时间外生下降”时，混合模型会出现典型的 **Wait‑for‑Technology Paradox** ——为了等到后期更低的火箭成本，解会倾向于前期只用电梯、把火箭留到后期才使用，从而形成不现实的“曲棍球棒式”建设曲线。

为解决这一病态，你的现有方案本身就是一种“规划-执行层”的反拖延设计（S0）；综述还给出三类“模型结构层”的补充机制（S1/S2/S3）。下面给出**适用性评估**（优点/缺点/实现难度/对你当前任务的适配度）：

- **(S0) 五年滚动规划（5‑year rolling horizon, technology freezing）—你的现有主方案**  
  - **核心思想**：以 5 年为一个规划周期。对第 \(p\) 个周期，设起始年为
    \[
    t_p=t_0+5p
    \]
    在 \(t_p\) 观测（或估计）当期的技术水平，并在该周期内将关键技术参数“冻结”为 \(t_p\) 的水平（尤其是火箭单位成本、固定成本、可用发射能力等），求解一个覆盖 \(\{t_p,\dots,t_p+4\}\) 的确定性调度计划；实际执行 5 年后，在 \(t_{p+1}\) 重新更新技术水平并再次规划。
  - **对你问题的直接效果**：在每个 5 年窗口内，“等待到窗口末尾更便宜”不再成立（成本在窗口内不随时间下降），因此会显著削弱“曲棍球棒式”后期集中；同时它与真实工程的预算/采购周期一致（更像 MCM Agency 的决策方式）。
  - **优点**：不改变 MILP 的线性结构；能自然吸收长期预测误差（每 5 年校正一次）；写作上可解释为“滚动决策/模型预测控制（MPC）”。
  - **缺点**：它是“执行策略”，不保证全局最优；若仍存在强烈的长期外生降本预期，极端情况下可能出现“每个周期都想再等等”的现象，因此通常需要配合**硬截止/阶段目标**（或在目标中显式体现时间价值）。
  - **结论**：作为你的主方案非常合理；并且可以把 S1/S2/S3 作为“若评委质疑拖延/权重”的增强论证与对照方案。

- **(S1) 内生学习曲线（Wright’s law / Learning‑by‑Doing）—最根本，但最难**  
  - **核心思想**：火箭（或电梯）的降本来自“干中学”，成本不再是时间函数，而是累计运输量/累计发射次数的函数 \(C_t=C_1(K_t)^{-b}\)。  
  - **对你问题的直接效果**：想获得后期低成本，必须在前期启动一定规模的火箭发射来积累 \(K_t\)，因此“等待”不再有利。  
  - **优点**：机制最真实、最能解释“为什么要尽早开始火箭/规模化运输”。  
  - **缺点**：严格写进 MILP 会引入非线性（成本与决策量耦合），需要分段线性 + SOS2（综述也强调这一点），代码/篇幅成本高；学习率参数也需要敏感性。  
  - **结论**：若你想把论文做得“更高级”，S1 最加分；但实现复杂度最高。

- **(S2) 延期惩罚与机会成本（Opportunity Cost of Delay）—最实用，推荐主用**  
  - **核心思想**：把“晚建成导致的生态/战略损失”货币化，显式加到目标函数里，让“等待”付出代价。  
  - **推荐形式（综述主推）**：二次惩罚形成 Soft Deadline（随时间推移惩罚加速上升）：  
    \[
    \text{Penalty}_t=\theta\,(t-2050)^2\,(1-\text{CompletionRatio}_t)
    \]
    其中 \(1-\text{CompletionRatio}_t\) 可以用欠交比例 \(B_t/M_{\text{tot}}\) 表示。  
  - **优点**：完全线性、易实现、非常契合题目“尽快减轻地球生态压力”的叙事；也最容易把“混合前期只用电梯”纠偏到更平滑的 S 型曲线。  
  - **缺点**：需要选择 \(\theta\) 的量纲与数值（因此必须做敏感性分析）。  
  - **结论**：你目前的工程目标与论文可写性，最适合用 S2 作为主机制（并用 \(\theta\) 做情景扫描）。

- **(S3) 社会折现率（Social Discount Rate, SDR）—只在你用 NPV 时有效**  
  - **核心思想**：如果目标函数用净现值（NPV）折现成本/收益，高折现率会让“未来的完工”在今天几乎不重要，从而鼓励拖延；应采用 1%–3% 的社会折现率（综述给出 Ramsey/ Stern 的论证）。  
  - **优点**：理论非常正统，适合写“代际公平”；作为参数设定理由很强。  
  - **缺点**：它只能削弱“折现导致的拖延”，但**无法单独消除**“火箭成本外生下降导致的等待”（仍需 S1 或 S2）。  
  - **结论**：若你论文里采用 NPV，S3 必须写；若不采用 NPV，可作为讨论与敏感性扩展。

> 推荐写作策略：正文把 **S0（五年滚动规划）** 作为你的主方案；S1/S2/S3 作为“如果不采用滚动规划，如何从模型结构上消除拖延”的补充对照。这样既符合你的任务逻辑，也能回应评委对拖延病态的质疑。
    

---

## 3.2 子模型 I：太空电梯系统 (SES)

太空电梯的物流链分为两段：**段A（地面 $\to$ 顶点锚点）** 与 **段B（顶点锚点 $\to$ 近月轨道）**。

### 3.2.1 动态运力约束（段A）

太空电梯的基建运力随技术成熟呈 S 型增长。采用 Logistic 函数描述第 $t$ 年的可用运力上限 $C_{SE}(t)$：

$$C_{SE}(t) = \frac{K_{SE}}{1 + \left(\frac{K_{SE} - C_{SE,0}}{C_{SE,0}}\right) e^{-r(t - t_0)}}$$

其中 $C_{SE,0} = 5.37 \times 10^5$ 吨/年，$K_{SE}$ 为设计峰值运力（假设 $K_{SE} \approx 20 C_{SE,0}$），$r$ 为扩容速率（假设为 0.2）。

设 $m^{SE}_t$ 为第 $t$ 年通过电梯运输的质量，需满足：

$$0 \le m^{SE}_t \le C_{SE}(t)$$

### 3.2.2 深空转运假设（段B：Apex → LLO）

物资到达顶点锚点（Apex Anchor）后，需要额外的推进与制动才能交付到近月轨道（LLO）。题面并未给出“转运器数量/周转窗口”之类的运力上限，因此在**基线模型**中我们采用如下假设：

- **段B不构成运力瓶颈**：不对“转运器任务次数”设置上限，也不引入任何限制电梯年度运量的段B约束；段A 的 \(C_{SE}(t)\) 作为电梯链路的唯一运力上限。
- **段B只体现成本**：段B 的推进剂/机动需求（尤其你强调的制动/捕获）被折算进一个单位吨位变动成本系数 \(\alpha_{EM}\)（USD/t），直接与 \(m_t^{SE}\) 相乘计入成本。

> 备注：如果你希望在附录中展示“转运班次”的物理含义，可把班次数作为**派生量**计算（如 \(n_t^{EM}\approx m_t^{SE}/q^{EM}\)），但不把它作为约束或决策变量写进 MILP。
    

### 3.2.3 两段式成本结构

SES 总成本 $C_{SE}$ 由爬升成本与转运成本组成。

1. **爬升成本（段A）**：
    
    主要为电力消耗与运维。设单位质量能耗为 $e_{\text{GEO}}$，综合电价为 $p_e$，固定运维费为 $f_{SE}$：
    
    $$c_{\text{climb}} = p_e \cdot e_{\text{GEO}} + c_{\text{O\&M}}$$
    
2. **转运成本（段B）**：

    段B 的复杂动力学与推进剂需求被折算为“单位吨位变动成本”：

    $$
    C_{\text{trans}}(t) = \alpha_{EM} \cdot m^{SE}_t
    $$
    

综上，SES 的总成本为：

$$
C_{SE} = \sum_{t \in \mathcal{T}} \left[ \left( c_{\text{climb}} \cdot m^{SE}_t + f_{SE} \cdot z_t \right) + \left( \alpha_{EM} \cdot m^{SE}_t \right) \right]
$$

### 3.2.4 （更细节但仍可线性）如何把“制动/捕获成本”计入 $\alpha_{EM}$（来自旧稿的物理口径）

旧稿中你强调：从 Apex 释放到月球并非“免费”，尤其需要计入 **到月球后的制动/捕获**（LOI）等机动成本。为了既保留物理含义、又不破坏 MILP 的线性可解性，我们把动力学影响压缩进一个“有效载荷占比/质量比”参数，再映射到线性的 $\alpha_{EM}$。

1) 设段B（Apex $\to$ LLO）的 $\Delta v$ 预算为：

$$
\Delta v_{EM}=\Delta v_{\text{corr}}+\Delta v_{\text{brake}}+\Delta v_{\text{LOI}}(+\Delta v_{\text{plane}})
$$

其中 $\Delta v_{\text{brake}}$ 表示把“过剩能量”调整到可被月球捕获的主动制动（你希望显式计入的关键项）。

2) 用火箭方程把 $\Delta v_{EM}$ 映射为“载荷占比”（payload fraction）：

$$
\lambda_{EM}=\frac{m_{\text{payload}}}{m_0}=\exp\!\left(-\frac{\Delta v_{EM}}{I_{sp}g_0}\right),
\qquad
R_{EM}=\frac{m_0}{m_{\text{payload}}}=\frac{1}{\lambda_{EM}}
$$

3) 若把“每吨总初始质量 $m_0$ 对应的综合成本”（推进剂+结构+保障等）写为 $c^{EM,\text{gross}}$（USD/t），则把 1 吨载荷送达 LLO 的线性变动成本系数可写为：

$$
\alpha_{EM}=\frac{c^{EM,\text{gross}}}{\lambda_{EM}}=c^{EM,\text{gross}}\cdot R_{EM}
$$

这样：$\Delta v_{\text{brake}}$ 越大 $\Rightarrow \lambda_{EM}$ 越小 $\Rightarrow \alpha_{EM}$ 越大，从而“制动成本”被自然计入段B的线性成本中。

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
    
2. **基地有效容量限制**：
    
    综合考虑基础设施规模与当地天气条件，定义 $L_i$ 为基地 $i$ 的**年度有效最大发射次数**（Effective Annual Launch Cap）。若基地启用，则发射次数不能超过此上限：
    
    $$n_{i,t} \le L_i \cdot y_i$$
    
    （注：若 $y_i=0$，则 $n_{i,t}$ 强制为 0）。
    

### 3.3.2 学习曲线与成本模型

火箭成本具有显著的技术学习效应（Learning Curve）。我们采用按时间指数下降的简化模型。

设 $b$ 为成本下降速率，$t_0$ 为基准年：

- **单次发射固定成本**：$C^{\text{fix}}_{i}(t) = C^{\text{fix}}_{i,0} \cdot e^{-b(t-t_0)}$
    
- **单位质量动态成本**：$\alpha_i(t) = \alpha_{i,0} \cdot e^{-b(t-t_0)}$
    

火箭系统总成本 $C_R$ 包括发射运营成本与基地启用成本 $F_i$：

$$C_R = \sum_{t \in \mathcal{T}} \sum_{i \in \mathcal{I}} \left( C^{\text{fix}}_{i}(t) \cdot n_{i,t} + \alpha_i(t) \cdot m_{i,t} \right) + \sum_{i \in \mathcal{I}} F_i \cdot y_i$$

---

## 3.4 综合混合优化模型 (The Simplified Hybrid Model)

将上述子系统整合，得到最终的优化模型。

### 3.4.1 决策变量汇总

- $z_t, y_i \in \{0,1\}$：时序控制与选址决策。
    
- $m^{SE}_t, m_{i,t} \ge 0$：各渠道物资流量。
    
- $n_{i,t} \in \mathbb{Z}_{\ge 0}$：火箭年度发射次数（整数）。
    

### 3.4.2 最终优化问题

$$
\begin{aligned}
\min \quad
& J = w_C \frac{C_{SE} + C_R}{C_{\text{ref}}} + w_T \frac{T_{\text{avg}}}{T_{\text{ref}}}
\\
\text{s.t.}\quad
& \text{(1) 总需求:}\quad \sum_{t \in \mathcal{T}} \left( m^{SE}_t + \sum_{i \in \mathcal{I}} m_{i,t} \right) \ge M_{\text{tot}}
\\
& \text{(2) 完工逻辑:}\quad m^{SE}_t + \sum_{i \in \mathcal{I}} m_{i,t} \le \overline{M} \cdot z_t,\quad z_t \ge z_{t+1}
\\
& \text{(3) 电梯约束:}\quad m^{SE}_t \le C_{SE}(t)
\\
& \text{(4) 火箭约束:}\quad m_{i,t} \le \eta_i q \cdot n_{i,t},\quad n_{i,t} \le L_i \cdot y_i
\\
& \text{(5) Backlog 定义:}\quad
B_t \ge M_{\text{tot}}-\sum_{\tau=t_0}^{t}\left(m_\tau^{SE}+\sum_{i\in\mathcal{I}} m_{i,\tau}\right),\quad B_t\ge 0
\\
& \text{(6) 平均到货时间:}\quad
T_{\text{avg}}=\frac{1}{M_{\text{tot}}}\sum_{t\in\mathcal{T}} B_t
\end{aligned}
$$
