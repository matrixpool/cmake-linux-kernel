cmake_minimum_required(VERSION 2.8.11)

project(simple_demo CXX)

if("${CMAKE_CXX_COMPILER_ID}" MATCHES "(GNU|Clang)")
    set(CMAKE_CXX_FLAGS "-std=c++11")
endif()

include(ExternalProject)

ExternalProject_Add(kernel
    URL https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-6.6.68.tar.gz
    URL_HASH SHA256=6fb25ba5f89babe026128f477299784c78da8ae23586ad9db0bc02befc5ce3ba  
    # DOWNLOAD_DIR "${PROJECT_BINARY_DIR}/dl"
    # SOURCE_DIR "${PROJECT_BINARY_DIR}/build_dir/linux-6.6.68"
    # PREFIX "${PROJECT_BINARY_DIR}/build_dir/linux-6.6.68"
    CONFIGURE_COMMAND make defconfig
    BUILD_COMMAND make -j
    BUILD_IN_SOURCE TRUE  
)

# ExternalProject_Add(
#     kernel
#     URL https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-4.19.285.tar.xz
#     PREFIX ${CMAKE_CURRENT_SOURCE_DIR}/kernel-4.19.285
#     CONFIGURE_COMMAND "make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- defconfig"
#     BUILD_COMMAND "make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- uImage"
#     BUILD_IN_SOURCE 1
# )

# ExternalProject_Add(xml2
#         URL https://download.gnome.org/sources/libxml2/2.11/libxml2-2.11.5.tar.xz
#         URL_HASH SHA256=3727b078c360ec69fa869de14bd6f75d7ee8d36987b071e6928d4720a28df3a6
#         #https://github.com/GNOME/libxml2/archive/refs/tags/v2.11.5.tar.gz
#         #GIT_REPOSITORY https://github.com/GNOME/libxml2
#         #GIT_TAG v2.11.5
#         DOWNLOAD_NO_PROGRESS 1
#         DOWNLOAD_DIR "${PROJECT_BINARY_DIR}/deps-download"
#         SOURCE_DIR "${PROJECT_BINARY_DIR}/xml2"
#         #BINARY_DIR ""
#         BUILD_IN_SOURCE TRUE
#         CONFIGURE_COMMAND ./configure --prefix=$ENV{HOME}/.cos-local.2 --enable-shared=no --enable-static=yes --without-python --without-lzma
#         BUILD_COMMAND make -j
#         INSTALL_COMMAND make install && ln -sf $ENV{HOME}/.cos-local.2/include/libxml2/libxml $ENV{HOME}/.cos-local.2/include/libxml
#         TEST_COMMAND ""
#         GIT_SHALLOW true
#         )
