set(CMAKE_SYSTEM_NAME Linux)
set(QSG_CROSS x86_64-linux-)

set(CMAKE_C_COMPILER ${QSG_CROSS}gcc)
set(CMAKE_CXX_COMPILER ${QSG_CROSS}g++)
set(CMAKE_AR${QSG_CROSS}ar)
set(CMAKE_RANLIB ${QSG_CROSS}ranlib)

add_definitions(-nodefaultlibs)

