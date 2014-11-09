#!/sbin/sh

# delete mpdecision & thermald because it is no longer needed
rm -rf /system/bin/thermald
rm -rf /system/bin/mpdecision
rm -rf /system/lib/hw/power.msm8974.so
rm -rf /system/lib/hw/power.msm8960.so
# clean init.d scripts
INITD_DIR=/system/etc/init.d
# Trinity
rm -f $INITD_DIR/95dimmers
rm -f $INITD_DIR/98tweak
rm -f $INITD_DIR/99complete
# SG
rm -f $INITD_DIR/98_startup_script
rm -f $INITD_DIR/99_startup_complete
# Air
rm -f $INITD_DIR/89airtweaks
rm -f $INITD_DIR/98airtweak
rm -f $INITD_DIR/98airtweaks
rm -f $INITD_DIR/99airtweaks
# Franco
rm -f $INITD_DIR/13overclock
rm -f $INITD_DIR/00turtle
# Hellsgod
rm -f $INITD_DIR/00confg
# neo
rm -rf $INITD_DIR/*Neo*
rm -f /system/bin/*Neo*
rm -rf /sdcard/neo
# slim
rm -rf $INITD_DIR/01mpdecision
# ak
rm -rf $INITD_DIR/00ak
# defcon
rm -rf $INITD_DIR/99defcon

# clean kernel setting app shared_prefs
rm -rf /data/data/mobi.cyann.nstools/shared_prefs
rm -rf /data/data/aperture.ezekeel.gladoscontrol/shared_prefs
rm -rf /data/data/com.derkernel.tkt/shared_prefs
rm -rf /data/data/com.franco.kernel/shared_prefs
rm -rf /data/data/com.liquid.control/shared_prefs
rm -rf /data/data/com.af.synapse/databases/*
rm -rf /data/data/com.teamkang.fauxclock/shared_prefs
# remove dalvik cache
#rm -rf /data/dalvik-cache
#rm -rf /cache/dalvik-cache
