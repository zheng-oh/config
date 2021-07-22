#!/bin/bash
#! /bin/bash
time_stamp=`date +%s`
wall_paper_dir="/home/zxing/Picture/"
file_name=$wall_paper_dir`ls $wall_paper_dir | sort --random-sort | head -1`
echo $file_name

script='var allDesktops = desktops();print (allDesktops);for (i=0;i<allDesktops.length;i++) {d = allDesktops[i];d.wallpaperPlugin = "org.kde.image";d.currentConfigGroup = Array("Wallpaper", "org.kde.image", "General");d.writeConfig("Image", "file://'$file_name'")}'

export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/1000/bus"
qdbus org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript "$script"


