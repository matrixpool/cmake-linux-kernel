cmake_minimum_required(VERSION 3.12)

set(CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)

include(PrintColor)

#product list
set(PRODUCTS)
list(APPEND PRODUCTS "QSG2000M-G")
list(APPEND PRODUCTS "QSG1000L")

#convert input parameter
string(TOUPPER "${VERSION}" VERSION)
string(TOUPPER "${PRODUCT}" PRODUCT)

#check if product type is correct
list(FIND PRODUCTS "${PRODUCT}" finded)
if(finded EQUAL -1)
    message(FATAL_ERROR "No product type selected or unsupported product type, exit....")
else()
    message_yellow("select product type: ${PRODUCT}")
    include(Product_${PRODUCT})
endif()

#cross compile environment
if(QSG_CPU STREQUAL "x86_64")
    message_yellow("select CPU type: ${QSG_CPU}")
    find_package(X86_64Linux)
elseif(QSG_CPU STREQUAL "arm64")
    message_yellow("select CPU type: ${QSG_CPU}")
    find_package(Arm64Linux)
else()
    message(FATAL_ERROR "No CPU type selected or unsupported CPU type, exit...") 
endif()

project(QSG C CXX ASM)

#check QSG version
string(REGEX MATCH "^V[0-9]+\\.[0-9]+\\.[0-9]+$" version_matched "${VERSION}")
if(version_matched)
    set(QSG_VERSION "${VERSION}")
else()
    message(FATAL_ERROR "the version number invalid: ${VERSION}")
endif()


#define QSG compile parameters
set(QSG_PRODUCT ${PRODUCT})
set(QSG_DOWNLOAD_DIR "${PROJECT_BINARY_DIR}/dl")
set(QSG_BUILD_DIR "${PROJECT_BINARY_DIR}/building")
set(QSG_OUTPUT_DIR "${PROJECT_SOURCE_DIR}/output/${QSG_PRODUCT}")
set(QSG_DIST_DIR "${PROJECT_SOURCE_DIR}/output/dist")
set(QSG_KERNEL_DIR "" CACHE STRING "QSG kernel directory variable")
set(QSG_KERNEL_VERSION "" CACHE STRING "QSG linux kernel version variable")
set(QSG_KERNEL_MODULE_DIR "${QSG_OUTPUT_DIR}/lib/modules/${QSG_KERNEL_VERSION}")

file(MAKE_DIRECTORY ${QSG_OUTPUT_DIR})
file(MAKE_DIRECTORY ${QSG_DIST_DIR})

add_subdirectory(3party)
add_subdirectory(src)

#make image
add_custom_target(rootfs-install
    COMMAND sh ${CMAKE_SOURCE_DIR}/script/rootfs_${QSG_PRODUCT}.sh ${CMAKE_C_COMPILER} ${QSG_OUTPUT_DIR}
)

#make bootloader
add_custom_target(bootloader-install
    COMMAND sh ${CMAKE_SOURCE_DIR}/script/bootloader_${QSG_PRODUCT}.sh ${QSG_PRODUCT} ${QSG_OUTPUT_DIR} ${QSG_DIST_DIR} ${QSG_VERSION}
)

#make clean-all
add_custom_target(clean-all
    COMMAND ${CMAKE_BUILD_TOOL} clean
    COMMAND ${CMAKE_COMMAND} -E remove_directory ${QSG_OUTPUT_DIR}
    COMMAND ${CMAKE_COMMAND} -E remove_directory ${QSG_DIST_DIR}
)
