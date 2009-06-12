$(call inherit-product, build/target/product/ea.mk)

PRODUCT_PACKAGES := \
     SoundRecorder

# Overrides
PRODUCT_BRAND := TI
PRODUCT_NAME := beagleboard
PRODUCT_DEVICE := beagleboard
PRODUCT_PACKAGE_OVERLAYS := vendor/ea
