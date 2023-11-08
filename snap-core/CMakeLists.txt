# Copyright (c) 2021-2023, twiinIT
#
# Proprietary and confidential, Safran.
#
# The full license is in the file LICENSE, distributed with this software.

set(SNAP_CORE_INCLUDE_DIR ${CMAKE_CURRENT_SOURCE_DIR})
set(SNAP_GLIB_CORE_INCLUDE_DIR "${CMAKE_SOURCE_DIR}/glib-core")

loadFolder("snap-core" SNAP_CORE_HEADERS SNAP_CORE_SRCS)

add_library(snap-core SHARED ${SNAP_CORE_HEADERS} ${SNAP_GLIB_CORE_INCLUDE_DIR} ${SNAP_CORE_SRCS})

target_include_directories(
    snap-core
    PUBLIC
        $<BUILD_INTERFACE:${SNAP_CORE_INCLUDE_DIR}>
        $<BUILD_INTERFACE:${SNAP_GLIB_CORE_INCLUDE_DIR}>
        $<INSTALL_INTERFACE:include>
)
# target_link_libraries(snap-core PUBLIC glib-core)

if(WIN32)
    target_compile_options(snap-core PRIVATE /bigobj)
endif()

strip(snap-core)
