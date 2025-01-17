cmake_minimum_required(VERSION 3.12)

set(CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)

include(PrintColor)

#convert input parameters
string(TOLOWER "${CPU}" CPU)
set(QSG_CPU "${CPU}")

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

#define QSG directories
set(QSG_DOWNLOAD_DIR "${PROJECT_BINARY_DIR}/dl")
set(QSG_BUILD_DIR "${PROJECT_BINARY_DIR}/building")
set(QSG_IMAGE_DIR "${PROJECT_BINARY_DIR}/image")
set(QSG_KERNEL_DIR "" CACHE STRING "QSG kernel directory variable")

if(NOT EXISTS ${QSG_IMAGE_DIR})
    file(MAKE_DIRECTORY ${QSG_IMAGE_DIR})
endif()

add_subdirectory(3party)
add_subdirectory(src)
