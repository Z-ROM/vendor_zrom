PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0

ifeq ($(PRODUCT_GMS_CLIENTID_BASE),)
PRODUCT_PROPERTY_OVERRIDES += \
    ro.com.google.clientidbase=android-google
else
PRODUCT_PROPERTY_OVERRIDES += \
    ro.com.google.clientidbase=$(PRODUCT_GMS_CLIENTID_BASE)
endif

PRODUCT_PROPERTY_OVERRIDES += \
    keyguard.no_require_sim=true \
    ro.url.legal=http://www.google.com/intl/%s/mobile/android/basic/phone-legal.html \
    ro.url.legal.android_privacy=http://www.google.com/intl/%s/mobile/android/basic/privacy.html \
    ro.com.android.wifi-watchlist=GoogleGuest \
    ro.setupwizard.enterprise_mode=1 \
    ro.com.android.dateformat=MM-dd-yyyy \
    ro.com.android.dataroaming=false

PRODUCT_PROPERTY_OVERRIDES += \
    ro.build.selinux=1 \
    persist.sys.root_access=3

# ROM Statistics and ROM Identification
PRODUCT_PROPERTY_OVERRIDES += \
    ro.romstats.url= \
    ro.romstats.name=ZROM \
    ro.romstats.version=$(shell date +"%d-%m-%y") \
    ro.romstats.askfirst=0 \
    ro.romstats.tframe=1

# Enable ADB authentication and root
ADDITIONAL_DEFAULT_PROPERTIES += \
    ro.secure=0 \
    ro.adb.secure=0 \
    persist.sys.root_access=3

# Disable excessive dalvik debug messages
PRODUCT_PROPERTY_OVERRIDES += \
    dalvik.vm.debug.alloc=0

# Backup Tool
PRODUCT_COPY_FILES += \
    vendor/zrom/prebuilt/common/bin/backuptool.sh:system/bin/backuptool.sh \
    vendor/zrom/prebuilt/common/bin/backuptool.functions:system/bin/backuptool.functions \
    vendor/zrom/prebuilt/common/bin/50-zrom.sh:system/addon.d/50-zrom.sh \
    vendor/zrom/prebuilt/common/bin/99-backup.sh:system/addon.d/99-backup.sh \
    vendor/zrom/prebuilt/common/etc/backup.conf:system/etc/backup.conf

# ZROM-specific init file
PRODUCT_COPY_FILES += \
    vendor/zrom/prebuilt/common/etc/init.local.rc:root/init.zrom.rc

# Copy latinime for gesture typing
PRODUCT_COPY_FILES += \
    vendor/zrom/prebuilt/common/lib/libjni_latinime.so:system/lib/libjni_latinime.so

# Copy libgif for Nova Launcher 3.0
PRODUCT_COPY_FILES += \
    vendor/zrom/prebuilt/common/lib/libgif.so:system/lib/libgif.so

# SELinux filesystem labels
PRODUCT_COPY_FILES += \
    vendor/zrom/prebuilt/common/etc/init.d/50selinuxrelabel:system/etc/init.d/50selinuxrelabel

# Enable SIP+VoIP on all targets
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml

# Don't export PS1 in /system/etc/mkshrc.
PRODUCT_COPY_FILES += \
    vendor/zrom/prebuilt/common/etc/mkshrc:system/etc/mkshrc \
    vendor/zrom/prebuilt/common/etc/sysctl.conf:system/etc/sysctl.conf

# Init.d Support
PRODUCT_COPY_FILES += \
    vendor/zrom/prebuilt/common/etc/init.d/00banner:system/etc/init.d/00banner \
    vendor/zrom/prebuilt/common/etc/init.d/90userinit:system/etc/init.d/90userinit \
    vendor/zrom/prebuilt/common/bin/sysinit:system/bin/sysinit

# Prebuilt Packages
PRODUCT_COPY_FILES += \
    vendor/zrom/prebuilt/common/app/ApexLauncher.apk:system/app/ApexLauncher.apk \
    vendor/zrom/prebuilt/common/app/GoogleTTS.apk:system/app/GoogleTTS.apk

# Embed SuperUser
SUPERUSER_EMBEDDED := true

# System packages
PRODUCT_PACKAGES += \
    CellBroadcastReceiver \
    Development \
    Superuser \
    su \
    OmniSwitch \
    EOSWeather \
    Basic \
    HoloSpiralWallpaper \
    LiveWallpapersPicker \
    PhaseBeam

# Extra packages
PRODUCT_PACKAGES += \
    LockClock \
    KernelTweaker \
    ZPapers


# Extra Optional packages
PRODUCT_PACKAGES += \
    SlimFileManager \
    LatinIME \
    BluetoothExt

# Extra tools
PRODUCT_PACKAGES += \
    openvpn \
    e2fsck \
    mke2fs \
    tune2fs \
    mount.exfat \
    fsck.exfat \
    mkfs.exfat


# Viper4Android
PRODUCT_COPY_FILES += \
    vendor/zrom/prebuilt/common/etc/viper/ViPER4Android.apk:system/app/ViPER4Android.apk

# Stagefright FFMPEG plugin
PRODUCT_PACKAGES += \
    libstagefright_soft_ffmpegadec \
    libstagefright_soft_ffmpegvdec \
    libFFmpegExtractor \
    libnamparser

# Theme engine
PRODUCT_PACKAGES += \
    ThemeChooser \
    ThemesProvider

PRODUCT_COPY_FILES += \
    vendor/zrom/config/permissions/com.tmobile.software.themes.xml:system/etc/permissions/com.tmobile.software.themes.xml \
    vendor/zrom/config/permissions/org.cyanogenmod.theme.xml:system/etc/permissions/org.cyanogenmod.theme.xml

# easy way to extend to add more packages
-include vendor/extra/product.mk

PRODUCT_PACKAGE_OVERLAYS += vendor/zrom/overlay/common

# Boot animation include
ifneq ($(TARGET_SCREEN_WIDTH) $(TARGET_SCREEN_HEIGHT),$(space))

# determine the smaller dimension
TARGET_BOOTANIMATION_SIZE := $(shell \
  if [ $(TARGET_SCREEN_WIDTH) -lt $(TARGET_SCREEN_HEIGHT) ]; then \
    echo $(TARGET_SCREEN_WIDTH); \
  else \
    echo $(TARGET_SCREEN_HEIGHT); \
  fi )

# get a sorted list of the sizes
bootanimation_sizes := $(subst .zip,, $(shell ls vendor/zrom/prebuilt/common/bootanimation))
bootanimation_sizes := $(shell echo -e $(subst $(space),'\n',$(bootanimation_sizes)) | sort -rn)

# find the appropriate size and set
define check_and_set_bootanimation
$(eval TARGET_BOOTANIMATION_NAME := $(shell \
  if [ -z "$(TARGET_BOOTANIMATION_NAME)" ]; then
    if [ $(1) -le $(TARGET_BOOTANIMATION_SIZE) ]; then \
      echo $(1); \
      exit 0; \
    fi;
  fi;
  echo $(TARGET_BOOTANIMATION_NAME); ))
endef
$(foreach size,$(bootanimation_sizes), $(call check_and_set_bootanimation,$(size)))

PRODUCT_COPY_FILES += \
    vendor/zrom/prebuilt/common/bootanimation/$(TARGET_BOOTANIMATION_NAME).zip:system/media/bootanimation.zip
endif

# Versioning System
# KitKat Z-ROM freeze code
PRODUCT_VERSION_MAJOR = 4.4.4
PRODUCT_VERSION_MINOR = build
PRODUCT_VERSION_MAINTENANCE = 7.0
ifdef ZROM_BUILD_EXTRA
    ZROM_POSTFIX := -$(ZROM_BUILD_EXTRA)
endif
ifndef ZROM_BUILD_TYPE
    ZROM_BUILD_TYPE := UNOFFICIAL
    PLATFORM_VERSION_CODENAME := UNOFFICIAL
    ZROM_POSTFIX := -$(shell date +"%Y%m%d-%H%M")
endif

# SlimIRC
# export INCLUDE_SLIMIRC=1 for unofficial builds
ifneq ($(filter WEEKLY OFFICIAL,$(SLIM_BUILD_TYPE)),)
    INCLUDE_SLIMIRC = 1
endif

ifneq ($(INCLUDE_SLIMIRC),)
    PRODUCT_PACKAGES += SlimIRC
endif

# Set all versions
ZROM_VERSION := ZROM-$(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR).$(PRODUCT_VERSION_MAINTENANCE)-$(ZROM_BUILD_TYPE)$(ZROM_POSTFIX)-$(shell date +%Y-%m-%d)
ZROM_MOD_VERSION := ZROM-$(ZROM_BUILD)-$(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR).$(PRODUCT_VERSION_MAINTENANCE)-$(ZROM_BUILD_TYPE)$(ZROM_POSTFIX)-$(shell date +%Y-%m-%d)

PRODUCT_PROPERTY_OVERRIDES += \
    BUILD_DISPLAY_ID=$(BUILD_ID) \
    zrom.ota.version=$(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR).$(PRODUCT_VERSION_MAINTENANCE) \
    ro.zrom.version=$(ZROM_VERSION) \
    ro.modversion=$(ZROM_MOD_VERSION) \
    ro.zrom.buildtype=$(ZROM_BUILD_TYPE)
    
#Default buil.prop tweaks
PRODUCT_PROPERTY_OVERRIDES += \
    pm.sleep.mode=1 \
    wifi.supplicant_scan_interval=180
