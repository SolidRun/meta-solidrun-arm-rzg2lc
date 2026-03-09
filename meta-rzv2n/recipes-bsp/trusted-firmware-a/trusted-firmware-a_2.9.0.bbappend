TFA_URI = "git://github.com/SolidRun/arm-trusted-firmware.git;protocol=https"
TFA_REV = "4092464fa906c7149590ac09338715f2533e3d1d"
TFA_BRANCH = "rzv2n_1.2.0"

EXTRA_OEMAKE:append ?= " SOC_TYPE=${TFA_SOC_TYPE} "
