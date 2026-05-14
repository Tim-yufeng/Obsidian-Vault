在队列（Queue）的实现中，数组实现（特别是**循环数组**）通常比链表实现稍显复杂，其核心挑战在于如何解决“假满”问题并高效利用空间。

### 1. 为什么普通的数组实现不可行？

在简单的数组实现中，我们用 `front` 指向队头，`rear` 指向队尾。

- **入队（Enqueue）**：`rear` 向后移动。
    
- **出队（Dequeue）**：`front` 向后移动。
    
- **问题**：随着不断地出队，数组前端的空间会空闲出来，但 `rear` 最终会达到数组的末尾（容量上限）。此时，即使数组前面有空位，也无法再插入新元素。这种情况被称为“假满”**。
    

### 2. 核心解决方案：循环数组 (Circular Array)

循环数组通过逻辑上的“首尾相连”，让 `rear` 在达到数组末尾后能重新回到下标 `0`。

- **下标跳转逻辑**：
    
    使用**取模运算（%）**来实现下标的循环递增：
    
    - `rear = (rear + 1) % capacity;`
        
    - `front = (front + 1) % capacity;`
        

### 3. 如何区分“队空”与“队满”？

在循环数组中，如果 `front == rear`，既可能表示队列全空，也可能表示队列全满（`rear` 绕了一圈追上了 `front`）。为了解决这个歧义，课件中提到了两种常见方案：

#### **方案 A：使用计数器 `count`（课件主要采用）**

引入一个额外的变量 `count` 来记录当前队列中的元素个数：

- **初始化**：`front = 0, rear = 0, count = 0;`
    
- **队空**：`count == 0`
    
- **队满**：`count == capacity`
    

#### **方案 B：浪费一个空间**

故意让数组留出一个空位，不存满。

- **队空**：`front == rear`
    
- **队满**：`(rear + 1) % capacity == front`
    

### 4. 关键操作的示例逻辑

以下是基于 `count` 方案的实现逻辑：

- **入队 (Enqueue)**：

```cpp
void enqueue(T v) {
	if (count == capacity) throw QueueFull; // 检查是否已满
	elts[rear] = v;                         // 在 rear 位置放入值
	rear = (rear + 1) % capacity;           // rear 循环后移
	count++;                                // 计数增加
}
```
    
- **出队 (Dequeue)**：

```cpp
void dequeue() {
	if (count == 0) throw QueueEmpty;       // 检查是否为空
	front = (front + 1) % capacity;          // front 循环后移
	count--;                                // 计数减少
}
```


### 5. 易错点提醒

1. **取模运算**：必须确保每次移动 `front` 或 `rear` 时都执行 `% capacity`，否则会发生数组越界。
    
2. **容量管理**：数组大小是固定的。如果需要存储无限多元素，依然需要结合之前学过的“动态扩容（grow）”策略，但在循环数组中扩容后，重新排列原有的 `front` 和 `rear` 相对顺序会非常复杂。
    
3. **返回值**：`front()` 方法通常返回 `elts[front]` 的引用，而 `dequeue()` 则是真正移除元素的操作。