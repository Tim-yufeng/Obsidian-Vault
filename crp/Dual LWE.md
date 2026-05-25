为了让你彻底、清晰地掌握 **5.2.2 对偶 LWE 加密方案（Dual LWE Cryptosystem）** ，我们抛开所有抽象的渐近符号，**严格以加密一个比特 $\mu \in \{0, 1\}$ 为例** ，重新进行全流程的代数推导与几何原理解析。

## 1. 核心实体定义说明（密码系统的四大要素）

在维度为 $n$、格样本数为 $m$、模数为 $q$，且拥有离散高斯噪声分布 $\chi$ 的系统参数下，各实体定义如下：

- **明文（Plaintext）**：
    
    - $\mu \in \{0, 1\}$（单个比特信息） 。
        
- **公钥（Public Key, PK）**：
    
    - 由一个均匀随机矩阵 $\mathbf{\overline{A}} \in \mathbb{Z}_q^{n \times m}$ 和一个均匀随机向量 $\mathbf{u} \in \mathbb{Z}_q^n$ 拼装而成 。
        
    - 为了后续矩阵相乘书写方便，我们将其横向横向拼接为矩阵 $\mathbf{A}$ ：
        
        $$\mathbf{A} = [\mathbf{\overline{A}} \mid \mathbf{u}] \in \mathbb{Z}_q^{n \times (m+1)}$$
        
- **密钥（Secret Key, SK）**：
    
    - 一个由小整数（或二元数字）组成的**短列向量** $\mathbf{x} \in \mathbb{Z}^m$（或者是书中常设的 $\mathbf{x} \in \{0, 1\}^m$） 。
        
    - 它与公钥之间必须满足特定的线性非齐次组合关系：
        
        $$\mathbf{\overline{A}}\mathbf{x} = \mathbf{u} \pmod q \quad \text{[cite: 788]}$$
        
- **密文（Ciphertext, CT）**：
    
    - 一个长度为 $m+1$ 的**长行向量** $\mathbf{c}^t \in \mathbb{Z}_q^{m+1}$ 。为了便于解密拆账，我们可以将其天然切分为两部分 ：
        
        $$\mathbf{c}^t = [\mathbf{\overline{c}}^t \mid v]$$
        
        其中，$\mathbf{\overline{c}}^t \in \mathbb{Z}_q^m$ 是前 $m$ 个分量组成的行向量，$v \in \mathbb{Z}_q$ 是最后一个分量（标量） 。
        

## 2. 方案全流程运行机制（比特级详解）

### 🔓 步骤 1：密钥生成（KeyGen）—— 接收方运行

1. 接收方在本地选择（或使用陷门算法生成）一个均匀随机的矩阵 $\mathbf{\overline{A}}$ 。
    
2. 在本地采样一个低范数的短秘密向量 $\mathbf{x}$ 。
    
3. 计算出对应的公钥标靶向量 $\mathbf{u} = \mathbf{\overline{A}}\mathbf{x} \pmod q$ 。
    
4. 对外公开发布 $\mathbf{PK} = (\mathbf{\overline{A}}, \mathbf{u})$ ，自己在本地保留并秘密存储 $\mathbf{SK} = \mathbf{x}$ 。
    

### 🔒 步骤 2：加密（Encryption）—— 发送方运行

发送方获取到公钥 $\mathbf{PK}$，准备加密单个比特明文 $\mu \in \{0, 1\}$ ：

1. **采样 LWE 秘密**：在本地均匀随机采样一个高维度的秘密向量 $\mathbf{s} \in \mathbb{Z}_q^n$ 。
    
2. **采样高斯噪声**：从第四节所述的离散高斯分布 $\chi$ 中，独立采样 $m+1$ 个极小的短噪声，组成一个噪声行向量 $\mathbf{e}^t = [\mathbf{\overline{e}}^t \mid e_{last}] \in \mathbb{Z}^{m+1}$ 。其中 $\mathbf{\overline{e}}^t \in \mathbb{Z}^m$ 为前 $m$ 个分量，$e_{last} \in \mathbb{Z}$ 为最后一个分量 。
    
3. **构建密文向量**：利用矩阵乘法，分别计算密文的两个切片 ：
    
    - **前 $m$ 个密文分量**：$\mathbf{\overline{c}}^t = \mathbf{s}^t \mathbf{\overline{A}} + \mathbf{\overline{e}}^t \pmod q$
        
    - **最后一个密文分量**：$v = \mathbf{s}^t \mathbf{u} + e_{last} + \mu \cdot \left\lfloor \frac{q}{2} \right\rfloor \pmod q$
        
4. 组合出最终发出的长行向量密文传递给接收方 ：
    
    $$\mathbf{c}^t = [\mathbf{\overline{c}}^t \mid v] = \left[ (\mathbf{s}^t \mathbf{\overline{A}} + \mathbf{\overline{e}}^t) \ \;\middle|\;\ \left(\mathbf{s}^t \mathbf{u} + e_{last} + \mu \cdot \left\lfloor \frac{q}{2} \right\rfloor\right) \right] \pmod q$$
    

### 🔑 步骤 3：解密（Decryption）—— 接收方运行

接收方收到长向量密文 $\mathbf{c}^t = [\mathbf{\overline{c}}^t \mid v]$，祭出其本地保存的短秘密向量 $\mathbf{x}$ 展开内积解调 ：

1. **几何投影解算**：接收方直接计算代数指标 $d$ ：
    
    $$d = v - \mathbf{\overline{c}}^t \mathbf{x} \pmod q \quad \text{[cite: 797]}$$
    
2. **判定输出**：
    
    - 如果计算出来的数字 $d \pmod q$ 落在离 $0$ 极近的几何区间（例如 $\left[- \frac{q}{4}, \frac{q}{4}\right)$），则判定并输出明文 **$\mu = 0$** 。
        
    - 如果计算出来的数字 $d \pmod q$ 落在离 $\lfloor q/2 \rfloor$ 极近的几何区间，则判定并输出明文 **$\mu = 1$** 。
        

## 3. 核心数学原理是什么？

为什么这样一个看似毫无章法的解密公式 $d = v - \mathbf{\overline{c}}^t \mathbf{x}$ 能准确还原出比特 $\mu$ 呢 ？我们来看它的**代数代换过程**与**格几何原理**。

### 🧮 代数相消原理（为什么含有 $\mathbf{s}$ 的大数会消失？）
s
我们将加密时生成的密文公式，直接代入到解密方程 $d = v - \mathbf{\overline{c}}^t \mathbf{x}$ 中 ：

$$\begin{aligned}

d &= v - \mathbf{\overline{c}}^t \mathbf{x} \
\\
&= \left( \mathbf{s}^t \mathbf{u} + e_{last} + \mu \cdot \left\lfloor \frac{q}{2} \right\rfloor \right) - \left( \mathbf{s}^t \mathbf{\overline{A}} + \mathbf{\overline{e}}^t \right) \mathbf{x} \pmod q & \text{（代入加密密文）} \
\\
&= \mathbf{s}^t \mathbf{u} + e_{last} + \mu \cdot \left\lfloor \frac{q}{2} \right\rfloor - \mathbf{s}^t \mathbf{\overline{A}} \mathbf{x} - \mathbf{\overline{e}}^t \mathbf{x} \pmod q & \text{（将右边的减法项分配展开）}

\end{aligned}$$

此时，注意到密钥生成的根本代数因果：$\mathbf{\overline{A}}\mathbf{x} = \mathbf{u}$ 。于是，我们可以把上面第三项里的 $\mathbf{\overline{A}} \mathbf{x}$ 完美替换为 $\mathbf{u}$ ：

$$\begin{aligned} d &= \mathbf{s}^t \mathbf{u} + e_{last} + \mu \cdot \left\lfloor \frac{q}{2} \right\rfloor - \mathbf{s}^t (\mathbf{u}) - \mathbf{\overline{e}}^t \mathbf{x} \pmod q \\ \text{（代换：} \mathbf{\overline{A}}\mathbf{x} \to \mathbf{u} \text{） } \ &= \mathbf{s}^t \mathbf{u} - \mathbf{s}^t \mathbf{u} + \mu \cdot \left\lfloor \frac{q}{2} \right\rfloor + e_{last} - \mathbf{\overline{e}}^t \mathbf{x} \pmod q \\ \text{（调换项的顺序）} \ &= \mu \cdot \left\lfloor \frac{q}{2} \right\rfloor + (e_{last} - \mathbf{\overline{e}}^t \mathbf{x}) \pmod q  \text{（大数项相减归零，完全消失）} \end{aligned}$$

至此，**包含绝对机密的伪随机项 $\mathbf{s}^t \mathbf{u}$ 被完全消去**。解密得到的数字仅由两部分组成：

$$d = \text{明文编码信号 } \left( \mu \cdot \left\lfloor \frac{q}{2} \right\rfloor \right) + \text{复合积噪 } e_{new} \pmod q$$

其中复合积噪 $e_{new} = e_{last} - \mathbf{\overline{e}}^t \mathbf{x}$ 。

### 📐 格几何原理解析（为什么噪声干扰不影响判定？）

最后一步能够解调成功的关键，在于第二节所铺垫的**格空间有界距离（Bounded Distance）容噪性质** 。

因为在密码系统的初始化中，公钥中噪声 $\mathbf{e}$ 提取自小高斯分布，其每一个分量都极小 ；而接收方的私钥 $\mathbf{x}$ 也是一个极短的二元向量（每个元素只有 0 或 1） 。 这就导致了它们的内积复合噪声 $e_{new} = e_{last} - \mathbf{\overline{e}}^t \mathbf{x}$ 的**代数振幅依然被死死限制在一个极小的绝对范数范围内**（即 $\left|e_{new}\right| [cite_start]\ll \frac{q}{4}$） 。

我们站在模 $q$ 的一维几何圆环上来看这个判定结果 ：

- **当明文 $\mu = 0$ 时**： 解密结果 $d = 0 + e_{new} = e_{new} \pmod q$ 。由于 $e_{new}$ 极小，这个点会紧紧环绕在圆环的 $0$（或原点）周围。
    
- **当明文 $\mu = 1$ 时**： 解密结果 $d = \lfloor q/2 \rfloor + e_{new} \pmod q$ 。这个点会紧紧环绕在**圆环正对面的 $\lfloor q/2 \rfloor$** 周围 。
    

因为这两种信号在格空间中的编码距离被拉到了最大（相距 $q/2$） ，且噪声膨胀产生的几何位移远远不足以跨越 $\pm q/4$ 的分水岭边界 ，所以接收方只需看解密指标 $d$ 在圆环上离谁更近，就能以 $100\%$ 的确定性将原始比特 $\mu$ 丝毫不差地剥离并还原出来 。