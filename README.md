
copy, subtree, or submodule this director into: 

cmake/DSL
ie so that this README.md will be 
```
cmake/DSL/README.md
```
and you will have
```
cmake/DSL/cern
cmake/DSL/utils
```
.. and maybe more in the future

Copy the example CMakeLists.example.txt to your root CMakeLists.txt
It is taken from DLG4Volumebuilders.

You will need this part or its latest version (could change):
```
# This CMakeLists.txt is for VolumeBuilder
# It defines a static library for VolumeBuilder, including its source files,
# its headers, and its necessary Geant4 dependencies.

# Ensure minimum CMake version consistent with your main project
cmake_minimum_required(VERSION 3.15)

# Define a project for this sub-component
project(YourProject LANGUAGES CXX)

# Set C++ standard consistent with your main project
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(SETUP_FILE "vb_user_setup.sh")
set(SETUP_SCRIPT "$ENV{HOME}/${SETUP_FILE}")
set(DSL_CMAKE_PATH "${CMAKE_CURRENT_LIST_DIR}/cmake/DSL/")
include("${DSL_CMAKE_PATH}/cern/Geant4_Target.cmake")
include("${DSL_CMAKE_PATH}/cern/ROOT_Target.cmake")
include("${DSL_CMAKE_PATH}/utils/Setup_Paths.cmake")
```

Change the vb_user_setup.sh to the name of your setup script in your HOME directory (no ~/ or abosolute path, it MUST be in the home directory)
That script should define:
```
        GEANT4_PATH
        G4ENSDFSTATEDATA
        G4LEDATA
        G4LEVELGAMMADATA
        G4NEUTRONHPDATA
```
and
```
	ROOTSYS
```
env variables.  GEANT4_PATH is the path to the ROOT of the GEANT4 isntall, not the CMAKE path.
That could look something like this:
```
export Geant4_DIR="/opt/geant-10.7.4-C++17/geant4-install-4.10.7.4-C17-gcc-13.3.0/"
export ROOT_PATH="/opt/root/6.30.04-CPP17-install"
source ${Geant4_DIR}/bin/geant4.sh  # this should work on standard geant installs

# I have some redundant variable names from historical reasons.
export ROOT_DIR=${ROOT_PATH}
export ROOTSYS=${ROOT_DIR}
export GEANT4_PATH=${Geant4_DIR}   

#Extra ROOT setup
source ${ROOT_PATH}/bin/thisroot.sh
export PATH=${VOLUME_BUILDER_GIT_DIR}/bin:${PATH}

unset MAKEFILES  # Not sure what this does
```


Most importantly you will be setup with two virtual targets to use in the CMakeLists.txt:
```
ROOT_Target
Geant4_Target
```

which you can use lik this:
```
target_link_libraries(YourProject PUBLIC
    ROOT_Target
    Geant4_Target
)
```
