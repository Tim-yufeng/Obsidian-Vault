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

