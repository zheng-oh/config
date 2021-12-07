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
    pacstrap /mnt base linux linux-firmware vim
## 8. 配置系统
    genfstab -U /mnt >> /mnt/etc/fstab
    cat /mnt/etc/fstab
    cp /etc/pacman.d/mirrorlist /mnt/etc/pacman.d/mirrorlist
## 9. 进入系统-设置时区
    arch-chroot /mnt
    ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
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
    pacman -S grub efibootmgr intel-ucode/amd-ucode os-prober(可选，) grub-theme-vimix-color-2k-git(可选，主题)
    mkdir /boot/grub
	sudo pacman -Ql grub-theme-vimix-color-2k-git(可选)
	cp "theme.txt" 路径到 /etc/default/grub 下"GRUB_THEME"(可选)
    grub-mkconfig > /boot/grub/grub.cfg
    uname -m
    grub-install --target=x86_64-efi --efi-directory=/boot
## 12. 安装必须的软件
    pacman -S base-devel xorg xorg-server xorg-xinit picom feh neofetch htop chromium  wmname imwheel ranger lazygit dmenu fish wpa_supplicant dhcpcd wget git openssh avahi nss-mdns numlockx(可选)
    wget https://mirrors.tuna.tsinghua.edu.cn/anaconda/miniconda/Miniconda3-py39_4.9.2-Linux-x86_64.sh
    bash Mini....
    chsh -s /usr/bin/fish
## 13. 启动服务
    systemctl enable dhcpcd (虚拟机参考2)
	sed -i "s/hosts.*/hosts: files mdns4-minimal [NOTFOUND=return] dns mdns4/g" /etc/nsswitch.conf
    systemctl enable avahi-daemon
    systemctl enable sshd
## 14. 新建用户
    useradd -m -G wheel zxing
    passwd zxing
    ln -s /usr/bin/vim /usr/bin/vi
    visudo   (%wheel ALL=(ALL) NOPASSWD:ALL ，取消注释)
    reboot
## 15. archlinuxcn及镜像列表
    [archlinuxcn]
    Server = https://mirrors.tuna.tsinghua.edu.cn/archlinuxcn/$arch
    sudo pacman -S archlinuxcn-keyring reflector
    sudo reflector --verbose --latest 20 --country China --sort rate --save /etc/pacman.d/mirrorlist
    sudo pacman -Syy
    sudo pacman-key --refresh-keys
## 16. 驱动安装
    lspci | grep -e VGA -e 3D 查看显卡驱动
    pacman -Ss xf86-video 查看对应的显示驱动程序
    pacman -S xf86-video-vmware alsa-utils (安装虚拟机的显示驱动、声卡驱动)
    配置xorg.conf 显示器分辨率 (from git clone linux_config)
## 17a. 安装窗口管理、终端
    git clone dwm、st、autojump
    sudo make clean install
## 17b. 安装kde桌面
    sudo pacman -S plasma-meta kde-applications-meta sddm
	sudo systemctl enable sddm
## 18. 安装yay
    pacman -S yay
    git clone https://aur.archlinux.org/yay.git
## 19. 字体
#### 代码字体
    sudo pacman -S adobe-source-code-pro-fonts 
	yay -S nerd-fonts-source-code-pro
#### emoji
    yay -S ttf-symbola
    emoji查询 https://apps.timwhitlock.info/emoji/tables/unicode
#### 中文
    yay -S adobe-source-han-mono-cn-fonts adobe-source-han-sans-cn-fonts adobe-source-han-serif-cn-fonts
## 20. 中文输入法
    sudo pacman -Rsc fcitx
    sudo pacman -S fcitx5 fcitx5-chinese-addons fcitx5-qt fcitx5-gtk kcm-fcitx5 fcitx5-material-color
## 21. git push免密
    vim .git-credentials
    https://{username}:{password}@github.com
    git config --global credential.helper store
	git config --global user.name "zheng-oh"
	git config --global user.email "894389673@qq.com"
## 22. 文件管理窗口
	sudo pacman -S thunar
## 23. vscode wps ranger配置
	yay -S visual-studio-code-bin wps-office-cn wps-office-mui-zh-cn ttf-wps-fonts
	git clone https://github.com/cdump/ranger-devicons2 ~/.config/ranger/plugins/devicons2
## 24. latex
	sudo pacman -S texlive-most texlive-lang
#### vscode format
	sudo cpan Log::Log4perl
	sudo cpan Log::Dispatch
	sudo cpan YAML::Tiny
	sudo cpan File::HomeDir
	sudo cpan Unicode::GCString
## 25. docker 配置
#### 配置免sudo 使用docker
	sudo groupadd docker
#### 将用户加入该 group 内。然后退出并重新登录就生效啦。
	sudo gpasswd -a ${USER} docker
#### 重启 docker 服务
	sudo service docker restart
#### 切换当前会话到新 group 或者重启 X 会话
	newgrp - docker
#### redis
	docker run --name redis -p 6379:6379 --privileged=true --restart always -v ~/Documents/data/redis:/data -d redis --appendonly yes --requirepass “你的密码”
#### mariadb
	docker run --name mariadb -p 3306:3306 -e MYSQL_ROOT_PASSWORD=123456 -v ~/path/data:/var/lib/mysql --privileged=true --restart always -d mariadb --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci
	grant all privileges on *.* to testuser@localhost identified by "123456" ;
#### mongo
	docker run -d -p 27017:27017 -v /var/lib/mongo:/data/db --name mongo mongo --auth
	use admin
	db.createUser({user:"xxx",pwd:"xxxx",roles:["root"]})
	db.createUser({user:"aw","pwd":"123456",roles:[{role:"readWrite",db:"xx"}]})
#### v2ray
	brew install v2ray
	docker pull mzz2017/v2raya
	docker run -d -p 2017:2017 -p 20170-20172:20170-20172 --restart=always --name v2raya -v /usr/local/etc/v2ray:/etc/v2ray -v /usr/local/etc/v2raya:/etc/v2raya --privileged=true mzz2017/v2raya
	v2订阅地址:
	https://sub.foxicloud.com/api/v1/client/subscribe?token=dc8b11058b25d1222d44034f1e6815704120
	sync:
	undo cake robot angle account license urban path penalty anxiety wrestle hospital display crunch rather real demand topic pyramid glass cage festival play logic
	
