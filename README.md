# Archlinux 系统 安装

https://wiki.archlinux.org/index.php/Installation_guide
## 1. 检测系统
    ls /sys/firmware/efi/efivars  #存在则为 efi 启动
## 2. 连接wifi（虚拟机、物理网跳过）
    ip link  (获得wifi名,如：wlan0)
    iwlist wlan0 scan | grep ESSID (获取wifi名, 如：CMCC)
    wpa_passphrase CMCC passwd > internet.conf
    wpa_supplicant -c internet.conf -i wlan0 &
    dhcpcd &
## 3. 更新系统时间
    timedatectl set-ntp true
## 4. 分区
    fdisk -l
    fdisk /dev/sda
    g (创建gpt分区,efi)
    n (创建分区，sda1:512M，sda2:1G，sda3:28.5G)
## 5. 格式化
    mkfs.fat -F32 /dev/sda1(引导分区)
    mkfs.ext4 /dev/sda3(跟分区)
    mkswap /dev/sda2(交换分区)
## 6. 挂载
    mount /dev/sda3 /mnt
    swapon /dev/sda2
    mkdir /mnt/boot
    mount /dev/sda1 /mnt/boot
## 7. 安装
    mirrorlist 顺序修改
    cp /etc/pacman.d/mirrorlist /mnt/etc/pacman.d/mirrorlist
    pacstrap /mnt base linux linux-firmware vim
## 8. 配置系统
    genfstab -U /mnt >> /mnt/etc/fstab
    cat /mnt/etc/fstab
## 9. 进入系统-设置时区
    arch-chroot /mnt
    ln -sf /user/share/zoneinfo/Asia/Shanghai /etc/localtim
    hwclock --systohc
    vim /etc/locale.gen (en_US.UTF-8,en_GB.UTF-8)
    locale-gen
    /etc/locale.conf (LANG=en_GB.UTF-8)
## 10. 网络配置
    /etc/hostname
        myhostname
    /etc/hosts
        127.0.0.1	localhost
        ::1		localhost
        127.0.1.1	myhostname.localdomain	myhostname
    passwd   ######很重要
## 11. 安装引导
    pacman -S grub efibootmgr intel-ucode/amd-ucode os-prober(可选，)
    mkdir /boot/grub
    grub-mkconfig > /boot/grub/grub.cfg
    uname -m
    grub-install --targrt=x86_64-efi --efi-directory=/boot
## 12. 安装联网软件
    pacman -S fish wpa_supplicant dhcpcd wget git
    systemctl enable dhcpcd (仅虚拟机, 否则参考2)
## 13. 新建用户
    useradd -m -G wheel zxing
    passwd zxing
    ln -s /usr/bin/vim /usr/bin/vi
    visudo   (%wheel ALL=(ALL) NOPASSWD:ALL ，取消注释)
    reboot
## 14. archlinuxcn及镜像列表
https://mirrors.tuna.tsinghua.edu.cn/help/archlinuxcn/

    [archlinuxcn]
    Server = https://mirrors.tuna.tsinghua.edu.cn/archlinuxcn/$arch
    sudo pacman -S archlinuxcn-keyring reflector
    pacman -Sy archlinuxcn-keyring && pacman -Su
    sudo reflector --verbose --latest 20 --country China --sort rate --save /etc/pacman.d/mirrorlist
    sudo pacman -Syy
    sudo pacman -S -force pacman-mirrorlist
    <!-- sudo pacman-key --refresh-keys -->
## 15. 驱动安装
    lspci | grep -e VGA -e 3D 查看显卡驱动
    pacman -Ss xf86-video 查看对应的显示驱动程序
    pacman -S xf86-video-vmware alsa-utils (安装虚拟机的显示驱动、声卡驱动)
    配置xorg.conf 显示器分辨率 (from git clone linux_config)
## 16. 安装必须的软件
    wget https://mirrors.tuna.tsinghua.edu.cn/anaconda/miniconda/Miniconda3-py39_4.9.2-Linux-x86_64.sh
    bash Mini....
    pacman -S base-devel xorg xorg-server xorg-xinit picom habak neofetch htop chromium ranger dmenu numlockx(可选)
    chsh -s /usr/bin/fish
## 17. 安装窗口管理、终端
    git clone dwm、st
    sudo make clean install
## 18. 安装yay
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si
## 19. 字体
#### 代码字体
    sudo pacman -S adobe-source-code-pro-fonts 
	yay -S nerd-fonts-source-code-pro
#### emjo
    ttf-stmbola
#### 中文
    yay -S wqy-bitmapfont wqy-microhei wqy-microhei-lite wqy-zenhei adobe-source-han-mono-cn-fonts adobe-source-han-sans-cn-fonts adobe-source-han-serif-cn-fonts
## 20. 中文输入法
    sudo pacman -Rsc fcitx
    sudo pacman -S fcitx5 fcitx5-chinese-addons fcitx5-qt fcitx5-gtk kcm-fcitx5 fcitx5-material-color
## 20. git push免密
    vim .git-credentials
    https://{username}:{password}@github.com
    git config --global credential.helper store
## 21. docker 配置
#### 配置免sudo 使用docker
	sudo groupadd docker
#### 将用户加入该 group 内。然后退出并重新登录就生效啦。
	sudo gpasswd -a ${USER} docker
#### 重启 docker 服务
	sudo service docker restart
#### 切换当前会话到新 group 或者重启 X 会话
	newgrp - docker
#### redis
	docker run -d  --name redis -p 6379:6379 --privileged=true --restart always redis:latest
#### mysql
	docker run -d --name mysql -p 3306:3306 --privileged=true --restart always -e MYSQL_ROOT_PASSWORD=123456 -e TZ=Asia/Shanghai -v /var/lib/mysql:/var/lib/mysql mysql:latest --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci 
#### mongo
	docker run -d -p 27017:27017 -v /var/lib/mongo:/data/db --name mongo mongo --auth
	use admin
	db.createUser(
	   {
		 user: "root",
		 pwd: "123456",
		 roles: [ { role: "userAdminAnyDatabase", db: "admin" } ]
	   }
	 )

