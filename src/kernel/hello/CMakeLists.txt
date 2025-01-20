
set(HELLO thello)

set(HELLO_FILE ${HELLO}.ko)

set(
	KBUILD_CMD 
	$(MAKE) ARCH=${QSG_CPU} CROSS_COMPILE=${QSG_CROSS} -C ${QSG_KERNEL_DIR} 
	modules M=${CMAKE_CURRENT_BINARY_DIR} 
	src=${CMAKE_CURRENT_SOURCE_DIR}
)

set(HELLO_OBJS hello.o)

# Generate the Kbuild file through cmake.
file(
	WRITE 
	${CMAKE_CURRENT_SOURCE_DIR}/Kbuild 
	"obj-m := ${HELLO}.o\n${HELLO}-y := ${HELLO_OBJS}\n"
)

add_custom_command(OUTPUT ${HELLO_FILE}
        COMMAND ${KBUILD_CMD}
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        DEPENDS ${SRC_LISTS} VERBATIM)
add_custom_target(hello-module-compile ALL DEPENDS ${HELLO_FILE})
add_custom_target(hello-module-clean COMMAND ${KBUILD_CMD} clean)

install(PROGRAMS 
	${CMAKE_CURRENT_BINARY_DIR}/${HELLO_FILE}
	DESTINATION ${QSG_KERNEL_MODULE_DIR}
)

