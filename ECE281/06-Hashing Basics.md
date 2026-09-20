哈希表想解决的是 dictionary 问题：保存 `(key, value)`，并快速完成 `find`、`insert` 和 `remove`。数组按下标访问很快，但 key 的全集可能巨大而且不连续；hashing 的办法是把巨大的 key space 压缩到一个大小可控的 bucket 数组中。

## 从 key 到 home bucket

设当前集合为 $S$，先准备 $n$ 个 bucket，再选择 hash function

$$
h:U\to\{0,1,\ldots,n-1\}.
$$

同一个 key 必须总是得到同一个位置，$h(k)$ 称为 key $k$ 的 **home bucket**。理想情况下，计算 $h(k)$ 很快，而且实际出现的 keys 会均匀分散在整个表中。

hashing 并不保证不同 key 得到不同位置。若 $k_1\ne k_2$ 却有 $h(k_1)=h(k_2)$，就发生 collision。碰撞不是 hash function “坏掉了”，而是把巨大空间压进有限数组后的必然结果；后续真正要解决的是如何为碰撞项安排其他位置。

## Hash function 的两步

实际的 hash function 可以拆成两层：

1. `hashCode(key)`：把非整数 key 转成整数。
2. `compress(code)`：把整数压到合法下标范围，最常见的是 `code % tableSize`。

字符串若只把字符编码相加，会完全丢失位置。例如 `post`、`pots`、`spot` 的字符总和相同。polynomial hash 把字符所在位置也编码进去：

$$
t(s)=s[0]a^{k-1}+s[1]a^{k-2}+\cdots+s[k-2]a+s[k-1].
$$

代码不必真的计算高次幂。按 Horner 形式逐字符更新即可：

```cpp
int hashString(const string& word, int tableSize) {
    int code = 0;
    int a = 33;

    for (int i = 0; i < word.length(); i++) {
        code = (code * a + word[i]) % tableSize;
    }
    return code;
}
```

循环每次只做两件事：先用 `code * a` 把已经读过的字符整体向高位推进，再加上当前字符 `word[i]`。每一步都取模可以避免整数不断增长；函数返回值已经是合法 bucket 下标。

## 为什么 table size 常取质数

若 key 自身带有周期，例如内存地址总是 $4$ 的倍数，而 table size 又和这个周期共享小因子，那么很多 bucket 永远很少被用到。例如表长为偶数时，偶数 key 取模后仍只会落到偶数位置。

因此实践中常把 table size 选成不接近 $2$ 的幂、且不含小质因子的 prime number。它不能消灭 collision，但能减少输入模式与取模周期发生共振的机会。

## 一个最小实现框架

暂时假设 key 都是非负整数，而且不会碰撞。为了只看清楚“hash 后直接访问数组”，先用固定大小数组写一个最小版本：

```cpp
const int TABLE_SIZE = 11;

struct Entry {
    int key;
    string value;
    bool occupied;
};

Entry table[TABLE_SIZE];

int hashKey(int key) {
    return key % TABLE_SIZE;
}

void insert(int key, string value) {
    int bucket = hashKey(key);
    table[bucket].key = key;
    table[bucket].value = value;
    table[bucket].occupied = true;
}

string find(int key) {
    int bucket = hashKey(key);
    if (table[bucket].occupied && table[bucket].key == key) {
        return table[bucket].value;
    }
    return "not found";
}
```

`insert` 和 `find` 都先调用同一个 `hashKey`，所以相同 key 会回到相同 bucket。这里直接覆盖该位置，因此两个 key 若得到相同下标就会出错；这段代码只展示 hashing 的核心映射，真正可用的版本要在下一章加入 collision resolution。

## 本章抓手

hashing 的速度来自把搜索问题变成数组定位，但这个定位只是一个候选位置。设计时必须同时考虑 hash function、collision resolution、table size 与 rehashing；单独优化其中一个并不能保证整体表现。
