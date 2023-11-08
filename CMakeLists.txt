cmake_minimum_required(VERSION 3.9 FATAL_ERROR)
set(CMAKE_CXX_STANDARD 98)

project(snap)

# Build options
# option(BUILD_PYTHON_BINDINGS "Enable the build of Python bindings" OFF)
option(SNAP_BUILD_TESTS "Enable the build of C++ tests" OFF)
# option(BUILD_SHARED "Enable the build of the shared lib" ON)

# Make some utils available
set(CMAKE_MODULE_PATH
    ${CMAKE_SOURCE_DIR}/cmake
    ${CMAKE_MODULE_PATH}
)
# Allow to strip binaries on unix platforms
include(strip)
include(utility)

# Set installation directories (CMAKE_INSTALL_INCLUDEDIR, CMAKE_INSTALL_BINDIR, CMAKE_INSTALL_LIBDIR)
include(GNUInstallDirs)
message("-- CMake install prefix: " ${CMAKE_INSTALL_PREFIX})

set(CMAKECONFIG_INSTALL_DIR "${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}" CACHE
    STRING "install path for atlConfig.cmake")

message("  -> binaries: " ${CMAKE_INSTALL_BINDIR})
message("  -> libs: " ${CMAKE_INSTALL_LIBDIR})
message("  -> includes: " ${CMAKE_INSTALL_INCLUDEDIR})
message("  -> site-packages: " ${SP_DIR})
message("  -> cmake config: " ${CMAKECONFIG_INSTALL_DIR})

# Add helpers for cmake configuration
include(CMakePackageConfigHelpers)

if (CMAKE_BUILD_TYPE STREQUAL "")
    set(CMAKE_BUILD_TYPE
        "Release"
        CACHE STRING "Choose the type of build, options are: None (CMAKE_CXX_FLAGS or CMAKE_C_FLAGS used) Debug Release RelWithDebInfo MinSizeRel."
        FORCE
    )
endif()

# add_subdirectory(glib-core)
add_subdirectory(snap-core)

if(SNAP_BUILD_TESTS)
    add_subdirectory(tests)
endif()
