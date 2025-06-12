do_compile_prepend:solidrun-rzg2lc-som() {
	# Rebuild for different machine is broken
	oe_runmake clean

	# configure board parameters
	export FILENAME_ADD=_RZG2LC_SOM
	export DEVICE=RZG2LC
	export DDR_TYPE=DDR4
	export DDR_SIZE=1GB_1PCS
	export SWIZZLE=T3BC
}

do_compile_prepend:solidrun-rzg2l-som() {
	# Rebuild for different machine is broken
	oe_runmake clean

	# configure board parameters
		export FILENAME_ADD=_RZG2L_SOM
		export DEVICE=RZG2L
		export DDR_TYPE=DDR4
		export DDR_SIZE=1GB_1PCS
		export SWIZZLE=T1BC
}

do_compile_prepend:solidrun-rzv2l-som() {
	# Rebuild for different machine is broken
	oe_runmake clean

	# configure board parameters
		export FILENAME_ADD=_RZV2L_SOM
		export DEVICE=RZV2L
		export DDR_TYPE=DDR4
		export DDR_SIZE=2GB_1PCS
		export SWIZZLE=T1BC
}
