---
title: Home
aliases: [首页, Base]
tags: [base, index]
---

# 🏠 我的知识库首页

## 🔎 Quick Links
- [[2025 Fall Semester Course Index]]
- 📥 [[任务总览]]
- 📅 [[Daily Notes Index]]
- 📚 [[Reading List]]
- 🗂️ [[Projects]]
- ⚙️ [[Templates Index]]
- 🖼️ [[Obsidian使用指北-目录]]

---

## 📌 Today（今日）
> 快速概览：把今日最重要的 1-3 件事写在这里，或嵌入今天的 Daily Note。
- 今日重点： 
- 今日待办：
![[Daily/2025-09-11]]  <!-- 如果你用 Templater 可以改成动态日期 -->

---

## 🚧 In Progress（进行中项目）
```dataview
table status as "状态", file.link as "项目", due as "截止"
from "Projects"
where contains(tags, "project") or folder = "Projects"
sort due asc


