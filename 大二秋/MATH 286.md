# Foundational Results of Calculus and Linear Algebra
## Inverse Function Theorem
<span class="red"> Definition  </span>

Let (X ;  · ) be a ==complete==, normed vector space and $M\subset X$ a closed set. 
A function f : M → M is said to be a ==contraction mapping== if there exists ==a number C < 1== such that
$$|| f(x)-f(y) || \le C \cdot || x-y ||$$   
for all x, y $\in$ M.   

由此可以推知，一个contraction的函数是continuous的。

Contraction Mapping Principle{.red .bold}
接续上面的条件，如果 $f$ 是一个==contraction==，那么==唯一存在==一个 fixed point（不动点）$x_0 \in M$，that $f(x_0)=x_0$。
进一步的，我们可以用递归的方式定义这样一个数列，$a_0:=x$, $a_{n+1}:=f(a_n)$, $n\in \mathrm{N}$,  那么这个数列一定收敛到$x_0$, 即：
$$\lim_{n \to \infty} a_n = x_0$$

<span class="red"> Definition </span>

![[Pasted image 20250917131418.png]]  
其中我们称 $f$ 是 locally invertible at $x_0 \in \Omega$ 的，如果==存在== $\epsilon >0$ , that $f: B_{\epsilon}(x_0)\longrightarrow Y$ 在这个==开球==上是invertible的 . 

（==实际上就是多维情景下对可逆的最朴素认知==）

连续可导的函数集合我们表示为 $C^1(\Omega, Y)$, 类似的，一个连续可导函数$f\in C^1(\Omega, Y)$, 如果在 $\Omega$ 上是可逆的，而且其逆函数 $f^{-1}$ 也是连续可导的，那么我们称 $f$ 是 $C^1-\text{invertible}\;\text{on}\;\Omega$ 的。  

类似的， 如果是在一个小开球内满足可逆且逆函数连续可导，就是 locally $C^1-\text{invertible}\;\text{on}\;\Omega$  

Remark:
- 在区间 $\Omega$ 的每一点处均locally invertible, 不一定在区间 $\Omega$ 上就是invertible 的
- 存在连续可导的且可逆的函数，但是逆函数却不是连续可导的

<span class="red"> Lemma </span>

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
3. 不同特征值对应的特征向量相互独立，形成一个independent set, 然后如果一个 n 维方阵A恰有 n 个各不相同的特征值，那么它就有 n 个线性无关的特征向量，然后就可以组一个 basis 了； that is to say 这个矩阵的特征空间直和铺满了整个空间.
4. 一个n 维方阵（or 对应的linear map)最多有 n 个 distinct eigenvalues （needless to say)
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
（为什么 $U^*AU$ 对角化 $A$ ？注意 $U$ 是一个由正交归一的基底向量组成的矩阵，乘以它的转置，结果一定是单位矩阵，想想看为什么）

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
## Separable Equations
分离变量法求解微分方程的原理就是下面这个定理，它是对”擅自分离变量“行为的正规化：
![[Pasted image 20251015091700.png]]
这一切的前提是 $g(\eta)\ne 0$, 但是如果等于零了，首先常数函数 $y(x)=\eta$ 是一个解，另外的解取决于 (9.5) 的左边是否存在，如果存在，那么存在另外的解，否则, $y(x)=\eta$ 就是唯一解。
![[Pasted image 20251015092428.png]]

- [x] Assignment 4 ⏫ 📅 2025-10-17 ✅ 2025-10-15
## Homogeneous, Linear Equations
通常来说，一个一阶线性的 ODE 形如：
$$
a_{1}(x)y'+a_{0}(x)y=f(x)\;\; x \in I
$$
假设 $a_{0}$, $a_{1}$, $f$ 都是连续的实数函数，定义在 $I$

若 $f(x)=0$, 这个等式称为 homogeneous, 否则称为 inhomogeneous

Define the differential operator:
$$
L=a_{1}\frac{d}{dx}+a_{0}
$$
那么，上式就可以写作:
$$
Ly=f
$$
类似于线性代数中对线性方程的表述，我们称 $Ly=a_{1}(x)y'+a_{0}(x)y=0$ 是 $Ly=f$ 的 associated homogeneous equation
和线性方程一样，方程 $Ly=0$ 的不同解的线性组合耶依然是这个方程的解。（这被称为 superposition principle）

同样是线性代数中的做法，对于 $Ly=f$, 可以把它的解写作 $Ly=f$ 的一个特解，和$Ly=0$ 的所有解的线性组合：

![[Pasted image 20251015094011.png]]

以下是一种将一个一般形式的线性微分方程拆解为一个 homogeneous 的和一个 inhomogeneous 的线性微分方程时，它们各自的初始值选取的策略：
![[Pasted image 20251015095159.png]]
简单来说，就是 inhomogeneous 的初始值选 0，然后 homogeneous 的初始值选 $\eta$, 这样一来，它们的加和依然满足初始值是 $\eta$

回到 homogeneous 的线性微分方程，这种方程的解法是最简单的，因为可以直接利用 分离变量法，得到：

![[Pasted image 20251015095504.png]]

## Inhomogeneous Equations
求解 Inhomogeneous Equations 的思路是 ”叠加法“，这个方法要求深入理解等式 $a_{1}(x)y'+a_{0}(x)y=f(x)$ 的物理意义。

首先看齐次线性微分方程 $a_{1}(x)y'+a_{0}(x)y=0$，我们把它写作 $x'(t)+\beta x(t)=0$, 它的物理意义是，想象一堆放射性物质在衰变，满足：
$$
x(t)=x(0)\cdot e^{-\beta t} 
$$
$x(0)$ 就是初始物质总量

但是现在方程变成 $x'(t)+\beta x(t)=f(t) \implies x'(t)=f(t)-\beta x(t)$ 就是说，除了衰败速率满足和物质总量成正比，系数是 $\beta$, 而且总物质还在从外部源源不断的添加，添加速率就是 $f(t)$ 

我们运用 step function 的思路，将一段时间 (0, t) 划分小格，每个小格宽度是 $\Delta \tau$, 拟合函数 $f(t)$, 像这样：
![[Pasted image 20251015110154.png]]
然后在每个时间间隔 $\Delta \tau$ 内，函数值因为看作不变，于是外界给他增加的物质量就是 $f(\tau_{k})\Delta \tau$ , 其中因为 t 用来作为区间的限制了，所以就用 $\tau$ 作为时间变量，然后 $\tau_{k}$ 就是第 k 个时间区间对应的函数值。

新来的物质便随着其它物质一起衰败，于是考虑这些因素，整个物质的变化图应该是这样的（蓝线），可以看到确实拟合了实际的变化曲线（绿线）：
![[Pasted image 20251015110911.png]]
注意看，我们用这样一个式子 $x_{\tau}(t)$ 表示 $x'(t)+\beta x(t)=0$ 在 $x(\tau)=1$ 这一初始值条件下的解，那么我们知道，$x_{\tau}(t)=x(\tau)\cdot e^{-\beta (t-\tau)}=e^{-\beta (t-\tau)}, t\geq \tau$ 
也就是说，如果在时刻 $\tau$ 初始值不是 1，而是 $x(\tau_0)$，那么解就是 
$x(\tau_{0})\cdot e^{-\beta (t-\tau_{0})}$

那么 $\Delta \tau \cdot f(\tau) \cdot x_{\tau}(t)$ 就应该是 $x(\tau)=\Delta \tau \cdot f(\tau)$ 这一初始值下的解

注意，初始值的物理意义是，衰变物质在反映初始时的总量，在这个问题中，我们假设一开始没有物质，物质是通过函数 $f(t)$ 不断加进去的，于是在每个时间节点 $\tau_{k}$ 的物质量就应该是 $f(\tau_{k})$, 
那么在每个时间节点 $\tau_{k}$ 的衰变方程的解就应该是：$\Delta \tau \cdot f(\tau_{k}) \cdot x_{\tau}(t)$ 
于是，上面这个拟合的折线图，任意时间点的物质量就是，所有增加物质的时间节点的衰败方程的累加：
$$
x^{(n)}(t)=\sum^n_{k=1}\Delta \tau \cdot f(\tau_{k}) \cdot x_{\tau}(t) 
$$
将时间区间无限细分，我们就得到了实际的表达式：
$$
x^{(n)}(t)=\int^t_{0}f(\tau) \cdot x_{\tau}(t)\;d\tau = \int_{0}^t f(\tau)\cdot e^{-\beta(t-\tau)} d\tau
$$
推广到方程 $a_{1}(x)y'+a_{0}(x)y=f(x)$, 就是 Duhamel's Principle, 如下图：
![[Pasted image 20251015112754.png]]
结合上一节说的，一个 inhomogeneous equation 可以分解为 $y_{\text{part}}+y_{\text{homo}}$, 我们可以得到 inhomogeneous equation 的解法公式：
![[Pasted image 20251018110456.png]]
![[Pasted image 20251015131806.png]]

梳理一下用 Duhamel's Principle 求解非齐次微分方程的做法，方程是$a_{1}(x)y'+a_{0}y=f(x)$, 初始值是$y(\xi)=\eta$：
1. 首先，对于方程 $a_{1}(x)y'+a_{0}y=f(x)$, 我们要构造另一个齐次微分方程： $a_{1}(x)y_{\xi}'+a_{0}(x)y_{\xi}=0$, 然后它的初始值是 $y_{\xi}(\xi)=\frac{1}{a_{1}(\xi)}$ 这个方程的解 $y_{\xi}(x)$ 很容易求, 就是
$$
y_{\xi}(x)=\frac{1}{a_{1}(\xi)}\exp\left( \int_{\xi}^x - \frac{a_{0}(x)}{a_{1}(x)}dx \right)
$$
(嗯如果右边的积分顺利的话，确实不难求)
2. 现在我们有了 $y_{\xi}(x)$, 这个式子应该是和 $x$, $\xi$ 都有关系的，接下来，外面把它和 $f(\xi)$ 乘起来做积分，积分变量就是 $\xi$, 然后范围由 $x$ 和 $x_{0}$ 决定（其中 $x_{0}$ 就是满足 $f(x_{0})=0$ 的那个 自变量值）
	这样积分的结果就是 $y_{\text{part}}(x)$
$$
y_{\text{part}}(x)=\int_{x_{0}}^x f(\xi)\cdot y_{\xi}(x)=\int_{x_{0}}^x
\frac{f(\xi)}{a_{1}(\xi)}\cdot\exp\left( \int_{\xi}^x - \frac{a_{0}(x)}{a_{1}(x)}dx\right) d\xi
$$
==但是注意了！有趣的是，我们之前说过，可以令非齐次方程的初始值为：$y(\xi)=0$, 齐次方程的初始值为 $y(\xi)=\eta$, 这样它们加在一起初始值仍然满足 $y(\xi)=\eta$! 所以，这里的$x_{0}$ 应该就是 $\xi$==

3. 接下来就是求 $y_{\text{homo}}(x)$ 了，解齐次微分方程：$a_{1}(x)y'+a_{0}y=0$, 初始值是 $y(\xi)=\eta$，结果应当是：
$$
y_{\text{homo}}(x)=\eta\cdot \exp\left( \int_{\xi}^x - \frac{a_{0}(x)}{a_{1}(x)}dx \right)
$$
4. 最终的结果就是 $y=y_{\text{part}}+y_{\text{homo}}$

<span class="green"> 核心思想是，把每个时间点 t 视为一个单独的以 f(t) 为初始值（初始质量）的演变（衰变）过程，忽略其它部分 f(t) 的作用，然后把所有的时间点叠加起来（进行积分），得到整体的曲线。$\xi$ 代表的就是每个时间点，我们先求的那个函数的意义是，时间点$\xi$ 处，以初始质量为 1 ，演变的曲线，（这样这个函数可以直接乘以 $f(\xi)$ 表示当前的真实初始量。）设置 $y_{\xi}(\xi)=1/a_1(\xi)$, 是因为：我们要构造的方程其实是：$a_1(\xi)y'(\xi)=1-a_1(\xi) y(\xi)$ </span>





- [x] 286 HW5 ⏫ 📅 2025-10-24 ✅ 2025-10-25
## Transformable Equations

## General Integral Curves of First Order ODEs
对于形如 $h(x, y)y'+g(x, y)=0$ 的微分方程，解这个微分方程可以理解为在向量场 $F(x, y)=c\cdot \begin{pmatrix}-h(x, y)\\g(x, y)\end{pmatrix}$ 中寻找一个 curve：$\gamma(t)=\begin{pmatrix}x(t)\\y(t)\end{pmatrix}$, 与之处处相切。也就是说：
**Solutions to $h(x, y)y'+g(x, y)=0$ are integral curves of $F(x, y)$.**

$$
\gamma'(t)=F \circ \gamma(t)
$$
可以知道一个和 $F$ 正交的场是：
$$
F^{\perp}=\begin{pmatrix}
F_{2}(x, y)\\-F_{1}(x, y)
\end{pmatrix}=\begin{pmatrix}
g(x, y)\\h(x, y)
\end{pmatrix}
$$
![[Pasted image 20251030145002.png]]
![[Pasted image 20251030144945.png]]
其中 $c$ 未必是一个常数，也可以是一个关于 $x, y$ 的函数，我们称之为 $M(x, y)$：

![[Pasted image 20251020193640.png]]

恰当的 $M(x, y)$ 要能使得乘以原向量场 $F$ $=\begin{pmatrix}-h(x, y)\\g(x, y)\end{pmatrix}$ 的一个正交场 $\begin{pmatrix}g(x, y)\\h(x, y)\end{pmatrix}$ 后，得到的 $M(x, y)\cdot \begin{pmatrix}g(x, y)\\h(x, y)\end{pmatrix}$ 是一个势能场。

回忆 285 中如何实现这一点：一个场 $F$ 成为势能场的必要条件是：$\frac{\partial F_{2}}{\partial x}=\frac{\partial F_{1}}{\partial y}$ 
那么：
![[Pasted image 20251020195529.png]]
这里下角标代表对谁的偏导

我们可以假设 $M(x, y)$ 只和 $x$ 或 $y$ 有关，这样另一个变量的作用可以直接消去，整个等式的求解就简单多了：
![[Pasted image 20251020195746.png]]

## Introduction to Systems of Equations

首先，为什么要研究微分方程组？因为任何形如 $x^{(n)}=f(x,x',x'',\cdots, x^{(n-1)}, t)$ 的高阶微分方程都可以通过这样的方法解出：
![[Pasted image 20251020200547.png]]

也就是，通过巧设新的变量 一阶一阶“降维”，可以转化为一个一阶的微分方程组。

求解微分方程组的一种方法是将微分等式改写成积分等式（就是对左右两边积分）：
![[Pasted image 20251021175314.png]]
（14.7）的解也必定满足（14.8），相当于（14.8）是必要条件，这两个式子并不等价。

### Picard Iteration
如何解这个转化来的积分方程？一个重要方法是 Picard Iteration, 简单来说，就是随便找一个满足初始值的函数 $x^{(0)}$，作为 $x(t)$ 的猜测值，通常找 $x^{(0)}(t)=x_{0}$ (直接等于初始值的常函数)

然后代入 (14.8) 右侧，左侧等于下一个猜测值 $x^{(1)}$ , 也就是：
$$
x^{(1)}=x_{0}+\int_{t_{0}}^t F(x^{(0)}(s), s)ds
$$
不断重复这个步骤，随着 $k\to \infty$ , $x^{(k)}$ 会趋于 $x(t)$ 真实解。
（**背后的原理就是开头几章涉及的 Contraction Mapping Principle**）

### Theorem of Picard-Lindelöf
这个定理的作用是判断，像 $\frac{dx}{dt}=F(x, t)$ 这样一个微分方程组，解是否存在且唯一。

定理内容：如果满足 $F$ 是一个连续函数，且满足 Lipschitz estimate：
![[Pasted image 20251021180643.png]]

那么这个方程组存在唯一的解，在某个包含 $t_{0}$ 的区间内。

<span class='red'>（这里要特别注意，Lipschitz estimate 和一致连续、导数值有界都有区别）：
它们的严格关系可以描述为：一致连续（最松）> Lipschitz estimate > 导数值有界（最严）
举例来说，$y=\sqrt{ x }$ 是一致连续的，但是不满足 Lipschitz estimate， $y=|x|$ 满足 Lipschitz estimate，但是不满足导数值有界（不处处可导）</span>

讨论完解的存在和唯一性，接下来要关注解的“稳定性”，即：初始位置的一个小改变，会对解造成多大影响？
### Gronwall’s Inequality
这个定理就回答了这个问题，$x(t_{0})=x_{0}, y(t_{0})=y_{0}$ 定义了**同一个微分方程组** $F$ 下的两个**不同初始位置**的解（or 路径）
那么我们关注，这两条起点不同的路线发展下去，最终会相距多远？
![[Pasted image 20251021181306.png]]

这个不等式告诉我们，他们的距离 $||x(t)-y(t)||$ 一定会受限于这样一个值，其中包含前面满足 Lipschitz estimate 的 L 值

差点忘说了，这个不等式有一个前提，就是 $F$ 已经满足了前面的 Lipschitz estimate 条件，也就是解已经是存在且唯一的了。

但是我们可以利用这个定理反过来再验证一遍解的唯一性，$x(t)=y(t)$ 时， $||x(t)-y(t)||$ 一定为零，也就是==不可能存在同一起点出发，走出不同路线的可能==。

## Homogeneous, Linear Systems of Equations

首先介绍一下，线性微分方程组的两个分类，一些基本名词：
![[Pasted image 20251021210945.png]]
这一节要探讨的是 homogeneous 的线性微分方程组，也就是 $b=0$ 的情形。也就是 
$$
\frac{dx}{dt}=A(t)x 
$$
这种方程非常类似线性代数中的线性方程组 $y=Ax$, 它们也共享了解的 Superposition Principle:
简单来说，就是两个解的线性组合依然是解：
![[Pasted image 20251021211346.png]]

注意到，方程组 $\frac{dx}{dt}=A(t)x$ 的所有解组成的集合其实是一个 vector space, 我们称之为 solution space（解空间）, 
==**A set of functions giving a basis of the solution space is called a fundamental system of solutions.**==
上面这句话说白了就是，fundamental system of solutions (基本解系统) 就是解空间的一组基底，通过线性组合基本解系统，我们可以得到这个微分方程组所有可能的解。


简单说说我们到底想干啥：现在我们由这样一个线性微分方程组 $\frac{dx}{dt}=A(t)x$, 它的解是什么还取决于初始条件（位置），我们要找到并刻画这个方程组所有可能的解，于是我们首先找到初始条件的所有可能，也就是初始条件的一个基底（因为初始条件位于一个 n 维空间 $\mathbb{R}^n$ ），然后分别代入方程，求出的解的集合，诶你猜怎么着，就是这个微分方程组的 fundamental system of solutions (基本解系统)
这就是下面这个 Proposition 想说的：
![[Pasted image 20251021214321.png]]

理论有了，如何解这个方程组呢？先考虑最简单的情形，homogeneous，而且矩阵 $A$ 是 constant
$$
\frac{dx}{dt}=Ax, x(0)=x_{0} 
$$
非常非常有意思的是，如果我们像这样定义矩阵的指数幂，那么这个方程组的唯一解可以表示为:
$$
x(t)=e^{At}x_{0}
$$
用泰勒展开的方式定义矩阵次方：
![[Pasted image 20251021215325.png]]
可以证明这个级数是收敛的，而且是 absolutely convergent

那么剩下唯一的难点，就是计算矩阵的 k 次方了，两种情形：
1. $A$ 可对角化
2. $A$ 不可对角化
可对角化的情形很简单，可以得到：
![[Pasted image 20251021215559.png]]

如果不能对角化那么运用 Jordan Matrix，可以将 $A$ 变成 Jordan normal form:
![[Pasted image 20251021215843.png]]

结合下面这个例子：
![[Pasted image 20251021215935.png]]

根据上述的推导，我们可以得到，对于 $A$ 是 constant 的微分方程组，之前的 Proposition 可以改写为：
![[Pasted image 20251021220534.png]]

事实上，选择这个$e^{At}$ 要乘的基底，有两种方式，一种是 Standard Basis，还有是全体（广义）特征向量组成的基底，后者的好处是可以省去计算矩阵次方时对可逆矩阵的计算：
![[Pasted image 20251021220824.png]]

## Inhomogeneous, Linear Systems

非齐次的线性方程组，形如 $\frac{dx}{dt}=Ax+b(t), b(t)\ne 0$ 分为两种情形，一种是 $A$ 和 $t$ 无关，是个常数矩阵；另一种是有关。
### A 是常数

前者的做法比较简单，我们用一个小 trick 对方程进行变换：
左右同乘 $e^{-At}$:
$$
e^{-At}\frac{dx}{dt}=e^{-At}Ax+e^{-At}b(t)
$$
我们发现这个式子可以写成：
$$
e^{-At}\frac{dx}{dt}-e^{-At}Ax=\frac{d}{dt} (e^{-At}x)=e^{-At}b(t)
$$
于是，左右同时积分，可以得到 particular solution $x_{\text{part}}$：
$$
x_{\text{part}}(t)=e^{At}\int_{t_{0}}^te^{-As}b(s)ds
$$
这个解其实可以看作是对 Duhamel's principle 的方程组拓展；我们由此得到以下定理：

![[Pasted image 20251025132627.png]]

$x(t)=x_{\text{homo}}+x_{\text{part}}$， 没问题吧。

这是由初始值的情况下，如果没有初始值，要求 general solution 呢？

**$x_{\text{homo}}$ 需要用常数进行线性组合，$x_{\text{part}}$ 则基本没变化，写成不定积分即可，甚至不用在末尾加上常数 $C$, 这是因为，作为特殊解，$x_{\text{part}}$ 的职责仅仅是提供一个可以让等式成立的特解，而 generalize 的任务是 $x_{\text{homo}}$ 的组合完成的，换句话说，$x_{\text{homo}}$ 的线性组合已经涵盖了 $x_{\text{part}}$ 末尾常数的情形。**

写成严谨的数学定理：
![[Pasted image 20251025133302.png]]

可以看到，$x_{\text{homo}}$ 是找了相应的齐次方程组 $\frac{dx}{dt}=Ax$ 的一个基础解系：${x^{(1)}}, x^{(2)},\cdots ,x^{(n)}$, 然后用 n 个常数: $c_{1}, c_{2}, \cdots, c_{n}$ 作为系数线性组合它们。

### A 不是常数
这种情形下，不能再使用上面的方法，因为 $\frac{d}{dt}e^A(t)=A'(t)e^{A(t)}$ 不再成立。（$A'(t)A(t)\ne A(t)A'(t)$ in general）

为了求解，我们引出 Wronskian （朗斯基行列式）的概念：
简单来说，对于一个齐次微分方程组 $\frac{dx}{dt}=A(t)x$ , 如果有 ${x^{(1)}}, x^{(2)},\cdots ,x^{(n)}$ 作为它的 n 个解（假设矩阵 $A$ 是 n 维的！）
那么管这样一个由行列式定义的 $\mathbb{R}\to \mathbb{R}$ 的函数 $W$ 叫这些解的 *Wronskian*:
$$
W_{{x^{(1)}},\cdots ,x^{(n)}}(t)=\det({x^{(1)}}, x^{(2)},\cdots ,x^{(n)}) 
$$
或者简写为 $W(t)$.

两个重要的结论！
1. 对于任意 $t$, $W(t)\ne 0$ 当且仅当 ${x^{(1)}}, x^{(2)},\cdots ,x^{(n)}$ independent
2. $W(t)$ 要么对于任意 $t$ 都不为零，要么全部为零

由此我们知道：
首先这个结论可以判断一组解是否是线性独立的，只要随便找一个值 $t_{0}$ 看 $W(t_{0})$ 是否为零就行了，因为一个点即可代表全体

其次，$W(t)$ 作为一个一维函数，不可能存在和横轴的 “交点”，要么全部高于或低于横轴，要么就是横轴。

接下来是一个重要的等式, 对于方程 $\frac{dx}{dt}=Ax$ 的朗斯基行列式：
$$
\frac{dW}{dt}=\text{tr} A(t) \cdot W 
$$
于是我们可以立刻得到：
$$
W(t)=W(t_{0})e^{\int_{t_{0}}^t\text{tr}A(s)ds}
$$
(这个式子叫：*Abel’s equation for the Wronskian.*)

<span class="red"> 铺垫的差不多了，接下来讲讲怎么用 朗斯基行列式 解非齐次线性微分方程组的： </span>
这个方法利用了一个很有趣的事实，就是非齐次方程组 $\frac{dx}{dt}=A(t)x+b(t)$ 的 particular solution 可以写作全体齐次方程组的基础解系的“组合”：
$$
x_{\text{part}}(t)=c_{1}(t)x^{(1)}(t)+\cdots +c_{n}(t)x^{(n)}(t)
$$
我们把这个式子代入回方程组，可以分别解出每个“系数” $c_{1}(t),\cdots,c_{n}(t)$:
![[Pasted image 20251025142101.png]]

写成数学定理：
![[Pasted image 20251025142148.png]]


# Complex Analysis and the Laplace Transform

## Complex Differentiability
首先定义复数函数的导数，和实数领域的导数定义基本一样：
![[Pasted image 20251102221425.png]]

由这个定义，可以得到三个复函数的重要性质，这里先剧透一下：

![[Pasted image 20251102221518.png]]

第一个是现阶段可以理解的，已经够炸裂了，对于任何可导的复函数，它一定是无穷阶可导的。

一些定义，如果一个函数在一个开区间 $\Omega \subset \mathbb{C}$ 内的所有点都是 holomorphic, 那么它在这个区间就是 holomorphic 的
在整个 $\mathbb{C}$ 上均 holomorphic 的函数称为 entire

复函数导数的一些基本性质，主要是实数函数性质的迁移：
![[Pasted image 20251102221939.png]]

包括链式法则，加法乘法数乘，还有 Landau 展开

一个很重要的点是，$\mathbb{C}\to \mathbb{C}$ 的复函数并不能被等价于 $\mathbb{R}^2\to \mathbb{R}^2$ 的实函数，或者说 $\mathbb{R}^2\to C$ 的函数，对比下面这两个函数：
其中 $u, v$ 都是 $\mathbb{R}^2\to \mathbb{R}$ 的实数函数，$x,y$ 也都是实数
![[Pasted image 20251102222250.png]]

前者，也就是复函数，若想 holomorphic，必须满足：

![[Pasted image 20251102222341.png]]

这个式子也可以简写为：$u_{x}=v_{y}, u_{y}=-v_{x}$ 

现在呢我们决定搞点事情，定义两个 operation（算子）：

![[Pasted image 20251102222638.png]]

为什么定义它们？因为它们可以辅助判断是否 holomorphic

有这样一个结论，如果 $f=u+iv: \mathbb{C}\to \mathbb{C}$ 在点 $z\in \mathbb{C}$是 holomorphic 的, 那么：
$$
f'(z)=\frac{\partial f}{\partial z}=2\frac{\partial u}{\partial z}  ,\;\;\; \frac{\partial f}{\partial \bar{z}}=0 
$$
进一步，如果函数 $u, v$ 的偏导始终存在，而且连续且满足上式，那么复函数 $f$ 就是 holomorphic 的。

就是说，定义这两个算子相当于变换了一次坐标系，将 $x, y$ 坐标系换成了 $z, \bar{z}$ 构成的坐标系，我们不再研究 $x, y$ 的偏导，而是研究 $z, \bar{z}$ 方向的偏导

holomorphic 要求这个复函数只依赖 $z$, 并不依赖 $\bar{z}$ , 任一点 $z$ 处 $\bar{z}$ 方向的偏导都应该是零。

### 复平面中集合的一些定义
![[Pasted image 20251102223851.png]]

可以看到，open 和 bounded 定义和实数域都是一样的，然后 compact也是一样，因为 $\mathbb{C}$ 是有限维空间，所以 bounded+closed 直接等价于 compact

比较特殊的是 disconnected 和 connected 的概念，其实还是挺直观的，一个集合 $\Omega$ 的两个全开或全闭子集如果能完全覆盖 $\Omega$, 但是又是没有交集的，那么 $\Omega$ 就是空间上看被分割成两块的，也就是 disconnected.
然后 connected 的定义是经典的 “定义好一个然后取反”，就是“非 disconnected 即 connected”，不过关于 connected 还是有一条等价性判定的，就是集合内任意两点存在一条 curve 连接它们。

open + connected 的集合称为 a region or a domain

![[Pasted image 20251102223905.png]]
这是定义一个类似于描述一个复数域集合的大小的量，通过描述集合内点“最远能相距多远”；然后还有一个相关的结论：简单来说，如果无限个集合一一嵌套，且按照这个定义“大小”趋于零，那么最后一定会收敛到一个点，这个点包含在所有这串集合内

复数的 Power series 结论和实数基本一样：
![[Pasted image 20251102224222.png]]

但是请复习 186，还记得 disc of convergence 怎么算吗

![[Pasted image 20251102224316.png]]

![[Pasted image 20251102224353.png]]

一个复函数 $f$ 在点 $z_{0}$ 是 analytic 的，如果存在一个 power series $\sum_{n=0}^{\infty}a_{n}(z-z_{0})^n$ centered at $z_{0}$, 存在一个正的收敛半径，而且在 $z_{0}$ 周围一个邻域内完全贴合 $f$ 
如果存在这样一个 power series 在整个 $\Omega$ 上都拟合 $f$, 那么称 $f$ is analytic on $\Omega$

### 复平面的 curve 

这是复平面中 curve 的定义：
![[Pasted image 20251106142205.png]]

类似于我们在285中对一个实平面做的那样，可以定义复平面上的curve积分：
![[Pasted image 20251106142358.png]]

甚至还可以定义curve的长度，就是对 1 积分：
![[Pasted image 20251106142505.png]]
对应实函数的积分里的那个 bounded 定理

和实数函数的微积分一样，定义复函数的原函数概念：
![[Pasted image 20251106142616.png]]

由此可以得到一个定理，简单来说就是，就是一个连续的复函数如果有原函数，那么它在复平面上沿着任意一条曲线的积分结果只和始末状态有关：

![[Pasted image 20251106143214.png]]

这条定理是复分析中的基本定理，完全可以类比于实函数微积分中的牛顿-莱布尼茨公式。

由此我们可以立刻得到，对于一个连续且有原函数的函数 $f$, 它对于一条闭合曲线的积分一定是 0

以及得到另一个结论，就是对于一个 holomorphic 的复函数 $f$， 如果 $f'=0$, 那么 $f$ 一定是常数函数。（因为 $\Omega$ 内任意两个点，都可以证明他们的 $f$ 值相等）

一个有趣的事实，就是 $f(z)=\frac{1}{z}$ 是 $f(z)=z^{-n}， n=1, 2, 3 \cdots$ 系列函数中==唯一一个没有原函数的==
![[Pasted image 20251106143740.png]]

## Properties of Holomorphic Functions
在前一章有一个结论，一个复函数如果连续且存在原函数，那么它的积分具有路径无关性；在这一章我们要做的是，证明这个结论对于所有全纯的函数都成立，即：**一个在区域上全纯（holomorphic）的函数，其积分与路径无关，且在任意闭合路径上的积分为零** 

进一步引出 Cauchy's Theorem 和 Cauchy's Intergral Formula. 由此证明全纯函数都是 anlytic 的（可以展开为幂级数），从而揭示复函数的 holomorphic 和 analytic 是等价的

首先是 Goursat's Theorem：
![[Pasted image 20251111155344.png]]

这个定理告诉我们，**如果一个函数在某个区域上全纯，那么它在该区域内的任意三角形边界上的积分为零**
由这个定理，可以很容易推知，全纯函数在任意矩形边界的积分也是零

接下来的定理是：局部原函数存在定理，简单来说就是**如果一个函数在某个开圆盘上全纯，那么它在该圆盘上存在一个原函数**

![[Pasted image 20251111155729.png]]
**这一阶段将“积分零”与“存在原函数”联系起来**。这是从Goursat定理到柯西定理的关键桥梁。
由此我们得到 Cauchy's Theorem: ==在一个开圆盘上全纯的函数，在这个开圆盘上的任意闭合曲线积分为零==

![[Pasted image 20251111160514.png]]

![[Pasted image 20251111160859.png]]

Corollary 20.5 的结论不只是圆盘，可以拓展到其它各种 curve：

![[Pasted image 20251111163343.png]]

一个全纯的复函数在闭合的 toy contour 上积分结果是零，根据这个结论，我们可以计算许多实数微积分无法计算的积分问题，一般方法就是先将目标实数函数转化成一个复函数，然后找一个合适的 contour，积分，最终通过消去一些项，算出一些项，两边同时取实部 or 虚部，令 contour 的某些参数区域零或正无穷 等手段，可以算出我们要的积分值

比如下面这个例子，详细计算过程见 slide：

![[Pasted image 20251116192557.png]]

![[Pasted image 20251116192651.png]]

（同时熟悉一些常规曲线比如圆周、直线的 parametrization）

### Jordan's Lemma
简单来说，我们考虑一个函数在一个上半圆弧的积分是否能够在半径趋于无穷的时候趋于零；

如果这个函数 $f(z)$ 可以写成 $f(z)=e^{iaz}g(z)$ 的形式，其中 $a>0$, 
而且 $g(z)$ 满足 $\sup_{0\leq\theta\leq\pi}|g(\mathrm{Re}^{i\theta})|\to0$ 当 $R\to 0$ 的时候
那么有 
$$
\lim_{ R \to \infty } \int_{C_{R}}f(z)dz=0
$$
这就是 Jordan's Lemma:

![[Pasted image 20251116195845.png]]

### Cauchy’s Integral Formula
简单来说，就是一个全纯函数在某圆盘内的情况被圆盘边界完全确定，换种说法，圆盘内任意一点的函数值，都可以由该点坐标和圆盘边界上的函数值计算出来：

![[Pasted image 20251116195900.png]]

事实上，不止圆盘，Cauchy’s Integral Formula 对各种 toy contour 都适用。

我们可以对这个表达式（20.3）狠狠求导，然后得到 $f$ 的任意阶导函数：

![[Pasted image 20251116200434.png]]

这预示了一个惊人的事实，就是==任何全纯的复函数都是任意阶可导的==。

接下来我们引出复函数版的泰勒展开，由此证明==全纯的复函数都是 Analytic 的==。

一个全纯的复函数 $f$ 在任意一点 $z_{0}$, 周围的一个圆盘$D$范围内的点都可以用这样一个无穷幂级数完全拟合

![[Pasted image 20251116201050.png]]

而我们刚求出了任意阶导函数的计算公式，结合这个定理，我们就掌握用代数多项式完全拟合任意一个复函数的方法了。

### 唯一性定理
接下来我们对 Cauchy’s Integral Formula 进行一个拓展，探究什么样的条件可以==唯一确定一个复函数==

首先引出复分析中的聚点（accumulation point）概念：

![[Pasted image 20251116202909.png]]
（简单来说就是抛开自身，周围有无数个点都属于该集合）

然后就是唯一性定理：
简单来说，柯西积分定理告诉我们，一个 contour 边界如果确定了，那么其围成的区域内部也被唯一确定；
而唯一性定理的条件更宽泛，任意一个点集，只要包含了聚点，这个点集便可以唯一确定整个函数

![[Pasted image 20251116203045.png]]

### 解析延拓（Analytic continuation）
简单来说，就是将一个本来定义在集合 $M$ 的复函数拓展到一个定义在更大的集合 $\Omega$ 的复函数 $g$，（$M\subset\Omega$）满足在集合 $M$ 上 $f, g$ 都完全一样，于是 $g$ 就是 $f$ 的解析延拓：

![[Pasted image 20251116204122.png]]

注意一点：我们不要求被延拓的 $f$ 是全纯的，它可以是任意一个不连续的、不完美的函数，而延拓的目的就是在不改变其原有定义部分的前提下，将其弥补成一个完美的、全纯复函数，所以我们在定义中要求 $g$ 是全纯的

而仅仅由这个定义，我们能找到 $f$ 的解析延拓，却不能保证这个延拓函数 $g$ 是唯一的，如果要求唯一性，根据唯一性定理，需要集合 $M$ 包含 accumulation point

## Singularities and Poles

Singularities, 简单来说就是使得一个函数不全纯的点，是一个复函数”不完美“的地方：
![[Pasted image 20251117140722.png]]

可以分为三类：removable singularities, poles, essential singularities

简单来说：
- removable：如果可以被一个唯一函数解析延拓；
- pole：如果该函数的倒数 $g=\frac{1}{f}$ 在**除这一点处**是全纯的，而且函数 $g$ 在这一点处可以被解析延拓，并满足延拓后该点的值是 0；
- essential：前两个都不是

![[Pasted image 20251117150346.png]]

本节我们主要研究的是 poles

首先我们引出一个初中就能理解的、类似于因式分解思想的定理：
如果一个全纯的复函数 $f$, 满足在某一点 $z_{0}$ 等于零，且不在整个定义域全是零，那么 在点 $z_{0}$ 周围的某个区间 $U\subset \Omega$ , 存在一个非零的全纯函数 $g$
满足：
$$
f(z)=(z-z_{0})^n g(z)
$$
且这个 n 是唯一的
![[Pasted image 20251117151059.png]]

这个 n 我们称之为 multiplicity 或 order of the zero of $f$

如果 n=1, 称 zero is simple

不难联系刚刚引出的 pole 定义，如果 $f$ 在点 $z_{0}$ 是一个 pole，那么存在一个全纯函数，是 $f^{-1}$ 的解析延拓，延拓后的函数在该点处为零
那么存在一个唯一的正整数 n, 和非零全纯函数 $h$ ：
$$
f(z)=(z-z_{0})^{-n}h(z)
$$
这个 n 我们称之为：the multiplicity or order of the pole of $f$
n=1 就是 simple 的

接下来是一个很重要的定理：

![[Pasted image 20251117152532.png]]
如何理解它？根据前面一个定理 $f(z)=(z-z_{0})^{-n}h(z)$, 有
$$
h(z)=(z-z_{0})^{n}f(z)
$$
同时对于全纯函数 $h$, 我们可以将其解析表达：
$$
h(z)=\sum_{m=0}^\infty b_{m}(z-z_{0})^m
$$
于是让 $a_{-k}=b_{n-k}, k=1, 2 \cdots, n$ , 
$$
G(z)=\sum_{m=0}^\infty b_{n+m}(z-z_{0})^m
$$
我们就得到了定理的那个表达式

这个定理中， $G(z)$ 前面那一串分数项，我们称之为 函数 $f$ 在 pole $z_{0}$ 处的 principal part

<span class="green"> 有意思的是，对于存在多个 pole 点的函数，我们在每个 pole点附近的区域都能找到一个如上展示的 分式项+一个无穷幂级数 的形式，而后面的无穷幂级数收敛的区域，也就是整个拟合有效的区域，恰恰是区域 U 的最大范围，可以发现，不同 pole 点收敛区域是不会重叠的 </span>

![[Pasted image 20251117154039.png]]
![[Pasted image 20251117154054.png]]

在上述表达式中，有一项最为特殊，就是 $\frac{a_{-1}}{z-z_{0}}$
它的系数 $a_{-1}$ 称为 residue of f at the pole $z_{0}$:

![[Pasted image 20251117154248.png]]


之所以特殊，因为只有它没有原函数，我们前面说过；更有趣的是，如果我们对整个函数 $f$ 沿着一个闭合 contour 积分，除了 $\frac{a_{-1}}{z-z_{0}}$m以外其他项因为存在 primitive，全部变成零，最终对这一项的积分结果竟然就是 $2\pi i \cdot a_{-1}$! (这其实就是我们接下来要说的留数定理)

![[Pasted image 20251117155443.png]]

接下来我们考虑如何求这个神奇的 residue，我们希望找到一个方法，不用把整个展开的表达式求出来就能算出 residue；
如果该 pole 的order是1（simple pole），那么很简单：
![[Pasted image 20251117200425.png]]

如果不是，我们首先给 $f$ 乘上 $(z-z_{0})^n$，然后连求 n-1 次导数，然后让极限趋于 $z_{0}$, 最后除以 $(n-1)!$

![[Pasted image 20251117200600.png]]
（证明照着计算的顺序走，不难理解）
## Residue Calculus

首先是 Residue Theorem（留数定理）其实根据上一章的公式 (21.9)已经可以直接推出：
![[Pasted image 20251117220500.png]]

包含一个极点的积分等于 $2\pi i$ 乘以 residue，包含多个极点就是把 residue 都加起来：
![[Pasted image 20251117220558.png]]

### The Complex Logarithm
我们希望将实数函数的对数函数推广到复数域，但是我们知道，复数域中不存在一个函数是 1/z 的原函数，所以无法直接推广。

我们可以在一个单连通（simply connected）的开集上定义复对数，这个集合 $\Omega$ 必须满足两个条件：
1. 包含点 1
2. 不包含原点 0
然后定义公式：
$$
\ln z=\int_{C} \frac{dz}{z}
$$
其中 $C$ 是连接 1 和 z 的任意一条简单曲线，且整条曲线都位于 $\Omega$ 内

因为 $\Omega$ 单连通，而且 1/z 在 $\Omega$ 上全纯 （此时 $\Omega$ 不包含 0），所以积分值不依赖路径，确保了这个定义的唯一性，答案的唯一性
同时满足 $\ln 1=0$，符合实数对数

<span class="green">  我们通过限制定义域 Ω，从而“切断”了复平面上围绕原点的闭合路径，避免了多值性问题。 </span>

选择一个特定的单连通区域：$\Omega=\mathbb{C}\setminus \{x \in \mathbb{R}:x\leq 0\}$
就是复平面上挖去 $x\leq_{0}$ 那一条射线，得到的区域称为割平面，它在负实轴上被“割开”了

- 在这个定义域内，复数 $z=re^{i\varphi}$ 的辐角 $\varphi$ 被限制在 $(-\pi,\pi)$ 范围内。
- 因此，对数函数被定义为：$\ln z=\ln r+i\varphi \;(r>0,-\pi<\varphi<\pi)$ 
- 这个特定的分支被称为**主支**（principal branch）

![[Pasted image 20251118093838.png]]
![[Pasted image 20251118093854.png]]

要注意的是，在 principal branch 中，$\ln(z_{1}z_{2})\neq \ln z_{1}+\ln z_{2}$

甚至可以定义复数指数：
![[Pasted image 20251118094127.png]]

## From Heaviside Operator to Laplace Transformation

首先引入一个叫 Heaviside function 的函数，可以用来描述电路的 "switched on"，我们在 215 也见过它：
![[Pasted image 20251118164419.png]]

Heaviside 方法的核心是，将难以参与代数运算的微分运算变成我们熟悉的数乘，而 Laplace Transformation 是对 Heaviside 方法的合法化

我们希望找到一种 transformation，使得转换后，微分可以变成乘以一个数 $D$:
![[Pasted image 20251118164652.png]]

我们规定这种变换要满足两个条件，首先是线性性（类似对函数的线性组合），还有是“微分相当于数乘”，至于后面为什么有个 $+f(0)$, 纯粹是人为规定，便于与 Laplace Transformation 接轨

![[Pasted image 20251118164823.png]]

同样是人为规定的是，我们希望这个数乘的数 $D$, 不是别的，就是当前的变量 $p$，也就是：
$$
D\{f\}(p)=p\cdot\{f\}(p)
$$
于是：
$$
\{f'\}(p)=p\cdot\{f\}(p)-f(0)
$$
$$
p\cdot\{f\}(p)=\{f'\}(p)+f(0)
$$
最终发现，满足这些条件的唯一变换是：
$$
\{f\}(p)=\int_{0}^{\infty}e^{-pt}f(t)dt
$$
这就是 Laplace Transformation

Laplace Transformation的严格引入如下，随之还有 locally integrable 的定义，是对于定义域上任意一个紧致子集都可积

![[Pasted image 20251118165616.png]]

注意Laplace变换成立必须满足的条件，如何理解这个条件？因为Laplace Transformation 中有一项是 $e^{-pt}$, $p$ 是自变量，为了避免这个积分发散，我们需要这个 $e^{-pt}$ 能始终“压住” $f(t)$, 而让自变量 $p$ 满足这样一个区间条件，在该区间内，$f(t)$ 的增长速度不会显著大于指数函数


Laplace Transformation 在解决有初始值的特解问题比较容易，但是不善于解决没有初始值的通解问题

**如何根据变换后的函数反推变换前**：

![[Pasted image 20251118170026.png]]

![[Pasted image 20251118170047.png]]
![[Pasted image 20251118170103.png]]

用 Laplace 变换求解微分方程的流程就是，首先两边都进行变换，有个有用的关系式用来表示高阶导数的Laplace变换：

![[Pasted image 20251121190908.png]]

这个关系式很重要

然后尝试表示出目标函数的Laplace变换的表达式，最后进行Laplace的逆变换，还原出原本的目标函数

Laplce 方法的一个优势是，它可以求解包含不连续部分的微分方程，比如 Heaviside function （“开关函数”）

对于这种存在突变行为的不连续函数，我们通常采用 Heaviside function 来表示它们，很重要的一个原因就是 Heaviside function 的Laplace变换很简单
这就是一个转换不连续函数为Heaviside function 的典型例子：
![[Pasted image 20251121191300.png]]

## Analyticity and Inversion of the Laplace Transform

我们将 Laplace Transformation 的方法推广到复数域：
$$
F(z)=(\mathcal{L}f)(z),\;\; z=p+iq\in \mathbb{C}
$$
根据Laplace变化成立的条件，我们需要 $z$ 的实部满足限制，即 $\mathrm{Re}(z)>\beta$

$F(z)=(\mathcal{L}f)(z)$ 在满足条件的区域，即$\mathrm{Re}(z)>\beta$区域是完全收敛的，$e^{zt}$ 也是可微的，于是在该区域 $F$ 就是全纯的。
进一步，如果 $F$ 存在极点(poles), 那么一定是在 $\mathrm{Re}(z)\leq\beta$ 的区域

但是在$\mathrm{Re}(z)>\beta$的区域，也许原Laplace不收敛，而复函数还是可以定义的，于是我们可以用收敛区域的复函数来定义未收敛区域的Laplace函数值，进而实现了一个解析延拓。

### The Bromwich Integral

![[Pasted image 20251123110505.png]]

注意在 t>0 和 t<0 的部分我们用不同的半圆弧来计算，目的是为了圆弧部分能在半径趋于无穷的时候成功收敛到零：
<p align="center">
  <img src="Pasted image 20251123110645.png" width="320"/>
  <img src="Pasted image 20251123110706.png" width="320"/>
</p>
事实上，这个积分的求解结果正是Laplace变换的逆变换：

![[Pasted image 20251123110840.png]]

## A Convolution Product, Impulses, Green Functions

### Convolution（卷积）
定义两个函数间的运算：
$$
(f*g)(t)=\int_{0}^tf(t-s)g(s)ds
$$
称为 convolution of $f$ and $g$

不难发现这种运算满足交换律，结合律和分配律

它和Laplace变换的联系就是，两个函数卷积的Laplace变换，等于各自Laplace变换的乘积：
$$
\mathcal{L}(f*g)=(\mathcal{L}f)\cdot (\mathcal{L}g)
$$
这种运算有时候能帮助我们求解一些Laplace变换的逆变换，比如下面这个例子：
![[Pasted image 20251123111628.png]]
（将目标变换后的函数分解成两个已知如何变回去的函数乘积，然后做它们原函数的卷积）

### Green's Function and Impulses

考虑一个线性二阶非齐次常微分方程：
$$
ay''+by'+cy=f(t)
$$
初始值：$y(0)=y_{0}, \;y'(0)=y_{1}$
我们关心它的特解 $y_{\text{part}}$
根据Laplace变换，可以得到这样一个结论 (推导见Slide 548-550)：
$$
y_{\text{part}}=f*g(t)
$$
其中 $g(t)$ 满足 
$$
\mathcal{L}g(p)=\frac{1}{ap^2+bp+c}
$$
![[Pasted image 20251123112402.png]]

Impulse 不是一个真正的函数，但是具有很多函数的特征，为了方便表示，我们常常把它当作一个函数对待，比如物理学家定义其为 Delta Function: $\delta(t)$, 
含义是在 $t$ 时刻对系统的一个冲激作用，作用时间趋于零，作用力趋于无穷大，但是总冲量是 1. 

一个很重要的结论是, 该系统的 Green's Function 和某时刻 Impulse 的卷积，结果就是该时刻的 Green's Function 函数值：
$$
g*\delta(t)=g(t)
$$
而我们知道，系统对外界作用 $f$ 的相应是 $y_{\text{part}}=f*g(t)$, 所以系统对于 $t$ 时刻的一个冲激 $\delta(t)$ 的相应响应就是 Green's Function $g(t)$
因此，Green's Function 也被称为 impulse response of the physical system.

$\delta$ 的Laplace变换就是 1：
$$
(\mathcal{L}\delta)(p)=\int_{0}^\infty e^{-pt}\delta(t)dt=e^{-pt}|_{t=0}=1
$$
![[Pasted image 20251123134634.png]]

## The Fourier Transform

首先是 傅里叶变换的计算公式：
![[Pasted image 20251123134756.png]]
（在$f$ absolutely integrable 的时候才存在，以确保变换结果收敛存在）

在形式上，傅里叶变换很像拉普拉斯变换，主要区别是：
1. 积分范围是整个 $\mathbb{R}$, 而拉普拉斯变换是 $[0, \infty)$
2. 指数项多了一个 $i$, 使得这个变换后的函数具有振荡性

### Fourier Transformation的一些基本性质

1. ![[Pasted image 20251123135240.png]]
2. 
$$
\widehat{{(f')}}(\xi)=i\xi \cdot\widehat{f}(\xi)
$$
$$
\frac{d}{d\xi} \widehat{f}(\xi)=\widehat{(-ixf)}(\xi)
$$
一个特殊的函数：$f(x)=e^{-x^{2}/2}$, 它的傅里叶变换是自身，即$\widehat{f}=f$

给无穷处的衰减速率定义一系列“分级”：
![[Pasted image 20251123140443.png]]

可以发现，如果一个绝对可积的函数是 n 阶可导的，而且求n次导后还是绝对可积的，那么它求n阶导后的傅里叶变换就是原函数傅里叶变换乘上 $(i\xi)^n$, 我们又知道傅里叶变换应该是有界的，那么可以得到原函数傅里叶变换满足一个衰减速率：
![[Pasted image 20251126195447.png]]

从而，我们得到这样一个结论：函数越光滑（可导阶数越高），它的傅里叶变换的衰减的速率就越快。

如果函数是无穷阶可导的，那么它的傅里叶变换就是任意次数的 polynomial decay, 也就是 faster-than-polynomial decay

那么如何让傅里叶变换是 exponential decay 的呢？
## Analytic Theory of the Fourier Transform

本章节我们首先探讨这样一个问题，满足什么条件的一个实函数，其傅里叶变换不仅存在，而且逆变换也存在。

为了找到这个条件，我们引出这样一个函数集合的定义，如果函数 $f$ 在这样一个以实轴为中心的条带区域，是解析的，而且满足第二个条件，which is a 衰减条件（但是这个衰减要求比指数衰减要弱），那么称所有满足这一条件的函数组成这样一个集合，集合符号中的 $a$ 就和条带宽度相关。
![[Pasted image 20251126230028.png]]

然后我们马上得到下面这个定理，它将函数的复解析和其傅里叶变换的衰减速率联系在了一起，复解析意味着指数衰减，其中复解析的条带越宽，代表衰减的越快（b越大）
![[Pasted image 20251126230053.png]]

接下来，我们首先定义了任意一个大于0的a值，对应的该集合的总和是这玩意，然后就引出了 Fourier Inverse Theorem, 即：满足该集合(即存在某宽度的条带区域内解析，且满足那个奇奇怪怪的收敛条件)的函数，其傅里叶变换都存在这样一个逆变换
![[Pasted image 20251126230225.png]]
更有意思的是，这个逆变换公式和傅里叶变换公式神似，可以说是，只差了指数上的一个负号。

前面(Theorem 28.3)我们探讨了，复平面上条带区域内的解析（和一个收敛条件）如何得到实轴上的，函数的指数衰减；现在反过来，下面这个定理告诉我们，指数衰减可以推出傅里叶变换的存在，和复平面条带区域的解析性：
![[Pasted image 20251126231431.png]]

下面又是一个傅里叶逆变换定理，简单解读一下，满足下面三个条件的函数，同样存在逆变换：
- $f$ 是**绝对可积的** ($f ∈ L¹(R)$)。
- $f$ 是**分段光滑的**：在有限个点 $a_{1}, ..., a_{n}$ 之外，$f$ 是连续可微的。
- $f$ 在每个间断点 $a_{k}$ 处的**左极限和右极限都存在**。

![[Pasted image 20251126231454.png]]

这两个傅里叶逆变换定理是什么关系什么区别？第二个傅里叶逆变换定理适用性更广泛，不再要求函数必须非常光滑，而是对于存在不光滑不连续的点也有容忍性：“**只要它可积且只有有限个不光滑点，那么逆变换也成立，但在不光滑点会收敛到平均值**” 

- [x] 286 Quiz 3 ⏫ 📅 2025-11-29 ✅ 2025-11-29
- [x] 286 Quiz 4 ⏫ 📅 2025-11-29 ✅ 2025-11-29
- [ ] 286 Quiz 5 ⏫ 📅 2025-12-06
- [ ] 286 Quiz 6 ⏫ 📅 2025-12-06

# Series Expansions and Partial Differential Equations

## Power Series Solutions

本章的核心内容是 power series ansatz, 就是说，通过假设解的形式为一个幂级数：
$$
x(t)=\sum_{k=0}^\infty a_{k}t^k
$$
代入方程求出系数 $a_{1}, a_{2},\dots$

我们本章主要对付这种形式的微分方程：
$$
P(t)x''+Q(t)x'+R(t)x=0, \;\;t \in \mathbb{R}
$$
也就是 homogeneous 的微分方程，对于非 homogeneous 的，可以使用 Wronskian 方法

有一个问题是，如果对于某些 $t_{0}\in \mathbb{R}$，$P(t_{0})=0$，那么 $t_{0}$ 两侧情况不连续，我们需要分别解出 $t<t_{0}$ 和 $t>t_{0}$ 的情形，但是这两个结果可能完全不一样，无法统一成一个解。

因此，我们还是要把上面这个式子的 $P(t)$ 项约掉，变成：
$$
x''(t)+p(t)x'+q(t)x=0
$$
函数 $p(t), q(t)$ 的性质直接决定了解的性质，从下面这个定理可以看出来：

![[Pasted image 20251129115453.png]]

简单来说，就是如果函数 $p(t), q(t)$ 在围绕某点处有幂级数展开，那么方程的解 $x$ 在围绕该处同样有一个幂级数展开，而且在 $p(t), q(t)$ 都收敛的范围内一定收敛（收敛半径大于等于 $p(t), q(t)$ 收敛半径的最小值）

由这个定理，也引出了 power series ansatz 方法的一大局限性，就是它通常只能做到找出围绕某点周围的一片区域的解析解，但是一旦超过该解的幂级数的收敛范围，这个解就不再适用，然而微分方程的真正解并不一定局限在这个范围内。（一个具体例子见课件 615）

## Regular Singular Points

还是研究形如 $P(t)x''+Q(t)x'+R(t)x=0$ 的微分方程，首先我们介绍一种特殊的微分方程，叫 Euler's equation: 
$$
t^{2}x''+\alpha tx'+\beta x=0\;,\; \alpha, \beta \in \mathbb{R}
$$
这个方程的解法是假设解的形式为 $x(t)=t^r$, （因为注意到方程二阶导系数为t二次，一阶导为一次，x(t) 项为常数）

代入求解，可以得到：
![[Pasted image 20251129142730.png]]

### Singular Points

我们将方程 $x''+p(t)x'+q(t)x=0$ 定义在一个复平面上，那么，如果对于点 $t_{0}\in \mathbb{C}$, $p,q$ 在其邻域都是解析的，那么$t_{0}$ 就是一个 **ordinary point**, 否则是一个 **singular point**

singular point 又可以分为两类情况，如果对于 singular point $t_{0}\in \mathbb{C}$, $p$ 在该点是一个阶数不超过1的极点，$q$ 是一个阶数不超过2的极点，那么称为一个 regular singular point（正则奇点），否则称为 irregular singular point

回忆复分析章节讨论极点的时候，阶数代表了前面有多少个分式项，于是，我们可以得到函数 $p,q$ 的如下形式：
![[Pasted image 20251129144356.png]]

下面是一些具体例子，其中最经典的就是 Bessel's equation:
![[Pasted image 20251129144514.png]]
![[Pasted image 20251129144526.png]]

### The Method of Frobenius

对于 $x''+p(t)x'+q(t)x=0$ ，如果 $t=0$ 处是一个正则奇点，那么我们可以乘上 $t^{2}$ , 变形为：
$$
t^{2}x''+t(tp(t))x'+t^{2}q(t)x=0
$$
根据正则奇点，我们知道 $p, q$ 在分别乘以 $t, t^{2}$ 后，$tp(t)$ 和 $t^{2}q(t)$ 就都是解析的了，于是我们假设这样一个解:

![[Pasted image 20251129145102.png]]

经过一通复杂的计算，可以得到：
![[Pasted image 20251129145216.png]]

进一步的：
![[Pasted image 20251129145351.png]]

$F(r)=r(r-1)+p_{0}r+q_{0}=0$ 称为指标方程(indicial equation)
这个方程可以解出两个独立的 $r$ 值，分别作为递推公式 (30.8) 的起点，从而得到完整的，两个独立的，解

两种情况可能导致这种方式失效：
1. 指标方程解出的两个解相等，即 $r_{1}=r_{2}$
2. 指标方程解出的两个解差值为整数，即 $r_{1}=r_{2}+N, N\in \mathbb{N}$
 

