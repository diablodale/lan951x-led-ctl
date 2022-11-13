cmake_minimum_required(VERSION 3.16)

project(lan951x-led-ctl LANGUAGES C)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/cmake")

set(CMAKE_INSTALL_PREFIX /usr)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

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

add_compile_definitions(
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
