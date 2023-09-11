# configure board parameters
do_compile_prepend() {
	# Rebuild for different machine is broken
	oe_runmake clean 

	if [ "${MACHINE}" = "rzg2lc-hummingboard" ]; then
		export FILENAME_ADD=_RZG2LC_HUMMINGBOARD
		export DEVICE=RZG2LC
		export DDR_TYPE=DDR4
		export DDR_SIZE=1GB_1PCS
		export SWIZZLE=T3BC
	fi

	if [ "${MACHINE}" = "rzg2l-hummingboard" ]; then
		export FILENAME_ADD=_RZG2L_HUMMINGBOARD
		export DEVICE=RZG2L
		export DDR_TYPE=DDR4
		export DDR_SIZE=1GB_1PCS
		export SWIZZLE=T1BC
	fi

	if [ "${MACHINE}" = "rzv2l-hummingboard" ]; then
		export FILENAME_ADD=_RZV2L_HUMMINGBOARD
		export DEVICE=RZV2L
		export DDR_TYPE=DDR4
		export DDR_SIZE=2GB_1PCS
		export SWIZZLE=T1BC
	fi
}
