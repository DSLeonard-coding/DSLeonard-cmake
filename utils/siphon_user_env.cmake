macro(siphon_user_env)
    if(EXISTS "${SETUP_SCRIPT}")
        foreach(VAR_NAME ${ARGN})
            execute_process(
                    COMMAND bash -c "source ${SETUP_SCRIPT}> /dev/null 2>&1  ; echo \$${VAR_NAME}"
                    OUTPUT_VARIABLE DETECTED_VALUE
                    OUTPUT_STRIP_TRAILING_WHITESPACE
            )
            if(DETECTED_VALUE)
                set(${VAR_NAME} "${DETECTED_VALUE}")
                set(ENV{${VAR_NAME}} "${DETECTED_VALUE}")
                message(STATUS "  [Siphon] ${VAR_NAME} -> ${DETECTED_VALUE}")
            else()
                message(STATUS " [Siphon] Failed to retrieve ENV variable ${VAR_NAME}")
                message(STATUS " [Siphon]       This may or may not be fatal.")
            endif()
        endforeach()
    else()
        message(STATUS "Please copy ${SETUP_FILE} to your home directory and edit the paths in it")
    endif()
endmacro()
