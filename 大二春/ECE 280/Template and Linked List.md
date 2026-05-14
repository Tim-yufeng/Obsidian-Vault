### 1. 模板的动机与核心概念 (Templates)
* **痛点**：如果你写了一个 `IntList`，接着又要用 `DoubleList`，除了数据类型 `int` 变成 `double`，逻辑完全一样。传统的复制粘贴会导致大量**代码冗余**。
* **模板的本质**：让**数据类型参数化**。

---

### 2. 函数模板 (Function Templates)
* **语法**：在函数定义前加上 `template <class T>` 或 `template <typename T>`。两者等价。
* **示例**：
  ```cpp
  template <class T>
  void swap(T &a, T &b) {
      T temp = a;
      a = b;
      b = temp;
  }
  ```
  
- **调用与类型推导**：
    
    - 显式指定：`swap<int>(x, y);`
        
    - 隐式推导：编译器通常能根据参数自动猜出类型，直接写 `swap(x, y);` 即可。
        

---

### 3. 类模板 (Class Templates) 

- **语法**：在类定义前加模板声明。

    ```cpp
    template <class T>
    class List {
        // 内部可以使用类型 T，如 T value;
    };
    ```
    
- **类的实例化**：使用类时必须**显式指明具体类型**。
    
    - `List<int> li;` （栈上分配）
        
    - `List<double> *ldp = new List<double>;` （堆上分配）
        

#### **模板类的最大坑点：代码组织结构**

- **普通类**：声明在 `.h`，实现在 `.cpp`。
    
- **模板类**：**必须将所有的成员函数实现都写在 `.h` 文件中**（或者在 `.h` 末尾 include 实现文件），**绝不能**将声明和实现分离开编译！因为**编译器在实例化模板时必须看到完整的实现代码才能生成具体的类**。
    

#### **类外实现成员函数的语法规范**

如果你**不在类内部直接写实现，而在类外面写**，必须遵守极其严格的语法：

1. **每个函数前**都要加上 `template <class T>`。
    
2. 作用域类名不再是 `List`，而是 **`List<T>`**。
    

- **普通成员函数**：

```cpp
template <class T>
void List<T>::insert(T v) { ... }
```

- **构造函数与析构函数**：

```cpp
template <class T>
List<T>::List() { ... } // 构造

template <class T>
List<T>::~List() { ... } // 析构
```

- **赋值运算符 (operator=)**：

```cpp
template <class T>
List<T>& List<T>::operator=(const List<T> &l) { ... }
```

**解析**：只要是代表“这个类的类型”，都必须加上 `<T>`。返回值是 `List<T>&`，参数是 `const List<T>&`，作用域是 `List<T>::`，只有函数名 `operator=` 不需要加 `<T>`。

![[Pasted image 20260421154841.png]]