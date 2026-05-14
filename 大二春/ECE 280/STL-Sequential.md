STL，是 **standard template library** 的简称，里面的container可以分为以下三类：

![[Pasted image 20260428135844.png]]

## Sequential Containers

![[Pasted image 20260428135953.png]]

### 首先是 vector:
- 需要 `#include <vector>` 
- vector 需要定义模板，使用时：`vector<int> vec;` 
- 三种初始化方式：
	1. `vector<T> v1;`  最基础，初始化为 T 型空向量
	2. `vector<T> v2(v1);`  拷贝 `v1` 完成对 `v2` 的构造
	3. `vector<T> v3(n, t);`  构造 `v3` 为：n 个元素均为 t 值
- `v.size()` 方法可以获得向量大小，但是注意返回值是向量相应 type 的 `size_type`，比如 `vector<int>::size_type`
![[Pasted image 20260428140840.png]]
- `v.push_back(t)`： 添加元素 t 至向量末尾
- `v.pop_back()`：将向量末尾元素移除，无返回值，向量不能为空
- 关于向量的下标：向量支持像数组那样的下标，但是要注意：
	1. 可以通过下标读取或改写已存在的元素值
	2. 将一个变量赋给向量后，向量保存的是其副本，修改里面不影响外面
	3. 不能通过下标来添加元素！下标访问的元素必须已存在，这要求在下标访问前注意检查边界，或使用更安全（自带边界检查）的 `v.at(10)` 
- 其他一些方法：
	- `v1 = v2` ：将 v1 替换为 v2 的拷贝
	- `v.clear()`：清空向量
	- `v.front()`：返回开头元素的引用，向量必须非空
	- `v.back()`：返回末尾元素的引用，向量必须非空
- 关于 Iterator，这是一个类似指针的东西，声明方法：`vector<int>::iterator it;` 
	- `v.begin()` 返回指向第一个元素的 iterator，`v.end()` 返回指向==最后一个元素再后面一位==的 iterator
![[Pasted image 20260428143816.png]]
如果向量是空的，此时 `v.begin() == v.end()` 
- 和指针一样，`*iter` 是 dereference，得到指向的元素值，可以用来访问和修改相应的元素
- Iterator 的值在一个向量内连续变化，换句话说，`iter++` 指向下一个元素，也可以拿 Iterator 直接和一个整数相加，相应移多少位
- 还有一种常量 Iterator，只访问不修改指向值，类似于 **pointer to const**，自身可以指向别处，定义方式：`vector<int>::const_iterator it;`  
- 可以对 Iterator 比较大小，**在同一个向量内**，位置靠前的 Iterator 更小
- 结合 Iterator，有一种新的插入元素的方式：`v.insert(p, t)` ：将 t 值插入到 p 所指向的位置**前面**，然后返回插入元素的 iterator
	- `v.insert(v.begin(), t)` 就是插入在开头，`v.insert(v.end(), t)` 就是插入到末尾
- `v.erase(p)`：移除指向的元素，返回**被移除元素的后一个位置**的 Iterator，如果移除末尾元素，返回就是 `end()` （也叫 off-the-end iterator），但是 p 自己不能是 off-the-end iterator

## Deque

基于数组的双向队列，支持快速索引，相较向量，支持在开头的插入和删除（虽然向量可以通过 insert 和 erase 实现，但是他们的复杂度是不一样的），引入 deque：`#include <deque>` 

<p align="center">
  <img src="Pasted image 20260428150615.png" width="320"/>
  <img src="Pasted image 20260428150623.png" width="320"/>
</p>
## list

本质是双头链表，因此不支持索引，访问特定位置的元素只能一步步走过去，但是优点是插入和删除动作比向量和deque快
引入：`#include <list>`

![[Pasted image 20260428151849.png]]

<p align="center">
  <img src="Pasted image 20260428151908.png" width="320"/>
  <img src="Pasted image 20260428151914.png" width="320"/>
</p>

这三种STL Container 的优劣和选择可以简单概括如下：

![[Pasted image 20260428152043.png]]
