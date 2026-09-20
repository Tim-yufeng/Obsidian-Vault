这一讲用 k-nearest neighbors (KNN) 这一个最简单的模型，跑完 machine learning 的整条流水线：从“人写规则”转向“从数据估规则”，把对象变成 feature vector，用 distance 定义相似度，再逐个处理 $k$、scaling、validation 这些后面每个模型都会重新遇到的决定。KNN 本身几乎没有数学难度，它的价值在于把“一个模型怎么被用起来”完整暴露出来。

## 从手写规则到从数据学习

传统编程的形态是把解法写死：input → human-written instructions → output。温度换算是这条路的样板——$F = 1.8C + 32$，关系已知、精确且稳定，规则本身就是完整答案。

垃圾邮件是同一个问题在复杂度上的反面。一条看起来很合理的规则是「邮件里出现 FREE、WINNER 或 !!! 就判为 SPAM」，它在样例上完全正确，但两条新邮件立刻暴露了它的边界：

- “Your account will be closed today. Confirm your information immediately.” 一个关键词都没出现 → 规则判为 NOT SPAM，实际是 SPAM
- “The seminar is free for all students.” 命中了 “free” → 规则判为 SPAM，实际是 NOT SPAM

问题不在于关键词挑得不好，而在于每加一条规则都会同时扩大它的误伤面。换一条路：**给系统大量带已知答案的邮件，让它自己估计出一个 model**：

$$\text{LABELED EXAMPLES} \rightarrow \text{LEARNING ALGORITHM} \rightarrow \text{MODEL}$$

新邮件进来，模型判为 SPAM。这里的分工是：人指定 learning process（用什么算法、看哪些数据），模型负责从数据里估计出有用的 pattern。因此该走哪条路的判据是 pattern 的性质——逻辑简单稳定（固定税表、温度换算）时手写规则更直接，pattern 复杂、noisy 或难以写清（垃圾邮件、患者风险）时才需要 learning。课件的收尾句点出了全部难点：不是拟合过去，而是泛化到未来。

## 什么是机器学习

课件给的工作定义是：用数据构建一个 model，使它能够对新的样本给出有用的 prediction。人脸识别、个性化推荐、医学筛查、内容生成看起来毫不相干，但结构相同——data → learn patterns → produce an output，差别只在数据形式和输出形式。

Mitchell 的形式化定义把这件事写成三个格子：一个程序从 experience $E$ 中学习、针对 task $T$、以 performance measure $P$ 衡量，当且仅当它在 $T$ 上的、由 $P$ 度量的表现随 $E$ 提升。代入邮件问题：$T$ 是把新邮件判为 spam 或 not spam，$E$ 是此前标注过的邮件，$P$ 是在未见邮件上的预测正确数。这三个格子是之后每个模型都要填的检查表。<span class="red">泛化（generalization）指的是在新样本上表现良好，而不是记住训练样本。</span>训练时模型见过 “Confirm your account immediately.” 并知道它标为 SPAM；测试时给它的是一封措辞全新的邮件，它必须认出更宽的 pattern 才算学到东西。

![[Pasted image 20260915140146.png]]

课件也把当前术语放进同一个嵌套结构：Artificial Intelligence ⊃ Machine Learning ⊃ Deep Learning ⊃ Foundation Models。Foundation Models 内部，language-centered 的 LLM 与 multimodal LLM 是重叠的两类——multimodal LLM 仍然是一个 LLM，只是把语言与图像、音频、视频接到了同一个模型里。这门课处理的是这套层级中“从数据学习”的原则，而不是某一个模型或产品。
![[Pasted image 20260915140415.png]]
## 从应用问题到学习问题

一个真实需求要变成学习问题，先把四件事写清楚：

1. Input $x$：能观察到哪些信息；
2. Desired output $y$：希望系统输出什么；
3. Training information：训练样本里是否带着已知的 target；
4. Evaluation：如何衡量成功。

如果每个输入 $x_i$ 都有对应的已知 target $y_i$，训练数据就是 labeled 的：

$$\mathcal{D} = \{(x_1,y_1),\dots,(x_n,y_n)\}$$

有已知 target 就进入 supervised learning。决定任务类型的不是输入，而是 target 本身：$y$ 是 category 时是 classification，$y$ 是 continuous value 时是 regression。同一组输入特征（size、age、location、房间数）可以支持两种完全不同的任务——预测价格档位（Low/Medium/High）是 classification，预测具体成交价（¥3,250,000）是 regression，前者用 classifier，后者用 regressor。<span class="red">target 是类别还是连续值，同时决定了学习任务和模型的种类。</span>用这条判据过一遍常见问题：房价、明天的温度是 regression，邮件是否 spam、花的品种是 classification。这一讲先做 KNN classification，再把同一套思路推广到 regression。

## KNN：用相近的样本来判断

起点是一个具体的分类问题：已知三种 iris（setosa、versicolor、virginica）的若干样本，问一朵新花属于哪一种。$y \in \{\text{setosa},\text{versicolor},\text{virginica}\}$ 是类别，所以这是 classification。

计算只能作用在数字上，因此第一步是把实物变成 feature vector。对一朵花测量 sepal length、sepal width、petal length、petal width 四个量（单位 cm），得到

$$\mathbf{x} = \begin{bmatrix} 5.1 \\ 3.5 \\ 1.4 \\ 0.2 \end{bmatrix}$$

feature 是可测量的属性，features $\mathbf{x}$ 就是用来预测 target $y$ 的信息。这里有一个容易被忽略的前提：KNN 比较的是 representation 之间的距离，不是物体本身——量哪些特征、量得准不准，直接决定了模型能看到什么。

每个样本变成 $\mathbb{R}^4$ 中的一个点之后，训练集就是 feature space 里一批带标签的点，新样本是同一空间里的另一个点。

![[Pasted image 20260915124247.png]]

横轴 petal length、纵轴 petal width，三种颜色对应三个 species，红星是新花，虚线圆圈画出了它周围的近邻。课件在这里埋了一句提醒：近邻只保证“特征值相近”，不保证标签相同——星号周围同时有 versicolor 和 virginica。这正是后面要投票、而不是直接取最近一个的原因。

## 距离定义相似度

KNN 用 distance function 比较两个 feature vector，默认使用 Euclidean distance：

$$d(\mathbf{x},\mathbf{z}) = \sqrt{\sum_{j=1}^{d}(x_j - z_j)^2}$$

其中 $d$ 是特征个数（iris 数据里 $d=4$）。它就是两点之间直线段的长度：每个特征上先作差、平方、求和，最后开方。距离越小，两个样本越相似。

用一个只有两个特征的例子走一遍：新花在 (petal length, petal width) 上是 $(4.7,1.5)$，Flower B 是 $(4.3,1.3)$，则

$$d = \sqrt{(4.7-4.3)^2 + (1.5-1.3)^2} = \sqrt{0.4^2 + 0.2^2} = \sqrt{0.20} \approx 0.45$$

一次距离计算把多个特征上的差异压成一个数字。<span class="green">这一步其实已经决定了 KNN 会“相信”什么：它相信我们选定的那组 measurement 构成的几何，而不是对象本身，所以特征选择与 scaling 在这里不是可选项。</span>

## 从距离到近邻与投票

对一朵新花，KNN 算出它到全部训练样本的距离，按距离排序，取最近的前 $k$ 个。课件给的例子是：

| Training flower | Species    | Distance to $x_{new}$ |
| --------------- | ---------- | --------------------- |
| Flower A        | setosa     | 3.42                  |
| Flower B        | versicolor | 0.45                  |
| Flower C        | virginica  | 1.18                  |
| Flower D        | versicolor | 0.62                  |
| Flower E        | virginica  | 0.91                  |

排序结果是 $B < D < E < C < A$。取 $k=3$ 就是 B、D、E，标签为 versicolor、versicolor、virginica，投票得到 versicolor 2 : virginica 1 : setosa 0：

$$\hat{y} = \operatorname{mode}\{y_i : x_i \in N_k(x_{new})\} = \text{versicolor}$$

其中 $N_k(x_{new})$ 是新样本的 $k$ 个最近邻集合。整个算法由五个固定步骤组成：

1. Compute：算出新样本到每个带标签样本的距离；
2. Rank：按距离从近到远排序；
3. Select：保留最近的 $k$ 个；
4. Collect：取出这些样本的已知标签；
5. Predict：返回出现次数最多的类别。

这五步可以直接写成代码：

```python
import numpy as np

def knn_predict(X_train, y_train, x_new, k):
    # 1. compute：到每个训练样本的欧氏距离
    diff = X_train - x_new
    dist = np.sqrt((diff ** 2).sum(axis=1))
    # 2. rank + 3. select：取距离最小的 k 个样本的下标
    neighbors = np.argsort(dist)[:k]
    # 4. collect + 5. predict：收集标签并投票
    labels = y_train[neighbors]
    values, counts = np.unique(labels, return_counts=True)
    return values[counts.argmax()]
```

`np.argsort(dist)` 返回的是排好序的下标而不是距离值，正好对应 Rank 一步要给出“样本编号”；投票用 `np.unique` 数出每个标签出现的次数。值得注意的是这个函数里没有任何训练步骤——KNN 的 model 就是被存下来的训练集本身。

## 训练集与测试集：如何检验泛化

在建模之前先把带标签的数据分成两组：training set 和 test set。KNN 把 training set 里的样本全部存下来当作候选邻居；test set 的用法固定为四步：

1. 只把 test 样本的 features $\mathbf{x}$ 交给模型；
2. 把它已知的标签 $y$ 藏起来；
3. 让模型给出预测 $\hat{y}$；
4. 把 $\hat{y}$ 与藏起来的 $y$ 比较。

评价者知道 $y_{test}$，但模型在预测阶段不能使用它——test data 模拟的是模型将来会遇到的新样本。

有了预测结果就可以量性能。设 10 个样本中判对 8 个，则

$$\text{Accuracy} = \frac{8}{10} = 0.80, \qquad \text{Error Rate} = \frac{2}{10} = 0.20 = 1 - \text{Accuracy}$$

accuracy 与 error rate 衡量的都是模型在未见样本上的表现，它们的分母永远是不参与学习的那批数据。

## $k$ 控制什么

$k$ 决定每次预测受多少个邻居影响，也直接决定 decision boundary 的形态。

![[Pasted image 20260915124247-01.png]]

$k=1$ 时每个点各自为政，边界绕着个别训练样本拐弯，任何噪声点都能拉出一块自己的区域；$k=15$ 时边界接近一条平滑的直线，不再对个别样本敏感，代价是局部结构被抹平。$k$ 越大，decision boundary 越不灵活。

它对预测的直接影响用一个小例子就能看出来。五个邻居按距离排列：

| Neighbor rank | Distance | Label |
| --- | --- | --- |
| 1 | 1.2 | Blue |
| 2 | 1.8 | Orange |
| 3 | 2.1 | Blue |
| 4 | 2.7 | Orange |
| 5 | 3.0 | Orange |

$k=1$ 时结果是 Blue，$k=3$ 时 Blue 以 2:1 胜出，$k=5$ 时 Orange 以 3:2 反超。$k$ 不只是一个精度参数，它是模型复杂度的旋钮。

灵活与平滑的两端各对应一种失败：

- $k$ 很小 → 模型过于 flexible，训练表现很高而 test 表现明显更低，预测被噪声左右（overfitting）；
- $k$ 很大 → 模型过于平滑，训练与 test 表现都差，局部结构被忽略（underfitting）。

好的泛化需要两者之间的平衡：既拟合有用的 pattern，又不把噪声当成 pattern。

## 用验证集选择 $k$

$k$ 不能在 test set 上挑。因此我们把可用的带标签数据多分出来一份 **validation data** 专门用于比较不同的 $k$ 并选出最好的一个

于是现在我们把带标签数据分成了 training data，validation data，test data 三类，通常比例设为 7：1：2 或 6：2：2 。像 $k$ 这样**在最终测试前选定、不由训练过程直接估出的模型设置**称为 **hyperparameter**。

选择过程只有三步：试若干候选 $k$；在每个 $k$ 上测 validation error；取误差最小的那个。

![[Pasted image 20260915124258.png]]

$$k^* = \arg\min_k \text{ValidationError}(k)$$

图中的 validation error 曲线先降后升：$k$ 太小时模型太灵活，$k$ 太大时模型太钝，最低点落在 $k=7$ 附近。所以最优的 $k$ 不一定是最小或最大的那个。<span class="red">test set 在模型选择期间必须保持未被使用。</span>把这条流程直接写成代码：

```python
best_k, best_err = None, 1.0
for k in [1, 3, 5, 7, 9, 11, 13, 15]:
    err = np.mean([knn_predict(X_train, y_train, x, k) != y
                   for x, y in zip(X_val, y_val)])
    if err < best_err:
        best_k, best_err = k, err
# 选定的 k 只在 test set 上评价一次
test_err = np.mean([knn_predict(X_train, y_train, x, best_k) != y
                    for x, y in zip(X_test, y_test)])
```

`X_test` 只在最后两行出现，这就是上面那条约束最直接的形式化：任何用于选择的量都只能来自 validation。

## 特征缩放

Euclidean distance 对每个特征的数值尺度敏感。若 age 以“岁”计、income 以“元”计，income 上的差动辄上万而 age 只差几十，距离几乎完全由 income 决定——特征的重要性被尺度而不是被信息量决定了。

课件给的例子能让结论整个翻转。新客户 $x_{new}=(30,60000)$，两个候选邻居 $A=(31,80000)$、$B=(50,61000)$：缩放前 $d(A)\approx 20000$、$d(B)\approx 1000$，income 支配距离，B 更近；把 age 按 10 年、income 按 20000 归一后

$$d'(A) = \sqrt{\left(\frac{1}{10}\right)^2 + \left(\frac{20000}{20000}\right)^2} \approx 1.01, \qquad d'(B) = \sqrt{\left(\frac{20}{10}\right)^2 + \left(\frac{1000}{20000}\right)^2} \approx 2.00$$

最近的邻居换成了 A。scaling 改变的不只是数值大小，而是 feature space 的几何，因此可能改变谁是邻居，最终改变预测。

![[Pasted image 20260915124258-01.png]]

图上左右两幅是同一批数据在缩放前后的邻域形状：缩放前的近邻区域被拉成一个扁长的椭圆，几乎只沿大尺度特征的方向延伸；缩放后它接近一个圆，两个特征才有可比的贡献。邻域形状变了，圈进来的样本就变了。

两种常用做法：

- Standardization（标准化）：先把训练集（该特征）的均值和标准差 $\mu_j$、$\sigma_j$ 算出来，然后标准化就是：$x_j' = \dfrac{x_j - \mu_j}{\sigma_j}$，它==把训练特征的中心移到 0、用标准差作单位度量数值，不产生固定的最小值与最大值==，是**距离型模型的常用默认选择**（不仅是 KNN）。
- Min–max scaling（极值归一化）：$x_j' = \dfrac{x_j - x_{j,\min}}{x_{j,\max} - x_{j,\min}}$，==把训练集的最小值映到 0、最大值映到 1==，通常落在 $[0,1]$；它对极端的 min/max 很敏感，适合希望数值范围有界的场合。

用课件的数据走一遍：训练集里 $\mu_{age}=40$、$\sigma_{age}=10$、$\mu_{income}=50000$、$\sigma_{income}=20000$，于是 $x_{new}=(30,60000)$ 标准化后是 $x'_{new}=(-1,0.5)$；同一组数据做 min–max（$20\le age\le 60$、$20000\le income\le 100000$）得到的是 $x'_{new}=(0.25,0.50)$。

两种方法没有普遍的最优解，需要用 validation data 比较；但 KNN 通常总需要某种形式的 scaling。关键约束是缩放参数只能由 training data 拟合，然后原样用于 validation 与 test：

```python
from sklearn.preprocessing import StandardScaler

scaler = StandardScaler()
X_train_s = scaler.fit_transform(X_train)   # 只用训练集估 μ 与 σ
X_val_s   = scaler.transform(X_val)         # 复用同一组参数
X_test_s  = scaler.transform(X_test)
```

`fit` 与 `transform` 分离正是这条规则的实现：一旦 $\mu_j$、$\sigma_j$ 用 validation 或 test 的数据算出，测试集的信息就通过缩放参数泄漏进了模型。

## 从分类到回归

KNN regression 找邻居的方式与 classification 完全一样，变的只是最后一步的聚合。$N_k(x)$ 仍然是 $x$ 的 $k$ 个最近邻，target 从类别换成连续值之后，==预测取它们的平均==：

$$\hat{y} = \frac{1}{k}\sum_{x_i \in N_k(x)} y_i$$

例如新房子周围最近的三个训练样本价格分别是 21 万、23 万、25 万美元，则 $\hat{y} = (210000+230000+250000)/3 = 230000$。<span class="red">classification 取邻居标签的众数，regression 取邻居 target 的平均值，其余步骤完全相同。</span>

## KNN 的强项与限制

KNN 容易理解和实现，同时支持 classification 与 regression，能表达 flexible 且 nonlinear 的关系，几乎不需要显式的模型训练，因此在小型数据集上是一个很强的 baseline。这些优点来自同一个事实：它不拟合一个复杂公式，而是依赖被存下来的数据的几何。

代价也随之而来：

- 必须存储全部训练样本，预测时对每个训练样本算一次距离，数据一大就很慢；
- 对 feature scaling 与无关特征敏感；
- 维度升高以后距离本身不再有区分度（scaling 一节已经展示了尺度如何扭曲“谁更近”，高维问题是同一件事的放大版）。

这页课件最后留了一个问题：如果 KNN 这么直观，为什么还需要别的模型？<span class="green">从这一讲内部的线索看，答案是它的“模型”就是数据本身——容量由数据表示和邻居个数决定，预测成本随数据量线性增长，而这两点正是后续模型要处理的对象。</span>

## 端到端流程

KNN 的算法只有五步，但围绕它的决定才是这门课真正要带走的东西。课件的完整流程是：

1. Define the problem：确定 features $\mathbf{x}$ 与 target $y$；
2. Represent the data：把每个对象转成 feature vector；
3. Split the labeled examples：划出 training、validation、test 三份；
4. Preprocess consistently：只用 training data 拟合 scaling 参数；
5. Build the model：KNN 把带标签的训练样本存下来；
6. Select the model：用 validation performance 选择 $k$；
7. Evaluate generalization：在未被触碰的 test set 上评价一次；
8. Predict future examples：套用同一套表示与预处理，找邻居并聚合。

概括起来就是 represent → split → scale → select k → test → predict，其中每一个决定都必须在看不到 test set 的前提下做出。这条流水线会在这门课后面的每个模型上重现，换掉的只是第 5、6 两步。

参考书对应章节：Müller & Guido, *Introduction to Machine Learning with Python* 第 1、2 章（features/samples/labels、generalization、overfitting 与 k-nearest neighbors），Géron, *Hands-On Machine Learning* 第 1 章，以及 Mitchell (1997) 中 task / experience / performance 的形式化定义。
