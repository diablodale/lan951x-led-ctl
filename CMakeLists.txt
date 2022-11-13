cmake_minimum_required(VERSION 3.16)

set(CMAKE_DISABLE_SOURCE_CHANGES ON)
set(CMAKE_DISABLE_IN_SOURCE_BUILD ON)

# This needs to come before project() to skip the compiler config process
if ("${CMAKE_BINARY_DIR}" STREQUAL "${CMAKE_SOURCE_DIR}")
	message(FATAL_ERROR "In-source builds are disabled.
Please create a subfolder and use `cmake ..` inside it.
NOTE: cmake will now create CMakeCache.txt and CMakeFiles/*.
You must delete them, or cmake will refuse to work.")
endif() # yes, end-markers and even else() need empty parentheses

project(lan951x-led-ctl LANGUAGES C)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/cmake")

set(CMAKE_INSTALL_PREFIX /usr)
set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)

set(CMAKE_VERBOSE_MAKEFILE ON)

find_package(PkgConfig REQUIRED)

pkg_check_modules(libusb REQUIRED libusb-1.0)

set(HEADERS
	include/lan951x-led-ctl.h
)

add_executable(${PROJECT_NAME}
	${HEADERS}
)

target_include_directories(${PROJECT_NAME} PUBLIC
	${CMAKE_BINARY_DIR}	# HB9HEI - location of generated version.h
	${CMAKE_SOURCE_DIR}/include
)

target_link_libraries(${PROJECT_NAME} PRIVATE
	usb-1.0
)

target_sources(${PROJECT_NAME} PRIVATE
	src/lan951x-led-ctl.c
)

add_dependencies(${PROJECT_NAME}
	git-version
)

target_compile_options(${PROJECT_NAME} PUBLIC
	-g
	-Os
	-std=c11
	-fstack-protector-strong
	-Wall
	-Wextra
	-Werror
	-Wstrict-prototypes
	-Wconversion
	-Wmissing-prototypes
	-Wshadow
	-Wunused
)

install(TARGETS ${PROJECT_NAME} DESTINATION bin)

# HB9HEI - custom target that produces version.h	(req. cmake 3.0)
add_custom_target(git-version ALL
	${CMAKE_COMMAND} -P ${CMAKE_CURRENT_SOURCE_DIR}/cmake/gitversion.cmake
)
