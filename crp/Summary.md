# 现代格密码学基础与核心系统架构

本文档系统性地梳理了现代格密码（Lattice-Based Cryptography）的核心理论与应用架构。全篇按照从直觉概念到严格数学定义的逻辑递进，涵盖底层格几何问题、平均情况困难假设（SIS/LWE 及其环变体），以及基于这些假设构建的两类核心公钥加密系统。

## 1. 格（Lattice）的基本定义

### 1.1 直观几何理解

在直觉层面，格可以被视作无限延伸的、具有周期性规律的离散点阵。在二维平面中，它类似于无限拼接的方格纸或壁纸的交点；在三维空间中，则类似于晶体结构中的原子排列。格的核心几何特征在于其**离散性**和**周期平移性**。

### 1.2 严格数学定义

给定 $n$ 维实数空间 $\mathbb{R}^n$ 中的 $k$ 个线性无关的向量构成的基底 $\mathbf{B} = \{\mathbf{b}_1, \dots, \mathbf{b}_k\}$，由该基底生成的格 $\mathcal{L}(\mathbf{B})$ 定义为这些向量的所有**整系数线性组合**的集合：

$$\mathcal{L}(\mathbf{B}) = \left\{ \sum_{i=1}^k z_i \mathbf{b}_i : z_i \in \mathbb{Z} \right\} = \mathbf{B} \cdot \mathbb{Z}^k$$

在密码学中，通常只讨论满秩格（Full-rank Lattice），即 $k=n$ 的情况。

格的基本域（Fundamental Parallelepiped）$\mathcal{P}(\mathbf{B})$ 定义为由基底张成的半开半闭多面体。空间中的任意点均可唯一地分解为一个格点与一个落在基本域内的残差向量之和。

## 2. 核心底层几何问题（最坏情况硬度）

密码学的安全性必须建立在公认的数学难题之上。在格理论中，最核心的难题是寻找极度倾斜、高维空间下的特定几何点。这些问题构成了整个格密码学最底层的“最坏情况（Worst-case）”安全基石。

### 2.1 最短向量问题（SVP, Shortest Vector Problem）

- **直觉**：在杂乱无章的无限点阵中，找到距离原点最近的那一个点。
    
- **数学描述**：给定格 $\mathcal{L}$ 的任意基底 $\mathbf{B}$，寻找一个非零向量 $\mathbf{v} \in \mathcal{L}$，使得其欧几里得范数 $||\mathbf{v}|| = \lambda_1(\mathcal{L})$，其中 $\lambda_1$ 为格的第一连续极小值。
    
- **放宽变体**：近似最短向量问题（$SVP_\gamma$）要求寻找长度不超过 $\gamma(n) \cdot \lambda_1(\mathcal{L})$ 的向量。决策版本（$GapSVP_\gamma$）则要求区分最短向量是极短还是极长。
    

### 2.2 有界距离译码问题（BDD, Bounded Distance Decoding）

- **直觉**：空间中有一个不在格点上的“靶点”，已知它非常靠近某个具体的格点，求该格点。
    
- **数学描述**：给定格的基底 $\mathbf{B}$ 和目标点 $\mathbf{t} \in \mathbb{R}^n$，并承诺目标点距离格的距离 $dist(\mathbf{t}, \mathcal{L}) < d$（$d$ 足够小以保证解的唯一性），求距离 $\mathbf{t}$ 最近的格点 $\mathbf{v}$。
    

## 3. 现代基础：平均情况困难问题（SIS 与 LWE）

直接使用 SVP 或 BDD 构造密码系统存在致命缺陷：难以生成“平均情况下同样困难”的公私钥对。Ajtai 与 Regev 的突破在于引入了定义在随机 $q$-ary 格上的平均情况问题，并证明了它们与最坏情况格问题在计算复杂性上的等价性。

### 3.1 短整数解问题（SIS, Short Integer Solution）

- **直觉理解**：给定一堆随机的数字（或向量），在其中挑出几个，使它们的和正好是特定模数 $q$ 的倍数。
    
- **数学定义**：给定 $m$ 个均匀随机的向量 $\mathbf{a}_i \in \mathbb{Z}_q^n$ 构成的矩阵 $\mathbf{A} \in \mathbb{Z}_q^{n \times m}$。寻找一个非零向量 $\mathbf{z} \in \mathbb{Z}^m$，满足：
    
    $$\mathbf{A}\mathbf{z} = \mathbf{0} \pmod q \quad \text{且} \quad ||\mathbf{z}|| \le \beta$$
    
- **几何本质**：这是在寻找由平价校验矩阵 $\mathbf{A}$ 定义的随机 $q$-ary 格 $\mathcal{L}^\perp(\mathbf{A})$ 中的短向量（即平均情况下的 SVP 问题）。
    
- **归约逻辑**：在多项式时间内以不可忽略的概率求解 SIS 问题，等价于求解任意 $n$ 维一般格上的最坏情况 $GapSVP$ 和独立最短向量问题（$SIVP$）。
    

### 3.2 容错学习问题（LWE, Learning With Errors）

- **直觉理解**：求解一个带有一点点计算误差的线性方程组。如果没有误差，通过高斯消元法瞬间即可解出；但引入微小的随机高斯误差后，问题变得极其困难。
    
- **数学定义**：给定一个均匀随机的秘密向量 $\mathbf{s} \in \mathbb{Z}_q^n$。LWE 样本由对 $(\mathbf{a}_i, b_i)$ 构成，其中 $\mathbf{a}_i \in \mathbb{Z}_q^n$ 是均匀随机的，且：
    
    $$b_i = \langle \mathbf{s}, \mathbf{a}_i \rangle + e_i \pmod q$$
    
    其中 $e_i \in \mathbb{Z}$ 是从误差分布 $\chi$（通常为离散高斯分布）中采样的微小噪声。
    
    - **搜索 LWE (Search-LWE)**：给定 $m$ 个样本，求秘密 $\mathbf{s}$。
        
    - **决策 LWE (Decision-LWE)**：区分给定的 $m$ 个样本是来源于真实的 LWE 分布，还是完全均匀随机生成的数。
        
- **几何本质**：LWE 的实质是在 $\mathcal{L}^\perp(\mathbf{A})$ 的对偶格 $\mathcal{L}(\mathbf{A})$ 上解决有界距离译码（BDD）问题。
    
- **归约逻辑**：Regev 证明了，求解具有误差率 $\alpha$ 的 LWE 问题，至少与求解任意一般格上的 $GapSVP_{\tilde{O}(n/\alpha)}$ 等价。
    

### 3.3 代数演进：Ring-SIS 与 Ring-LWE

- **演进动机**：标准的 SIS 和 LWE 需要传输和存储庞大的矩阵 $\mathbf{A}$，导致公钥尺寸呈二次方 $\tilde{O}(n^2)$ 增长，运算效率极低。
    
- **机制转换**：将基础代数结构从向量空间 $\mathbb{Z}_q^n$ 转移到多项式环 $R_q = \mathbb{Z}_q[X]/(f(X))$ 上。
    
    - 一个环元素 $a \in R_q$ 可以自然地表示 $n$ 个相互关联的向量（类似于循环矩阵的列）。
        
    - 计算机制从“矩阵-向量乘法”转换为“多项式乘法”，可以通过快速傅里叶变换（FFT）在 $\tilde{O}(n)$ 的准线性时间内完成。
        
- **结果**：密钥尺寸降低至 $\tilde{O}(n)$，运算速度呈指数级优化，但底层硬度假设相应变为了理想格（Ideal Lattices）上的最坏情况问题。
    

## 4. 核心密码学构造：两套 LWE 加密系统

基于 Decision-LWE 假设的不可区分性，格密码学衍生出了两套互为代数对偶的主流公钥加密体系。

### 4.1 Regev 加密方案（基础 PKE）

该方案的公钥蕴含了特定的 LWE 结构，直接将明文叠加在 LWE 样本之上。

- **系统生成**：
    
    - **私钥 (SK)**：随机抽样的 $\mathbf{s} \in \mathbb{Z}_q^n$。
        
    - **公钥 (PK)**：矩阵 $\mathbf{A} \in \mathbb{Z}_q^{n \times m}$ 与 LWE 样本向量 $\mathbf{b}^t = \mathbf{s}^t \mathbf{A} + \mathbf{e}^t \pmod q$。
        
- **加密 (Encrypting $\mu \in \{0,1\}$)**：
    
    使用随机二元短向量 $\mathbf{r} \in \{0, 1\}^m$ 作为随机性，输出密文 $\mathbf{CT} = (\mathbf{u}, v)$：
    
    $$\mathbf{u} = \mathbf{A}^T \mathbf{r} \pmod q$$
    
    $$v = \mathbf{b}^T \mathbf{r} + \mu \cdot \lfloor q/2 \rfloor \pmod q$$
    
- **解密 (Decrypting)**：
    
    计算代数投影 $d = v - \mathbf{u}^T \mathbf{s} \pmod q$。
    
    - _数学机理_：$d = (\mathbf{s}^T\mathbf{A}\mathbf{r} + \mathbf{e}^T\mathbf{r} + \mu \lfloor q/2 \rfloor) - (\mathbf{A}^T\mathbf{r})^T\mathbf{s} = \mathbf{e}^T\mathbf{r} + \mu \lfloor q/2 \rfloor$。
        
    - 由于 $\mathbf{e}$ 和 $\mathbf{r}$ 都极短，合成噪声 $\mathbf{e}^T\mathbf{r}$ 的幅度远小于 $q/4$。此时若 $d$ 接近 $0$，则 $\mu=0$；若接近 $q/2$，则 $\mu=1$。
        
- **安全逻辑（Lossiness Argument）**：若将公钥中的 $\mathbf{b}$ 替换为纯随机数（基于 Decision-LWE 假设），则密文成分 $v$ 也变为纯随机数。此时明文信息在信息论层面上被完全抹除。
    

### 4.2 Dual LWE 加密方案（高级应用基石）

对偶方案反转了公钥结构：公钥是纯随机数，而加密后的密文变成了一组 LWE 样本。该特性使其成为基于身份加密（IBE）等高级协议的基础。

- **系统生成**：
    
    - **公钥 (PK)**：纯均匀随机矩阵 $\overline{\mathbf{A}}$ 与纯随机向量 $\mathbf{u}$ 拼接成的矩阵 $\mathbf{A} = [\overline{\mathbf{A}} \mid \mathbf{u}]$。
        
    - **私钥 (SK)**：满足 $\overline{\mathbf{A}}\mathbf{x} = \mathbf{u} \pmod q$ 的特定低范数短向量 $\mathbf{x}$。
        
- **加密 (Encrypting $\mu \in \{0,1\}$)**：
    
    采样随机 LWE 秘密 $\mathbf{s}$ 与短噪声 $\mathbf{e}$，将密文 $\mathbf{c}$ 构造为对偶方向的 LWE 结构：
    
    $$\mathbf{c}^t = \mathbf{s}^t \mathbf{A} + \mathbf{e}^t + (0, \dots, 0, \mu \cdot \lfloor q/2 \rfloor) \pmod q$$
    
- **解密 (Decrypting)**：
    
    接收方利用私钥结构，计算内积以消除 $\mathbf{s}$：
    
    $$d = \mathbf{c}^t \cdot \begin{pmatrix} -\mathbf{x} \\ 1 \end{pmatrix} \pmod q$$
    
    - _数学机理_：$\mathbf{s}^t \mathbf{A} \begin{pmatrix} -\mathbf{x} \\ 1 \end{pmatrix} = \mathbf{s}^t (-\overline{\mathbf{A}}\mathbf{x} + \mathbf{u}) = \mathbf{0}$。带有秘密 $\mathbf{s}$ 的大数项完全相消，仅残留短噪声组合与明文编码项。
        
    - 通过判定 $d$ 是趋向于 $0$ 还是 $q/2$ 完成解调。
        
- **体系价值**：在此框架中，公钥 $\mathbf{A}$ 毫无代数特征，这意味着可以通过哈希函数将用户的 ID 映射为公钥向量 $\mathbf{u}_{id}$，然后由可信中心利用格陷门技术（Lattice Trapdoor）为其反向采样并配发相应的短私钥解 $\mathbf{x}_{id}$，从而原生实现无需分发公钥的 IBE 体系。