# Copyright (c) 2021-2023, twiinIT
#
# Proprietary and confidential, Safran.
#
# The full license is in the file LICENSE, distributed with this software.

set(SNAP_GLIB_CORE_INCLUDE_DIR ${CMAKE_CURRENT_SOURCE_DIR})

loadFolder("glib-core" SNAP_GLIB_CORE_HEADERS SNAP_GLIB_CORE_SRCS)

add_library(glib-core SHARED ${SNAP_GLIB_CORE_HEADERS} ${SNAP_GLIB_CORE_SRCS})

target_include_directories(
    glib-core
    PUBLIC
        $<BUILD_INTERFACE:${SNAP_GLIB_CORE_INCLUDE_DIR}>
        $<INSTALL_INTERFACE:include>
)

strip(glib-core)
