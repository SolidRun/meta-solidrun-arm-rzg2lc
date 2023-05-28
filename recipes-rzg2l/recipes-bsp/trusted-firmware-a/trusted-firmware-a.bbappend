FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append = " \
file://0002-add-solidrun-rzg2lc-support.patch \
"

COMPATIBLE_MACHINE_rzg2lc-hummingboard = "(rzg2lc-hummingboard)"

# need specify MBEDTLS_DIR sources at build-time
export MBEDTLS_DIR="${WORKDIR}/mbedtls"

# plat/renesas/rzg/platform.mk:10: *** "Error: Unknown LSI. Please use LSI=<LSI name> to specify the LSI".  Stop.
export LSI="AUTO"
