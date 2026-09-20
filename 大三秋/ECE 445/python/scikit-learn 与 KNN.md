# scikit-learn 与 KNN

> 适用于 ECE 445 Lab 1。重点是看懂 Python 对象怎样在代码中流动，以及怎样用 scikit-learn 完成 KNN 分类与回归。原始手册按 scikit-learn 1.6.1 编写。

## 先抓住整条代码链

一段常见的 KNN 代码，本质上只有这条链：

```text
读取数据 → 拆分数据 → 创建模型 → fit → predict → 计算指标
```

```python
from sklearn.datasets import load_iris
from sklearn.model_selection import train_test_split
from sklearn.pipeline import make_pipeline
from sklearn.preprocessing import StandardScaler
from sklearn.neighbors import KNeighborsClassifier
from sklearn.metrics import accuracy_score

iris = load_iris(as_frame=True)
X = iris.data
y = iris.target

X_train, X_test, y_train, y_test = train_test_split(
    X,
    y,
    test_size=0.20,
    random_state=42,
    stratify=y,
)

model = make_pipeline(
    StandardScaler(),
    KNeighborsClassifier(n_neighbors=5),
)

model.fit(X_train, y_train)
y_pred = model.predict(X_test)
accuracy = accuracy_score(y_test, y_pred)
```

把这段代码按对象理解：

| 代码 | 得到什么 |
|---|---|
| `load_iris(...)` | 装着数据和说明的 `Bunch` |
| `iris.data` | 特征表 `X` |
| `iris.target` | 标签 `y` |
| `train_test_split(...)` | 四个互相配对的数据块 |
| `make_pipeline(...)` | 一个完整的 `Pipeline` 模型 |
| `model.fit(...)` | 模型读取并记住训练数据中的信息 |
| `model.predict(...)` | 一维预测数组 |
| `accuracy_score(...)` | 一个分数 |

## 读取数据后先看类型与形状

### `load_iris()` 与 `load_diabetes()`

```python
from sklearn.datasets import load_iris, load_diabetes

iris = load_iris(as_frame=True)
X_cls = iris.data
y_cls = iris.target

diabetes = load_diabetes(as_frame=True)
X_reg = diabetes.data
y_reg = diabetes.target
```

`as_frame=True` 让特征和目标保留为 Pandas 对象，列名更容易检查。数据集本身仍是 `Bunch`，可以把它理解成“能用点号取内容的字典”。

`load_diabetes()` 还提供 `scaled` 参数，默认 `scaled=True`；只有明确需要原始尺度时才设为 `False`。`load_iris()` 没有这个参数。

| 成员 | 内容 |
|---|---|
| `.data` | 输入特征 |
| `.target` | 分类标签或回归目标 |
| `.feature_names` | 特征名列表 |
| `.target_names` | 分类数据的类别名 |
| `.frame` | 特征和目标合在一起的表 |
| `.DESCR` | 数据集说明 |

也可以直接得到两个对象：

```python
X, y = load_iris(return_X_y=True, as_frame=True)
```

拿到新数据后，先检查：

```python
print(type(X), type(y))
print(X.shape, y.shape)
print(X.columns)
print(X.head())
print(y.head())
```

很多报错并不是模型有问题，而是对象类型、行数或列名和预想的不一样。

## 拆分数据：返回顺序不能写乱

```python
from sklearn.model_selection import train_test_split

X_train, X_test, y_train, y_test = train_test_split(
    X,
    y,
    test_size=0.20,
    random_state=42,
    stratify=y,
)
```

`train_test_split(X, y, ...)` 同时把 `X` 和 `y` 按相同的行位置拆开，返回顺序固定为：

```text
X 的较大部分，X 的较小部分，y 的较大部分，y 的较小部分
```

所以左侧通常写成 `X_train, X_test, y_train, y_test`。函数只看位置，不会根据变量名帮忙纠正。

常用参数：

| 参数 | 作用 |
|---|---|
| `test_size=0.20` | 测试集占总数据的 20% |
| `random_state=42` | 固定随机拆分，方便复现 |
| `shuffle=True` | 拆分前打乱，默认开启 |
| `stratify=y` | 分类时尽量保持各类别比例 |

### 训练集、验证集、测试集

调参数时，先留出测试集，再把剩余部分拆成训练集和验证集：

```python
X_train_valid, X_test, y_train_valid, y_test = train_test_split(
    X,
    y,
    test_size=0.20,
    random_state=42,
    stratify=y,
)

X_train, X_valid, y_train, y_valid = train_test_split(
    X_train_valid,
    y_train_valid,
    test_size=0.25,
    random_state=42,
    stratify=y_train_valid,
)
```

第二次拆分时，`stratify` 必须使用当前正在拆的 `y_train_valid`，不能继续传原始 `y`。这两次拆分最终得到约 60% 训练、20% 验证、20% 测试。

测试集只在参数确定后使用。若一边看测试结果一边改参数，测试集就不再是一次独立的最终检查。

## `StandardScaler`：只在训练数据上拟合

```python
from sklearn.preprocessing import StandardScaler

scaler = StandardScaler()
X_train_scaled = scaler.fit_transform(X_train)
X_valid_scaled = scaler.transform(X_valid)
X_test_scaled = scaler.transform(X_test)
```

三个动作要分清：

| 方法 | 做什么 | 会不会改变 `scaler` 的状态 |
|---|---|---|
| `fit(X_train)` | 记录训练集各列的均值和缩放量 | 会 |
| `transform(X)` | 使用已经记录的量转换新数据 | 不会 |
| `fit_transform(X_train)` | 先拟合，再转换同一份数据 | 会 |
<span class="green"> fit_transform 是通过训练集数据计算均值和标准差，换句话说就是用训练集来学习如何标准化，scaler.fit_transform(X_train) 完成标准化换算器 scaler 的学习过程，紧跟着他的输出赋值给 X_train_scaled 完成对训练集的标准化；然后 transform 使用这套规则分别对验证集和测试集完成标准化，这一步不涉及标准化规则的学习，因此不会改变 scaler</span>

拟合后可以查看：

```python
print(scaler.mean_)
print(scaler.scale_)
print(scaler.n_features_in_)
```

以 `_` 结尾的属性通常只有 `fit()` 后才存在。

不要这样做：

```python
X_train_scaled = scaler.fit_transform(X_train)
X_valid_scaled = scaler.fit_transform(X_valid)  # 错：又拟合了一次
```

验证集和测试集只能使用训练集得到的缩放规则。否则模型在训练期间间接看到了本应未知的数据。

两个较少用但方便调试的方法：

```python
X_original_units = scaler.inverse_transform(X_train_scaled)

scaler = StandardScaler().set_output(transform="pandas")
X_train_scaled = scaler.fit_transform(X_train)
```

第一种把数值换回原尺度；第二种让转换结果继续保留为 DataFrame。稀疏矩阵通常要设 `with_mean=False`，普通 Lab 数据保持默认即可。

## Pipeline：把预处理和模型绑在一起

手动缩放容易漏步骤，因此更推荐：

```python
from sklearn.pipeline import make_pipeline

model = make_pipeline(
    StandardScaler(),
    KNeighborsClassifier(n_neighbors=5),
)
```

调用：

```python
model.fit(X_train, y_train)
y_pred = model.predict(X_valid)
```

Pipeline 内部会自动完成：

```text
fit 时：scaler.fit_transform(X_train) → KNN.fit(..., y_train)
predict 时：scaler.transform(X_valid) → KNN.predict(...)
```

因此传给 Pipeline 的应是原始 `X_train`、`X_valid`、`X_test`。不要在外面先缩放一次，否则数据会被重复转换。

### 查看和修改内部参数

`make_pipeline` 会自动生成小写步骤名：

```python
print(model.named_steps)
print(model.get_params().keys())
```

这个 Pipeline 的内部参数名形如：

```text
standardscaler__with_mean
kneighborsclassifier__n_neighbors
kneighborsclassifier__weights
```

双下划线表示“某一步里的某个参数”。修改后要重新 `fit()`：

```python
model.set_params(
    kneighborsclassifier__n_neighbors=9,
    kneighborsclassifier__weights="distance",
)
model.fit(X_train, y_train)
```

需要自定义短步骤名时，可以改用：

```python
from sklearn.pipeline import Pipeline

model = Pipeline([
    ("scale", StandardScaler()),
    ("knn", KNeighborsClassifier()),
])

model.set_params(knn__n_neighbors=9)
```

## KNN 分类

```python
from sklearn.neighbors import KNeighborsClassifier

knn = KNeighborsClassifier(
    n_neighbors=7,
    weights="distance",
    metric="minkowski",
    p=2,
    n_jobs=-1,
)
```

Lab 1 最值得调整的参数：

| 参数 | 常用值 | 作用 |
|---|---|---|
| `n_neighbors` | `1, 3, 5, ...` | 使用多少个邻居 |
| `weights` | `"uniform"` | 每个邻居等权 |
| `weights` | `"distance"` | 距离越近，权重越大 |
| `p` | `1` | 配合 Minkowski metric 使用 Manhattan distance |
| `p` | `2` | 配合 Minkowski metric 使用 Euclidean distance |
| `n_jobs` | `-1` | 邻居搜索使用可用处理器 |

`algorithm`、`leaf_size` 等参数通常先保持默认。若 `metric` 本身不使用 `p`，改 `p` 也不会产生预期作用。

### 常用方法

```python
model.fit(X_train, y_train)

y_pred = model.predict(X_valid)
probabilities = model.predict_proba(X_valid)
```

`predict()` 返回一维 NumPy 数组。`predict_proba()` 的每一列对应一个类别，列顺序应从分类器的 `classes_` 查看：

```python
classifier = model.named_steps["kneighborsclassifier"]
print(classifier.classes_)
print(probabilities[0])
```

查询实际邻居时，要先经过 Pipeline 内已经拟合好的 scaler：

```python
scaler = model.named_steps["standardscaler"]
classifier = model.named_steps["kneighborsclassifier"]

X_query_scaled = scaler.transform(X_valid.iloc[[0]])
distances, indices = classifier.kneighbors(
    X_query_scaled,
    n_neighbors=5,
)

neighbor_rows = X_train.iloc[indices[0]]
```

这里使用 `iloc`，因为 `indices` 给出的是训练数据中的位置，而不是原始索引标签。

### 单个样本仍要保持二维

```python
one_row = X_valid.iloc[[0]]  # DataFrame，shape 为 (1, 特征数)
prediction = model.predict(one_row)
```

不要用 `X_valid.iloc[0]`，它会得到一维 Series，常引发 `Expected 2D array`。

## KNN 回归

```python
from sklearn.neighbors import KNeighborsRegressor

model = make_pipeline(
    StandardScaler(),
    KNeighborsRegressor(
        n_neighbors=11,
        weights="uniform",
    ),
)

model.fit(X_train, y_train)
y_pred = model.predict(X_valid)
```

分类器和回归器都有 `fit()`、`predict()`、`kneighbors()`、`get_params()` 和 `set_params()`。主要差别是：

| 分类 | 回归 |
|---|---|
| 输出类别 | 输出连续数值 |
| 有 `predict_proba()` | 没有 `predict_proba()` |
| `score()` 是 accuracy | `score()` 是 $R^2$ |

若作业要求 mean absolute error (MAE)，不能把回归器的 `score()` 当作 MAE，必须显式计算。

## 指标：真实值在前，预测值在后

所有常见指标都按这个顺序：

```python
metric(y_true, y_pred)
```

### 分类指标

```python
from sklearn.metrics import (
    accuracy_score,
    precision_score,
    recall_score,
    f1_score,
    confusion_matrix,
    classification_report,
)

accuracy = accuracy_score(y_test, y_pred)
precision = precision_score(y_test, y_pred, average="macro")
recall = recall_score(y_test, y_pred, average="macro")
f1 = f1_score(y_test, y_pred, average="macro")
cm = confusion_matrix(y_test, y_pred)
print(classification_report(y_test, y_pred, digits=3))
```

多分类时常见的 `average`：

| 值 | 含义 |
|---|---|
| `"macro"` | 每类分别计算，再等权平均 |
| `"weighted"` | 每类分别计算，再按样本数加权 |
| `"micro"` | 先汇总各类计数，再计算 |
| `None` | 返回每个类别各自的结果 |

显示 confusion matrix：

```python
from sklearn.metrics import ConfusionMatrixDisplay

ConfusionMatrixDisplay.from_predictions(
    y_test,
    y_pred,
    display_labels=iris.target_names,
    cmap="Blues",
)
```

### 回归指标

```python
from sklearn.metrics import mean_absolute_error

mae = mean_absolute_error(y_test, y_pred)
```

MAE 越小越好；accuracy、precision、recall 和 F1 通常越大越好。这个方向会直接决定后面使用 `idxmin()` 还是 `idxmax()`。

## 手动比较多组参数

通用结构是“每轮新建模型，算一次结果，存一个字典”：

```python
import pandas as pd

candidate_k = [1, 3, 5, 7, 9, 11, 13, 15]
candidate_weights = ["uniform", "distance"]
rows = []

for weights in candidate_weights:
    for k in candidate_k:
        model = make_pipeline(
            StandardScaler(),
            KNeighborsClassifier(
                n_neighbors=k,
                weights=weights,
            ),
        )

        model.fit(X_train, y_train)
        train_pred = model.predict(X_train)
        valid_pred = model.predict(X_valid)

        rows.append({
            "k": k,
            "weights": weights,
            "training_accuracy": accuracy_score(y_train, train_pred),
            "validation_accuracy": accuracy_score(y_valid, valid_pred),
        })

results = pd.DataFrame(rows)
```

`append()` 必须在内层循环中，否则不会保存每一组参数的结果。每轮都重新创建模型，保存到表中的是参数和分数，不是模型本身。

### 从结果表选出参数

```python
best_index = results["validation_accuracy"].idxmax()
best_row = results.loc[best_index]

best_k = int(best_row["k"])
best_weights = best_row["weights"]
```

| 方法 | 返回什么 |
|---|---|
| `max()` / `min()` | 最大或最小的数值 |
| `idxmax()` / `idxmin()` | 该数值所在行的索引标签 |
| `loc[label]` | 按索引标签取行 |
| `iloc[position]` | 按位置取行 |

回归中选最小 MAE：

```python
best_index = results["validation_MAE"].idxmin()
best_k = int(results.loc[best_index, "k"])
```

若多个候选得到相同最佳分数，可以先筛选，再明确自己的 tie-break rule：

```python
best_accuracy = results["validation_accuracy"].max()
best_candidates = results[
    results["validation_accuracy"] == best_accuracy
]

uniform_candidates = best_candidates[
    best_candidates["weights"] == "uniform"
]

if not uniform_candidates.empty:
    best_candidates = uniform_candidates

best_row = best_candidates.sort_values(by="k").iloc[0]
```

这里的规则是：并列时先选 `uniform`，仍并列时选更小的 `k`。规则也可以换，但不要让结果依赖“刚好哪一行排在最前面”。

### 用选出的参数训练最终模型

```python
final_model = make_pipeline(
    StandardScaler(),
    KNeighborsClassifier(
        n_neighbors=int(best_row["k"]),
        weights=best_row["weights"],
    ),
)

final_model.fit(X_train_valid, y_train_valid)
test_pred = final_model.predict(X_test)
test_accuracy = accuracy_score(y_test, test_pred)
```

最终模型要用训练集和验证集合并后的 `X_train_valid`、`y_train_valid` 重新拟合，再对测试集做一次最终评估。

## 用 `GridSearchCV` 自动搜索

手动循环适合看清过程；`GridSearchCV` 可以把“遍历参数 + cross-validation + 重新拟合最佳模型”合在一起。

```python
from sklearn.model_selection import GridSearchCV

pipeline = make_pipeline(
    StandardScaler(),
    KNeighborsClassifier(),
)

param_grid = {
    "kneighborsclassifier__n_neighbors": [1, 3, 5, 7, 9],
    "kneighborsclassifier__weights": ["uniform", "distance"],
}

search = GridSearchCV(
    estimator=pipeline,
    param_grid=param_grid,
    scoring="accuracy",
    cv=5,
    n_jobs=-1,
    refit=True,
    return_train_score=True,
)

search.fit(X_train_valid, y_train_valid)

print(search.best_params_)
print(search.best_score_)

final_model = search.best_estimator_
test_pred = final_model.predict(X_test)
```

常用拟合后属性：

| 属性 | 内容 |
|---|---|
| `best_params_` | 最佳参数字典 |
| `best_score_` | 最佳平均验证分数 |
| `best_estimator_` | 已按最佳参数重新拟合的 Pipeline |
| `cv_results_` | 所有候选结果 |

`param_grid` 中的参数名也遵守 `步骤名__参数名`。拿不准时直接查看：

```python
print(pipeline.get_params().keys())
```

只想得到 cross-validation 的分数时：

```python
from sklearn.model_selection import cross_val_score

scores = cross_val_score(
    pipeline,
    X_train_valid,
    y_train_valid,
    scoring="accuracy",
    cv=5,
    n_jobs=-1,
)

print(scores)
print(scores.mean(), scores.std())
```

## 常见报错怎么定位

### `NameError`

变量还不存在。Notebook 中常见原因是导入或创建变量的单元格没有运行，或变量名拼写前后不一致。重启后应从头顺序运行。

### `NotFittedError`

在 `predict()` 前忘了 `fit()`：

```python
model.fit(X_train, y_train)
y_pred = model.predict(X_valid)
```

### `Expected 2D array, got 1D array`

单行输入仍要保留二维：

```python
one_row = X.iloc[[0]]
```

NumPy 数组可写：

```python
one_row = array[0].reshape(1, -1)
```

### 特征名称或顺序不一致

预测时列名和顺序应与拟合时一致：

```python
print(model.feature_names_in_)
X_query = X_query[model.feature_names_in_]
```

### `n_neighbors` 大于训练样本数

```python
print(len(X_train))
print(model.get_params()["kneighborsclassifier__n_neighbors"])
```

减小 `n_neighbors`，尤其要注意 cross-validation 中每一折的实际训练集更小。

### 参数名写错

构造器参数是 `n_neighbors`，不是 `neighbor`。Pipeline 内部参数还要加步骤名前缀：

```python
print(KNeighborsClassifier().get_params())
print(model.get_params().keys())
```

类名是 `StandardScaler`，不是 `StandardScalar`。

### 输入长度不一致

```python
print(len(X_train), len(y_train))
print(len(y_test), len(y_pred))
```

`fit(X, y)`、指标函数以及共同拆分的数据都要求样本数互相对应。

### 不知道变量现在是什么

```python
print(type(object_name))
print(getattr(object_name, "shape", None))
print(model)
print(model.named_steps)
```

先确认类型和 shape，再看后续方法是否真的适用于这个对象。

## 最后检查：读代码时问这八个问题

1. 这一行返回什么类型？
2. 返回值交给了哪个变量？
3. 这个方法会不会改变对象内部状态？
4. 输入是一维还是二维，shape 是什么？
5. 当前按位置取值，还是按索引标签取值？
6. 循环中每次新建了什么，又保存了什么？
7. Pipeline 的内部步骤名是什么？
8. 选择结果时应取最大还是最小，返回的是数值还是索引？

这八个问题能把一大段代码拆成一串可逐项检查的调用。最关键的边界始终是：预处理只从训练数据学习，参数只用验证过程决定，测试集只负责最后一次检查。
