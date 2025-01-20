set(__BUSYBOX_VERION "1.36.1")
set(__BUSYBOX_HASH "b8cc24c9574d809e7279c3be349795c5d5ceb6fdf19ca709f80cde50e47de314")

#compile busybox
ExternalProject_Add(busybox
    URL https://www.busybox.net/downloads/busybox-${__BUSYBOX_VERION}.tar.bz2
    URL_HASH SHA256=${__BUSYBOX_HASH}  
    DOWNLOAD_DIR ${QSG_DOWNLOAD_DIR}
    SOURCE_DIR "${QSG_BUILD_DIR}/busybox-${__BUSYBOX_VERION}"
    PREFIX "${QSG_BUILD_DIR}"
    BUILD_IN_SOURCE TRUE  
    CONFIGURE_COMMAND ${CMAKE_COMMAND} -E copy ${PROJECT_SOURCE_DIR}/package/busybox/config/config .config
    BUILD_COMMAND COMMAND $(MAKE) ARCH=${QSG_CPU} CROSS_COMPILE=${QSG_CROSS} -j2 
    INSTALL_COMMAND 
        COMMAND $(MAKE) ARCH=${QSG_CPU} CROSS_COMPILE=${QSG_CROSS} install
        COMMAND rsync -av ${QSG_BUILD_DIR}/busybox-${__BUSYBOX_VERION}/_install/ ${QSG_OUTPUT_DIR}
    DOWNLOAD_EXTRACT_TIMESTAMP TRUE
)
add_custom_target(busybox-compile DEPENDS busybox)
