<span class="green"> 运行了./bin/TxtToInp Dense4/“encode MatTiles_137 4.txt” Dense4/MatTiles_137_4.inp，成功生成了第一个inp文件，并且能够成功导入Abaqus，结果是一张2D矩形平板 </span>
![[Pasted image 20260412221224.png]]
在有限元中处理拓扑结构的常见方法有两种：贴体网格（Body-fitted mesh，即你期望的镂空网格）与固定网格（Fixed grid/多材料插值）。我们当前采用的是后者。

- **因果关系**：为了避免在代码中进行极度复杂且容易报错的布尔抠图运算和非结构化网格划分，C++ 脚本生成了一个完整的 $400 \times 400$ 结构化网格矩阵。
    
- **物理属性**：镂空图案并非通过“删除单元”实现，而是通过**材料指派**实现。网格中的实体部分被赋予了 `SolidMat`（常规刚度），而原本应该是孔洞的地方被赋予了 `VoidMat`（其杨氏模量被设定为基体的 $0.001$ 倍）。在宏观受力时，这些孔洞单元的承载力几乎为零，等效于拓扑镂空。
    
- **维度差异**：论文中不仅包含二维模型（Fig 2, 3, 4），还探讨了三维拓展（Fig 6）。你目前处理的 `MatTiles` 及其权重集 `Dense4` 属于二维空间（平面应力问题），因此呈现为 2D 形式是正确的。三维模型需要采用体素（Voxel）和 C3D8 单元重新映射。
    

**如何在 Abaqus 中验证真实拓扑图案：**

1. 在左侧模型树中展开 `Assembly` -> `Sets`。
    
2. 找到 `SOLID_SET` 和 `VOID_SET`。
    
3. 点击上方菜单栏的 `Tools` -> `Display Group` -> `Create...`。
    
4. 在 Item 选框中选择 `Elements`，在 Method 中选择 `Element sets`。
    
5. 选中 `VOID_SET`，点击下方的 **Remove**。此时，极其微弱的软材料被隐藏，你将直接看到与论文完全一致的错综复杂的错位网格拓扑。

<span class="green"> 隐藏软材料后得到的是一个平面十字形，且长度宽度正好为20格； </span>
