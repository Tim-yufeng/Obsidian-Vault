
---
## 📝 基本语法

- **写法**：`<% ... %>`
    
- **执行 JS 语句**：`<%* ... %>`（多行脚本模式）
    
- **对象入口**：`tp`（Templater 内置对象）
    

---

## 📅 日期与时间

|语法|含义|示例输出|
|---|---|---|
|`<% tp.date.now("YYYY-MM-DD") %>`|当前日期|2025-09-09|
|`<% tp.date.now("dddd") %>`|星期几|Tuesday|
|`<% tp.date.now("HH:mm") %>`|当前时间|22:45|
|`<% tp.date.now("YYYY-[W]ww") %>`|年份+周数|2025-W37|
|`<% tp.date.now("MMMM Do, YYYY") %>`|完整日期|September 9th, 2025|

💡 日期格式遵循 [Moment.js](https://momentjs.com/docs/#/displaying/format/) 规则。

---

## 📄 文件信息

|语法|含义|示例输出|
|---|---|---|
|`<% tp.file.title %>`|当前文件名（不含扩展名）|Lecture-Week1|
|`<% tp.file.path %>`|文件路径|Notes/Class/Lecture-Week1.md|
|`<% tp.file.folder() %>`|所在文件夹|Class|
|`<% tp.file.creation_date("YYYY-MM-DD") %>`|文件创建日期|2025-09-08|
|`<% tp.file.last_modified_date("HH:mm") %>`|文件修改时间|21:30|

---

## 🙋 用户输入

|语法|含义|示例|
|---|---|---|
|`<% tp.user.name %>`|调用自定义脚本变量|"Yufeng"|
|`<% tp.system.prompt("请输入关键词") %>`|弹出输入框|（手动输入）|

---

## 🔄 引用与插入

|语法|含义|示例|
|---|---|---|
|`<% tp.file.include("[[Template-Note]]") %>`|插入另一份模板内容|（展开成模板文本）|
|`<% tp.user.todayNote() %>`|调用自定义函数（如“生成今日笔记路径”）|Notes/Daily/2025-09-09.md|

---

## ⚡ 脚本模式

- **多行 JS 脚本**：
    

```markdown
<%*
let course = await tp.system.prompt("课程名？")
tR += `# ${course} 笔记`
%>
```

👉 插入时会弹出输入框，生成标题。

---

## 🎯 常见场景

- **日记**：`# 日记 <% tp.date.now("YYYY-MM-DD") %>`
    
- **科研**：`# <% tp.file.title %> - <% tp.date.now("YYYY-MM-DD") %>`
    
- **课堂**：`课程: <% tp.system.prompt("课程名？") %>`
    

---

⚡ **最佳实践**：

- 常用 `<% tp.date.now %>`、`<% tp.file.title %>` 就能覆盖 80% 场景。
    
- 进阶时再用 `tp.system.prompt`、脚本模式做交互。
    
- 模板放在 `Templates/` 文件夹统一管理。
    

---
