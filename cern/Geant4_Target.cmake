include (cmake/siphon_user_env.cmake)
siphon_user_env(GEANT4_PATH)

if(NOT GEANT4_PATH)
    message(FATAL_ERROR "GEANT4_PATH not set in Environment or vb_user_setup.sh")
endif()

# This doesn't work for gcc 13 and geant 10.7
#if(G4_CMAKE_FILES)
#    # Take the first match found
#    list(GET G4_CMAKE_FILES 0 G4_FIRST_MATCH)
#    get_filename_component(Geant4_DIR "${G4_FIRST_MATCH}" DIRECTORY)
#    find_package(Geant4 REQUIRED)
#    message(STATUS "Found Geant4 CMake at: ${Geant4_DIR}")
#else()
#    message(FATAL_ERROR "Could not find Geant4Config.cmake in ${GEANT4_PATH}")
#endif()

# --- Hunt for the directory containing Geant4Config.cmake ---
file(GLOB_RECURSE G4_CMAKE_FILES
        "${GEANT4_PATH}/*Geant4Config.cmake")

# Get Geant4 flags old-fashioned way
execute_process(COMMAND ${GEANT4_PATH}/bin/geant4-config --cflags OUTPUT_VARIABLE G4_CFLAGS OUTPUT_STRIP_TRAILING_WHITESPACE)
execute_process(COMMAND ${GEANT4_PATH}/bin/geant4-config --libs OUTPUT_VARIABLE G4_LIBS OUTPUT_STRIP_TRAILING_WHITESPACE)

# Create the Shadow Target
add_library(Geant4_Target INTERFACE)

separate_arguments(G4_CFLAGS_LIST NATIVE_COMMAND "${G4_CFLAGS}")
foreach(flag ${G4_CFLAGS_LIST})
    if(flag MATCHES "^-I(.+)")
        target_include_directories(Geant4_Target INTERFACE "${CMAKE_MATCH_1}")
    elseif(flag MATCHES "^-D(.+)")
        target_compile_definitions(Geant4_Target INTERFACE "${CMAKE_MATCH_1}")
    endif()
endforeach()

# Clean up the libs string and link it
separate_arguments(G4_LIBS_LIST NATIVE_COMMAND "${G4_LIBS}")
target_link_libraries(Geant4_Target INTERFACE ${G4_LIBS_LIST})
