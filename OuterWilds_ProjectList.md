## 1. 四文件基础框架代码

### 文件一：全局调度 `beamerthemeOuterWilds.sty`

负责统一调用子主题并设置全局参数 。

Code snippet

```
\ProvidesPackage{beamerthemeOuterWilds}

% 调用子主题 
\usecolortheme{OuterWilds}
\useinnertheme{OuterWilds}
\useoutertheme{OuterWilds}

% 移除底部导航符号 
\setbeamertemplate{navigation symbols}{}

% 设置全局区块阴影
\setbeamertemplate{blocks}[rounded][shadow=true]
```

### 文件二：色彩定义 `beamercolorthemeOuterWilds.sty`

将游戏中的核心色调映射到 Beamer 元素中 。

Code snippet

```
\ProvidesPackage{beamercolorthemeOuterWilds}
\RequirePackage{xcolor}

% 定义核心色调 [cite: 12, 13]
\definecolor{OWCampfire}{HTML}{EE6D25} % 篝火橙
\definecolor{OWNomaiBlue}{HTML}{2260AD} % 挪麦蓝
\definecolor{OWGiantsDeep}{HTML}{558E8C} % 深巨星绿
\definecolor{OWGhostMatter}{HTML}{51BE93} % 幽灵物质绿
\definecolor{OWEyeDark}{HTML}{0B1333}    % 宇宙之眼深空蓝

% 应用色彩映射
\setbeamercolor{palette primary}{bg=OWEyeDark, fg=white}
\setbeamercolor{title}{fg=OWCampfire}
\setbeamercolor{frametitle}{fg=OWNomaiBlue}
\setbeamercolor{structure}{fg=OWNomaiBlue} % 影响列表项等
\setbeamercolor{block title}{bg=OWNomaiBlue, fg=white}
\setbeamercolor{block body}{bg=OWNomaiBlue!10, fg=black}
\setbeamercolor{alerted text}{fg=OWGhostMatter} % 警示色 [cite: 13]
```

### 文件三：内部布局 `beamerinnerthemeOuterWilds.sty`

负责标题页、列表项环境及列表符号 。

Code snippet

```
\ProvidesPackage{beamerinnerthemeOuterWilds}
\RequirePackage{tikz}

% 设置列表项符号（后续将替换为您准备的图标） 
\setbeamertemplate{itemize item}{\tikz{\draw[fill] (0,0) circle (0.5ex);}} 

% 标题页布局定制 
\defbeamertemplate*{title page}{OuterWilds}[1][]{
  \vfill
  \begingroup
    \centering
    \begin{beamercolorbox}[sep=8pt,center,#1]{title}
      \usebeamerfont{title}\inserttitle\par
      \ifx\insertsubtitle\@empty\else
        \vskip0.25em
        {\usebeamerfont{subtitle}\usebeamercolor[fg]{subtitle}\insertsubtitle\par}
      \endif
    \end{beamercolorbox}
  \endgroup
  \vfill
}
```

### 文件四：外部装饰 `beamerouterthemeOuterWilds.sty`

管理页眉页脚、背景画布及进度条 。

Code snippet

```
\ProvidesPackage{beamerouterthemeOuterWilds}
\RequirePackage{tikz}

% 背景集成：区分封面与普通页 [cite: 59]
\usebackgroundtemplate{
  \begin{tikzpicture}
    \useasboundingbox (0,0) rectangle(\the\paperwidth,\the\paperheight);
    \ifnum\thepage=1
      % 封面使用 start_page.png 
      \node[inner sep=0pt, anchor=center] at (current page.center) 
        {\includegraphics[width=\paperwidth, height=\paperheight]{start_page.png}};
    \else
      % 内容页使用 solar_system1.png 并设置透明度 [cite: 43, 53]
      \node[opacity=0.15, inner sep=0pt, anchor=center] at (current page.center) 
        {\includegraphics[width=\paperwidth, height=\paperheight]{solar_system1.png}};
    \fi
  \end{tikzpicture}
}
```

---

## 2. 逐步完善指南

建议您按照以下顺序分步推进：

### 第一步：色彩与字体的精确校准

- **任务**：在 `beamercolortheme` 中微调色值。如果可能，安装并配置游戏原版字体 **ITC Serif Gothic** 。
    
- **素材利用**：观察 `eye1.png` 中的亮部色调，用于设置 `frametitle` 的前景色。
    

### 第二步：利用 TikZ 丰富背景细节

- **任务**：在 `beameroutertheme` 中，使用 TikZ 在普通页的右下角添加 `symbol3.png` 中的“哈斯星探险 Logo”作为低对比度水印 。
    
- **进阶**：使用您的 `nomai_words1.png` 结合 TikZ 的 `opacity` 属性，在页眉或页脚处绘制微弱的挪麦文字轨迹 。
    

### 第三步：图标化列表项 (Itemize Bullets)

- **任务**：将 `beamerinnertheme` 中的列表符号替换为您转换好的 SVG 矢量图标 。
    
    - **一级列表**：使用 `eye1.svg` (宇宙之眼螺旋)。
        
    - **二级列表**：使用行星图标（如木炉星）。
        
- **注意**：需要引入 `svg` 宏包支持。
    

### 第四步：实现“22 分钟”进度条

- **任务**：在 `beameroutertheme` 的 `footline` 模板中添加一个 TikZ 矩形，其宽度随 `\insertframenumber/\inserttotalframenumber` 动态增长，并模仿氧气条的色彩渐变 。
    

---

**您想先深入实现哪一部分？我可以为您提供“宇宙之眼”图标作为列表 Bullet 的具体 TikZ 替换代码。**