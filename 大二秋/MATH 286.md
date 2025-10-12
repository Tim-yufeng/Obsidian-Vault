# Foundational Results of Calculus and Linear Algebra
## Inverse Function Theorem
Definition{.blue .bold}  
Let (X ;  · ) be a ==complete==, normed vector space and $M\subset X$ a closed set. 
A function f : M → M is said to be a ==contraction mapping== if there exists ==a number C < 1== such that
$$|| f(x)-f(y) || \le C \cdot || x-y ||$$   
for all x, y $\in$ M.   

由此可以推知，一个contraction的函数是continuous的。

Contraction Mapping Principle{.red .bold}
接续上面的条件，如果 $f$ 是一个==contraction==，那么==唯一存在==一个 fixed point（不动点）$x_0 \in M$，that $f(x_0)=x_0$。
进一步的，我们可以用递归的方式定义这样一个数列，$a_0:=x$, $a_{n+1}:=f(a_n)$, $n\in \mathrm{N}$,  那么这个数列一定收敛到$x_0$, 即：
$$\lim_{n \to \infty} a_n = x_0$$

Definition{.blue .bold} 
![[Pasted image 20250917131418.png]]  
其中我们称 $f$ 是 locally invertible at $x_0 \in \Omega$ 的，如果==存在== $\epsilon >0$ , that $f: B_{\epsilon}(x_0)\longrightarrow Y$ 在这个==开球==上是invertible的 . 

（==实际上就是多维情景下对可逆的最朴素认知==）

连续可导的函数集合我们表示为 $C^1(\Omega, Y)$, 类似的，一个连续可导函数$f\in C^1(\Omega, Y)$, 如果在 $\Omega$ 上是可逆的，而且其逆函数 $f^{-1}$ 也是连续可导的，那么我们称 $f$ 是 <span class="red">$C^1-\text{invertible}\;\text{on}\;\Omega$ </span>的。  

类似的， 如果是在一个小开球内满足可逆且逆函数连续可导，就是<span class="red">locally $C^1-\text{invertible}\;\text{on}\;\Omega$ </span>

Remark:
- 在区间 $\Omega$ 的每一点处均locally invertible, 不一定在区间 $\Omega$ 上就是invertible 的
- 存在连续可导的且可逆的函数，但是逆函数却不是连续可导的

Lemma{.red .bold}
![[Pasted image 20250917140229.png]]  

首先可以证明下方这个酷似泰勒展开的式子的准确性，由于GL(X)是一个群，其元素相乘相加依然属于该集合，因此证明了：只要线性映射$L$满足 $||L||<1$，那么$1-L$就是可逆的。进而可以证明GL(X)是开集。

接下来登场的就是本小节的主角，多元函数下的逆函数定理：
![[Pasted image 20250917142336.png]]  
如何理解这个定理？首先从一维下的逆函数定理入手，我们知道，对于一个连续可导的一维函数$f$, 如果在点$x_0$处该函数导数值不为0，即$f'(x_0)\ne 0$，那么$f$在$x_0$附近时单调的，所以存在一个局部的逆函数，而且这个逆函数也是连续可导的，其导函数满足公式：
$$ (f^{-1})'(f(x_0))=\frac{1}{f'(x_0)} $$
那么回到多元情形，如果一个连续可导的多元函数$f$, 其导函数$Df|_{x_0}$是可逆的，也即是说，其雅可比矩阵的行列式不等于0，那么这个矩阵当然是可逆的，于是这个定理告诉我们，函数$f$在该点处局部可逆且逆函数连续可导，这个局部的逆函数，的导函数，就是$Df|_{x_0}$雅可比矩阵的逆矩阵：
$$ Df^{-1}|_{f(x)}=(Df|_x)^{-1} \in L(Y, X) $$

下面这个例子展示了，一方面处处局部可逆不一定全局可逆，另一方面也展示了求出逆函数的导函数也许很简单，甚至比找到逆函数本身都要容易许多：
![[Pasted image 20250917144227.png]]  
![[Pasted image 20250917144240.png]]  

- **关于“locally invertible”**
    
    - 条件是 $Df(x_0)$ 可逆（即雅可比行列式非零），这个只保证局部单射和可逆。
        
    - **注意**：局部可逆 ≠ 全局可逆。比如 $\sin x$ 在 $x=0$ 附近可逆，但在全体 $\mathbb{R}$ 上不是。
        
- **关于“存在连续可导且可逆，但逆函数不是连续可导”的例子**
    
    - 一个常见例子是  
        $f(x)=x^3,\, \quad x\in \mathbb{R}$  
        它的逆函数是  
        $f^{-1}(x) = \sqrt[3]{x}​$
        $f$ 是 $C^1$ 且可逆，但 $f^{-1}$ 在 $x=0$ 处不可导（甚至连续可导性都失败）。
        
- **直观理解**
    
    - 一维下条件是 $f'(x_0)\neq 0$，因为导数非零意味着函数在局部严格单调。
        
    - 多维下条件是 $\det Df(x_0)\neq 0$，因为 Jacobian 可逆意味着函数在局部不会“压缩”维度，保留了足够的信息。
## Implicit Function Theorem

一个形如 $(x, y)\in \mathrm{R}^2$, $F(x, y)=0$ 的曲线称为 **implicitly defined by $F$**. 
形如 $(x, y)\in \mathrm{R}^2$, $y=g(x)$ 或者 $(x, y)\in \mathrm{R}^2$, $x=g(y)$ 的表示方式称为 **explicitly representation**

整个曲线无法被表示为 explicitly representation，但是也许locally可以，即在曲线上每一点处都截取一小段表示为显函数。

以一个二维曲线单位圆为例，我们可以在所有**切线斜率不为零**的地方找到 locally explicitly representation: 
![[Pasted image 20250919092103.png]]  
切线斜率不为零是存在$y=g(x)$ 表示的条件（准确来讲应该是选区的一小段区域$\Omega$不能包含切线斜率为零的点），这一条件可以表示为：
$$\frac{\partial F}{\partial y} \ne 0$$ 一条曲线可能存在某些点，$y=g(x)$ 和$x=g(y)$ 都不存在。

![[Pasted image 20250919093327.png]]
多元函数的输出可以看作是对其代表的曲线的限制，可以看到在没有冗余表达式时，输出曲线的维度就是输入维度减去输出维度。

在最简单的 $F$: $\mathrm{R}^2 \longrightarrow \mathrm{R}$, $F(x, y)=0$ 情形下，如果在某个局部区域，存在$g$ 满足 $y=g(x)$，那么有
$$ F(x, g(x)) =0$$ ![[Pasted image 20250919093842.png]] 当$F$ 和 $g$ 都可导且分母不为零时，这个式子其实和之前提到的$\frac{\partial F}{\partial y} \ne 0$ 等价。

下面是本节的主角，Implicit function theorem（隐函数定理）：
![[Pasted image 20250919095644.png]]  
简单来说，对于一个$F: \mathrm{R}^n_x \times \mathrm{R}^m_y \longrightarrow \mathrm{R}^m$ 的函数，要想在$x_0$邻域内存在显函数，需要满足两个条件：
1. 区间 $\Omega$ 内存在 $x_0$, $y_0$, $F(x_0, y_0)=0$ 
2. $\det(DF(x_0, \cdot)|_{y_0}) \ne 0$ ，简单来说就是如果我要用$x$来表示$y$, 写成$y=g(x)$ 的形式，那么固定 $x=x_0$, 函数$F$对$y$的偏导数雅可比矩阵必须是可逆的，也就是其行列式不能为零。
行列式不等于零其实包含一个隐藏条件，就是这个雅可比矩阵得是方阵，也就是说，变量y的维度必须等于函数$F$输出的维度。

不难注意到，当m=n=1时，也就是x, y都是维度为1的变量，此时 $\det(DF(x_0, \cdot)|_{y_0}) \ne 0$ 就等价于前面的 $\frac{\partial F}{\partial y} \ne 0$。

![[Pasted image 20250919103803.png]]  
这个式子本质上就是前面的$$g'(x)= -\frac{\partial_1 F(x, g(x))}{\partial_2 F(x, g(x))} $$ 拓展到多元输出的形式，函数$F$不再是常数函数，而是输出维度和y相同，也保证了(2.7)的矩阵运算能合法进行。

1. **条件 $\frac{\partial F}{\partial y} \neq 0$**
    
    - 一维情况很好理解：单位圆 $x^2+y^2-1=0$，在点 $(0,1)$ 处斜率有限，可以写成 $y=g(x)$；但在 $(1,0)$ 处竖直切线，就必须写成 $x=g(y)$。
        
    - 这体现了定理的“局部性”。
        
2. **高维推广的直觉**
    
    - $F(x,y)=0$ 的几何意义是“把 $\mathbb{R}^n$ 中的一部分切出来形成一个流形”。
        
    - 要能写成 $y=g(x)$，要求“在 $y$ 方向上能解方程”，即雅可比矩阵对 $y$ 可逆。
        
    - 维度关系：  
    $$\dim(\text{解集}) = \dim(x) - \dim(F) = n - m$$
        
3. **更直观的图像**
    
    - 可以把隐函数定理理解为“高维的切线斜率不为零”。
        
    - 例如球面 $F(x,y,z)=x^2+y^2+z^2-1=0$，在 $(0,0,1)$ 点附近，可以用 $z=g(x,y)$ 描述；但在赤道上，比如 $(1,0,0)$，就不能用 $z=g(x,y)$，只能换一个变量当显函数。

## Lagrange Multipliers for Constrained Extrema
找一个曲面的极值我们知道怎么做， 但是如果加上另一条曲线的限制呢？

假设情景，曲面函数$f: \Omega \rightarrow \mathrm{R}, \Omega \subset \mathrm{R}^n$ , 被限制于函数$F$定义的曲线： $\mathrm{C}=\{x\in \mathrm{R}^n : F(x)=0\}$ 
<p align="center">
  <img src="Pasted image 20250919104952.png" width="200"/>
  <img src="Pasted image 20250919105034.png" width="200"/>
</p>
不难发现，要找到曲线限制下的极值，我们要找$F$曲线和$f$曲面的等高线相切的地方，也就是切向量共线的地方，虽然相切只是极值的 <span class="red">必要条件</span>.

那么我们就要表示它们的切向量，根据隐函数定理，我们可以将 $F(x)=0$写成$x_2=g(x_1)$，像以下推导所示：

![[Pasted image 20250919104854.png]] 
$f$ 曲面等高线可以表示为$f(x)-c=0, c\in \mathrm{R}$ （你问我为什么？这不就是等高线的definition吗）, 并且表示成和$F$一样的形式：
![[Pasted image 20250919110248.png]]  
根据这两个向量共线，我们得到，存在一个实数 $\lambda$, 满足下式：
![[Pasted image 20250919110401.png]]  
这两个式子可以合并起来写作：
$$DF|_{\xi}+\lambda Df|_{\xi}=0$$ 通过解出如下的方程组，即可得到所有可能的极值点：
![[Pasted image 20250919111339.png]] 
接下来是重头戏，前面我们讨论的这个例子是低维情况的，曲面函数和约束曲线都是二维的，曲面是 $\mathrm{R}^2\rightarrow \mathrm{R}$, 约束曲线是 $F(\cdot, \cdot)=0$, 也是两个未知数，那么如果是在n维空间，曲面是 $\mathrm{R}^n\rightarrow \mathrm{R}$, 然后约束曲线是在n维空间内有m个约束，这样形成的就是一个n-m维面（好像也叫流形？）。

那么这个n-m维的约束面在n维空间的正交补空间就是m维的，这个正交补空间就相当于二维情况下的与约束曲线切向量正交的那个法向量，我们希望这个法向量和曲面的梯度向量共线。

回到高维情景，我们希望这个正交补空间和曲面的梯度向量……不对，梯度向量只是一个一维的向量，而这个正交补空间可能有很多维，所以我们需要的是这个**梯度向量的方向和这个正交补空间平行**。（其实就是梯度向量要落在这个空间内）

怎么理解这件事？在二维情境下，我们之所以要约束曲线和曲面的等高线相切，因为寻找constrained extrema可以看作是，沿着约束曲线前进，同时不断测量曲面该点处的“高度”，而正交补空间因为与约束曲线垂直，在该空间内移动不改变曲线上的前进位置，所以当梯度向量属于正交补空间时，有可能取得约束极值。

以下是规范的数学表达：
![[Pasted image 20250920185559.png]]  
这个(3.3)就是我们求约束极值要解的方程组，它看起来十分抽象，但是我们换种写法，要解的就是如下所示的m+n个方程组成的方程组：
![[Pasted image 20250920194936.png]]  
这个方程组有一种很有意思的等价形式，定义这样一个函数 $\psi$：
![[Pasted image 20250920195032.png]]  
然后==让它所有自变量的偏导数都等于0==，就可以解出我们要找的所有可能极值点的坐标。

## Eigenvalue Problems and Matrix Diagonalization

Please just review your 214. {.red .bold}
不过可以在这里回顾几个容易遗忘但又比较关键的概念:
1. 当我们讨论的特征向量成为函数的时候（函数本来就可以看作向量嘛），我们管它们叫 eigenfunctions
2. 286通过讨论”矩阵转置作为一个线性映射，它的特征值和特征向量“这一话题，推导出来任何方阵都可以唯一分解为一个对称矩阵和一个反对称矩阵的和，即
$$A=\frac{1}{2}(A+A^T)+\frac{1}{2}(A-A^T)$$
	对称矩阵和反对称矩阵这两个矩阵空间刚好构成直和，维度分别是$\frac{n(n+1)}{2}$和$\frac{n(n-1)}{2}$，加起来就是$n^2$了。（这些我们在214都讨论过）
3. 不同特征值对应的特征向量相互独立，形成一个independent set, 然后如果一个n 维方阵A恰有n 个各不相同的特征值，那么它就有n 个线性无关的特征向量，然后就可以组一个basis 了； that is to say 这个矩阵的特征空间直和铺满了整个空间.
4. 一个n 维方阵（or 对应的linear map)最多又n 个 distinct eigenvalues （needless to say)
5. geometric multiplicity (特征空间总维度) $\le$ algebraic multiplicity（特征多项式次数，也即是矩阵边长）
6. geometric multiplicity=algebraic multiplicity $\Longleftrightarrow$ Diagonalizable
7. D 代表A对角化后的对角阵，U=($v_1,v_2, \cdots, v_n$)，那么 $A=UDU^{-1}$ or $D=U^{-1}AU$ 

## Spectral Theorem

**self-adjoint**: 线性映射 $L\in \mathbb{L}(V, V)$， 满足$L=L^*$ , or $\left \langle u, Lv  \right \rangle = \left \langle Lu, v \right \rangle$ 
如果写成矩阵形式，就是满足 $A=A^*=\bar A^T$ 
<span class="red"> Lemma </span> 
对于这样一个self-adjoint的线性映射，它的所有特征值一定是实数。（它也至少有一个实数的特征值）
### Invariant Subspaces
假设 $U\subset V$ is a subspace, $L\in \mathbb{L} (V, V)$，如果对于任意 $u\in U$, 有 $Lu \in U$，（<span class="green"> 就是集合$U$内元素被$L$映射了还在$U$内出不去</span>） 
那么我们说，$U$ is invariant under $L$

<span class="red"> Lemma </span> 
如果 $L\in \mathbb{L}(V, V)$ 是self-adjoint的，而 $U\subset V$ is invariant under L, 那么 $U$的补集$U^{\perp}$ 同样是 invariant under $L$ 

<span class="red"> Spectral theorem </span> 
假设 $V$是一个有限维的内积空间， $L\in \mathbb{L}(V, V)$ 是self-adjoint的, 那么 $L$ 的特征向量可以组成 $V$ 空间的一组正交向量基底。

（这个定理也揭示了self-adjoint 的本质，就是**它的作用里没有“拧转”成分，只有“沿某些方向的拉伸/压缩”**）

由此我们也知道，所有 self-adjoint 的矩阵都一定是 diagonalizable 的。（因为特征向量都组成基底了）

甚至可以更进一步，因为 self-adjoint 的矩阵一定存在一组正交特征向量，所以我们可以找到一组**正交归一的基底**，比如$(v_1, v_2, \cdots, v_n)$，都是它的特征向量，然后将其对角化。

对于 self-adjoint 矩阵 $A$ 的对角化，我们知道有 $D=U^*AU$，其中 $U$ 因为是特征向量基底到原直角坐标系基底的转换矩阵，所以 $U=(v_1, v_2, \cdots, v_n)$, 而$U^*$ 就是 $U$ 的共轭转置矩阵，在实数范围内就是转置。很显然 $U^*$ 和 $U$ 都是正交归一的矩阵。

于是我们知道，对于 self-adjoint 的矩阵 $A$，一定可以找到一个由其正交归一特征向量组成的矩阵 $U$, 使得通过共轭转置（或转置）变换 $U^*AU$，可以将 $A$ 对角化为一个只包含特征值的对角矩阵 $D$. {.red}

### Applications of the Spectral Theorem

Spectral theorem 还有其它应用，比如一个285的话题，判断一个矩阵是否是 positive definite or negative definite 

因为我们知道 Hessian 矩阵式对称矩阵，而在实数域对称矩阵一定也是 self-adjoint 矩阵（自伴矩阵），因此我们可以大胆运用自伴矩阵的性质，得到以下定理：
<span class="red">Lemma </span>
对于一个 self-adjoint 的矩阵 $A\in \text{Mat}(n\times n, \mathbb{R})$, $A$ is positive definite $\Longleftrightarrow$ 矩阵 $A$ 的所有特征值严格大于零

## Jordan Normal Form 
我们知道，一切**无法对角化**源于**特征空间维度**不足，那么如何用一种退而求其次的方式给他补全维度？

特征空间的定义是 $E_1:=\ker(A-\lambda \mathbb{1})$, 我们定义这样一个空间：$E_2:=\ker(A-\lambda \mathbb{1})^2=\{v\in V: (A-\lambda \mathbb{1})^2 v=0\}$, 注意到，$E_1\subset E_2$ , 所以空间 $E_2$ 相当于是原特征空间的一个 extension.

空间 $E_2$ 的元素就被称为广义特征向量 (generalized eigenvectors)

广义特征向量的获取本质上就是增加 $(A-\lambda \mathbb{1})$ 的次数求 kernel, 不过增加到多少次没有限制，直到找不出广义特征向量，所有特征空间把总空间填满为止。因此几次指数求出的特征向量以 rank 标志，如下定义：
![[Pasted image 20250927163408.png]] 
注意定义特意申明了 $(A-\lambda \mathbb{1})^{r-1} v\ne 0$, 因为高次为0，往低次走肯定也都是0，次数越高，特征空间是在原有基础上不断被扩大的。

- 于是普通特征向量就是 rank=1 的广义特征向量
- 我们把满足 $(A-\lambda \mathbb{1})^{r} v= 0$, $(A-\lambda \mathbb{1})^{r-1} v\ne 0$, 的这个空间表示为：$E_r\setminus E_{r-1}$  
求广义特征向量有两种方法，一种是 "Bottom up", 另一种是 “Top down”
### "Bottom up"
简单来说，就是如果要求 rank=2 的广义特征向量，就在 $E_1$ 空间内找一个特征向量 $v^{(1)}\in E_1$, 然后令 
$$(A-\lambda \mathbb{1})v^{(2)}=v^{(1)}$$
于是解出 $v^{(2)}\in E_2$
但是这个方法有个问题，就是 $E_1$ 如果是一维的倒还好，如果多维，那么选取哪个方向上的特征向量可能直接影响后面的广义特征向量能不能正常被解出来。（你不能保证一试一个准）

### "Top down"
这个方法可以规避上一个方法的问题，顾名思义，我们这次先从rank最高的广义特征向量开始求。

一个小结论，如果一个特征值 $\lambda$ 相应的 algebraic multiplicity 是 $a_{\lambda}$, geometric multiplicity 是 $\dim V_{\lambda}$ , 那么rank可能需要取的最高次数是 $m:= a_{\lambda}-\dim V_{\lambda}+1$, 于是我们从这个 m 开始：
$$ (A-\lambda \mathbb{1})^m v=0$$
$$ (A-\lambda \mathbb{1})^{m-1} v\ne 0$$ 然后 rank=m-1 的广义特征向量可以通过下式求得：
$$ v^{(m-1)}:=(A-\lambda \mathbb{1})v^{(m)}$$
同样的，$v^{(m-1)}$ 应该满足 $(A-\lambda \mathbb{1})^{m-2} v^{(m-1)}\ne 0$ 
像这样从上至下，我们可以求出所有广义特征向量：
![[Pasted image 20250927170005.png]]


这里直接放 Slide 上的 Jordan block 和 Jordan matrix 的定义，不难理解：
![[Pasted image 20250927182607.png]] 
一个有意思的概念是 left-shift operator, 这个214也有讲过
![[Pasted image 20250927182725.png]] 
之所以提它，因为一个 Jordan block 可以被写成 $\lambda$ 倍的单位矩阵和一个 left-shift operator 的和。

然后是线性映射的直和的定义：
![[Pasted image 20250927183024.png]] 
目的是引出：**Jordan matrix可以写成 Jordan blocks 的直和**

**<span class="red"> Jordan Normal Form Theorem</span>**
Every complex matrix is similar to a Jordan matrix.
也就是说，任意负数方阵都可以被分解成 Jordan matrix 的形式

**Definition**
A matrix $N\in \text{Mat}(n\times n;\mathbb{C})$, is said to be **nilpotent** 如果存在 $k\in \mathbb{N}$
that $N^k=0$.

两条Proposition：
1. 每个复矩阵都相似于若干 “常数矩阵+nilpotent" 形成的算子的直和
2. 每个 nilpotent matrix 都相似于一系列 left-shift operators 的直和


 - [x] Assignment 2, ⏫ 📅 2025-10-10 ✅ 2025-10-06

 - [x] Assignment 3, ⏫ 📅 2025-10-10 ✅ 2025-10-7
# Differential Equation
## Overview
想象一个向量场 $F:\mathbb{R}\to \mathbb{R}$, $F(x, y)=\begin{pmatrix}F_{1}(x, y)\\ F_{2}(x, y)\end{pmatrix}$ , 它是一个粒子在二维空间运动的速度场，每个点的向量代表粒子在该位置的速度，现在外面要根据这个速度场求解粒子的轨迹信息。

一种做法是定义轨迹随时间的函数：$\gamma(t)=\begin{pmatrix}\gamma_{1}(t)\\\gamma_{2}(t)\end{pmatrix}=\begin{pmatrix}x(t)\\y(t)\end{pmatrix}$
于是根据位移和速度的关系，有
$$
\frac{dx}{dt}=F_{1}(x, y), \;\frac{dy}{dt}=F_{2}(x, y)
$$
但是这个方程组解起来非常困难，（这种无法先单独解出一个方程的方程组称为 “coupled”, 反之称为“decoupled”）

于是为了简化方程，我们将 velocity field 转化成 directional field，就是每个点只保留斜率信息，如下图所示：
![[Pasted image 20251011142234.png]] 
我们希望这个方向场 (directional field) 中没有垂直的方向，因为这样所有斜率存在，我们就可以将方向场写作如下形式：
$$
G: \mathbb{R}\to \mathbb{R} , \; G(x, y)= \begin{pmatrix}
1\\f(x, y)
\end{pmatrix}
$$
如此一来，$f(x, y)$ 便直接代表斜率。

有趣的是，我们假设的条件是速度方向场没有垂直的向量，斜率处处存在，这也就意味着，任意符合条件的轨迹也不存在斜率不存在的地方。

于是我们可以运用 Implicit Function Theorem, 将轨迹的 $y$ 用 $x$ 表示，于是：
$$
\gamma(x)=\begin{pmatrix}
x\\y(x)
\end{pmatrix}
$$
$$
\gamma'(x)=\begin{pmatrix}
1\\y'(x)
\end{pmatrix}=\begin{pmatrix}
1\\f(x, y)
\end{pmatrix}
$$
于是我们得到了：
$$
y'(x)=f(x, y)
$$
由此可以求解出轨迹方程。

在这个微分方程的简化过程中，我们牺牲掉的是时间方面的信息，原本的方程以时间 $t$ 为变量，可以获取轨迹随时间的变化关系，现在扔掉 $t$ 之后便只有轨迹方程了。

### Terminology
- ordinary differential equations (ODEs)：常微分方程
- partial differential equation (PDE)：偏微分方程
- 一个微分方程的 order 是出现的最高阶导数阶数
- explicit or implicit equation: 懒得写了看slide吧
- 微分方程 $y'(x_{0})=f(x, y)$ 的一个 solution：$y: I \to \mathbb{R}^n$ 应该是一个满足方程的连续可导的函数
- 该微分方程的 general soluiton 则是所有满足该方程的函数的集合
![[Pasted image 20251011144324.png]] 


- [ ] Assignment 4 ⏫ 📅 2025-10-17 


