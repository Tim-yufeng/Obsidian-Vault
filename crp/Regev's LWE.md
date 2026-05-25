为了彻底理清 Peikert 书中第 5.2.1 节介绍的基于 LWE 的被动安全加密方案（即经典 Regev 加密方案的对偶形式或其标准变体），我们需要从**数学实体定义**和**实际运行流程**两个维度进行拆解。

书中 5.2.1 节的核心思想是：**利用 LWE 样本的伪随机性来隐藏（Encrypt）明文信息**。

### 一、 LWE 加密方案中的三大核心实体

在 $n$ 维安全参数、模数 $q$、以及误差分布 $\chi$（通常为离散高斯分布）下，各实体的数学定义如下：

#### 1. 密钥（Secret Key, SK）

- **数学形式**：一个随机向量 $\mathbf{s} \in \mathbb{Z}_q^n$（有时为了优化也会从误差分布 $\chi^n$ 中采样）。
    
- **物理意义**：这是只有解密方知道的隐秘线性组合系数。
    

#### 2. 公钥（Public Key, PK）

公钥由一个随机矩阵和一组带有 LWE 噪声的向量组合而成，公开给所有人用于加密。

- **数学形式**：$\mathbf{PK} = (\mathbf{A}, \mathbf{b})$
    
    - $\mathbf{A} \in \mathbb{Z}_q^{m \times n}$：一个完全均匀随机采样的公共矩阵（通常 $m \approx n \log q$）。
        
    - $\mathbf{b} \in \mathbb{Z}_q^m$：基于密钥 $\mathbf{s}$ 生成的 LWE 观测向量：
        
        $$\mathbf{b} = \mathbf{A}\mathbf{s} + \mathbf{e} \pmod q$$
        
        其中 $\mathbf{e} \in \mathbb{Z}^m$ 是从小误差分布 $\chi^m$ 中独立采样出来的噪声向量。
        
- **安全性原理**：根据第四节的 Decision-LWE 假设，在不知道 $\mathbf{s}$ 和 $\mathbf{e}$ 的情况下，对偶空间外的观察者无法将 $\mathbf{b}$ 与一个纯随机向量区分开来。因此 $\mathbf{PK}$ 看起来就像一堆随机数。
    

#### 3. 密文（Ciphertext, CT）

假设我们要加密一个全明文比特向量（或单个比特，为表述清晰，此处以加密单个明文比特 $\mu \in \{0, 1\}$ 为例）。

- **数学形式**：$\mathbf{CT} = (\mathbf{u}, v)$
    
    - $\mathbf{u} \in \mathbb{Z}_q^n$：抽样组合后的混淆向量。
        
    - $v \in \mathbb{Z}_q$：载有明文信息的标量。
        
- **计算公式**：加密方随机采样一个短“随机性（Randomness）”向量 $\mathbf{r} \in \{-1, 0, 1\}^m$（或从特定短分布采样），然后计算：
    
    $$\mathbf{u} = \mathbf{A}^T \mathbf{r} \pmod q$$
    
    $$v = \mathbf{b}^T \mathbf{r} + \mu \cdot \left\lfloor \frac{q}{2} \right\rfloor \pmod q$$
    
- **核心技巧**：$\mu \cdot \lfloor q/2 \rfloor$ 被称为**编码（Encoding）**。当 $\mu=0$ 时，编码为 $0$；当 $\mu=1$ 时，编码为 $q/2$（模 $q$ 空间中距离 $0$ 最远的点）。这为容忍噪声留出了最大的几何空间。
    

### 二、 实际应用中的全流程运行机制

在实际系统中，整个加密通信流程分为四个阶段：**系统初始化、密钥生成、加密、解密**。

```
【密钥生成方】                               【加密发送方】
  1. 采样 s, e, A
  2. 计算 b = As + e
  3. 发布 PK=(A, b)  ──────── 公钥公开 ───────► 1. 准备明文 μ ∈ {0,1}
                                               2. 采样短向量 r
                                               3. 计算 u = Aᵀr, v = bᵀr + μ·⌊q/2⌋
                     ◄─────── 传送密文(u, v) ── 4. 发送 CT=(u, v)
【解密接收方】
  4. 计算 d = v - uᵀs
  5. 解调判断 d 靠近 0 还是 q/2
  6. 恢复出 μ
```

#### 阶段 1：系统初始化（Setup）

双方（或标准协议）确定全局参数：维度 $n$、样本数 $m$、大素数 $q$ 以及高斯噪声标准差 $\sigma$。公共矩阵 $\mathbf{A}$ 可以在此时通过公共随机数生成器（如配置了统一种子的 SHAKE-256）直接生成，所有人共享，无需重复传输。

#### 阶段 2：密钥生成（KeyGen）—— 接收方运行

1. 接收方在本地随机生成 $\mathbf{s}$。
    
2. 采样高斯短噪声 $\mathbf{e}$。
    
3. 计算 $\mathbf{b} = \mathbf{A}\mathbf{s} + \mathbf{e} \pmod q$。
    
4. 将 $\mathbf{PK} = (\mathbf{A}, \mathbf{b})$ 写入公钥证书发给发送方，本地妥善保存 $\mathbf{s}$ 作为私钥。
    

#### 阶段 3：加密（Encryption）—— 发送方运行

若发送方想要传送明文 $\mu \in \{0, 1\}$：

1. 产生一个随机的低范数向量 $\mathbf{r}$。
    
2. 计算密文的第一部分 $\mathbf{u} = \mathbf{A}^T \mathbf{r}$。
    
3. 计算密文的第二部分 $v = \mathbf{b}^T \mathbf{r} + \mu \cdot \lfloor q/2 \rfloor$。
    
4. 将密文包裹 $\mathbf{CT} = (\mathbf{u}, v)$ 通过网络公开传送给接收方。
    

#### 阶段 4：解密（Decryption）—— 接收方运行

接收方收到 $(\mathbf{u}, v)$ 后，利用私钥 $\mathbf{s}$ 进行**解调（Demodulation）**：

1. **内部代数展开**：接收方计算 $d = v - \mathbf{u}^T \mathbf{s} \pmod q$。
    
    我们来看这个 $d$ 里面究竟装了什么：
    
    $$\begin{aligned}
    
    d &= v - \mathbf{u}^T \mathbf{s} \
    
    &= (\mathbf{b}^T \mathbf{r} + \mu \cdot \lfloor q/2 \rfloor) - (\mathbf{A}^T \mathbf{r})^T \mathbf{s} \
    
    &= (\mathbf{s}^T \mathbf{A} + \mathbf{e}^T)\mathbf{r} + \mu \cdot \lfloor q/2 \rfloor - \mathbf{r}^T \mathbf{A} \mathbf{s} \
    
    &= \mathbf{s}^T \mathbf{A} \mathbf{r} + \mathbf{e}^T \mathbf{r} + \mu \cdot \lfloor q/2 \rfloor - \mathbf{s}^T \mathbf{A} \mathbf{r} \
    
    &= \mathbf{e}^T \mathbf{r} + \mu \cdot \lfloor q/2 \rfloor \pmod q
    
    \end{aligned}$$
    
2. **消去格点项，提取残差**：你会发现，含有秘密的线性组合项 $\mathbf{s}^T \mathbf{A} \mathbf{r}$ 被完美抵消了。最后剩下的结果，就是第二节所说的**模基本域运算的几何具象**。解密结果等于：
    
    $$d = \text{新噪声 } e_{new} + \text{编码信号 } (\mu \cdot \lfloor q/2 \rfloor)$$
    
    其中 $e_{new} = \mathbf{e}^T \mathbf{r}$。因为 $\mathbf{e}$ 和 $\mathbf{r}$ 都是极短的向量，它们的内积 $e_{new}$ 在模 $q$ 的意义下依然是一个非常小的扰动（远小于 $q/4$）。
    
3. **判定输出**：
    
    - 如果 $\mu = 0$，则 $d = e_{new}$，它会高度精准地**紧靠在 $0$ 附近**。
        
    - 如果 $\mu = 1$，则 $d = q/2 + e_{new}$，它会高度精准地**紧靠在 $q/2$ 附近**。
        
    - 接收方只需看 $d$ 在代数几何圆环上更接近谁：如果 $d$ 落在 $[-q/4, q/4)$ 范围内，判定 $\mu = 0$；否则判定 $\mu = 1$。由此成功恢复出原始明文。