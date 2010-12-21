PRODUCT_PACKAGES := \
        SoundRecorder \
        GeneralRunner \
        EvilSkull \
        TSCalibration \
        Vase \
        SerialMonitor \
        

$(call inherit-product, build/target/product/rowboat.mk)

# Overrides
PRODUCT_BRAND := TI
PRODUCT_NAME := beagleboard
PRODUCT_DEVICE := beagleboard
PRODUCT_PACKAGE_OVERLAYS := vendor/rowboat/generic
