# Add ASan only if a specific flag is passed or in a specific build mode
if(USE_ASAN)
    add_compile_options(-fsanitize=address -fno-omit-frame-pointer)
    add_link_options(-fsanitize=address)
endif()

#-----------------------------------------------------------------------------------#
#Custom paths to search for packages:
#-----------------------------------------------------------------------------------#
set(OPTIONAL_ENVS
        CUSTOM_CMAKE_PREFIX_PATHS
)

if(USER_CUSTOM_PATHS)
siphon_user_envs(OPTIONAL_ENVS "OPTIONAL")
    file(TO_CMAKE_PATH "${CUSTOM_CMAKE_PREFIX_PATHS}" PROCESSED_PATHS)
    list(APPEND CMAKE_PREFIX_PATH ${PROCESSED_PATHS})
endif()



#-----------------------------------------------------------------------------------#
#Intended for NDA material, to guard if we don't have access.
#-----------------------------------------------------------------------------------#
function(check_git_repo_access repo_name repo_url out_ok)
    find_package(Git QUIET)
    if(NOT GIT_FOUND)
        message(WARNING "[No Git] Skipping '${repo_name}' (${repo_url}): git not found.")
        set(${out_ok} FALSE PARENT_SCOPE)
        return()
    endif()

    execute_process(
            COMMAND ${CMAKE_COMMAND} -E env GIT_TERMINAL_PROMPT=0
            ${GIT_EXECUTABLE} ls-remote --exit-code "${repo_url}" HEAD
            RESULT_VARIABLE git_status
            OUTPUT_QUIET
            ERROR_QUIET
    )

    if(NOT git_status EQUAL 0)
        message(WARNING "[No Git Access] Skipping '${repo_name}' (${repo_url}): no access or unreachable.")
        set(${out_ok} FALSE PARENT_SCOPE)
        return()
    endif()

    set(${out_ok} TRUE PARENT_SCOPE)
endfunction()