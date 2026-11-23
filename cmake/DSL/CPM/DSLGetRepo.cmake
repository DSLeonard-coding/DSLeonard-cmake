# cmake/DSLGetRepo.cmake
include_guard(GLOBAL)
include("${CMAKE_CURRENT_LIST_DIR}/CPM.cmake")

# dsl_get_repo(<dir> <repo-url> <tag-or-sha>)
# Ensures <dir> is a checkout of <repo> at <tag>. Create <dir>/.developing to leave it alone.
macro(dsl_get_repo DIR REPO TAG)
    get_filename_component(_ds_dir "${DIR}" ABSOLUTE BASE_DIR "${CMAKE_CURRENT_LIST_DIR}")
    get_filename_component(_ds_name "${_ds_dir}" NAME)
    string(MD5 _ds_key "${_ds_dir}")

    if(EXISTS "${_ds_dir}/.developing")
        message(STATUS "dsl_get_repo: ${_ds_dir} in developing mode, leaving as-is")
        message(STATUS "remove file ${_ds_dir}/.developing to allow auto-update")
    elseif(EXISTS "${_ds_dir}" AND "${_dsl_get_repo_${_ds_key}}" STREQUAL "${TAG}")
        message(STATUS "${_ds_dir} is up to date.  Add file ${_ds_dir}/.developing
         to protect sub-project from updates for local development. \n")
        # already fetched at this tag in this build dir (e.g. restart pass)
    else()
        CPMAddPackage(
            NAME ${_ds_name}
            GIT_REPOSITORY ${REPO}
            GIT_TAG ${TAG}
            SOURCE_DIR "${_ds_dir}"
            DOWNLOAD_ONLY YES
        )
        set(_dsl_get_repo_${_ds_key} "${TAG}" CACHE INTERNAL "dsl_get_repo: tag fetched into ${_ds_dir}")
        message(STATUS "${_ds_dir} was updated.  Add file ${_ds_dir}/.developing
         to protect sub-project from updates for local development. \n")
    endif()
endmacro()