# Recompile with: mkimage -C none -A arm -T script -d boot.cmd boot.scr
# CPU=H5
# OS=friendlycore/ubuntu-oled/ubuntu-wifiap/openwrt/debian/debian-nas...

echo "running boot.scr"
setenv load_addr 0x44000000
setenv fix_addr 0x44500000
fatload mmc 0 ${load_addr} uEnv.txt
env import -t ${load_addr} ${filesize}

fatload mmc 0 ${kernel_addr} ${kernel}

if test $board = nanopi-neo2-v1.1; then 
    fatload mmc 0 ${dtb_addr} sun50i-h5-nanopi-neo2.dtb
else
    fatload mmc 0 ${dtb_addr} sun50i-h5-${board}.dtb
fi
fdt addr ${dtb_addr}

# setup boot_device
fdt set mmc${boot_mmc} boot_device <1>

setenv bootargs "console=${debug_port} earlyprintk
root=/dev/mmcblk0p2 rootfstype=ext4 rw rootwait fsck.repair=${fsck.repair}
panic=10 fbcon=${fbcon} ${hdmi_res} ${overlayfs} ${pmdown}"

booti ${kernel_addr} ${ramdisk_addr}:${ramdisk_size} ${dtb_addr}
