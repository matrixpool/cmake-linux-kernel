cmake_minimum_required(VERSION 3.12)

project(simple_demo C CXX)

if("${CMAKE_CXX_COMPILER_ID}" MATCHES "(GNU|Clang)")
    set(CMAKE_CXX_FLAGS "-std=c++11")
endif()

set(QSG_DOWNLOAD_DIR "${PROJECT_BINARY_DIR}/dl")
set(QSG_BUILD_DIR "${PROJECT_BINARY_DIR}/building")
set(QSG_IMAGE_DIR "${PROJECT_BINARY_DIR}/image")

include(ExternalProject)

ExternalProject_Add(kernel
    URL https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-6.6.68.tar.gz
    URL_HASH SHA256=6fb25ba5f89babe026128f477299784c78da8ae23586ad9db0bc02befc5ce3ba  
    DOWNLOAD_DIR ${QSG_DOWNLOAD_DIR}
    SOURCE_DIR "${PROJECT_BINARY_DIR}/linux-6.6.68"
    PREFIX ${QSG_BUILD_DIR}
    BUILD_IN_SOURCE TRUE  
    CONFIGURE_COMMAND make tinyconfig
    BUILD_COMMAND make -j2 
    INSTALL_COMMAND make INSTALL_PATH=${QSG_IMAGE_DIR} install && make INSTALL_MOD_PATH=${QSG_IMAGE_DIR} modules_install
    DOWNLOAD_EXTRACT_TIMESTAMP TRUE
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
