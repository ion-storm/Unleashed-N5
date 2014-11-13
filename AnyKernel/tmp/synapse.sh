#!/sbin/sh
rm -f /system/etc/init.d/UKM;
rm -f /system/xbin/uci;
cp -f /tmp/synapse/data/UKM/UKM /system/etc/init.d/UKM;
cp -f /tmp/synapse/data/UKM/uci /system/xbin/uci;
chmod -R 755 /system/etc/init.d/*;
chmod -R 755 /data/UKM/actions/*;
chmod 6755 /system/xbin/uci;
cp -Rf /tmp/synapse/data/UKM /data/;
cp -Rf /tmp/synapse/data/app /data/;
echo "Synapse Installed";
