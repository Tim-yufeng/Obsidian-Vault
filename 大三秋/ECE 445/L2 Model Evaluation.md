这一讲回答上一讲留下的问题：KNN 给出的 $\hat{y}$ 到底能不能信。可信的评估需要两件事——在真正没见过的样本上测试，以及用能暴露重要错误的指标来衡量。

## 95% 的准确率也可能是彻底失败

医院筛查任务：用 KNN 判断病人是否需要随访，$\hat{y} \in \{\text{no follow-up}, \text{follow-up}\}$，其中正类（positive）是“需要随访”。

一个对 1000 个病人一律预测 no follow-up 的模型：判对 950 人，50 个需要随访的病人一个都没检出，准确率（accuracy）仍然是 $950/1000 = 0.95$。

| 实际情况 | 人数 | 模型预测 |
| --- | --- | --- |
| 不需要随访 | 950 | no follow-up（判对） |
| 需要随访 | 50 | no follow-up（全部漏掉） |

所以**可信的评估需要两件事**：一是在没有参与过学习的样本上测试，评估数据不能影响 model fitting、model selection 或 preprocessing 的任何决定；二是选择能反映真实任务的指标，让重要的失败可见。上面这个模型 95% 的准确率里，“0 / 50 检出”这件事完全没有露面。

## 三类数据各管一件事

带标签数据分成 training set、validation set 和 test set：训练集拟合模型，验证集比较候选，测试集只做一次最终评价。

用 1-nearest-neighbor 就能看出为什么不能用训练集评估：训练样本的最近邻就是它自己，模型直接返回自己存下来的标签，训练集上的正确率自然虚高。以 KNN 选 $k \in \{3,5,7\}$ 为例：

| 候选 | validation accuracy |
| --- | --- |
| $k=3$ | 90% |
| $k=5$ | 94% |
| $k=7$ | 92% |

选出 $k=5$，然后只用 test set 评价这个已经锁定的模型。每个决定该用哪份数据是固定的：

1. 计算 feature scaling 的均值和标准差 → training set；
2. 提供 KNN 需要的带标签邻居 → training set；
3. 比较 $k=3$、$k=5$、$k=7$ → validation set；
4. 报告最终性能 → test set。

划分前要先 shuffle：如果 100 条病人记录本身按结果排好了序（前 70 条 no follow-up、后 30 条 follow-up），直接按连续行切分会切出没有任何正类的训练集。

当一个对象有多条记录时，shuffle 的单位不是行而是对象。100 个病人各有 3 次就诊，共 300 条记录；按行打乱会让同一个病人的不同就诊分别落进训练集和测试集，模型在测试之前就已经见过这个人。正确做法是打乱 100 个 patient ID，让同一个病人的所有就诊记录进入同一个集合。**划分单位是 subject，不是 row。**

## 单次 hold-out 不够稳

同一个建模方法，如果 validation split 里恰好多是 profile 清楚、离 decision boundary 远的病人，分数就偏高；如果抽到的多是边界附近的模糊样本，分数就偏低。两种划分都合法，却可能给出相反的结论。为了减小单词划分带来的偶然性，我们引出交叉验证法。

## Five-fold cross-validation

cross-validation（交叉验证）把数据均分成若干份，每一份叫一个 fold（折）；分成五份就是 five-fold cross-validation（五折交叉验证）。流程是两步：

1. 先把 test set 单独留出来：all data → development data + untouched test set；
2. 对 development data 做 five-fold，**除 test data 以外的全部数据都用来选 $k$**。

![[Pasted image 20260917123704.png]]

每一轮（Round）留一折做验证、其余四折做训练，五轮下来每一折都恰好当过一次验证集。每一折内部做三件事：用四折拟合模型（preprocessing 也在这里拟合）→ 在被留出的那一折上预测 → 记录一个分数，然后把这个模型丢掉。**每一折都会重新训练一个全新的模型。**

### 走一遍完整流程

设定：development data 有 1000 个病人，候选 $k \in \{3,5,7\}$。先把 1000 人随机均分成 5 折，每折 200 人。对每一个 $k$：

1. Round 1：用 Fold 2–5（800 人）拟合 scaler 并训练 KNN，在 Fold 1（200 人）上算 accuracy，记下第一个分数；
2. Round 2：改用 Fold 1、3、4、5 训练，在 Fold 2 上验证；
3. 依次做完 5 轮，这一个 $k$ 就得到 5 个验证分数，例如 84%、88%、86%、91%、81%。

$k=3$、$k=5$、$k=7$ 各自跑完 5 轮，比较平均分（以及分数的波动）选出一个 $k$；选定的 $k$ 在全部 1000 人 development data 上重新拟合一次，最后在 untouched test set 上评价一次。

它解决的正是偶然性：每个样本都恰好被验证一次，每次验证用的都是那一轮没参与训练的 20%，平均分不再取决于“是不是碰巧抽到一批简单病人”。5 个分数之间的差距还额外给出稳定性信息——两组配置平均分同为 86% 时，81%–91% 和 85%–87% 显然不是一回事。

### 折内的预处理也只能看训练折

错误流程：用全部五折拟合 scaler → 用 Fold 1、3、4、5 训练 KNN → 在 Fold 2 上评价。问题出在 $\mu_j$、$\sigma_j$ 是用包含 Fold 2 的数据算出来的，验证折的信息在模型准备阶段就进来了，这就是数据泄漏（leakage）。

正确流程：只用 Fold 1、3、4、5 拟合 scaler → 用它 transform Fold 2 → 训练 KNN → 在 Fold 2 上评价。**每一个预处理步骤都只能用训练折拟合。**

scikit-learn 的 pipeline 把这件事变成默认行为：

```python
from sklearn.model_selection import cross_val_score
from sklearn.pipeline import make_pipeline
from sklearn.preprocessing import StandardScaler
from sklearn.neighbors import KNeighborsClassifier

pipe = make_pipeline(StandardScaler(), KNeighborsClassifier())
for k in [3, 5, 7]:
    pipe.set_params(kneighborsclassifier__n_neighbors=k)
    scores = cross_val_score(pipe, X_dev, y_dev, cv=5)   # 每折重新 fit scaler 与 KNN
    print(k, scores.mean(), scores.std())
```

`make_pipeline` 把 scaler 和 KNN 绑成一个整体，`cross_val_score` 在每一折里重新拟合整个 pipeline，scaler 只会看到那一折的训练部分，上面那种泄漏就不会发生。

### 什么时候值得做

数据有限或中等时用 five-fold：每个样本都能参与验证，每次模型用约 80% 的数据训练，结果不太依赖某一次随机划分，5 个分数还能看出波动。数据非常大时 hold-out 就够了——100 万个样本切 10% 仍有 10 万验证样本，而交叉验证要把训练重复 5 次。

交叉验证有两种用途：数据够时用它选模型（留出 test set，在 development data 上选 $k$）；数据非常小时用它估计性能（把各折分数平均当作泛化性能的估计，同时报告均值与波动）。但同一批交叉验证结果不能既用来选 $k$、又当作无偏的最终性能。

## 混淆矩阵：accuracy 藏起来了什么

混淆矩阵（confusion matrix）把预测按“实际类别 × 预测类别”摊开。对“一律预测 no follow-up”的模型，1000 人里 950 个判对、0 个误报、50 个漏掉、0 个检出；换成更好的配置则是：

|  | 预测 no follow-up | 预测 follow-up |
| --- | --- | --- |
| 实际 no follow-up | True Negative (TN) 真阴性：920，正确放过 | False Positive (FP) 假阳性：30，误报 |
| 实际 follow-up | False Negative (FN) 假阴性：10，漏掉 | True Positive (TP) 真阳性：40，正确检出 |

命名规则分两段：True / False 说的是模型判得对不对，Positive / Negative 说的是模型预测成了什么。这个任务里最危险的是 false negative——需要随访的病人被漏掉。

## Precision 与 Recall

**准确率（accuracy）** 的分子就是 TN 与 TP 之和：

$\text{Accuracy} = \frac{TN + TP}{\text{all predictions}} = \frac{920 + 40}{1000} = 96\%$

它把 950 个正确放过和 40 个正确检出加在一起，所以从 95% 涨到 96% 完全看不出“检出 0 人”已经变成“检出 40 人”。

![[Pasted image 20260917123655-01.png]]

**精确率（precision，也叫查准率）** 的分母是模型预测为 positive 的全部样本：

$\text{Precision} = \frac{TP}{TP + FP} = \frac{40}{70} \approx 57\%$

含义是“被判为 positive 的样本里，有多少是真的 positive”。**召回率（recall，也叫查全率）** 的分母是实际为 positive 的全部样本：

$\text{Recall} = \frac{TP}{TP + FN} = \frac{40}{50} = 80\%$

含义是“真正的 positive 被找回了多少”。<span class=“red”>三者只差在分母：accuracy 从全体出发，precision 从预测出发，recall 从真实出发。</span>

**F1 分数（F1 score）** 把 precision 与 recall 合起来，只有两者都不低时才高：

$F_1 = 2 \cdot \frac{\text{Precision} \cdot \text{Recall}}{\text{Precision} + \text{Recall}}$

哪个指标重要取决于哪种错误更贵：医学筛查漏掉病人代价大 → 优先 recall，可以接受一些误报；垃圾邮件过滤把正常邮件丢进垃圾箱代价大 → 优先 precision。多判 positive 会同时抬高 recall、压低 precision：

| 模型 | TP | FP | FN | Precision | Recall | F1 |
| --- | --- | --- | --- | --- | --- | --- |
| KNN A（少判 positive） | 30 | 10 | 20 | 75% | 60% | ≈0.67 |
| KNN B（多判 positive） | 45 | 45 | 5 | 50% | 90% | ≈0.64 |

筛查任务里通常会批准 B，因为漏掉病人的代价远大于一次误报；但如果随访检查本身昂贵、有风险或者医院容量有限，这个决定就会翻转。F1 把两种错误同等看待，它不替你决定哪种错误更贵。

## 多分类

二分类 (Binary Classification) 的 target 只有两个类别；多分类（Multiclass Classification）的 target 有 $C > 2$ 个互斥类别，混淆矩阵每个类别占一行一列：

| 实际 ↓ / 预测 → | Setosa | Versicolor | Virginica |
| ----------- | ------ | ---------- | --------- |
| Setosa      | 18     | 0          | 0         |
| Versicolor  | 0      | 16         | 2         |
| Virginica   | 0      | 3          | 15        |

评价某一个类别时，把它当作 positive、其余当作 negative，就能逐类算 precision、recall 与 F1。以 versicolor 为例：$TP = 16$，$FN = 2$（被预测成 virginica），$FP = 3$（virginica 被预测成 versicolor），于是 precision 与 recall 分别是 $16/19$ 与 $16/18$。

## 回归指标：MAE、RMSE 与 $R^2$

同样的评估逻辑用在连续 target 上。KNN 回归预测房价，新房在 feature space 里的 $k=3$ 个邻居成交价是 260、280、300（单位 ¥10,000），预测取平均：

$\hat{y} = \frac{260 + 280 + 300}{3} = 280$

实际成交 300，误差 $e_i = y_i - \hat{y}_i = +20$，也就是低了 ¥200,000。误差的符号给方向（正 = 低估，负 = 高估），大小给偏差量。

**平均绝对误差（mean absolute error, MAE）** 取绝对值去掉方向，每个误差线性计入：

$\text{MAE} = \frac{1}{n}\sum_{i=1}^{n}|y_i - \hat{y}_i| = \frac{|20| + |{-20}| + |70|}{3} \approx 36.7$

结果是 ¥367,000，与 target 同单位，可以直接读成“典型误差”。

**均方根误差（root mean squared error, RMSE）** 先平方再平均，==大误差被放大==（数学上不难理解）：

$\text{RMSE} = \sqrt{\frac{1}{n}\sum_{i=1}^{n}(y_i - \hat{y}_i)^2} = \sqrt{\frac{20^2 + (-20)^2 + 70^2}{3}} \approx 43.6$

所以这批数据里 RMSE（¥436,000）明显大于 MAE。极端例子更清楚：误差 10、10、10、10 与 0、0、0、40 的 MAE 都是 10，RMSE 却分别是 10 和 20。

选择取决于大误差的代价：房价误差 20 万大致就应该算成 10 万的两倍 → 用 MAE；电力需求预测里一次大偏差会造成严重缺电或昂贵的过剩容量 → 用 RMSE。
![[Pasted image 20260920101835.png]]

**决定系数（coefficient of determination, $R^2$）** 把模型与一个“永远预测均值”的基线比较：

$R^2 = 1 - \frac{\sum_i (y_i - \hat{y}_i)^2}{\sum_i (y_i - \bar{y})^2} = 0.72$

它表示平方误差比均值基线少了 72%。$R^2 = 1$ 是完美预测，$R^2 = 0$ 表示不比均值基线好，$R^2 < 0$ 表示比均值基线还差（在未见数据上可能出现）。它不是“预测正确的比例”。

```python
from sklearn.metrics import confusion_matrix, precision_score, recall_score, f1_score

print(confusion_matrix(y_test, y_pred))   # [[TN, FP], [FN, TP]]
print(precision_score(y_test, y_pred))    # TP / (TP + FP)
print(recall_score(y_test, y_pred))       # TP / (TP + FN)
print(f1_score(y_test, y_pred))           # 2PR / (P + R)
```

```python
import numpy as np
from sklearn.metrics import mean_absolute_error, mean_squared_error, r2_score

print(mean_absolute_error(y_test, y_pred))          # 误差的平均大小
print(np.sqrt(mean_squared_error(y_test, y_pred)))  # 先平方求均值，再开方
print(r2_score(y_test, y_pred))                     # 相对均值基线的改进
```

## 完整流程与终检

一个可信的评估长这样。development 阶段：保住 test set；先定好评价指标；用 five-fold 比较 $k=3,5,7$；选出一个 $k$。最终评价：用全部 development data 重新拟合选定流程；在 test set 上只评一次；报告混淆矩阵和选定指标。

反例是一份学生报告的审计：他按行 shuffle 拆分所有就诊记录、用完整数据算 scaling 参数、用 test accuracy 比较 $k$、选定 $k=5$ 之后又报告同一个 test accuracy。这个 96% 至少有四个问题——同一个病人的多次就诊落在不同集合里；test 信息参与了 feature scaling；test set 被用来选 $k$；accuracy 可能掩盖漏诊。

<span class=“red”>可信的结果需要三件事：未参与任何决策的数据、与任务匹配的指标、以及把划分方式与指标选择都写清楚的报告。</span>

<span class=“green”>这三条约束——按 subject 划分、scaler 只看训练折、test set 不参与选 k——其实是同一条判据：任何在真正预测新病人时拿不到的信息，都不能影响建模过程中的任何一步。</span>

参考书章节：Müller & Guido 第 5 章（cross-validation、grid search、classification metrics、regression metrics），Géron 第 2 章（创建 test set、RMSE 与 cross-validation）与第 3 章（confusion matrix、precision / recall / F1、multiclass evaluation）。
