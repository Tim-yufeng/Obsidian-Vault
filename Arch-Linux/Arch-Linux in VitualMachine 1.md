## ISO文件下载

我是在这个地址下载的.iso：
[ISO Address](https://mirrors.ustc.edu.cn/archlinux/iso/2026.02.01/)

## 虚拟机准备

- 在 VirtualBox 中新建虚拟机，类型选择 Linux，版本选择 Arch Linux (64-bit)
- 内存分配了4GB，虚拟硬盘动态分配了20GB
- “系统”面板中，选择启用 EFI，且**不勾选“启用安全启动 (Enable Secure Boot)”**
- 启动虚拟机，应该看到 `root@archiso ~ #`

## 基础系统构建

- `ls /sys/firmware/efi/efivars` ：目录存在且有文件，则说明系统已经成功以 UEFI 模式启动
- `cfdisk /dev/sda` ：用 cfdisk 工具来管理 `/dev/sda` 这块硬盘的分区表
	- `cfdisk` 是一个有图形化菜单（虽然也没好看到哪去）的**交互式分区管理工具**
	- `/dev/sda` 是Linux中的第一块硬盘（第二块就是`/dev/sdb`……以此类推）这里我们就对付这一块硬盘
		- 可以通过`lsblk`或`fdisk -l` 查看所有硬盘喔
	- 然后选择 `gpt` , 这是现代标准的分区表
- 分区操作：
![[Pasted image 20260407220700.png]]
- 运行以下命令：
```bash
mkfs.fat -F 32 /dev/sda1

mkfs.ext4 /dev/sda3

mkswap /dev/sda2
swapon /dev/sda2
```
1. `mkfs` 是 make file system （制作文件系统），`.fat` 是使用 FAT 格式，`-F 32` 是使用 FAT32 版本，`/dev/sda1` 是硬盘的第一个分区
2. `.ext4` 也是一种格式，是Linux系统最常用最标准的格式
3.  `mkswap /dev/sda2` 将第二个分区标记为“交换分区”， `swapon /dev/sda2` 则是立即启用它
	- swap 分区是“仓库”，不需要挂载到目录，用 `swapon` 激活即可
- `mount /dev/sda3 /mnt` ：将硬盘的根分区`/dev/sda3`挂载到 `/mnt`目录，相当于把`/mnt`作为硬盘根分区的入口，`/mnt`称为挂载点
- `mount --mkdir /dev/sda1 /mnt/boot`：用 `mkdir` 在 `\mnt` 内创建 `boot` 文件夹，然后把 EFI 分区 `/dev/sda1` 挂载上去
	- 这样将来系统启动时，引导文件就放在 `/boot` 里，但实际存储在 EFI 分区上
```text
硬盘 /dev/sda
├── sda1 (512M, FAT32)  ──挂载到──>  /mnt/boot  （引导文件存放处）
├── sda2 (4G, swap)     ──启用──>  作为虚拟内存使用（不挂载到目录）
└── sda3 (剩余, ext4)   ──挂载到──>  /mnt        （系统根目录）

此时 /mnt 目录结构：
/mnt
├── (即将安装的系统文件)
└── boot/  ← 实际指向 sda1（EFI 分区）
```

- `pacstrap -K /mnt base linux linux-firmware nano networkmanager`：往硬盘里装系统：
	- `pacstrap` 是 Arch 安装专用的脚本，作用就是往挂载好的目录 (`\mnt`) 里安装基础软件包
	- `-K` 是保持Linux内核模块的意思，确保不被压缩
	- 后面一长串 `base linux linux-firmware nano networkmanager` 就是要安装的东西了：
		1. 其中 `base` 是Arch的基础系统，包含Linux 最核心的命令：`ls`, `cd`, `cp`, `mv`, `bash`, `systemd` 等
		2. `linux` 就是Linux内核
		3. `linux-firmware` 是固件驱动，包含各种硬件（WiFi、显卡、声卡、网卡）的驱动程序
		4. `nano` 就是我们熟悉的那个nano, 简单的文本编辑器
		5. `networkmanager` 顾名思义，用来自动连接 WiFi，有线网络等
		6. 这5个东东构成了一个**最小可用系统**，后续更高级的东东通过 `pacman` 安装
- 实操中这一步发生了报错，原因是其中一个脚本需要键盘布局定义，二这玩意还没被定义好：
	1. `genfstab -U /mnt >> /mnt/etc/fstab`：首先生成一份**分区挂载表**，记录分区挂载关系
	2. `arch-chroot /mnt`：这一步将根目录从Live系统的`/` 换成了硬盘系统的 `/mnt`，其实就是把操作的对象从Live系统换成了硬盘系统
	3. `echo "KEYMAP=us" > /etc/vconsole.conf` 创建了一个键盘布局设置文件 `vconsole.conf`，并将布局设为美式键盘
	4. `mkinitcpio -P`：重新生成 initramfs（之前失败的地方）
## 系统配置

- `ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtimehwclock --systohc`：设置时区
- **本地化 (Locale)：**
	- 编辑文件：`nano /etc/locale.gen`
	    
	- 找到 `en_US.UTF-8 UTF-8`，删掉前面的 `#` 号。
	    
	- 保存退出（Nano 中按 `Ctrl+O`, `Enter`, `Ctrl+X`）。
	    
	- 执行生成：`locale-gen`
	    
	- 设置变量：`echo "LANG=en_US.UTF-8" > /etc/locale.conf`
- `echo "your-computer-name" > /etc/hostname`：设置主机名
- `passwd`：设置root密码
## 配置引导程序 (Bootloader)

- `pacman -S grub efibootmgr`：安装 GRUB 本身，以及让它能与 UEFI 固件通信的工具
	- `grub` 是实际的引导程序；`efibootmgr` 允许 Linux 修改主板的 EFI 启动项列表
- `grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB`：
	- `grub-install`: 安装GRUB到指定位置
	- `--target=x86_64-efi`：告诉 GRUB：“你要装到一个现代 64 位电脑的 UEFI 主板上”
	- `--efi-directory=/boot`：告诉 GRUB：“你的家（EFI 分区）在 `/boot` 目录下”
	- `--bootloader-id=GRUB`：设定引导器在主板启动菜单的显示名称为 GRUB
- `grub-mkconfig -o /boot/grub/grub.cfg`：
	- 通过`grub-mkconfig`自动检测系统里的内核、其他操作系统，生成 GRUB 菜单
	- 通过`-o`输出到`/boot/grub/grub.cfg`这个文件
	- 如果输出包含`Found linux image: /boot/vmlinuz-linux`，说明内核被GRUB成功找到
- `systemctl enable NetworkManager`：使得重启后能自动连上网
- 现在我的状态是 root 用户，相当于一个拥有最高权限的超级管理员，但是这不利于操作的安全（防止你把系统删没了），因此要创建普通用户：
```bash
useradd -m -G wheel tim_yufeng
passwd tim_yufeng
```
- 彻底退出与重启：
```bash
exit                # 退出 chroot 模式回到 ISO 环境
umount -R /mnt      # 递归卸载所有挂载的分区，确保数据完整写入磁盘
reboot              # 重启
```
