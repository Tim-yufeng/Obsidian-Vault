## I/O 

- Without `using namespace std;`,  yet forget to write `std::` before `ifstream` and `stringstream` ?
- Who wrote this `std::ifstream iFile_s.open(speciesFile);` ???
		==It should be `std::ifstream iFile_s; iFile_s.open(speciesFile);`== 
		and don't forget to include `<fstream>`

## Basic Cpp
- ```cpp
  case opcode_t::CALLPLUGIN:

            std::string plg_nm = creature.species->pluginNames[inst.pluginSlot];
            ...
            break;
  ```
  where's `{}` for `case` ?
  Well the thing is, if you define and initialize a new variable, you MUST use a `{}` for this `case`
- `cout` 和 `cin` 都存在缓冲区效应，首先是 `cout`, 体现在 `cout << ` 后面的内容会先储存在一个缓冲区内，只有出现 `<< endl` , `'\n'` （不一定），`<< flush` 的时候会清除缓冲区
	- `cin` 的缓冲区则是：每次读取后剩下的一个换行符 `'\n'` 会留在缓冲区，不会被自动扔掉（这一点`cin` 没有 `getline()` 智能），如果下一个读取的还是 `cin` 它会自动跳过这个换行符，但是如果是 `getline()` 就会直接读取这个换行符并立刻停止读取（读了个寂寞），所以这时候需要在之前用 `cin.ignore()` 把这个讨厌的换行符忽略掉
- non-const 可以 赋值给 const, 但是 const 不能赋值给 const，可以理解为，后续行为是左边（被赋值）一方说了算，对于 non-const变量，你可以选择把它当 const 对待，不改变它的值，但是反过来就不行；
	
	比如下面这个例子：
	![[Pasted image 20260329211421.png]]
	其中 (8) invalid,  (9) valid, 
	因为 x 是 non-const, ref1 是 const, x 可以被赋值给 ref1，ref1作为 const reference，无法改变自身的值，换句话说，“把 non-const 的 x 赋给 const 的ref1” 这个操作 不会改变 x non-const 的属性，只是我们无法通过 ref1 来改变 x

### 一些 typedef 的问题

![[Pasted image 20260329214642.png]]

实际上：（1）和 （2）都是 const pointer, 相当于 `int * const px` 
(3) 当然就是 pointer to const, 而（4）就是 const pointer to const int

如何理解这件事？
==当 `const` 作用于一个由 `typedef` 定义的类型时，它永远作用于该**类型本身**，而不是该类型内部指向的基础类型。==

只要 `typedef` 的底层是一个指针类型：

1. **外部 `const` 的唯一效力**：是让该指针变量无法再指向其他地址。
    
2. **指向内容的属性**：完全由 `typedef` 定义时的内部结构决定

- Some packages you might forget:
	- `getline()` , `get()` , `ignore()`   that's ==`<iostream>`== 
	- For those `std::string` you deal with, that's ==`<string>`==
	- `atoi()` to turn string into int, that's ==`<cstdlib>`==
	- `setw()`, that's ==`<iomanip>`==

 - 动态分配的时候，`new <type> [num]` 这个 num 得是 `size_t` 