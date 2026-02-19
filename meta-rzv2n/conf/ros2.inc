# ROS2 Humble package configuration for RZ/V2N
# Based on Renesas rzv2n_ros2 meta-ros-humble.patch
#
# Usage: Add the following to conf/local.conf:
#   include conf/ros2.inc

# ros2 base
IMAGE_INSTALL:append = " ros-core"
IMAGE_INSTALL:append = " demo-nodes-cpp"
IMAGE_INSTALL:append = " demo-nodes-py"

# V4L2
IMAGE_INSTALL:append = " v4l-utils"
# v4l2-camera is patched by meta-rzv2-ros-humble with OpenCVA (OCA_Activate)
# calls. Requires meta-rz-opencva layer to be enabled.
#IMAGE_INSTALL:append = " v4l2-camera"

# image-transport-plugins
IMAGE_INSTALL:append = " image-transport-plugins"

# ament cmake (for cross-build)
IMAGE_INSTALL:append = " ament-cmake"
IMAGE_INSTALL:append = " ament-cmake-auto"
IMAGE_INSTALL:append = " ament-cmake-catch2"
IMAGE_INSTALL:append = " ament-cmake-copyright"
IMAGE_INSTALL:append = " ament-cmake-core"
IMAGE_INSTALL:append = " ament-cmake-cppcheck"
IMAGE_INSTALL:append = " ament-cmake-cpplint"
IMAGE_INSTALL:append = " ament-cmake-export-definitions"
IMAGE_INSTALL:append = " ament-cmake-export-dependencies"
IMAGE_INSTALL:append = " ament-cmake-export-include-directories"
IMAGE_INSTALL:append = " ament-cmake-export-interfaces"
IMAGE_INSTALL:append = " ament-cmake-export-libraries"
IMAGE_INSTALL:append = " ament-cmake-export-link-flags"
IMAGE_INSTALL:append = " ament-cmake-export-targets"
IMAGE_INSTALL:append = " ament-cmake-flake8"
IMAGE_INSTALL:append = " ament-cmake-gen-version-h"
IMAGE_INSTALL:append = " ament-cmake-gmock"
IMAGE_INSTALL:append = " ament-cmake-google-benchmark"
IMAGE_INSTALL:append = " ament-cmake-gtest"
IMAGE_INSTALL:append = " ament-cmake-include-directories"
IMAGE_INSTALL:append = " ament-cmake-libraries"
IMAGE_INSTALL:append = " ament-cmake-lint-cmake"
IMAGE_INSTALL:append = " ament-cmake-mypy"
IMAGE_INSTALL:append = " ament-cmake-nose"
IMAGE_INSTALL:append = " ament-cmake-pclint"
IMAGE_INSTALL:append = " ament-cmake-pep257"
IMAGE_INSTALL:append = " ament-cmake-pycodestyle"
IMAGE_INSTALL:append = " ament-cmake-pyflakes"
IMAGE_INSTALL:append = " ament-cmake-pytest"
IMAGE_INSTALL:append = " ament-cmake-python"
IMAGE_INSTALL:append = " ament-cmake-ros"
IMAGE_INSTALL:append = " ament-cmake-target-dependencies"
IMAGE_INSTALL:append = " ament-cmake-test"
IMAGE_INSTALL:append = " ament-cmake-uncrustify"
IMAGE_INSTALL:append = " ament-cmake-version"
IMAGE_INSTALL:append = " ament-cmake-xmllint"
IMAGE_INSTALL:append = " ament-copyright"
IMAGE_INSTALL:append = " ament-cppcheck"
IMAGE_INSTALL:append = " ament-cpplint"
IMAGE_INSTALL:append = " ament-flake8"
IMAGE_INSTALL:append = " ament-index-cpp"
IMAGE_INSTALL:append = " ament-index-python"
IMAGE_INSTALL:append = " ament-lint"
IMAGE_INSTALL:append = " ament-lint-auto"
IMAGE_INSTALL:append = " ament-lint-cmake"
IMAGE_INSTALL:append = " ament-lint-common"
IMAGE_INSTALL:append = " ament-mypy"
IMAGE_INSTALL:append = " ament-nodl"
IMAGE_INSTALL:append = " ament-pclint"
IMAGE_INSTALL:append = " ament-pep257"
IMAGE_INSTALL:append = " ament-pycodestyle"
IMAGE_INSTALL:append = " ament-pyflakes"
IMAGE_INSTALL:append = " ament-uncrustify"
IMAGE_INSTALL:append = " ament-xmllint"
IMAGE_INSTALL:append = " ament-package"

TOOLCHAIN_TARGET_TASK:append = " foonathan-memory-staticdev"

# additional ros2 packages (moveit2 dependencies etc.)
IMAGE_INSTALL:append = " control-msgs"
IMAGE_INSTALL:append = " geometry2"
IMAGE_INSTALL:append = " eigen-stl-containers"
IMAGE_INSTALL:append = " octomap-msgs"
IMAGE_INSTALL:append = " geometric-shapes"
IMAGE_INSTALL:append = " object-recognition-msgs"
IMAGE_INSTALL:append = " random-numbers"
IMAGE_INSTALL:append = " srdfdom"
IMAGE_INSTALL:append = " urdf-parser-plugin"
IMAGE_INSTALL:append = " urdfdom-py"
IMAGE_INSTALL:append = " octomap"
IMAGE_INSTALL:append = " eigen3-cmake-module"
IMAGE_INSTALL:append = " image-geometry"
IMAGE_INSTALL:append = " ros2-control"
IMAGE_INSTALL:append = " openssh-scp"
IMAGE_INSTALL:append = " openssh-ssh"

# tf/tf2
IMAGE_INSTALL:append = " tf-transformations"
IMAGE_INSTALL:append = " tf2 tf2-bullet tf2-eigen tf2-eigen-kdl"
IMAGE_INSTALL:append = " tf2-geometry-msgs tf2-kdl tf2-msgs tf2-py"
IMAGE_INSTALL:append = " tf2-ros tf2-ros-py tf2-sensor-msgs"

# rmw
IMAGE_INSTALL:append = " rmw"
IMAGE_INSTALL:append = " rmw-implementation"
IMAGE_INSTALL:append = " rmw-implementation-cmake"
IMAGE_INSTALL:append = " rmw-cyclonedds-cpp"
IMAGE_INSTALL:append = " rmw-dds-common"
IMAGE_INSTALL:append = " rmw-fastrtps-cpp"
IMAGE_INSTALL:append = " rmw-fastrtps-dynamic-cpp"
IMAGE_INSTALL:append = " rmw-fastrtps-shared-cpp"
IMAGE_INSTALL:append = " fastcdr"
IMAGE_INSTALL:append = " fastrtps"
IMAGE_INSTALL:append = " fastrtps-cmake-module"
IMAGE_INSTALL:append = " libyaml libyaml-dev"
IMAGE_INSTALL:append = " libyaml-vendor libyaml-vendor-dev"
IMAGE_INSTALL:append = " foonathan-memory foonathan-memory-vendor"

# rcl
IMAGE_INSTALL:append = " rcl"
IMAGE_INSTALL:append = " rcl-action"
IMAGE_INSTALL:append = " rcl-interfaces"
IMAGE_INSTALL:append = " rcl-lifecycle"
IMAGE_INSTALL:append = " rcl-logging-interface"
IMAGE_INSTALL:append = " rcl-logging-noop"
IMAGE_INSTALL:append = " rcl-logging-spdlog"
IMAGE_INSTALL:append = " rcl-yaml-param-parser"
IMAGE_INSTALL:append = " python3-numpy"

# LiDAR node
IMAGE_INSTALL:append = " hls-lfcd-lds-driver"

# Library provider preferences for Mali GPU
PREFERRED_PROVIDER_virtual/libgl = "mali-library"
PREFERRED_PROVIDER_virtual/egl = "mali-library"
PREFERRED_PROVIDER_virtual/libgles2 = "mali-library"
PREFERRED_PROVIDER_virtual/libgbm = "mali-library"
PREFERRED_PROVIDER_virtual/libopencl = "mali-library"

# related packages
IMAGE_INSTALL:append = " tesseract tesseract-lang"
IMAGE_INSTALL:append = " opencv opencv-dev"
PACKAGECONFIG:append:pn-opencv = " gtk"
PACKAGECONFIG:append:pn-nativesdk-opencv = " gtk"
IMAGE_INSTALL:append = " sudo"
IMAGE_INSTALL:append = " libgomp libgomp-dev libgomp-staticdev"

# Skip License QA
INHERIT:remove = "create-spdx"
WARN_QA:remove = "license-exists"

# Enable network access for git fetches
BB_NO_NETWORK = "0"

# Cross-build for demos
TOOLCHAIN_HOST_TASK:append = " nativesdk-python3-numpy nativesdk-python3-setuptools"

INHERIT += "rm_work"

# Build fixes for upstream -Werror issues in ROS2 packages
CXXFLAGS:append:pn-octomap = " -Wno-error=deprecated-declarations"

# --- Packages disabled due to missing dependencies ---
# Uncomment if the required dependencies are available in your setup.
#
# realsense2 (requires librealsense2 recipe)
#SKIP_RECIPE[librealsense2] = ""
#SKIP_RECIPE[realsense2-camera] = ""
#IMAGE_INSTALL:append = " librealsense2"
#IMAGE_INSTALL:append = " realsense2-camera"
#IMAGE_INSTALL:append = " realsense2-camera-msgs"
#
# navigation2 (requires libnanoflann-dev)
#SKIP_RECIPE[navigation2] = ""
#SKIP_RECIPE[nav2-bringup] = ""
#IMAGE_INSTALL:append = " navigation2 nav2-bringup"
#
# cartographer (requires openmp support)
#IMAGE_INSTALL:append = " cartographer-ros"
