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

# Python scripts (spawner, unspawner, hardware_spawner) get shebangs that
# exceed the 128-char kernel limit due to long Yocto build paths.
# Fix by replacing the full path with /usr/bin/env python3.
do_install:append() {
    for f in $(find ${D} -type f -name 'spawner' -o -name 'unspawner' -o -name 'hardware_spawner'); do
        if head -1 "$f" | grep -q '^#!.*python'; then
            sed -i '1s|^#!.*python.*$|#!/usr/bin/env python3|' "$f"
        fi
    done
}
