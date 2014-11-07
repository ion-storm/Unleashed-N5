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
/tmp/mkbootimg --kernel /tmp/kernel/zImage-dtb --cmdline 'console=ttyHSL0,115200,n8 androidboot.hardware=hammerhead user_debug=31 maxcpus=2 msm_watchdog_v2.enable=1' --base 0x00000000 --pagesize 2048 --ramdisk_offset 0x02900000 --tags_offset 0x02700000 --ramdisk /tmp/out/boot.img-ramdisk.gz --output /tmp/boot.img
if [ -e /tmp/boot.img ]; then
	echo "[AnyKernel] Boot.img created successfully!" | tee /dev/kmsg
else
	echo "[AnyKernel] Boot.img failed to create!" | tee /dev/kmsg
	exit 1
fi
