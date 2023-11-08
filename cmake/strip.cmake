# Copyright (c) 2021-2023, twiinIT
#
# Proprietary and confidential, Safran.
#
# The full license is in the file LICENSE, distributed with this software.

function(strip target_name)
    # Strip unnecessary sections of the binary on Linux/macOS
    if(CMAKE_STRIP)
        if(APPLE)
            set(x_opt -x)
    endif()

    add_custom_command(
        TARGET ${target_name}
        POST_BUILD
        COMMAND ${CMAKE_STRIP} ${x_opt} $<TARGET_FILE:${target_name}>)
    endif()
endfunction()
