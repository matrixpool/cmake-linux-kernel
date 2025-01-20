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

#define QSG compile parameters
set(QSG_PRODUCT ${PRODUCT})
set(QSG_DOWNLOAD_DIR "${PROJECT_BINARY_DIR}/dl")
set(QSG_BUILD_DIR "${PROJECT_BINARY_DIR}/building")
set(QSG_OUTPUT_DIR "${PROJECT_SOURCE_DIR}/output/${QSG_PRODUCT}")
set(QSG_DIST_DIR "${PROJECT_BINARY_DIR}/output/dist")
set(QSG_KERNEL_DIR "" CACHE STRING "QSG kernel directory variable")
set(QSG_KERNEL_VERSION "" CACHE STRING "QSG linux kernel version variable")

#check and delete before image directory
if(EXISTS ${QSG_OUTPUT_DIR})
    file(REMOVE_RECURSE ${QSG_OUTPUT_DIR})
endif()
file(MAKE_DIRECTORY ${QSG_OUTPUT_DIR})

add_subdirectory(3party)
# add_subdirectory(src)
