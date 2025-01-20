include(ExternalProject)

if("${QSG_CPU}" STREQUAL "x86_64")
  set(__ARCH "x86")
endif()

set(QSG_KERNEL_DIR "${QSG_BUILD_DIR}/linux-${QSG_KERNEL_VERSION}" CACHE STRING "QSG kernel source directory" FORCE)
message_yellow("linux kernel version: ${QSG_KERNEL_VERSION}")
message_yellow("linux kernel path: ${QSG_KERNEL_DIR}")

#compile kernel
ExternalProject_Add(kernel
    URL ${__KERNEL_URL}
    URL_HASH SHA256=${__KERNEL_HASH}  
    DOWNLOAD_DIR ${QSG_DOWNLOAD_DIR}
    SOURCE_DIR "${QSG_KERNEL_DIR}"
    PREFIX ${QSG_BUILD_DIR}
    BUILD_IN_SOURCE TRUE  
    CONFIGURE_COMMAND ${CMAKE_COMMAND} -E copy ${PROJECT_SOURCE_DIR}/package/kernel/${QSG_CPU}/config/config .config
    BUILD_COMMAND make ARCH=${QSG_CPU} CROSS_COMPILE=${QSG_CROSS} all -j2 
    INSTALL_COMMAND 
        COMMAND ${CMAKE_COMMAND} -E make_directory ${QSG_OUTPUT_DIR}/boot
        COMMAND ${CMAKE_COMMAND} -E make_directory ${QSG_KERNEL_MODULE_DIR}
        COMMAND cp ${QSG_KERNEL_DIR}/arch/${__ARCH}/boot/${__KERNEL_IMAGE} ${QSG_OUTPUT_DIR}/boot
        COMMAND find ${QSG_KERNEL_DIR} -name "*.ko" | xargs -I {} cp {} ${QSG_KERNEL_MODULE_DIR}
    DOWNLOAD_EXTRACT_TIMESTAMP TRUE
)
add_custom_target(kernel-compile DEPENDS kernel)
add_custom_target(kernel-module-clean COMMAND ${KBUILD_CMD} clean)

