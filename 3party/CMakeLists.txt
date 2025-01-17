include(ExternalProject)

if(${QSG_CPU} STREQUAL "x86_64")
    set(QSG_KERNEL_DIR "${QSG_BUILD_DIR}/linux-6.6.31" CACHE STRING "QSG kernel directory" FORCE)
    message_yellow("linux kernel: ${QSG_KERNEL_DIR}")
endif()
#compile kernel
ExternalProject_Add(kernel
    URL https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-6.6.31.tar.gz
    URL_HASH SHA256=9181339df8415cfc6799c7da6b64528d3b0382536a9c4d5fd9984657f9581deb  
    DOWNLOAD_DIR ${QSG_DOWNLOAD_DIR}
    SOURCE_DIR "${QSG_KERNEL_DIR}"
    PREFIX ${QSG_BUILD_DIR}
    BUILD_IN_SOURCE TRUE  
    CONFIGURE_COMMAND ${CMAKE_COMMAND} -E copy ${PROJECT_SOURCE_DIR}/package/kernel/config/config .config
    BUILD_COMMAND make ARCH=${QSG_CPU} CROSS_COMPILE=${QSG_CROSS} all -j2 
    INSTALL_COMMAND make INSTALL_PATH=${QSG_IMAGE_DIR} install && make INSTALL_MOD_PATH=${QSG_IMAGE_DIR} modules_install
    DOWNLOAD_EXTRACT_TIMESTAMP TRUE
)
add_custom_target(kernel-compile DEPENDS kernel)

#compile busybox
ExternalProject_Add(busybox
    URL https://www.busybox.net/downloads/busybox-1.36.1.tar.bz2
    URL_HASH SHA256=b8cc24c9574d809e7279c3be349795c5d5ceb6fdf19ca709f80cde50e47de314  
    DOWNLOAD_DIR ${QSG_DOWNLOAD_DIR}
    SOURCE_DIR "${QSG_BUILD_DIR}/busybox-1.36.1"
    PREFIX ${QSG_BUILD_DIR}
    BUILD_IN_SOURCE TRUE  
    # CONFIGURE_COMMAND ${CMAKE_COMMAND} -E copy ${PROJECT_SOURCE_DIR}/package/busybox/config/config .config && sed -i 's/^CONFIG_PREFIX=.*$/CONFIG_PREFIX="${QSG_IMAGE_DIR}"/' .config
    CONFIGURE_COMMAND ${CMAKE_COMMAND} -E copy ${PROJECT_SOURCE_DIR}/package/busybox/config/config .config
    BUILD_COMMAND make ARCH=${QSG_CPU} CROSS_COMPILE=${QSG_CROSS} install -j2 
    INSTALL_COMMAND ""
    DOWNLOAD_EXTRACT_TIMESTAMP TRUE
)
add_custom_target(busybox-compile DEPENDS busybox)
