# 02 Linux

本节目标是能在 Linux 下自主完成日常操作：在目录树里移动、增删改查文件、把程序的标准输入输出接到别处，并知道遇到不会的命令时去哪里查。命令本身不难记，真正容易出错的是路径的参照点、通配符的匹配范围，以及重定向的方向。

## Unix 与 Linux 的关系

Unix 是一个支持 multitasking 与 multi-user 的 operating system，1969 年由 AT&T Bell Labs 的 Ken Thompson、Dennis Ritchie 等人开发。之后出现大量 Unix-like 变体：Linux、BSD（UC Berkeley）、Solaris（Sun Microsystems）、Android（Google）、iOS（Apple）等。

<span class="red">Linux 是一个 free and open source 的 Unix-like operating system，由 Linus Torvalds 于 1991 年首次发布。</span>它有众多发行版（distribution），如 Gentoo、Red Hat、Ubuntu。课程建议用 Ubuntu，并推荐 Windows 用户使用 WSL（Windows Subsystem for Linux）；也可以装在虚拟机（VMware Workstation、VirtualBox）里。Linux 的交互方式是在 terminal 中输入命令，terminal 可以从右键菜单等多种途径打开。

## 目录树与路径

Linux 的目录组织成一棵树，最顶层是 root directory `/`。`/` 下面挂 `bin/`、`home/`、`lib/` 等，`home/` 下再按用户分成 `mary/`、`peter/` 等。

![[Pasted image 20260809153001.png]]

切换目录的基本命令是 `cd pathname`，例如 `cd /usr/bin` 就是一个典型的 pathname。真正需要记牢的是几个特殊字符的参照点：`/` 是 root directory，`~` 是 home directory（Linux 是多用户系统，每个用户有自己的 home），`.` 是 current directory，`..` 是 parent directory。这四个符号是后面所有相对路径写法的基础。

## 列出目录内容与文件信息

`ls directory` 列出指定目录内容，例如 `ls /home`；只写 `ls` 则列出当前工作目录。两个常用选项是 `ls -l`（long format）与 `ls -a`（连同 hidden files 一起列出，隐藏文件指以点开头的文件名，如 `.bash_history`）。Linux 的选项可以合并，因此 `ls -la` 与 `ls -l -a` 等价。注意 `-a` 的 “a” 指的是 all。

`ls -l` 的输出把每一行的字段按固定位置排列：permission、owner、group、file size（单位 byte）、modification time、file name。

![[Pasted image 20260809153002.png]]

permission 的第一个字符区分文件类型，`-` 是 regular file，`d` 是 directory；随后九个字符分成三组，依次是 owner、group、everyone else 的 read / write / execution 权限。把这三组和第一列的 `d`/`-` 一起看，就能一眼判断一个对象是文件还是目录、以及自己能不能改它，这也是以后遇到 “Permission denied” 时的第一处排查点。

## 创建、复制、移动与删除

创建目录用 `mkdir dir`，删除目录用 `rmdir dir`，但 `rmdir` 只能删除空目录。创建一个空文件用 `touch file`。

复制的基本形式是 `cp source dest`，几个变体值得单独记住：`cp file1 file2` 把 file1 的内容复制进 file2；`cp file1 dir` 把文件复制进目录，也可以一次给多个源 `cp file1 file2 dir`；`cp -r dir1 dir2` 递归复制整个目录。目录复制时目标是否已存在会改变行为：如果 dir2 不存在，就把 dir1 复制成 dir2；如果 dir2 已存在，就把 dir1 复制到 dir2 里面。

通配符 `*` 可以代表任意字符串，<span class="red">包括空字符串</span>，这一点直接决定了 `ls` 模式的匹配范围。例如要列出当前文件夹中所有且仅有以 `xyz` 结尾的文件（假设没有隐藏文件），`ls *.xyz` 是对的；而 `ls *xyz` 会把 `xyz` 本身也匹配进来，`ls ./*xyz` 则因为 `*` 能匹配空串而无法保证只列出 `xyz` 扩展名。符号链接和隐藏文件的问题此时都还不涉及。

移动与重命名共用 `mv source dest`：`mv file1 file2` 把 file1 改名成 file2；`mv file1 dir` 把文件移进目录；`mv dir1 dir2` 在 dir2 不存在时把 dir1 改名为 dir2，在 dir2 存在时把 dir1 移进 dir2。命名规则和 `cp -r` 完全一致，记住一套即可。

删除用 `rm file`，可以一次删多个 `rm file1 file2`，删除目录及其内容用 `rm -r dir`。删除是不可逆的，因此常用选项是 `-i`（每次删除前询问）。把 `alias rm='rm -i';` 写进 `~/.bashrc` 就能让每次登录都生效。

## 查看与编辑文件

编辑文件可以用轻量的 `nano file` 或图形化的 `gedit file`，更进阶的是 `vim` 与 `emacs`。查看文件内容用 `cat file` 或 `less file`。`less` 的翻页与查找键位和 `man` 一致，值得记住：`q` 退出，`G`（shift + g）跳到末尾，`g` 回到开头，`/` 后输入内容进行搜索，`n` 跳到下一个匹配、`N` 跳到上一个匹配。

## I/O redirection

大多数命令行程序把结果写到 standard output，默认目标是屏幕；用 `>` 可以把 standard output 重定向到文件，例如 `ls -l > ls_rst.txt` 把列出结果写入 `ls_rst.txt`。方向相反，许多命令可以从 standard input 读入数据，默认来源是键盘；用 `<` 可以把 standard input 改成文件，例如 `my_add < input.txt`，其中 `my_add` 是一个从键盘读两个输入并输出其和的程序。输入重定向的一个直接用途就是测试。

两个方向可以同时使用，`sort < fruit.txt > my_favorite.txt` 的含义是：以 `fruit.txt` 作为 `sort` 的输入，把排序结果写到 `my_favorite.txt`。因此程序读入的是 `fruit.txt`，写出的是 `my_favorite.txt`，处于字母序的是输出内容，而不是 `fruit.txt` 本身被改写。

## 其他常用命令

自动补全：输入前几个字符后按 `Tab`，若只有一个匹配项 Linux 会补全剩余部分；若有多个匹配项，再按一次会列出所有候选。

比较两个文件用 `diff file1 file2`：文件相同则没有输出；有差异时，`<` 后的行来自第一个文件，`>` 后的行来自第二个文件；摘要行里的 `c` 表示 change、`a` 表示 add、`d` 表示 delete。常用选项 `-w` 忽略空白（空格与 tab）差异。

安装与卸载程序用 apt：`sudo apt-get install program`（例如 `sudo apt-get install emacs`），卸载用 `sudo apt-get autoremove program`。`sudo` 表示以 superuser 身份执行命令，会要求输入密码。

查文档用 `man command`，例如 `man ls`；浏览 manual 时的操作方式与 `less` 相同。进一步的自学入口是 http://linuxcommand.org/。
