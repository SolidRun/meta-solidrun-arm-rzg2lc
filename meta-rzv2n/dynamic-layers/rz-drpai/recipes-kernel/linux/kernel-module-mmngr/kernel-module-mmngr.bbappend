# Fix broken copy_from_user calls in DRP-AI mmngr bug-fix patch
FILESEXTRAPATHS:prepend:rzv2n-sr-som := "${THISDIR}/${PN}:"
SRC_URI:remove:rzv2n-sr-som = "file://0009-kernel-module-mmngr-bug-fix.patch"
SRC_URI:append:rzv2n-sr-som = " file://0009-kernel-module-mmngr-bug-fix-solidrun.patch"
