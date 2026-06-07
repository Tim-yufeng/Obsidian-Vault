# Part I

## Set

## Logic

**一些术语和表示习惯**

![[Pasted image 20260519220047.png]]
AND: conjunction   $\vee$
OR: disjunction      $\wedge$

注意 $A\to B\to C$ 等价于 $A\to (B\to C)$, 不等价于 $(A\to B)\to C$
同理，$\vee$ 和 $\wedge$ 也是

最后两个要背住：

![[Pasted image 20260519220840.png]]
以及，注意复习270

![[Pasted image 20260519221121.png]]

**Magma, Semigroup and Monoid**

magma 要求最低，只需要 pair $(M, *)$ 是封闭的即可，就是 $*: M \times M \to M$ ，或者说，两个 M 中元素参与这个运算结果一定还在M内
Semigroup 就是 magma 基础上，要求 $*$ 运算满足结合律
Monoid 在 semigroup 基础上，要求存在 identity element：

![[Pasted image 20260601203815.png]]


### Relations and Functions

![[Pasted image 20260605105838.png]]

relation 反应的是两个集合 A 和 B，他们中各取一个元素，之间是否满足的某种关系，只有 true or false，比如 $x \in A, y \in B$ ，如果满足关系 R，即 $xRy$ 

这里的 $R$ 很类似于映射，有 domain 和 codomain
特别的，如果映射方 B 就是 A 自己，那么称 R是 relation on A，也就是 A 内部的一个 relation

有三种特殊的关系，分别是:
- empty relation：A 和 B 中没有相关的元素
- identity relation: A=B, 每个元素只和自己相关
- universal relation：任意两个元素都有关系
![[Pasted image 20260605110638.png]]

