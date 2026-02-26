# enable codecs if machine supports hw encoder / decoder
COMPATIBLE_MACHINE = "${@bb.utils.contains_any('MACHINE_FEATURES', 'hwh264dec hwh264enc', '${MACHINE}', '(^$)', d)}"
