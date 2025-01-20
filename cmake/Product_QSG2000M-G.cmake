
#set the related parameters
set(QSG_CPU "x86_64" CACHE STRING "QSG CPU type" FORCE)
set(QSG_KERNEL_VERSION "6.6.31" CACHE STRING "${QSG_PRODUCT} Linux kernel version" FORCE)
set(__KERNEL_URL "https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-${QSG_KERNEL_VERSION}.tar.gz" CACHE STRING "kernl URL" FORCE)
set(__KERNEL_HASH "9181339df8415cfc6799c7da6b64528d3b0382536a9c4d5fd9984657f9581deb" CACHE STRING "kernel hash" FORCE)

#set the related compile modules 
