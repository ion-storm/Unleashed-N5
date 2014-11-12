#!/sbin/sh
mkdir /tmp/out
if [ -e /tmp/boot.img ]; then
	/tmp/unpackbootimg -i /tmp/boot.img -o /tmp/out
else
	echo "boot.img dump failed!" | tee /dev/kmsg
	exit 1
fi
rm -rf /tmp/boot.img
if [ -e /tmp/out/boot.img-ramdisk.gz ]; then
	rdcomp=/tmp/out/boot.img-ramdisk.gz
	echo "[AnyKernel] New ramdisk uses GZ compression." | tee /dev/kmsg
elif [ -e /tmp/out/boot.img-ramdisk.lz4 ]; then
	rdcomp=/tmp/out/boot.img-ramdisk.lz4
	echo "[AnyKernel] New ramdisk uses LZ4 compression." | tee /dev/kmsg
else
	echo "[AnyKernel] Unknown ramdisk format!" | tee /dev/kmsg
	exit 1
fi
mkdir /tmp/ramdisk
cd /tmp/ramdisk/
gunzip -c /tmp/out/boot.img-ramdisk.gz | cpio -i
cd /
#add init.d support if not already supported
#this is no longer needed as the ramdisk now inserts our modules, but we will
#keep this here for user comfort, since having run-parts init.d support is a
#good idea anyway.
#found=$(find /tmp/ramdisk/init.rc -type f | xargs grep -oh "run-parts /system/etc/init.d");
#if [ "$found" != 'run-parts /system/etc/init.d' ]; then
#        #find busybox in /system
#        bblocation=$(find /system/ -name 'busybox')
#        if [ -n "$bblocation" ] && [ -e "$bblocation" ] ; then
#                echo "BUSYBOX FOUND!";
#                #strip possible leading '.'
#                bblocation=${bblocation#.};
#        else
#                echo "BUSYBOX NOT FOUND! init.d support will not work without busybox!";
#                echo "Setting busybox location to /system/xbin/busybox! (install it and init.d will work)";
#                #set default location since we couldn't find busybox
#                bblocation="/system/xbin/busybox";
#        fi
#	#append the new lines for this option at the bottom
#        echo "" >> /tmp/ramdisk/init.rc
#        echo "service userinit $bblocation run-parts /system/etc/init.d" >> /tmp/ramdisk/init.rc
#        echo "    oneshot" >> /tmp/ramdisk/init.rc
#        echo "    class late_start" >> /tmp/ramdisk/init.rc
#        echo "    user root" >> /tmp/ramdisk/init.rc
#        echo "    group root" >> /tmp/ramdisk/init.rc
#fi
#found2=$(find /tmp/ramdisk/init.hammerhead.rc -type f | xargs grep -oh "service postinit /sbin/post-init.sh");
#if [ "$found2" != 'service postinit /system/xbin/busybox sh /sbin/post-init.sh' ]; then
#                echo echo "userinit found!";
#        else
#                #append UCI
#                echo "" >> /tmp/ramdisk/init.hammerhead.rc
#                echo "service postinit /sbin/post-init.sh" >> /tmp/ramdisk/init.hammerhead.rc
#                echo "    class main" >> /tmp/ramdisk/init.hammerhead.rc
#                echo "    user root" >> /tmp/ramdisk/init.hammerhead.rc
#                echo "    group root system" >> /tmp/ramdisk/init.hammerhead.rc
#                echo "    disabled" >> /tmp/ramdisk/init.hammerhead.rc
#                echo "    seclabel u:r:shell:s0" >> /tmp/ramdisk/init.hammerhead.rc
# 	fi
busybox cp -f /tmp/init.rc /tmp/ramdisk/
busybox cp -f /tmp/init.hammerhead.rc /tmp/ramdisk/
busybox sed -i 's/start mpdecision/stop mpdecision/g' /tmp/ramdisk/init.hammerhead.rc
rm /tmp/out/boot.img-ramdisk.gz
cd /tmp/ramdisk/
find . | cpio -o -H newc | gzip > /tmp/out/boot.img-ramdisk.gz
cd /
rm -rf /tmp/ramdisk
/tmp/mkbootimg --kernel /tmp/kernel/zImage-dtb --cmdline 'console=ttyHSL0,115200,n8 androidboot.hardware=hammerhead user_debug=31 maxcpus=2 msm_watchdog_v2.enable=1' --base 0x00000000 --pagesize 2048 --ramdisk_offset 0x02900000 --tags_offset 0x02700000 --ramdisk /tmp/out/boot.img-ramdisk.gz --output /tmp/boot.img
if [ -e /tmp/boot.img ]; then
	echo "[AnyKernel] Boot.img created successfully!" | tee /dev/kmsg
else
	echo "[AnyKernel] Boot.img failed to create!" | tee /dev/kmsg
	exit 1
fi
