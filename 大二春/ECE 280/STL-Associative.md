## 核心概念：Dictionary ADT

- 存储**键值对 (key, value)**
- **键必须唯一**：不同 pair 的 key 不同
- 主要操作：
  - `find(key)`：根据 key 查找 value
  - `insert(key, value)`：插入新对，若 key 存在则更新 value
  - `remove(key)`：删除 key 及其 value
- 键空间通常比值空间更规整，便于搜索

## Associative vs. Sequential Containers

**存储依据的区别：**
- 顺序容器：按**位置**存储和访问（第1个、第2个...）
- 关联容器：按**键**存储和检索

**操作的差异：**
- 关联容器**没有** `front()`、`push_front()`、`pop_front()`、`back()`、`push_back()`、`pop_back()`
- 共有操作：`begin()`、`end()`、`size()`、`empty()`、`clear()`、`=`

两种主要的关联容器类型：`map` 和 `set`

## map

- 又称关联数组（associative array），下标可以是任意类型
- 需要 `#include <map>`

**构造方式：**
```cpp
map<k, v> m;        // 创建空 map，key 类型为 k，value 类型为 v
map<k, v> m(m2);    // 拷贝构造，m 和 m2 类型必须相同
```

**键类型的约束：**
- map 中的元素按 key 自动排序
- key 类型必须支持**严格弱序（strict weak ordering）**
- 本质就是支持 `<` 操作（如 int 的大小比较，string 的字典序）
- 自定义类型需要提供比较函数

## pair 类型

map 中的每个元素都是一个 `pair` 对象

**定义方式：**
```cpp
pair<T1, T2> p1;           // 两个元素被值初始化
pair<T1, T2> p1(v1, v2);   // 用 v1 和 v2 初始化
make_pair(v1, v2)          // 自动推断类型创建 pair
```

**访问成员：**
- `p.first`：第一个成员（在 map 中是 const key，不可修改）
- `p.second`：第二个成员（在 map 中是 value，可修改）

## map 迭代器

- 解引用 map 迭代器得到 `pair<const Key, Value>` 对象
- 通过 `it->first` 访问 key（只读）
- 通过 `it->second` 访问 value（可读写）

## 添加元素

**方式一：下标操作符 `[]`**
```cpp
map<string, int> word_count;
word_count["Anna"] = 1;
```
实际过程：
1. 搜索 key 为 "Anna" 的元素
2. 未找到时，插入新 pair，key 为 "Anna"，value 被值初始化为 0
3. 将 value 赋值为 1

**方式二：`insert` 成员函数**

## 下标操作的特点（重要陷阱）

- 与数组/vector 的下标不同：使用**不存在的 key** 会**自动插入**该 key
- 若 key 存在，返回对应 value 的引用
- **查找时慎用**：`cout << word_count["Ben"];` 如果 "Ben" 不存在，会插入一个值为 0 的 pair

## 查找元素：find()

```cpp
m.find(k)
```
- 返回指向 key 为 k 的元素的迭代器
- 若 k 不存在，返回 `m.end()`（off-the-end iterator）
- **不会修改 map**，是安全的查找方式

```cpp
map<string,int>::iterator it = word_count.find("abc");
if (it != word_count.end()) {
    occurs = it->second;
}
```

## 删除元素：erase()

**两种重载形式：**

```cpp
m.erase(iter)    // 删除迭代器指向的元素，iter 不能是 end()，返回 void
m.erase(k)       // 删除 key 为 k 的元素，返回删除个数（map 中为 0 或 1）
```

## 遍历 map

- 使用 `begin()` 和 `end()` 遍历
- **遍历顺序**：按 key 的升序排列，而不是插入顺序

```cpp
map<string, int>::iterator it;
for (it = word_count.begin(); it != word_count.end(); ++it) {
    cout << it->first << " occurs " << it->second << " times";
}
```

## set

- 只存储 key，不存储 value
- 用于高效判断某个值是否存在
- 应用场景：存储一篇文章中所有不重复的单词

**与 map 的对比：**

| 特性 | map | set |
|------|-----|-----|
| 存储内容 | `(key, value)` 对 | 只有 key |
| 元素类型 | `pair<const Key, Value>` | `Key` |
| 下标 `[]` | 支持 | 不支持 |
| 用途 | 字典、词频统计 | 集合、去重、存在性判断 |

## 三种关联容器对比

| 特性 | vector | deque | list | map | set |
|------|--------|-------|------|-----|-----|
| 存储逻辑 | 位置 | 位置 | 位置 | 键 | 键 |
| 下标访问 | O(1) | O(1) | 不支持 | O(log n) | 不支持 |
| 中间插入/删除 | O(n) | O(n) | O(1)* | O(log n) | O(log n) |
| 是否自动排序 | 否 | 否 | 否 | 是（按 key） | 是（按 key） |

*list 的插入/删除本身是 O(1)，但找到位置需要 O(n)

## 选择建议

- 需要**按位置快速访问**：`vector` 或 `deque`
- 需要在**两端频繁增删**：`deque`
- 需要在**中间频繁增删**且已持有迭代器：`list`
- 需要通过**键快速查找值**：`map`
- 只需要判断**某个值是否存在**：`set`
