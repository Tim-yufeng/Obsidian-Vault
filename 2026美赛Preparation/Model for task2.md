# 4 Model Construction for Task 2: Stochastic Simulation & Robustness Analysis

## 4.1 框架概述：仿真-优化耦合机制

Task 1 的模型假设了理想的系统运行环境，然而在实际航天工程中，火箭发射失败、空间环境恶化导致的电梯停运等不确定性因素（Uncertainties）不可避免 。为了评估物流系统的**韧性（Resilience）**与**鲁棒性（Robustness）**，我们将 Task 1 的 MILP 模型扩展为**随机仿真-滚动优化框架（Stochastic Simulation-Optimization Framework）**。

该框架包含两层循环：

1. **外层（场景生成）**：利用拉丁超立方采样（LHS）生成大量包含随机故障参数的场景集合 $\Omega$。
    
2. **内层（滚动执行）**：在每个仿真步长（年）中，根据当年的实际故障情况更新系统状态，并调用 MILP 求解器对剩余任务进行**再规划（Re-planning）**，模拟决策者对突发事件的适应性调整。
    

> **[Insert Figure 4: Flowchart of the Rolling Horizon Simulation Framework]**
> 
> _(注：此处需插入流程图。包含模块：场景生成 $\to$ 时间步进 $t$ $\to$ 注入随机故障 $\to$ 计算实际运量 & 损失 $\to$ 求解 MILP 更新剩余计划 $\to$ $t=t+1$ 循环)_

## 4.2 随机干扰建模 (Modeling of Disturbances)

我们将系统的不确定性分解为两类离散与连续随机变量。

### 4.2.1 火箭运输系统的离散故障

火箭发射被建模为伯努利过程（Bernoulli Process）。设 $p_i(t)$ 为第 $t$ 年基地 $i$ 的单次发射失败概率。引入随机变量 $\xi_{i,k}^t \sim \text{Bernoulli}(1 - p_i(t))$ 表示第 $k$ 次发射的状态（1为成功，0为失败）。

当发射失败（$\xi=0$）时，系统将遭受三重惩罚：

1. **运量损失**：该次发射的物资未能送达。
    
2. **经济惩罚**：产生额外成本 $\pi_i(t)$（包括火箭制造成本及货物价值损失）。
    
3. **时间惩罚**：发射台需进行事故调查与修复，导致该基地在 $d_{\text{repair}}$ 周内无法执行新任务。
    

修正后的基地年最大发射能力 $\tilde{L}_{i,t}$ 变为随机变量：

$$\tilde{L}_{i,t} = L_i - \sum_{k=1}^{N_{fail}} \lceil \frac{d_{\text{repair}}}{52} \cdot L_i \rceil$$

### 4.2.2 太空电梯系统的连续可用性

太空电梯受空间碎片、热胀冷缩或系绳摆动（Tether Swaying）影响，其运行状态呈现连续波动 。定义 $A_{SE}(t) \in (0, 1]$ 为第 $t$ 年的**可用率因子（Availability Factor）**。我们假设 $A_{SE}(t)$ 服从 Beta 分布，因其定义域有界且能灵活描述偏态分布：

$$A_{SE}(t) \sim \text{Beta}(\alpha, \beta)$$

实际运力上限修正为：

$$\tilde{C}_{SE}(t) = C_{SE}(t) \cdot A_{SE}(t)$$

同时，低可用率会导致维护成本非线性上升。修正后的运维成本函数为：

$$\tilde{f}_{SE}(t) = f_{SE} \cdot e^{\gamma (1 - A_{SE}(t))}$$

其中 $\gamma$ 为维护成本敏感度系数。

> **[Insert Table 5: Stochastic Parameters Setup]**
> 
> _(注：此处插入表格，列出 $p_i$ 的基准值（如 0.02）、$d_{\text{repair}}$（如 2周）、Beta分布参数 $\alpha, \beta$ 的设定值及其来源)_

## 4.3 滚动时域执行逻辑 (Rolling Horizon Execution)

为了模拟真实的运营管理，我们在每个时间步 $t$ 执行以下逻辑：

### 4.3.1 状态观测与执行

在 $t$ 年初，观测到随机向量 $\boldsymbol{\omega}_t = (\tilde{L}_{i,t}, \tilde{C}_{SE}(t))$。计算当年的实际运输量 $m^{real}_t$ 和实际累积成本 $Cost^{real}_t$：

$$m^{real}_t = \min(m^{plan}_t, \text{Capacity}(\boldsymbol{\omega}_t))$$

$$Cost^{real}_t = Cost^{plan}_t + \text{Penalty}(\text{Failures})$$

### 4.3.2 动态再规划 (Re-planning)

计算截止 $t$ 年末的剩余未完成需求：

$$M_{rem}(t+1) = M_{tot} - \sum_{\tau=t_0}^{t} m^{real}_\tau$$

若 $M_{rem}(t+1) > 0$，则以 $t+1$ 为新起点，以 $M_{rem}(t+1)$ 为新需求，调用 **Task 1 的 MILP 模型** 重新优化剩余年份的运输策略。这种机制确保了模型具有**自适应性（Adaptability）**，能够通过后期加速运输（如增加火箭班次）来弥补前期的延误。

## 4.4 鲁棒性度量指标 (Robustness Metrics)

通过 $N_{sim}$ 次蒙特卡洛仿真，我们获得完工时间 $\tilde{T}$ 和总成本 $\tilde{C}$ 的经验分布。采用以下指标评估方案的鲁棒性：

### 4.4.1 风险价值 (Value at Risk, VaR)

在置信水平 $(1-\alpha)$ 下（通常取 95%），系统可能面临的最大完工时间或成本边界：

$$\text{VaR}_{\alpha}(T) = \inf \{ t \in \mathbb{R} : P(\tilde{T} > t) \le \alpha \}$$

### 4.4.2 条件风险价值 (Conditional Value at Risk, CVaR)

用于评估尾部风险（即最坏情况下的平均损失）：

$$\text{CVaR}_{\alpha}(C) = E[\tilde{C} \mid \tilde{C} \ge \text{VaR}_{\alpha}(C)]$$

如果一个方案的 $\text{CVaR}$ 与均值差距较小，说明该方案在极端故障下依然保持稳定，即具有较强的鲁棒性。

> **[Insert Figure 5: Boxplot Comparison of Robustness]**
> 
> _(注：此处插入箱线图占位符。横轴为三种方案，纵轴为完工时间延迟量。展示混合方案的箱体最窄，意味着不确定性最低)_

> **[Insert Figure 6: Parameter Sensitivity Heatmap]**
> 
> _(注：此处插入热力图占位符。横轴为火箭失败率，纵轴为电梯可用率，颜色深浅代表成本超支比例)_

---

# 符号定义表 (Symbol Definition for Task 2)

以下表格整理了在 Task 2 随机模型中新引入的数学符号及其物理含义：

|**Symbol**|**Definition**|**Unit**|**Description**|
|---|---|---|---|
|**Random Variables**||||
|$\xi_{i,k}^t$|Launch Outcome|Binary|Bernoulli trial result: 1 (Success), 0 (Failure).|
|$\tilde{L}_{i,t}$|Effective Launch Cap|Launches/yr|Adjusted max launches considering repair downtime.|
|$A_{SE}(t)$|Availability Factor|[0, 1]|Percentage of operational time for Space Elevator.|
|$\tilde{C}_{SE}(t)$|Effective SE Capacity|Tons/yr|Realized capacity after accounting for disturbances.|
|**Parameters**||||
|$p_i(t)$|Failure Probability|-|Probability of a single rocket launch failure.|
|$\pi_i(t)$|Failure Penalty|USD|Financial cost incurred per failed launch.|
|$d_{\text{repair}}$|Repair Duration|Weeks|Downtime of a launch pad after an accident.|
|$\alpha, \beta$|Shape Parameters|-|Parameters for the Beta distribution of $A_{SE}$.|
|$\gamma$|Cost Sensitivity|-|Coefficient for nonlinear O&M cost increase.|
|**Metrics**||||
|$m^{real}_t$|Realized Transport|Tons|Actual mass transported in year $t$ under uncertainty.|
|$M_{rem}(t)$|Remaining Demand|Tons|Unfulfilled demand needed to be planned for $t+1 \dots H$.|
|$\text{VaR}_{\alpha}$|Value at Risk|Years / USD|The threshold value at risk level $\alpha$ (e.g., 95%).|
|$\text{CVaR}_{\alpha}$|Conditional VaR|Years / USD|Expected loss exceeding the VaR threshold (Tail Risk).|
