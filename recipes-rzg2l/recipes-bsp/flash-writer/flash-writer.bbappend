# configure board parameters
do_compile_prepend() {
	if [ "${MACHINE}" = "rzg2lc-hummingboard" ]; then
		export FILENAME_ADD=_RZG2LC_HUMMINGBOARD
		export DEVICE=RZG2LC
		export DDR_TYPE=DDR4
		export DDR_SIZE=1GB_1PCS
		export SWIZZLE=T3BC
	fi
}
