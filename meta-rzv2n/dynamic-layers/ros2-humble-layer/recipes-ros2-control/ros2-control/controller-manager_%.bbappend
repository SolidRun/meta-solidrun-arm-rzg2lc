# Remove obsolete patch - the compiler warnings fix is already applied upstream
SRC_URI:remove = "file://disable-compiler-options.patch"

# rclcpp/exceptions.hpp has constructor params that shadow member variables,
# triggering -Werror=shadow added by this package's CMakeLists.txt.
# We strip the flag via sed and also append -Wno-error=shadow as a fallback,
# since the latter must appear last on the command line to take effect.
do_configure:prepend() {
    sed -i 's/-Werror=shadow//g' ${S}/CMakeLists.txt
}
OECMAKE_CXX_FLAGS:append = " -Wno-error=shadow"
